<template>
  <div>
    <el-row>
      <el-col :span="2" style="height: 36px;line-height: 36px">
        <label>用户名称:</label>
      </el-col>
      <el-col :span="8">
        <el-input
          placeholder="请输入用户名称"
          v-model="selectUserName"
          clearable>
        </el-input>
      </el-col>
      <el-col :span="8" style="margin-left: 10px">
        <el-button type="primary" icon="el-icon-search" @click="selectUser()">搜索</el-button>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="24">
        <el-button type="primary" @click="getUser()">所有用户</el-button>
        <el-button type="primary" @click="getUser('front')">前台用户筛选</el-button>
        <el-button type="primary"  @click="getUser('admin')">后台用户筛选</el-button>
        <el-button type="primary" @click="getAdmin()">后台管理员筛选</el-button>
      </el-col>
    </el-row>
    <br/>
    <el-row>
      <el-col :span="22">
        <el-table :data="currentPageData" border>
          <el-table-column type="index" label="序号" width="50" align="center"></el-table-column>
          <el-table-column align="center" prop="userId" label="用户Id" width="70"></el-table-column>
          <el-table-column align="center" prop="username" label="用户名" width="150"></el-table-column>
          <el-table-column align="center" label="来源" width="80">
            <template slot-scope="scope">
              <div v-if="scope.row.registerFromApp === 'admin'" style="color: #ff272d">后端管理</div>
              <div v-else-if="scope.row.registerFromApp === 'front'" style="color: orange">前端</div>
              <div v-else style="color: rgba(90,0,14,0.46)">未知</div>
            </template>
          </el-table-column>
          <el-table-column align="center" prop="principal" label="Principal Id" width="600"></el-table-column>
          <!--<el-table-column align="center" prop="createdBy" label="创建人" width="400"></el-table-column>-->
          <el-table-column align="center" prop="createdAt" label="创建时间" width="180"></el-table-column>
          <el-table-column align="center" label="状态" width="60">
            <template slot-scope="scope">
              <div v-if="scope.row.status === 'enable'" style="color: #4955ff">启用</div>
              <div v-else-if="scope.row.status === 'disable'" style="color: orange">冻结</div>
              <div v-else-if="scope.row.status == -1" style="color: red">删除</div>
            </template>
          </el-table-column>
          <el-table-column align="center" label="操作">
            <template slot-scope="scope">
              <!--<el-button size="mini" type="info" @click="handleEdit(scope.row.principal)">编辑</el-button>-->
              <el-button size="mini" type="info" @click="openRole(scope.row)" :loading="scope.row.remindLoading">角色分配</el-button>
              <!--<el-button size="mini" type="primary" @click="addRole(scope.row.principal)">设置为管理员</el-button>-->
              <el-button v-if="scope.row.status === 'enable'" size="mini" type="warning" @click="setUserState(scope.row.principal,'disableUser')">冻结</el-button>
              <el-button v-else size="mini" type="success" @click="setUserState(scope.row.principal,'enableUser')">恢复</el-button>
              <el-button size="mini" type="danger" @click="setUserState(scope.row.principal,'deleteUser')">删除</el-button>
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
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="30%">
      <p>用户名：</p>
      <el-input placeholder="" v-model="user.username" disabled>
      </el-input>
      <p>Principal ID：</p>
      <el-input placeholder="" v-model="user.principal" disabled>
      </el-input>
      <p>角色：</p>
      <el-radio-group v-model="userRole">
        <el-radio label="guest">游客</el-radio>
        <el-radio label="user">普通用户</el-radio>
        <el-radio label="admin">管理员</el-radio>
      </el-radio-group>
      <span slot="footer" class="dialog-footer">
				<el-button @click="dialogVisible = false">取 消</el-button>
				<el-button v-if="dialogTitle==='角色分配'" type="success" @click="setRole()" :loading="confirmLoading">确定分配角色</el-button>
				<el-button v-else-if="dialogTitle==='编辑用户'" type="success" @click="updateUser()">确 定</el-button>
			</span>
    </el-dialog>
  </div>
</template>

