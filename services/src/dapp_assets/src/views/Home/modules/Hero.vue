<template>
  <!-- Hero Start -->
  <section class="bg-half">

    <div class="container">
      <div class="title-heading text-center">
        <transition name="el-zoom-in-top" mode="in-out">
          <h1 v-if="show" appear="true" class="para-title font-weight-bold text-white">{{ $t('home.hero.title') }}</h1>
        </transition>
        <transition name="el-zoom-in-top" mode="in-out">
          <p v-if="show" class="para-desc mx-auto text-white">{{ $t('home.hero.desc') }}</p>
        </transition>
        <!-- <el-button class="para-login">Log in Internet Identity</el-button> -->
        <div>
          <transition-group tag="div" name="el-zoom-in-bottom" mode="in-out" class="para-data">
            <div v-if="show" class="para-data-chid" key="box1">
              <div class="data-title">{{ $t('home.hero.dataTitle1') }}</div>
              <div class="data-content">{{summaryData.userCount}}</div>
            </div>
            <div v-if="show" class="para-data-chid" key="box2">
              <div class="data-title">{{ $t('home.hero.dataTitle2') }}</div>
              <div class="data-content">{{summaryData.rewardCount  | rewardCountFilter}}</div>
            </div>
            <div v-if="show" class="para-data-chid" key="box3">
              <div class="data-title">{{ $t('home.hero.dataTitle3') }}</div>
              <div class="data-content">{{summaryData.dappCount}}</div>
            </div>
          </transition-group>
        </div>
      </div>
    </div>
  </section>
  <!-- Hero End -->
</template>

<script>
import Bus from "@/utils/bus";
export default {
  name: "HomeHero",
  filters: {
    rewardCountFilter(val) {
      val = Number(val);
      return val > 0 ? val * 0.00000001 : val;
    }
  },
  data() {
    return {
      show: false,
      summaryData: {
        userCount: 0,
        dappCount: 0,
        rewardCount: 0
      }
    };
  },
  mounted() {
    setTimeout(() => {
      this.show = true;
    }, 500);
    this.stateSummary();
    Bus.$on("actorCreated", () => this.stateSummary());
  },
  methods: {
    async stateSummary() {
      if (this.$store.state.dapp) {
        this.summaryData = await this.$store.state.dapp.stateSummary();
        console.log(this.summaryData);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
// css
.fade-enter,
.fade-leave-to {
  // 声明入场的开始和离场的结束的样式
  opacity: 0;
}
.fade-enter-active,
.el-zoom-in-bottom,
.fade-leave-active {
  // 声明过渡动画持续时间
  transition: opacity 3s;
}
.bg-half {
  font-family: Roboto;
  height: 707px;
  color: #ffffff;
  .para-data,
  .para-title,
  .para-desc {
    z-index: 999;
    position: relative;
  }
  .title-heading {
    min-height: 430px;
  }
  .text-center::after {
    width: 473px;
    height: 473px;
    content: "";
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%) rotate(-90deg);
    background: linear-gradient(
      180deg,
      rgba(231, 32, 57, 0.6) 0%,
      rgba(214, 168, 81, 0.6) 31.25%,
      rgba(55, 139, 188, 0.6) 61.46%,
      rgba(81, 44, 134, 0.6) 100%
    );
    filter: blur(100px);
    z-index: 1;
  }
  .para-title {
    font-style: normal;
    font-weight: bold;
    font-size: 62px !important;
    line-height: 73px;
    text-align: center;
    margin-top: 10px;
  }
  .para-desc {
    font-style: normal;
    font-weight: 300;
    font-size: 20px;
    line-height: 23px;
    text-align: center;
    color: #ffffff;
    opacity: 0.8;
    margin-top: 24px;
  }
  .para-login {
    background: #b6fd21;
    border-color: #b6fd21;
    border-radius: 4px;
    margin-top: 44px;
    font-family: Roboto;
    font-style: normal;
    font-weight: 500;
    font-size: 14px;
    line-height: 16px;
    text-align: center;
    color: #17161d;
  }
  .para-data {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    margin-top: 200px;
    .para-data-chid {
      margin: auto;
      .data-title {
        font-size: 18px;
        line-height: 21px;
        /* identical to box height */
        text-align: center;
        opacity: 0.8;
      }
      .data-content {
        font-size: 42px;
        line-height: 49px;
        margin-top: 10px;
      }
    }
  }
}
</style>
