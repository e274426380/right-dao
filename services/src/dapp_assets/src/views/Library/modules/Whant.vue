<template>
  <section class="bg-half">
    <div class="container">
      <el-row>
          <p class="para-title" v-html="$t('library.whant.title')"></p>
      </el-row>
      <el-row :gutter="20" style="margin-top: 120px">
        <!--<el-col :span="6" v-for="(card, index) in cardData" :key="index">-->
          <!--<el-card class="quick-card" :body-style="{ padding: '30px' }" shadow="hover"-->
                   <!--@click.native="switchStart(index+1)">-->
            <!--<div slot="header" class="card-head">-->
              <!--<img alt="" :src="card.imgSrc" class="image" />-->
            <!--</div>-->
            <!--<div class="card-text">-->
              <!--<span>{{ card.text }}</span>-->
            <!--</div>-->
          <!--</el-card>-->
        <!--</el-col>-->
        <el-col :sm="6" :xs="12" class="building-card" v-for="(card, index) in cardData" :key="index" >
          <div class="head-icon flex-all-center" style="flex-wrap: nowrap;">
            <i :class=icon[index]></i>
          </div>
            <p class="card-text">{{ card.text }}</p>
            <p class="card-subtext" v-html="card.subtext"></p>
          <div class="href-array" v-for="(item, index) in card.href" :key="index">
            <a :href=item.url class="href-class" target="_blank">{{item.name}}</a>
          </div>
        </el-col>
      </el-row>
    </div>
    <el-row class="wishlist-body">
      <el-col :span="24">
        <div class="wishlist flex-all-center">
          <div class="flex-x-center">
            <div class="wishlist-text">
              <p class="flex-y-center">{{$t('library.whant.wishlist')}}
                <i class="iconfont icon-Vector" style="margin-left: 20px"></i></p>
              <p>{{$t('library.whant.wishListText')}}</p>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
  </section>
</template>

<script>
export default {
  name: 'Whant',
  data() {
    return {
      start:"",
      index:"",
      loading:false,
      icon:[
        "iconfont icon-a-QuickStart",
        "iconfont icon-a-Forindividual",
        "iconfont icon-Developers",
        "iconfont icon-a-Whitepaper",
      ]
    }
  },
  computed: {
    cardData() {
      return [
        {
          text: this.$t('library.whant.card1'),
          subtext:this.$t('library.whant.subtext1'),
          href: [
            {
              url:"https://www.icpleague.com/",
              name:"ICPL forum"
            },
            {
              url:this.$t('library.starts.card1.2.url'),
              name:"Gitbook"
            },
          ],
        },
        {
          text: this.$t('library.whant.card2'),
          subtext:this.$t('library.whant.subtext2'),
          href: [
            {
              url:this.$t('library.starts.card2.1.url'),
              name:"Gitbook"
            },
            // {
            //   url:"",
            //   name:this.$t('library.starts.card2.2.title')
            // },
            // {
            //   url:"",
            //   name:this.$t('library.starts.card2.3.title')
            // },
          ],
        },
        {
          text: this.$t('library.whant.card3'),
          subtext:this.$t('library.whant.subtext3'),
          href: [
            {
              url:this.$t('library.starts.card3.1.url'),
              name:this.$t('library.starts.card3.1.title')
            },
            // {
            //   url:"",
            //   name:this.$t('library.starts.card3.2.title')
            // },
            {
              url:this.$t('library.starts.card3.3.url'),
              name:this.$t('library.starts.card3.3.title')
            },
          ],
        },
        {
          text: this.$t('library.whant.card4'),
          subtext:this.$t('library.whant.subtext4'),
          href: [
            {
              url:this.$t('library.starts.card4.1.url'),
              name:this.$t('library.starts.card4.1.title')
            },
            // {
            //   url:"",
            //   name:this.$t('library.starts.card4.2.title')
            // },
          ],
        }
      ]
    },
    starts() {
      return [
        {
          index: 1,
          tag: this.$t('library.whant.card1'),
          content: [
            {
              title: this.$t('library.starts.card1.1.title'),
              text: this.$t('library.starts.card1.1.text'),
              url: this.$t('library.starts.card1.1.url'),
            },
            {
              title: this.$t('library.starts.card1.2.title'),
              text: this.$t('library.starts.card1.2.text'),
              url: this.$t('library.starts.card1.2.url'),
            },
          ]
        },
        {
          index: 2,
          tag: this.$t('library.whant.card2'),
          content: [
            {
              title: this.$t('library.starts.card2.1.title'),
              text: this.$t('library.starts.card2.1.text'),
              url: this.$t('library.starts.card2.1.url'),
            },
            {
              title: this.$t('library.starts.card2.2.title'),
              text: this.$t('library.starts.card2.2.text'),
            },
            {
              title: this.$t('library.starts.card2.3.title'),
              text: this.$t('library.starts.card2.3.text'),
            },
          ]
        },
        {
          index: 3,
          tag: this.$t('library.whant.card3'),
          content: [
            {
              title: this.$t('library.starts.card3.1.title'),
              text: this.$t('library.starts.card3.1.text'),
              url: this.$t('library.starts.card3.1.url'),
            },
            {
              title: this.$t('library.starts.card3.2.title'),
              text: this.$t('library.starts.card3.2.text'),

            },
            {
              title: this.$t('library.starts.card3.3.title'),
              text: this.$t('library.starts.card3.3.text'),
              url: this.$t('library.starts.card3.3.url'),
            },
          ]
        },
        {
          index: 4,
          tag: this.$t('library.whant.card4'),
          content: [
            {
              title: this.$t('library.starts.card4.1.title'),
              text: this.$t('library.starts.card4.1.text'),
              url: this.$t('library.starts.card4.1.url'),
            },
            {
              title: this.$t('library.starts.card4.2.title'),
              text: this.$t('library.starts.card4.2.text'),
            },
          ]
        },
      ]
    },
  },
  watch: {
    starts(newVal, oldVal) {
      this.switchStart(this.index);
    }
  },
  mounted(){
    //初始化从快速开始开始
    this.start=this.starts[0];
  },
  methods:{
    switchStart(index){
      this.loading=true;
      console.log(this.loading);
      var starts=this.starts;
      this.index=index;
      for (const start of starts) {
        if(start.index===index){
          this.start=start;
        }
      }
      setTimeout(() => (this.loading = false), 250)
    }
  }
}
</script>

