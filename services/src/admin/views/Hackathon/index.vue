<template>
  <section>
    <el-tabs v-model="tags" @tab-click="handleClick">
      <el-tab-pane
        v-for="(item,index) in tabs"
        :key="index"
        :label=item.label :name=item.route
        lazy="true">
      </el-tab-pane>
      <router-view></router-view>
    </el-tabs>
  </section>
</template>

<script>
  import {  timestampToDate } from "a@/utils/utils"
  export default {
    name: 'Hackathon',
    data() {
      return {
        //从vuex中读取actor，如果没有就为空
        tabs:[
          {
            label:"赞助商",
            route:"Sponsors",
          },
          {
            label:"奖项",
            route:"Awards",
          },
          {
            label:"赏金",
            route:"Bounty",
          },
          {
            label:"黑客松活动",
            route:"Hackathon",
          },
        ],
        tags:"Sponsors",
      }
    },
    methods:{
      handleClick(tab, event){
        this.$router.push(
          {
            name: tab.name
          }
        );
      },
    },
    mounted(){
      this.handleClick({name:"Sponsors"});
    }
  }
</script>

<style lang="scss" scoped>

</style>
