<template>
  <section>
    <el-row>
      <el-col style="margin-left: 10px">
        <router-link :to="{name:'EditHackathon'}">
          <el-button type="primary">增加黑客松</el-button>
        </router-link>

        <!--<el-button type="primary" @click="test()">测试</el-button>-->
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-table :data="currentPageData" stripe>
          <el-table-column type="index" label="序号" width="50" align="center"></el-table-column>-->
          <el-table-column align="center" prop="dappStats.profile.name" label="赞助商" width="150"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.description" label="奖品" width="275"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.description" label="要求" width="175"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.description" label="名次" width="275"></el-table-column>
          <el-table-column align="center" label="操作">
            <template slot-scope="scope">
              <!--<el-button size="mini" type="info" @click="handleEdit(scope.row.principal)">编辑</el-button>-->
              <el-button size="mini" type="info" @click="edit(scope.row)" :loading="scope.row.remindLoading">编辑</el-button>
              <!--<el-button size="mini" type="primary" @click="addRole(scope.row.principal)">设置为管理员</el-button>-->
              <el-button v-if="scope.row.dappStats.profile.status === 'enable'" size="mini" type="warning" @click="setDappState(scope.row.dappStats.profile.dappId,'verifyDapp','pening')">审核</el-button>
              <el-button v-else-if="scope.row.dappStats.profile.status === 'pening'" size="mini" type="success" @click="setDappState(scope.row.dappStats.profile.dappId,'verifyDapp','enable')">通过</el-button>
              <el-button v-else-if="scope.row.dappStats.profile.status === 'disable'" size="mini" type="success" @click="setDappState(sscope.row.dappStats.profile.dappId,'verifyDapp','pening')">恢复</el-button>
              <el-button size="mini" type="danger" @click="setDappState(scope.row.dappStats.profile.dappId,'deleteDapp')">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="20" align="center">
        <el-pagination
          @current-change="getDapp"
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
      title="增加赏金"
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
          <el-form-item label="数  量:" :rules="{
            required: true,
            message: '数量不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="url">
            <el-input v-model="dialogForm.url"  placeholder="请输入赏金的数量"></el-input>
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
          <el-form-item label="赏 金 要 求:" label-width="110px" prop="description">
            <el-input v-model="dialogForm.description"  placeholder="一句话介绍赏金要求"></el-input>
          </el-form-item>
          <el-form-item style="text-align: right">
            <template>
              <el-button @click="dialogVisible = false">取消</el-button>
              <el-button type="primary" :loading="dialogLoading" @click="addItem('dialogForm')">
                提交修改
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
    name: 'Bounty',
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
          url:"",
          photoUri: { src: "", type: "", buffer: "" },
          description:""
        },
        dialogLoading:false,
      }
    },
    methods:{
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
  .pic img{
    width:256px;
    height: 144px;
  }
</style>
