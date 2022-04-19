<template>
  <section>
    <el-row>
      <el-col style="margin-left: 10px">
        <el-button type="primary" @click="openAdd()">增加奖项</el-button>
        <!--<el-button type="primary" @click="test()">测试</el-button>-->
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-table :data="currentPageData" stripe>
          <el-table-column align="center" prop="prizeId" label="Id" width="50" ></el-table-column>
          <el-table-column class-name="img-logo" align="center" label="图片" width="250">
            <template slot-scope="scope">
              <img :src="fitlerBlobToBase64(scope.row.logo)" alt="">
            </template>
          </el-table-column>
          <el-table-column align="center" prop="name" label="名字" width="150"></el-table-column>
          <el-table-column align="center" prop="description" label="奖项描述" width="175"></el-table-column>
          <el-table-column align="center" label="奖项内容" width="275">
            <template slot-scope="scope">
              <div v-for="(item,index) in scope.row.bonus">
                <el-tag v-if="item.bonusType==='USDT'" style="color: #FFBB0D;background: rgba(255, 187, 13, 0.2);">{{item.amount}} {{item.bonusType}}</el-tag>
                <el-tag v-else style="color: #32E0C4;background: rgba(50, 224, 196, 0.2);">{{item.amount}} {{item.bonusType}}</el-tag>
              </div>
            </template>
          </el-table-column>
          <el-table-column align="center" prop="quantity" label="奖项数量" width="50"></el-table-column>
          <el-table-column align="center" prop="ranking" label="名次（排序）" width="150"></el-table-column>
          <el-table-column align="center" label="操作">
            <template slot-scope="scope">
              <el-button size="mini" type="info" @click="edit(scope.row.prizeId)">编辑</el-button>
              <el-button size="mini" type="danger" @click="deleteItem(scope.row)" :loading="scope.row.remindLoading">删除</el-button>
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
            <el-input v-model="dialogForm.name" placeholder="请输入奖项名称"></el-input>
          </el-form-item>
          <el-form-item label="类  型:" label-width="110px">
            <div v-for="(item, index) in dialogForm.bonus"
                 :key="index" class="bonus-type">
              <el-row style="margin-bottom: 10px">
                <el-col :span="4">
                  <el-form-item :rules="{required: true,message: '网址不能为空',trigger: 'blur'}"
                                :prop="'bonus.' + index + '.bonusType'">
                    <el-select v-model="item.bonusType" placeholder="请选择" style="width: 100px">
                      <el-option
                        v-for="tag in tags"
                        :key="tag.key"
                        :label="tag.label"
                        :value="tag.label">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="10">
                  <el-form-item :rules="{required: true,message: '网址不能为空',trigger: 'blur'}"
                                :prop="'bonus.' + index + '.amount'">
                    <el-input v-model.number="item.amount"  placeholder="请输入你要捐款的金额" style="width: 310px"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="4">
                  <el-button v-if="index === 0" @click.prevent="add(item)">增加</el-button>
                  <el-button v-if="index > 0" @click.prevent="remove(item)">删除</el-button>
                </el-col>
              </el-row>
              <el-tag v-if="item.bonusType==='USDT'" style="color: #FFBB0D;background: rgba(255, 187, 13, 0.2);">默认颜色</el-tag>
              <el-tag v-else style="color: #32E0C4;background: rgba(50, 224, 196, 0.2);">额外的颜色</el-tag>
            </div>
          </el-form-item>
          <el-form-item label="数  量:" :rules="{
            required: true,
            message: '数量不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="quantity">
            <el-input v-model.number="dialogForm.quantity"  placeholder="请输入奖项的数量"></el-input>
          </el-form-item>
          <el-form-item label="排  序:" :rules="{
            required: true,
            message: '名次排序不能为空',
            trigger: 'blur'
          }" label-width="110px" prop="ranking">
            <el-input v-model.number="dialogForm.ranking"  placeholder="请输入名次排序的id"></el-input>
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
          <el-form-item label="奖 项 描 述:" label-width="110px" prop="description">
            <el-input v-model="dialogForm.description"  placeholder="一句话介绍奖项的信息"></el-input>
          </el-form-item>
          <el-form-item style="text-align: right">
            <template>
              <el-button @click="dialogVisible = false">取消</el-button>
              <el-button v-if="dialogTitle==='增加奖项'" type="primary" :loading="dialogLoading" @click="addItem('dialogForm')">
                增加奖项
              </el-button>
              <el-button v-else-if="dialogTitle==='修改奖项'" type="primary" :loading="dialogLoading" @click="updateItem('dialogForm')">
                修改奖项
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
    name: 'Awards',
    data() {
      return {
        //从vuex中读取actor，如果没有就为空
        tags:[
          {
            key:"usdt",
            label:"USDT"
          },
          {
            key:"icp",
            label:"ICP"
          },
          {
            key:"grant",
            label:"Grant"
          },
          {
            key:"nft",
            label:"NFT"
          },
          {
            key:"other",
            label:"其他"
          },
        ],
        actor:this.$store.state.dapp|| "",
        tableData: [],
        selectId:"",
        loading:false,
        total: 0, // 总条目数，默认为0
        currentPage: 1, //当前页数 ，默认为1
        pageSize: 10, // 每页显示数量
        currentPageData: [], //当前页显示内容
        dialogVisible:false,
        dialogTitle:"增加奖项",
        dialogForm:{
          ranking:"",
          name:"",
          quantity:"",
          bonus: [ {bonusType: "ICP", amount: ""  }] ,
          photoUri: {src:"" ,type: "", buffer: "" },
          description:""
        },
        item:{},
        dialogLoading:false,
      }
    },
    methods:{
      openAdd(){
        this.dialogTitle='增加奖项';
        this.dialogVisible=true
      },
      async addItem(formName){
        this.$refs[formName].validate(async valid => {
          if (valid) {
            this.dialogLoading=true;
            console.log(this.dialogForm)
            const res = await this.actor.createPrize(
              this.dialogForm.ranking,
              this.dialogForm.name,
              this.dialogForm.bonus,
              {
                content:  this.dialogForm.photoUri.buffer,
                fileType:  this.dialogForm.photoUri.type
              },
              this.dialogForm.description,
              this.dialogForm.quantity,
            );
            console.log(res)
            if (Object.keys(res)[0] === "ok") {
              this.$message.success("提交成功");
              this.getItem();
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
        let res = await this.actor.allPrizes();
        this.total=res.length;
        let tableData = [];
        console.log(res)
        if(res){
          for (const item of res) {
            let tableItem={};
            tableItem=item[1];
            tableItem.bonus.amount = Number(tableItem.bonus.amount);
            tableItem.quantity = Number(tableItem.quantity);
            tableItem.ranking = Number(tableItem.ranking);
            tableItem.prizeId = Number(tableItem.prizeId);
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
            this.item.ranking=this.dialogForm.ranking;
            this.item.name= this.dialogForm.name;
            this.item.bonus=this.dialogForm.bonus;
            this.item.logo.content=this.dialogForm.photoUri.buffer;
            this.item.logo.fileType=this.dialogForm.photoUri.type;
            this.item.description=this.dialogForm.description;
            this.item.quantity=  this.dialogForm.quantity;
            const res = await this.actor.editPrize(this.item);
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
        this.dialogTitle='修改奖项';
        let res = await this.actor.getPrize(id);
        console.log(res);
        this.item=res[0];
        let item=res[0];
        this.dialogForm.ranking = item.ranking;
        this.dialogForm.name = item.name;
        this.dialogForm.bonus = item.bonus;
        this.dialogForm.photoUri.buffer = item.logo.content;
        this.dialogForm.photoUri.type = item.logo.fileType;
        this.dialogForm.description = item.description;
        this.dialogForm.quantity = item.quantity;
        this.dialogForm.photoUri.src = transformArrayBufferToBase64({
          content: this.dialogForm.photoUri.buffer,
          fileType: this.dialogForm.photoUri.type
        });
        this.dialogVisible = true;
      },
      async deleteItem(row){
        this.$set(row, 'remindLoading', true);
        let res = await this.actor.removePrize(row.prizeId);
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
      add(){
        this.dialogForm.bonus.push({
          bonusType: "ICP",
          amount: ""
        });
        console.log(this.dialogForm);
      },
      remove(item) {
        var index = this.dialogForm.bonus.indexOf(item);
        if (index !== -1) {
          this.dialogForm.bonus.splice(index, 1);
        }
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
  .img-logo img{
    width: 120px;
    height: 120px;
  }
  .bonus-type{
      margin-bottom: 10px;
  }
</style>
