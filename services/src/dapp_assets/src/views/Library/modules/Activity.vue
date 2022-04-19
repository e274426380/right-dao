<template>
  <section class="bg-half">
    <div class="container">
      <el-row>
        <el-col :span="24">
          <el-row class="flex-center act-head" type="flex" justify="space-between">
            <div>
              <span>{{$t('library.activity.title')}}</span>
            </div>
          </el-row>
          <el-row>
            <div style="float: right">
              <!--<button class="btn btn-primary btn-sm">{{$t('button.more')}}</button>-->
              <!--<a class="href-button" href="">More and more>></a>-->
            </div>
          </el-row>
          <hr class="i-hr"/>
          <el-row>
            <el-col :span="24" class="act-card" v-for="(act, index) in actData" :key="index">
              <el-col :sm="6" :xs="24" class="act-img">
                <img alt="" :src="act.imgSrc" />
              </el-col>
              <el-col :sm="18" :xs="24" class="act-text">
                <a target="_blank" :href="act.url">
                  <div class="act-text-head">
                    <span>{{ act.title }}</span>
                  </div>
                  <div class="act-content">
                    {{ act.content }}
                  </div>
                  <div class="act-bottom">
                    <span>{{ act.startDate }} - {{ act.endDate }}</span>
                  </div>
                </a>
              </el-col>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Activity',
  data() {
    return {
      actData: [
        {
          imgSrc: require('@/assets/images/event/event1.jpg'),
          title: '【生态峰会】DFINITY & ICPL 线上活动',
          content:
            'ICPL&DFINITY 官方联合举办：互联网计算机首届生态峰会，奇点降临 ICP 生态正在发生一次大爆炸，互联网计算' +
            '机运行着 100+ Grant、5000+ 智能合约、100+ DApp，生态最核心的项目将首次与观众见面！',
          startDate: 'Sep 16.2021',
          endDate: 'Sep 17.2021',
          url:"https://www.icpleague.com/thread/290"
        },
      ]
    }
  }
}
</script>
<style lang="scss" scoped>
.bg-half {
  padding: 36px 0;
}

.flex-center {
  display: flex;
  align-items: center;
}
.i-hr{
  color: #FFFFFF;
  width:110%;
  position: relative;
  right: 5%;
}
.act-head span:first-child {
  display: block;
  font-family: Roboto;
  font-style: normal;
  font-weight: bold;
  font-size: 48px;
  line-height: 66px;
  color: #FFFFFF;
}
.act-head span:nth-child(2) {
  font-family: Roboto;
  font-style: normal;
  font-weight: 300;
  font-size: 18px;
  line-height: 21px;
  color: #FFFFFF;
  opacity: 0.8;
}
.more-button {
  width: 88px;
  height: 40px;
  border-radius: 8px;
  padding-bottom: 0;
  padding-top: 0;
  font-size: 18px;
  font-family: SourceHanSansCN;
  font-weight: 400;
}
.act-card {
  /*background: rgba(255, 255, 255, 0.2);*/
  border-radius: 8px;
  width: 100%;
  margin-top: 36px;
}
.act-img {
  height: 210px;
  img{
    width: 100%;
    height: 100%;
    border-radius: 24px;
  }
}
.act-text {
  padding: 0 20px 20px 20px;;
}
.act-text-head {
  font-family: Roboto;
  font-style: normal;
  font-weight: bold;
  font-size: 24px;
  line-height: 28px;
  padding-bottom: 14px;
  color: #FFFFFF;
}
.act-content {
  font-family: Roboto;
  font-style: normal;
  font-weight: 300;
  font-size: 18px;
  line-height: 21px;
  color: #FFFFFF;
  opacity: 0.6;
}
.act-bottom{
  font-family: Roboto;
  font-style: normal;
  font-weight: 300;
  font-size: 18px;
  line-height: 16px;
  color: #FFFFFF;
  position:absolute;
  bottom:0px;
}
.href-button{
  font-family: Roboto;
  font-style: normal;
  font-weight: 300;
  font-size: 14px;
  line-height: 16px;
  text-decoration-line: underline!important;
  color: #B6FD21;
  opacity: 0.8;
}
.section-title {
  display: block;
  font-size: 26px;
  font-weight: 600;
  color: #333333;
}
.community-card {
  padding: 40px !important;
  background: #f0f2fe;
  border-radius: 8px;
}
.community-title {
  margin-top: 0;
  margin-bottom: 100px;
}
.footer-title {
  font-size: 26px;
  display: block;
  font-family: JetBrains Mono;
  font-weight: 600;
  color: #8590a6;
}
.footer-subtitle {
  display: block;
  margin-top: 19px;
  margin-bottom: 37px;
  font-size: 18px;
  font-family: JetBrains Mono;
  font-weight: 600;
  color: #8590a6;
}
.email-input {
  margin-bottom: 90px;
}
.email-input ::v-deep .el-input {
  width: 60%;
  min-width: 200px;
}
.email-input ::v-deep .el-input__inner {
  height: 48px;
  border-radius: 8px;
  font-weight: 400;
  font-size: 18px;
  font-family: SourceHanSansCN;
}
.sign {
  width: 116px !important;
  height: 40px;
  font-size: 18px;
  font-weight: 600;
  border-radius: 20px;
  margin-left: 36px;
}
</style>
