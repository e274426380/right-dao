<template>
  <div>
    <div>
      <el-row>
        <el-col :span="2" style="height: 36px;line-height: 36px">
          <label>PrincipalId:</label>
        </el-col>
        <el-col :span="8">
          <el-input
            placeholder="请输入ID"
            v-model="selectId"
            clearable>
          </el-input>
        </el-col>
        <el-col :span="8" style="margin-left: 10px">
          <el-button type="primary" icon="el-icon-search" @click="findLog('findByCanister',selectId)">按CanisterId搜索</el-button>
          <el-button type="success" icon="el-icon-search" @click="findLog('findByCaller',selectId)">按CallerId搜索</el-button>
          <!--<el-button type="primary" @click="test()">测试</el-button>-->
        </el-col>
      </el-row>
      <br/>
      <el-row>
        <el-col :span="24">
          <el-button type="primary" @click="getLog()">所有日志</el-button>
          按日志等级筛选：
          <el-radio-group v-model="radio" @change="findLevel">
            <el-radio-button label="全部"></el-radio-button>
            <el-radio-button label="deb"></el-radio-button>
            <el-radio-button label="info"></el-radio-button>
            <el-radio-button label="warn"></el-radio-button>
            <el-radio-button label="error"></el-radio-button>
          </el-radio-group>
        </el-col>
      </el-row>
      <br/>
      <el-row>
        <el-col :span="24">
          <el-table :data="currentPageData" border>
            <el-table-column type="index" label="序号" width="50" align="center"
                             sortable></el-table-column>
            <el-table-column align="center" prop="caller" label="Caller" width="225"></el-table-column>
            <el-table-column align="center" prop="canisterId" label="CanisterId" width="225"></el-table-column>
            <el-table-column align="center" prop="msg" label="日志信息" width="600"></el-table-column>
            <el-table-column align="center" prop="happenAt" label="创建时间" width="180"
                             sortable
                             :formatter="timestampToDate"></el-table-column>
            <el-table-column align="center" prop="level" label="日志级别" width="100"
                             :filters="[{text: 'deb', value: 'deb'},
                             {text: 'info', value: 'info'},
                             {text: 'warn', value: 'warn'},
                             {text: 'error', value: 'error'}]"
                             :filter-method="filterLevel">
            </el-table-column>
            <el-table-column align="center" label="操作">
              <template slot-scope="scope">
                <!--<el-button size="mini" type="info" @click="handleEdit(scope.row.principal)">编辑</el-button>-->
                <el-button size="mini" type="primary" @click="findLog('findByCanister',scope.row.canisterId)"
                style="margin-bottom: 5px;">按此CanisterId查询</el-button>
                <el-button size="mini" type="success" @click="findLog('findByCaller',scope.row.caller)">按此CallerId查询</el-button>
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
    </div>
  </div>
</template>

<script>
  import {  timestampToDate } from "a@/utils/utils"
  export default {
    name: 'Log',
    data() {
      return {
        //从vuex中读取actor，如果没有就为空
        actor:this.$store.state.dapp|| "",
        log:this.$store.state.log|| "",
        tableData: [],
        selectId:"",
        loading:false,
        total: 0, // 总条目数，默认为0
        currentPage: 1, //当前页数 ，默认为1
        pageSize: 10, // 每页显示数量
        currentPageData: [], //当前页显示内容
        radio:"全部",
      }
    },
    methods:{
      async test(){
        // let res = await this.log.findByCanister('2x',17);
        // console.log(res);
      },
      async getLog(){
        if(this.radio!=="全部"){
          this.radio="全部";
        }
        const loading=this.startLoading(".el-table__body-wrapper",null);
        let res = await this.log.take(1000);
        this.total=res.length;
        let tableData = [];
        for (const item of res) {
          // item.happenAt = timestampToDate(item.happenAt);
          tableData.push(item);
        }
        this.tableData=tableData;
        this.setCurrentPageData();
        loading.close();
      },
      async findLog(method,id) {
        if(id!=null&&id!==""){
          const loading=this.startLoading(".el-table__body-wrapper",null);
          console.log("this.log." + method + "('" + id + "',100)");
          const timer=setTimeout(() => {
            //防止一直没有关闭
            loading.close();
            this.$message({
              message: "查询超时",
              type: 'error'
            });
          }, 3000);
          let res = await eval("this.log." + method + "('" + id + "',100)");
          this.total=res.length;
          let tableData = [];
          for (const item of res) {
            // item.happenAt = timestampToDate(item.happenAt);
            tableData.push(item);
          }
          this.tableData=tableData;
          this.setCurrentPageData();
          clearTimeout(timer);
          console.log(res);
          loading.close();
        }else {
          this.$message({
            message: "查找的ID不能为空",
            type: 'error'
          });
        }
      },
      findLevel(value){
        if(value==='全部'){
          this.getLog();
        }else {
          this.findLog('findByLevel',value);
        }
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
      timestampToDate(row, column){
        return row.happenAt=timestampToDate( row.happenAt);
      },
      filterLevel(value, row, column){
        const property = column['property'];
        return row[property] === value;
      }
    },
    mounted(){
      this.getLog();
    }
  }
</script>

<style lang="scss" scoped>

</style>
