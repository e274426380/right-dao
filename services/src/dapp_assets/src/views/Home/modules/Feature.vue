<template>
  <section class="bg-half-170">
    <!-- Feature Start -->
    <div class="container">
      <div class="row">
        <div class="col-lg-24 col-md-24 mt-4 mt-sm-0 pt-2 pt-sm-0 why-create">
          <!-- <transition name="el-zoom-in-bottom" mode="in-out"> -->
          <div class="section-title ms-lg-3">
            <p class="title mb-4">{{ $t('home.feature.why') }}</p>
            <p class="text-muted">{{ $t('home.feature.why.desc') }}</p>
          </div>
          <!-- </transition> -->
          <!-- <transition name="el-zoom-in-bottom" mode="in-out"> -->
          <div style="text-align: center;">

          </div>
          <!-- </transition> -->
        </div>
        <!--end col-->
      </div>
      <div class="row row-data">
        <div class="col-lg-6 col-md-6 mt-5 pt-2 pt-sm-0 do-list" style="width:50%">
           <img src="~@/assets/images/logo@2x 2.png" class="img-fluid" alt="" />
          <!--  -->
        </div>
        <div class="col-lg-6 col-md-6 mt-5 pt-2 pt-sm-0 do-list">
          <div class="section-title row-wrapper ms-lg-3">
            <div class="icon-wrapper"> <img src="~@/assets/images/home/1.png" width="32px" height="32px" alt=""></div>
            <div class="section-content">
              <h4 class="title">{{ $t('home.feature.try') }}</h4>
              <p class="text-muted pb-4">{{ $t('home.feature.try.desc') }}</p>
            </div>
          </div>

          <div class="section-title row-wrapper ms-lg-3">
            <div class="icon-wrapper"> <img src="~@/assets/images/home/2.png" width="32px" height="32px" alt=""></div>
            <div class="section-content">
              <h4 class="title">{{ $t('home.feature.accelerate') }}</h4>
              <p class="text-muted pb-4">{{ $t('home.feature.accelerate.desc') }}</p>
            </div>
          </div>
          <div class="section-title row-wrapper ms-lg-3">
            <div class="icon-wrapper"> <img src="~@/assets/images/home/3.png" width="32px" height="32px" alt=""></div>
            <div class="section-content">
              <h4 class="title">{{ $t('home.feature.explore') }}</h4>
              <p class="text-muted pb-4">{{ $t('home.feature.explore.desc') }}</p>
            </div>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->
    </div>
    <!-- Feature End -->

    <el-scrollbar class="bar">
      <!-- <div class="active-img"> -->
      <template v-for="(item,index) in banners">

        <el-image v-if="item.imgSrc" :src=item.imgSrc :key="index"></el-image>
        <a v-else :href=item.outerUri target="_blank">
          <el-image :src=fitlerBlobToBase64(item.pic) :key="index"></el-image>
        </a>
      </template>
      <!-- </div> -->
    </el-scrollbar>
    <!-- <el-carousel :interval="4000" type="card" height="400px" indicator-position="none" style="margin-top: 120px">
      <el-carousel-item v-for="(item,index) in items" :key="index" style="border-radius: 24px">
        <el-image :src=item.imgSrc></el-image>
      </el-carousel-item>
    </el-carousel> -->
  </section>
</template>

<script>
  import { transformArrayBufferToBase64 } from '@/utils/utils';
  import Bus from "@/utils/bus";
