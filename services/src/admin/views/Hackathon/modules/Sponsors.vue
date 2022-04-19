<template>
  <section>
    <el-row>
      <el-col style="margin-left: 10px">
        <el-button type="primary" @click="openAdd()">增加赞助商</el-button>
        <!--<el-button type="primary" @click="test()">测试</el-button>-->
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-table :data="currentPageData" stripe>
          <el-table-column align="center" prop="sponsorId" label="Id" width="50" ></el-table-column>
          <el-table-column class-name="image-logo" align="center" label="LOGO" width="400">
            <template slot-scope="scope">
              <img :src="fitlerBlobToBase64(scope.row.logo)" alt="">
            </template>
          </el-table-column>
          <el-table-column align="center" prop="name" label="名字" width="150"></el-table-column>
         <el-table-column align="center" prop="description" label="介绍" width="575"></el-table-column>
          <el-table-column align="center" label="操作">
            <template slot-scope="scope">
              <el-button size="mini" type="info" @click="edit(scope.row.sponsorId)">编辑</el-button>
              <el-button size="mini" type="danger" @click="deleteItem(scope.row)"  :loading="scope.row.remindLoading">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="20" align="center">
        <el-pagination
          @current-change="setCurrentPageData"
          background
          layout="total,prev, pager, next"
          :total="total"
          :page-size="pageSize"
          :current-page.sync="currentPage"
        >
        </el-pagination>
      </el-col>
    </el-row>
    <el-dialog
      :title=dialogTitle
      :visible.sync="dialogVisible">
      <el-form :model="dialogForm" class="el-form-detail" ref="dialogForm" label-width="110px" label-position="right" v-loading="loading">
        <template>
          <el-form-item label="名  称:" :rules="{
            required: true,
            message: '名称不能为空',
            trigger: 'blur'
          }" prop="name">
            <el-input v-model="dialogForm.name" placeholder="请输入赞助商名称"></el-input>
          </el-form-item>
          <el-form-item label="地  址:" :rules="{
            required: true,
            message: '链接不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="uri">
            <el-input v-model="dialogForm.uri"  placeholder="请输入赞助商网址"></el-input>
          </el-form-item>
          <el-form-item style="margin-bottom: 40px" label="图  片:" :rules="{
            required: true,
            message: 'photo不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="photoUri">
            <el-upload class="img-uploader" :show-file-list="false" :before-upload="beforePhotoUpload">
              <img v-if="dialogForm.photoUri.src" :src="dialogForm.photoUri.src" class="img-photo" />
              <i class="el-icon-plus img-photo-uploader-icon">
                <!-- <span style="font-size:17px">上传图片</span>  -->
              </i>
            </el-upload>
            <span class="img-tip">logo建议像素：120(宽)*120(高)px，JPG、PNG格式，大小不超过100kb。</span>
          </el-form-item>
          <el-form-item label="赞 助 商 描 述:" label-width="110px" prop="description">
            <el-input v-model="dialogForm.description"  placeholder="一句话介绍赞助商的信息"></el-input>
          </el-form-item>
          <el-form-item style="text-align: right">
            <template>
              <el-button @click="dialogVisible = false">取消</el-button>
              <el-button v-if="dialogTitle==='增加赞助商'" type="primary" :loading="dialogLoading" @click="addItem('dialogForm')">
                增加赞助商
              </el-button>
              <el-button v-else-if="dialogTitle==='修改赞助商'" type="primary" :loading="dialogLoading" @click="updateItem('dialogForm')">
                修改赞助商
              </el-button>
              <!--<el-button type="primary" @click="test()">测试</el-button>-->
            </template>
          </el-form-item>
        </template>
      </el-form>
    </el-dialog>
  </section>
</template>

