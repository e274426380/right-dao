<template>
  <div>
    <div>
      <!--<el-row>-->
        <!--<el-col :span="24">-->
          <!--按轮播图位置筛选：-->
          <!--<el-radio-group v-model="radio" @change="findLevel">-->
            <!--<el-radio-button label="全部"></el-radio-button>-->
            <!--<el-radio-button v-for="tag in resource" :key="tag.key" :label="tag.key">{{tag.name}}</el-radio-button>-->
          <!--</el-radio-group>-->
        <!--</el-col>-->
      <!--</el-row>-->
      <el-row>
        <el-col>
          <el-button type="primary" @click="dialogVisible=true">增加轮播图</el-button>
        </el-col>
      </el-row>
      <br/>
      <el-row>
        <el-col :span="24">
          <el-table :data="currentPageData" border>
            <el-table-column prop="bannerId"  label="序号" width="50" align="center"
                             sortable></el-table-column>
            <el-table-column class-name="pic" align="center" label="图片" width="300">
              <template slot-scope="scope">
                <img :src="fitlerBlobToBase64(scope.row.pic)" alt="">
              </template>
            </el-table-column>
            <el-table-column align="center" prop="outerUri" label="链接" width="400"></el-table-column>
            <el-table-column align="center" prop="bannerCategory" label="板块" width="100">
              <template slot-scope="scope">
                <!--判断板块位置：值为home表示主页，值为dapp表示dapp主页-->
                <div v-if="scope.row.bannerCategory == 'home'" style="color: #348057">首页</div>
                <div v-else-if="scope.row.bannerCategory == 'dapp'" style="color: #bb3e42">dapp主页</div>
                <div v-else style="color: #000000">未知</div>
              </template>
            </el-table-column>
            <el-table-column align="center" prop="createdAt" label="创建时间" width="190"></el-table-column>
            <el-table-column align="center" prop="createdBy" label="创建人" width="225"></el-table-column>
            <!--<el-table-column align="center" prop="msg" label="状态" width="150"></el-table-column>-->
            <el-table-column align="center" label="操作">
              <template slot-scope="scope">
                <!--<el-button size="mini" type="info" @click="handleEdit(scope.row.principal)">编辑</el-button>-->
                <el-button size="mini" type="primary"
                           @click="deleteBanner(scope.row)"
                           :loading="scope.row.remindLoading"
                           style="margin-bottom: 5px;">删除</el-button>
             </template>
            </el-table-column>
          </el-table>
        </el-col>
      </el-row>
      <br/>
      <!--<el-row>-->
        <!--<el-col :span="20" align="center">-->
          <!--<el-pagination-->
            <!--@current-change="setCurrentPageData"-->
            <!--background-->
            <!--layout="total,prev, pager, next"-->
            <!--:total="total"-->
            <!--:page-size="pageSize"-->
            <!--:current-page.sync="currentPage"-->
          <!--&gt;-->
          <!--</el-pagination>-->
        <!--</el-col>-->
      <!--</el-row>-->
    </div>
    <el-dialog
      title="增加轮播图"
      :visible.sync="dialogVisible">
      <el-form :model="bannerForm" class="el-form-detail" ref="bannerForm" label-width="100px" label-position="right" v-loading="loading">
        <template>
          <el-form-item label="轮播图板块：" prop="resource">
            <el-radio-group v-model="bannerForm.resource">
              <el-radio v-for="tag in resource" :key="tag.key" :label="tag.key">{{tag.name}}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="轮播图超链接:" :rules="{
            required: true,
            message: '链接不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="url">
            <el-input v-model="bannerForm.url"></el-input>
          </el-form-item>
          <el-form-item style="margin-bottom: 40px" label="轮播图图片:" :rules="{
            required: true,
            message: 'photo不能为空',
            trigger: 'blur'
          }" label-width="100px" prop="photoUri">
            <el-upload class="img-uploader" :show-file-list="false" :before-upload="beforePhotoUpload">
              <img v-if="bannerForm.photoUri.src" :src="bannerForm.photoUri.src" class="img-photo" />
              <i v-else class="el-icon-plus img-photo-uploader-icon">
                <!-- <span style="font-size:17px">上传图片</span>  -->
              </i>
            </el-upload>
            <span class="img-tip">建议像素：640*360px，JPG、PNG格式。</span>
            <span class="img-tip">轮播图只能查询最新10个</span>
          </el-form-item>
          <el-form-item style="text-align: right">
            <template>
              <el-button @click="dialogVisible = false">取消</el-button>
              <el-button type="primary" :loading="dialogLoading" @click="addBanner('bannerForm')">
                提交修改
              </el-button>
              <!--<el-button type="primary" @click="test()">测试</el-button>-->
            </template>
          </el-form-item>
        </template>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  import {  timestampToDate,transformArrayBufferToBase64 } from "a@/utils/utils";
  export default {
    name: 'Dapps',
    data() {
      return {
        dialogVisible: false,
        resource:[
          {
            key:"home",
            name:"首页"
          },
          {
            key:"dapp",
            name:"dapp"
          },
        ],
        //从vuex中读取actor，如果没有就为空
        actor:this.$store.state.dapp|| "",
        tableData: [],
        bannerForm:{
          resource:"home",
          url:"",
          photoUri: { src: "", type: "", buffer: "" },
        },
        selectId:"",
        loading:false,
        dialogLoading:false,
        photoChange:false,
        total: 0, // 总条目数，默认为0
        currentPage: 1, //当前页数 ，默认为1
        pageSize: 10, // 每页显示数量
        currentPageData: [], //当前页显示内容
        radio:"全部"
      }
    },
    mounted(){
      this.getBanner();
    },
    methods:{
      test(){
        console.log("test");
        console.log(this.bannerForm);
      },
      async addBanner(formName){
        this.$refs[formName].validate(async valid => {
          if (valid) {
            this.dialogLoading=true;
            const res = await this.actor.createBanner({
              content: this.bannerForm.photoUri.buffer,
              fileType: this.bannerForm.photoUri.type
            },
              this.bannerForm.resource,
              this.bannerForm.url
            );
            if (Object.keys(res)[0] === "ok") {
              this.getBanner();
              this.$message.success("提交成功");
            } else {
              this.$message.error("提交失败");
              this.$message.error(res);
            }
            this.dialogLoading=false;
          }
        });

      },
      async getBanner(){
        const loading=this.startLoading(".el-table__body-wrapper",null);
        let res = await this.actor.getNewerBanner(10);
        console.log(res);
        let tableData = [];
        if(Object.keys(res)[0] === "ok"){
          for (const item of res.ok) {
            let banner={};
            banner=item[1];
            banner.bannerId = Number(banner.bannerId);
            banner.createdAt = timestampToDate(banner.createdAt);
            tableData.push(banner);
          }
          this.tableData=tableData;
          console.log( this.tableData);
          this.setCurrentPageData();
        }else {
          this.$message.error("获取轮播图失败");
        }
        loading.close();
      },
      async deleteBanner(banner){
        this.$set(banner, 'remindLoading', true);
        let res=await this.actor.deleteBanner(banner.bannerId);
        if(Object.keys(res)[0] === "ok"){
          this.$message.success("删除成功");
          this.getBanner();
        }else {
          this.$message.error("删除失败");
        }
        this.$set(banner, 'remindLoading', false);
      },
      // 设置当前页面数据，对数组操作的截取规则为[0~10],[10~20]...,
      setCurrentPageData() {
        let begin = (this.currentPage - 1) * this.pageSize;
        let end = this.currentPage * this.pageSize;
        this.currentPageData = this.tableData.slice(
          begin,
          end
        );
      },
      fitlerBlobToBase64(file) {
        return transformArrayBufferToBase64(file)
      },
      beforePhotoUpload(file) {
        this.bannerForm.photoUri.type = file.type;
        let reader = new FileReader();
        reader.readAsArrayBuffer(file);
        reader.onload = e => {
          this.bannerForm.photoUri.buffer = Array.from(
            new Uint8Array(e.target.result)
          );
          this.bannerForm.photoUri.src = transformArrayBufferToBase64({
            content: this.bannerForm.photoUri.buffer,
            fileType: this.bannerForm.photoUri.type
          });
          this.photoChange=true;
        };
      },
    }
  }
</script>

<style lang="scss" scoped>
  /*上传头像*/
  .img-uploader >>> .el-upload {
    background: #fbfdff;
    border: 2px dashed #9d9d9d;
    border-radius: 8px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .img-uploader >>> .el-upload:hover {
    border-color: #409eff;
  }
  .img-photo-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 641px;
    height: 360px;
    line-height: 360px;
    text-align: center;
  }
  .img-photo {
    width: 641px;
    height: 360px;
    display: block;
  }
  .pic img{
    width:256px;
    height: 144px;
  }
</style>