<style lang="scss" scoped>

.bg-half {
  font-family: Roboto;
  padding: 96px 0;
  color: #ffffff;
  .para-title {
    font-style: normal;
    font-weight: bold;
    font-size: 48px;
    line-height: 66px;
  }
  .para-desc {
    font-style: normal;
    font-weight: 300;
    font-size: 20px;
    line-height: 23px;
    color: #ffffff;
    opacity: 0.8;
    margin-top: 24px;
  }
}
.quick-card {
  /*margin-top: 40px;*/
  border-radius: 8px;
  transition: 0.3s;
}
.quick-card:hover{
  cursor: pointer;
  transform: translateY(-10px);
  span{
    border-bottom: 2px solid white;
    padding-bottom: 4px;
  }
}
.quick-card ::v-deep .el-card__header {
  padding: 36px;
  background: #f0f2fe;
}
.quick-card ::v-deep .el-card__body {
  background: #425ce1;
  opacity: 0.85;
}
.building-card {
  text-align: center;
  font-family: Roboto;
}
.head-icon{
  border: 0.1px solid #B6FD21;
  box-sizing: border-box;
  text-align: center;
  border-radius:50%;
  padding: 30px;
  width: 100px;
  height: 100px;
  margin:0 auto;
}
.iconfont{
  font-size:40px;
  color: #B6FD21;
}
.card-text {
  font-style: normal;
  font-weight: 500;
  font-size: 30px;
  line-height: 33px;
  transition: 0.2s;
  margin-top:25px;
}
.card-subtext{
  font-style: normal;
  font-weight: normal;
  font-size: 14px;
  line-height: 16px;
  text-align: center;
  opacity: 0.6;
  margin-bottom: 50px;
}
.href-array{
  a{
    font-style: normal;
    font-weight: 300;
    font-size: 14px;
    line-height: 16px;
    text-align: center;
    text-decoration-line: underline!important;
    color: #B6FD21;
    opacity: 0.8;
    transition: 0.2s;
    &:hover{
      opacity: 0.6;
    }
  }
}
.card-text:hover {
  /*cursor: pointer;*/
  /*transform: translateY(-10px);*/
}
.card-text span:hover {
  /*border-bottom: 2px solid white;*/
  /*padding-bottom: 4px;*/
}

.left-border {
  border-left: 8px solid rgba(66, 92, 225, 0.2);
  padding-left: 20px;
  margin:0 0 60px 0;
}

.blue-title {
  /*float: left;*/
  font-size: 24px;
  font-weight: 600;
  color: #5c72e5;
  margin-bottom: 20px;
}
.text-subtitle1 {
  /*float: left;*/
  font-size: 20px;
  font-weight: 400;
  color: #333333;
}
.wishlist-body{
  margin: 200px 0 100px 0;
  padding: 100px 0;
  background: linear-gradient(90deg, rgba(231, 32, 57, 0.6) 0%,
    rgba(214, 168, 81, 0.6) 32.35%,
    rgba(55, 139, 188, 0.6) 65.71%,
    rgba(81, 44, 134, 0.6) 100%);
}
.wishlist {
  width: 100%;
  height: 247px;
}
.wishlist-text {
  font-family: Roboto;
  font-style: normal;
  font-weight: bold;
  font-size: 56px;
  line-height: 66px;

  color: #FFFFFF;
}
</style>