<script>
  import {  timestampToDate,transformArrayBufferToBase64 } from "a@/utils/utils";
  export default {
    name: 'Sponsors',
    data() {
      return {
        //从vuex中读取actor，如果没有就为空
        tags:"",
        actor:this.$store.state.dapp|| "",
        tableData: [],
        selectId:"",
        loading:false,
        total: 0, // 总条目数，默认为0
        currentPage: 1, //当前页数 ，默认为1
        pageSize: 10, // 每页显示数量
        currentPageData: [], //当前页显示内容
        dialogVisible:false,
        dialogForm:{
          name:"",
          uri:"",
          photoUri: { src: "", type: "", buffer: "" },
          description:""
        },
        dialogTitle:"增加赞助商",
        dialogLoading:false,
      }
    },
    methods:{
      openAdd(){
        this.dialogTitle='增加赞助商';
        this.dialogVisible=true
      },
      async addItem(formName){
        this.$refs[formName].validate(async valid => {
          if (valid) {
            this.dialogLoading=true;
            const res = await this.actor.createSponsor(
              this.dialogForm.name,
              this.dialogForm.description,
              {
                content: this.dialogForm.photoUri.buffer,
                fileType: this.dialogForm.photoUri.type
              },
              this.dialogForm.uri
            );
            if (Object.keys(res)[0] === "ok") {
              this.getItem();
              this.$message.success("提交成功");
            } else {
              this.$message.error("提交失败");
              this.$message.error(res);
            }
            this.dialogLoading=false;
          }
        });
      },
      async getItem(){
        const loading=this.startLoading(".el-table__body-wrapper",null);
        let res = await this.actor.allSponsors();
        this.total=res.length;
        let tableData = [];
        console.log(res)
        if(res){
          for (const item of res) {
            let tableItem={};
            tableItem=item[1];

            tableItem.sponsorId = Number(tableItem.sponsorId);
            tableData.push(tableItem);
          }
          this.tableData=tableData;
          this.setCurrentPageData();
        }else {
          this.$message.error("获取失败");
        }
        loading.close();
      },
      async updateItem(formName){
        this.$refs[formName].validate(async valid => {
          if (valid) {
            this.dialogLoading=true;
            this.item.name= this.dialogForm.name;
            this.item.logo.content=this.dialogForm.photoUri.buffer;
            this.item.logo.fileType=this.dialogForm.photoUri.type;
            this.item.description=this.dialogForm.description;
            this.item.uri=  this.dialogForm.uri;
            const res = await this.actor.editSponsor(this.item);
            console.log(res)
            if (Object.keys(res)[0] === "ok") {
              this.$message.success("修改成功");
              this.dialogVisible=false;
              this.getItem();
            } else {
              this.$message.error("修改失败");
              this.$message.error(res);
            }
            this.dialogLoading=false;
          }
        });
      },
      async edit(id){
        this.dialogTitle='修改赞助商';
        let res = await this.actor.getSponsor(id);
        console.log(res);
        this.item=res[0];
        let item=res[0];
        this.dialogForm.name = item.name;
        this.dialogForm.photoUri.buffer = item.logo.content;
        this.dialogForm.photoUri.type = item.logo.fileType;
        this.dialogForm.description = item.description;
        this.dialogForm.uri = item.uri;
        this.dialogForm.photoUri.src = transformArrayBufferToBase64({
          content: this.dialogForm.photoUri.buffer,
          fileType: this.dialogForm.photoUri.type
        });
        this.dialogVisible = true;
      },
      async deleteItem(row){
        this.$set(row, 'remindLoading', true);
        let res = await this.actor.removeSponsor(row.sponsorId);
        if(Object.keys(res)[0]==='ok'){
          this.$message.success("删除成功");
          this.getItem();
        }else {
          this.$message.error("删除失败");
          this.$message.error(res);
        }
        this.$set(row, 'remindLoading', false);
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
        this.dialogForm.photoUri.type = file.type;
        let reader = new FileReader();
        reader.readAsArrayBuffer(file);
        reader.onload = e => {
          this.dialogForm.photoUri.buffer = Array.from(
            new Uint8Array(e.target.result)
          );
          this.dialogForm.photoUri.src = transformArrayBufferToBase64({
            content: this.dialogForm.photoUri.buffer,
            fileType: this.dialogForm.photoUri.type
          });
          this.photoChange=true;
        };
      },
    },
    mounted(){
      this.getItem();
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
    width: 120px;
    height: 120px;
    line-height: 120px;
    text-align: center;
  }
  .img-photo {
    width: 641px;
    height: 360px;
    display: block;
  }
  .image-logo img{
    width:100px;
    height:100px;
  }
</style>
