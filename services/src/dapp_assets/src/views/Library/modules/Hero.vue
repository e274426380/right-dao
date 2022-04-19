<template>
  <!-- Hero Start -->
  <section class="d-table w-100 bg-half" id="home">
    <div class="container">
      <div class="align-items-center">
        <div>
          <div class="title-heading text-center">
            <transition name="el-zoom-in-top" mode="in-out">
              <p v-if="show" class="heading para-title font-weight-bold text-white">
                DFINITY {{$t('home.navbar.library')}}
              </p>
            </transition>
            <transition name="el-zoom-in-top" mode="in-out">
              <p v-if="show" class="para-desc mx-auto text-white">
                {{$t('library.head.subtext')}}
              </p>
            </transition>
          </div>
        </div>
      </div>
    </div>
    <!--end container-->
  </section>
  <!--end section-->
  <!-- Hero End -->
</template>

<script>
export default {
  name: 'LibraryHero',
  data() {
    return {
      show: false,
    };
  },
  mounted() {
    setTimeout(() => {
      this.show = true;
    }, 500);
  },
}
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
  .bg-half::after{
    width: 473px;
    height: 473px;
    content: '';
    position: absolute;
    left: 50%;
    top:50%;
    transform:translate(-50%,-50%) rotate(-90deg);
    background: linear-gradient(
        180deg, rgba(231,32,57,0.6) 0%, rgba(214,168,81,0.6) 31.25%, rgba(55,139,188,0.6) 61.46%, rgba(81,44,134,0.6) 100%);
    filter: blur(100px);
    z-index: 1;
  }
  .title-heading{
    position:relative;
    z-index: 2;
    min-height: 143px;
  }
.bg-half {
  font-family: Roboto;
  color: #ffffff;
  padding-bottom: 200px;
  .para-title {
    font-style: normal;
    font-weight: bold;
    font-size: 62px;
    line-height: 73px;
    text-align: center;
  }
  .para-desc {
    font-style: normal;
    font-weight: 300;
    font-size: 20px;
    line-height: 23px;
    text-align: center;
    color: #ffffff;
    opacity: 0.8;
  }
  .para-login {
    background: #b6fd21;
    border-radius: 4px;
    margin-top: 44px;
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
