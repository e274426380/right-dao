<template>
  <div class="home">
    <PageNavbar />
    <HomeHero />
    <HomeFeature />
    <HomeDApp />
    <!-- <HomeCard /> -->
    <HomePartners />
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from "@/components";
import {
  HomeHero,
  HomeFeature,
  HomeDApp,
  HomeCard,
  HomePartners
} from "./modules";
export default {
  name: "Home",
  components: {
    PageNavbar,
    HomeHero,
    HomeFeature,
    HomeDApp,
    HomeCard,
    HomePartners,
    PageFooter
  }
};
</script>
<style lang="scss">
.home {
  background: #000000;
  font-family: Roboto, Helvetica, Tahoma, Arial, "PingFang SC", "Hiragino Sans GB", "Heiti SC", "Microsoft YaHei", "WenQuanYi Micro Hei", serif !important;
  .el-zoom-in-bottom-enter-active,
  .el-zoom-in-bottom-leave-active {
    opacity: 1;
    transform: translate(0, 0);
    transition: transform 3000ms cubic-bezier(0.23, 1, 0.32, 1),
      opacity 3000ms cubic-bezier(0.23, 1, 0.32, 1);
    transform-origin: center bottom;
  }
  .el-zoom-in-bottom-enter,
  .el-zoom-in-bottom-leave-active {
    opacity: 0;
    transform: translate(0, 200px);
  }
  .el-zoom-in-top-enter-active,
  .el-zoom-in-top-leave-active {
    opacity: 1;
    transform: translate(0, 0);
    transition: transform 3000ms cubic-bezier(0.23, 1, 0.32, 1),
      opacity 3000ms cubic-bezier(0.23, 1, 0.32, 1);
    transform-origin: center bottom;
  }
  .el-zoom-in-top-enter,
  .el-zoom-in-top-leave-active {
    opacity: 0;
    transform: translate(0, -200px);
  }
}
</style>