function mouse_scroll(e, dbody) {
  e.preventDefault();
  e = e || window.event;
  var delD = e.wheelDelta ? e.wheelDelta : -e.detail * 40; //判断上下方向
  var move_s = delD > 0 ? -50 : 50;
  document.body.scrollLeft = document.body.scrollLeft;
  dbody.scrollLeft += move_s; //非chrome浏览器用这个
  //chrome浏览器用这个
  if (dbody.scrollLeft == 0) dbody.scrollLeft += move_s;

  return false;
}
//这个是给对象增加监控方法的函数
function objAddEvent(oEle, sEventName, fnHandler) {
  if (oEle.attachEvent) oEle.attachEvent("on" + sEventName, fnHandler);
  else oEle.addEventListener(sEventName, fnHandler, false);
}
export default {
  name: "HomeFeature",
  data() {
    return {
      banners:[]
    };
  },
  async mounted() {
    Bus.$on("actorCreated", () =>this.getBanner());
    if(this.$store.state.dapp){
      this.getBanner()
    }
    let dbody = document.getElementsByClassName("el-scrollbar__wrap")[0];
    objAddEvent(dbody, "mousewheel", function(e) {
      return mouse_scroll(e, dbody);
    });
  },
  methods:{
    async getBanner(){
      let res = await this.$store.state.dapp.getNewerBanner(10);
      let tableData = [];
      if(Object.keys(res)[0] === "ok"){
        for (const item of res.ok) {
          let banner={};
          banner=item[1];
          banner.bannerId = Number(banner.bannerId);
          //验证是否在网址前加了http，没有加则自己加上
          let url=banner.outerUri;
          if(url.substr(0,7).toLowerCase() !== "http://" && url.substr(0,8).toLowerCase() !== "https://"){
            url = "http://" + url;
          }
          banner.outerUri=url;
          if(banner.bannerCategory==='home')
          { //主页
            tableData.push(banner);
          }else if(banner.bannerCategory==='dapp'){
            //dapp库
          }
        }
        this.banners=tableData;
        console.log("banners:");
        console.log(this.banners);
      }else {
        // this.$message.error("获取轮播图失败");
        console.log("not get banner");
        console.log(res);
        this.banners=this.items;
      }
    },
    fitlerBlobToBase64(file) {
      return transformArrayBufferToBase64(file)
    },
  },
  computed: {
    items() {
      // 如果切换语言的图片只需要在active的基础上加-en之类的名字即可，比如active1-en.jpg。
      //i18n切换图片
      return [
        {
          imgSrc: require("@/assets/images/banner/active1" +
            this.$t("banner.active1"))
        },
        {
          imgSrc: require("@/assets/images/banner/active2" +
            this.$t("banner.active2"))
        },
        {
          imgSrc: require("@/assets/images/banner/active3" +
            this.$t("banner.active3"))
        }
      ];
    }
  }
};
</script>

<style lang="scss">
.bg-half-170 {
  .el-scrollbar {
    padding: 0 30px;
    .el-scrollbar__wrap {
      height: 360px;
      overflow-y: hidden;
      .el-scrollbar__view {
        white-space: nowrap !important;
        .el-image {
          overflow: hidden;
          height: 360px;
          width: 640px;
          margin-right: 30px;

        }
      }
    }
  }
}
</style>
<style lang="scss" scoped>
.bg-half-170 {
  color: #ffffff;
  .why-create {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    .section-title {
      flex-basis: 50%;
      padding-right: 45px;
      .title {
        font-size: 56px;
        line-height: 66px;
        /* identical to box height */
      }
      .text-muted {
        color: #ffffff !important;
        font-weight: 300;
        font-size: 18px;
        line-height: 24px;
        opacity: 0.8;
        word-break: break-all;
      }
    }
    .img-fluid {
      width: 495px;
      margin: auto;
    }
    .do-list {
      display: flex;
      justify-content: flex-end;
    }
  }
  @media screen and (max-width: 900px) {
    .why-create {
      display: block;
    }
  }
  .row-data {
    margin: 100px 0;
    .img-fluid {
      width: 495px;
      margin: auto;
    }
  }
}

.row-wrapper {
  display: flex;
  align-items: center;
  margin-bottom: 4.5rem;
  .icon-wrapper {
    min-width: 100px;
    height: 100px;
    border: 0.1px solid #b6fd2166;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    i {
      font-size: 32px;
    }
  }

  .section-content {
    margin-left: 20px;
    .text-muted {
      color: #ffffff !important;
      opacity: 0.8;
      font-weight: 300;
      padding-bottom: 0 !important;
      font-size: 18px;
    }
  }
}

.active-img {
  width: 100%;
  overflow: hidden;
  overflow-x: auto;
  display: flex;
  .el-image {
    display: inline-block;
  }
}
.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 200px;
  margin: 0;
}
</style>
