<template>
  <div>
    <el-row>
      <el-col :span="2" style="height: 36px;line-height: 36px">
        <label>Dapp名称:</label>
      </el-col>
      <el-col :span="8">
        <el-input
          placeholder="请输入Dapp名称"
          v-model="selectName"
          clearable>
        </el-input>
      </el-col>
      <el-col :span="8" style="margin-left: 10px">
        <el-button type="primary" icon="el-icon-search" @click="searchDapp()">搜索</el-button>
        <!--<el-button type="primary" @click="test()">测试</el-button>-->
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-button type="primary" @click="getDapp()">所有DAPP</el-button>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-table :data="currentPageData" border>
          <el-table-column class-name="dapp-logo" align="center" label="LOGO" width="150">
            <template slot-scope="scope">
              <img :src="fitlerBlobToBase64(scope.row.logo)" alt="">
            </template>
          </el-table-column>
          <el-table-column align="center" prop="dappStats.profile.dappId" label="DappId" width="80"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.name" label="Dapp名字" width="150"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.createdBy" label="创建人PrincipalId" width="225"></el-table-column>
          <el-table-column align="center" prop="dappStats.profile.description" label="描述" width="575"></el-table-column>
          <!--<el-table-column align="center" prop="createdBy" label="创建人" width="400"></el-table-column>-->
          <el-table-column align="center" prop="dappStats.profile.createdAt" label="创建时间" width="180"></el-table-column>
          <el-table-column align="center" label="状态" width="60">
            <template slot-scope="scope">
              <!--status type:enable，disable，pening-->
              <div v-if="scope.row.dappStats.profile.status === 'enable'" style="color: #4955ff">启用</div>
              <div v-else-if="scope.row.dappStats.profile.status === 'disable'" style="color: orange">冻结</div>
              <div v-else-if="scope.row.dappStats.profile.status === 'pening'" style="color: red">审核</div>
            </template>
          </el-table-column>
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
  </div>
</template>

<script>
  import {  timestampToDate,transformArrayBufferToBase64 } from "a@/utils/utils";
  export default {
    name: 'Dapp',
    data() {
      return {
        selectName:"",
        searchData:[],
        //从vuex中读取actor，如果没有就为空
        actor:this.$store.state.dapp|| "",
        tableData: [],
        user:{},
        loading:false,
        confirmLoading:false,
        total: 0, // 总条目数，默认为0
        totalPage: 1, // 统共页数，默认为1
        currentPage: 1, //当前页数 ，默认为1
        pageSize: 10, // 每页显示数量
        currentPageData: [] //当前页显示内容
      }
    },
    async created(){
    },
    async mounted(){
      if(this.actor!==""){
        let res=await this.check();
        if(res==="ok"){
          await this.getDapp();
        }
        else {
          console.log("not ok");
        }
      }else {
        console.log("actor is null");
      }

    },
    methods:{
      startLoading() {
        this.loading = this.$loading({
          lock: true,
          // text: "Loading...",
          target: document.querySelector('.el-table__body-wrapper')//设置加载动画区域
        });
      },
      endLoading(){
        this.loading.close();
      },
      async searchDapp(){
        //防止还没有初始化完成就开始搜索，导致一直处于加载中的状态
        this.endLoading();
        if (this.selectName !== null && this.selectName !== '') {
          this.startLoading();
          console.log("selected");
          // this.tableData = this.searchData.filter( (item) => item.username.includes(this.selectName.trim()) );
          let res;
          if (this.searchData.length === 0) {
            console.log(this.selectName.trim() + "," + this.pageSize + ",0:" + 0);
            res = await this.actor.pageDappByName(this.selectName.trim(), this.pageSize, 0);
          } else {
            console.log(this.selectName.trim() + "," + this.pageSize + ",currentPage:" + this.currentPage);
            res = await this.actor.pageDappByName(this.selectName.trim(), this.pageSize, this.currentPage);
          }
          let items = res.data;
          console.log(res);
          console.log("items:");
          console.log(items);
          //将bigint转回number
          this.total = Number(res.totalCount);
          let tableData = [];
          for (const item of items) {
            item.dappStats.profile.dappId = Number(item.dappStats.profile.dappId);
            item.dappStats.profile.createdAt = Number(item.dappStats.profile.createdAt);
            tableData.push(item);
          }
          this.tableData = tableData;
          this.searchData = this.tableData;
          this.setCurrentPageData();
          this.endLoading();
        }else {
          console.log("not select");
          this.getDapp();
        }
      },
      edit(data){
        console.log(data);
        this.$router.push({
          name: 'SubmitDapp',
          query: {
            dapp: data
          }
        });
      },
      async check(){
        console.log("getSelf:");
        let res =await this.actor.getSelf();
        console.log(res);
        if(Object.keys(res)[0]==="ok"){
          const user=res.ok[0];
          this.user=user;
          this.$store.commit("SET_USER",user);
          return "ok";
        }else {
          console.log("check false");
        }
      },
      async getDapp(){
        console.log("getDapp:");
        this.startLoading();
        let res=await this.actor.pageDappIgnoreStatus(this.pageSize,this.currentPage-1);
        let items=res.data;
        //将bigint转回number
        this.total=Number(res.totalCount);
        console.log(res);
        let tableData=[];
        for (const item of items) {
          console.log(item);
          item.dappStats.profile.dappId=Number(item.dappStats.profile.dappId);
          item.dappStats.profile.createdAt=timestampToDate(item.dappStats.profile.createdAt);
          tableData.push(item);
        }
        this.tableData=tableData;
        console.log("AllUsers:");
        console.log(this.tableData);
        this.setCurrentPageData();
        this.endLoading();
      },
      async setDappState(id,method,status){
        //根据方法名调用对应方法
        let res=[];
        if(status===null||status===''){
          console.log("this.actor."+method+"('"+id+"')");
         res=await eval("this.actor."+method+"('"+id+"')");
          if (Object.keys(res)[0] === "ok") {
            this.$message({
              message: method+"操作成功",
              type: 'success'
            });
          }else {
            this.$message({
              message: res,
              type: 'error'
            });
          }
        }else {
          console.log("this.actor."+method+"("+id+",'"+status+"')");
          res=await eval("this.actor."+method+"("+id+",'"+status+"')");
          if (Object.keys(res)[0] === "ok") {
            this.$message({
              message: method + "：DappId" + id + "," + status + "操作成功",
              type: 'success'
            });
          }else {
            this.$message({
              message: res,
              type: 'error'
            });
          }
        }
        await this.getDapp();
      },
      // 设置当前页面数据，对数组操作的截取规则为[0~10],[10~20]...,
      setCurrentPageData(val) {
        let begin = (this.currentPage - 1) * this.pageSize;
        let end = this.currentPage * this.pageSize;
        this.currentPageData = this.tableData.slice(
          begin,
          end
        );
      },
      fitlerBlobToBase64(file) {
        return transformArrayBufferToBase64(file)
      }
  }
  }
</script>

<style lang="scss" scoped>
.dapp-logo img{
  width: 50px;
  height: 50px;
}
</style>