<script>
  import {  timestampToDate } from "a@/utils/utils"
  export default {
    name: 'Roles',
    data() {
      return {
        selectUserName:"",
        searchData:[],
        //从vuex中读取actor，如果没有就为空
        actor:this.$store.state.dapp|| "",
        tableData: [
          {
            createdAt: "1632470136027270000",
            createdBy: "2vxsx-fae",
            principal: "2vxsx-fae",
            status: "enable",
            userId: "1",
            username: "zhou"
          },
        ],
        dialogVisible:false,
        dialogTitle:"角色分配",
        user:{},
        userRole:"",
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
          await this.getUser();
          // this.totalPage = Math .ceil(this.tableData.length / this.pageSize);
          // // 计算得0时设置为1
          // this.totalPage = this.totalPage === 0 ? 1 : this.totalPage;
          this.setCurrentPageData();
        }
        else {
          console.log("not ok");
        }
      }else {
        console.log("actor is null");
      }

    },
    methods:{
      selectUser(){
        if(this.selectUserName!==null&&this.selectUserName!==''){
          console.log("selected");
          this.tableData = this.searchData.filter( (item) => item.username.includes(this.selectUserName.trim()) );
          this.setCurrentPageData();
        }else {
          console.log("not select");
          this.setCurrentPageData();
        }
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
      async getUser(from){
        const loading=this.startLoading(".el-table__body-wrapper",null);
        let res=[];
        if(from!=null&&from!==""){
          res=await this.actor.getUsersByRegisterFrom(from);
          console.log("from:"+from);
        }else {
          console.log("All");
          res=await this.actor.allUsers();
        }
        let items=res.ok;
        console.log(res);
        let tableData=[];
        for (const item of items) {
          item.userId=item.userId.toString();
          item.createdAt=timestampToDate(item.createdAt);
          tableData.push(item);
        }
        this.tableData=tableData;
        this.searchData=tableData;
        this.setCurrentPageData();
        console.log("AllUsers:");
        console.log(this.tableData);
        loading.close();
      },
      async getAdmin(){
        let res=await this.actor.admins();
        this.searchData=[];
        for (const principal of res) {
          let admin = this.tableData.find( (item) => item.principal===principal );
          if(admin!=null){
            this.searchData.push(admin);
          }
          console.log(admin)
        }
        this.tableData=this.searchData;
        this.setCurrentPageData();
        console.log(this.searchData);
        console.log(this.tableData);
      },
      async openRole(user){
        this.$set(user, 'remindLoading', true);
          this.user=user;
          let res=await this.actor.getRole(user.principal);
          this.userRole=Object.keys(res.ok)[0];
          this.dialogVisible=true;
        this.$set(user, 'remindLoading', false);
      },
      async addRole(id){
        console.log("add");
        // type variant { admin; user; guest }
        let res=await this.actor.assignRole(id,{admin:null});
        console.log(res);
        this.$message({
          message: res,
          type: 'info'
        });
      },
      async setRole(){
        this.confirmLoading=true;
        let res=await eval("this.actor.assignRole('"+this.user.principal+"',{"+this.userRole+":null})");
        this.$message({
          message: res,
          type: 'info'
        });
        this.confirmLoading=false;
        if(Object.keys(res)[0]==="ok"){
          this.dialogVisible=false;
          this.$message({
            message: "操作成功",
            type: 'success'
          });
        }
      },
      async setUserState(id,method){
        //根据方法名调用对应方法
        console.log("this.actor."+method+"('"+id+"')");
        let res=await eval("this.actor."+method+"('"+id+"')");
        console.log(res);
        await this.getUser();
        this.$message({
          message: method+"操作成功",
          type: 'success'
        });
      },
      // 设置当前页面数据，对数组操作的截取规则为[0~10],[10~20]...,
      setCurrentPageData(val) {
        let begin = (this.currentPage - 1) * this.pageSize;
        let end = this.currentPage * this.pageSize;
        this.currentPageData = this.tableData.slice(
          begin,
          end
        );
        //计算总条目数
        this.total = this.tableData.length ;
      },
    }
  }
</script>
<style lang="scss" scoped>


</style>
