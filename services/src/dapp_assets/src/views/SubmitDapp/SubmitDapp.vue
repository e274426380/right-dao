<template>
  <div id="submitDapp" class="submit-wrapper">
    <PageNavbar />
    <DetailSection />
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from "@/components";
import DetailSection from "./modules/Section.vue";
export default {
  name: "Detail",
  components: { PageNavbar, PageFooter, DetailSection },
  mounted() {
    const element = document.getElementById('submitDapp')
     element.onscroll = function () {
        if (
          element.scrollTop > 50 ||
          document.documentElement.scrollTop > 50
        ) {
          document.getElementById('topnav').classList.add('nav-sticky')
        } else {
          document.getElementById('topnav').classList.remove('nav-sticky')
        }
        // 页面右下角返回顶部按钮
        // if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
        //   document.getElementById('back-to-top').style.display = 'inline'
        // } else {
        //   document.getElementById('back-to-top').style.display = 'none'
        // }
      }
  },
};
</script>
<style lang="scss" scoped>
body {
  height: 100% !important;
  #app {
    height: 100% !important;
  }
}
.submit-wrapper {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
  overflow-y: auto;
}
</style>
