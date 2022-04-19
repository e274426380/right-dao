<template>
  <div>
    <!-- Footer Start -->
    <footer class="footer">
      <Forum></Forum>
      <div class="container">
        <el-row class="footer-wrapper">
          <el-col :md="8" :sm="8" :xs="24">
            <h4 class="footer_title">{{$t('footer.head.community')}}</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://medium.com/icp-league" target="_blank" class="footer_text"><i class="iconfont icon-a-medium11"></i></a>
              </li>
              <li>
                <a href="https://icpleague.com/" target="_blank" class="footer_text"><i class="iconfont icon-a-forum1"></i></a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text"><i class="iconfont icon-a-github-fill1"></i></a>
              </li>
            </ul>
          </el-col>
        </el-row>
        <el-row class="footer-wrapper">
          <el-col :md="8" :sm="8" :xs="24">
            <h4 class="footer_title">{{$t('footer.head.contactus')}}</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text"><i class="iconfont icon-a-twitter21"></i></a>
              </li>
              <li>
                <a href="https://t.me/joinchat/qNiiCG5GAB9mZjc1" target="_blank" class="footer_text"><i class="iconfont icon-a-bxl-telegram1"></i></a>
              </li>
            </ul>
          </el-col>
        </el-row>
        <el-row :gutter="24">
          <!-- <el-col :md="8" :sm="8" :xs="24">
            <img style="margin-top: 60px" src="@/assets/images/navigation/logo@2x.png" height="37" />
          </el-col> -->
          <!--<el-col :md="6" :sm="12" :xs="24">-->
          <!--<h4 class="footer_title">Private</h4>-->
          <!--<ul class="list-unstyled mt-4">-->
          <!--<li>-->
          <!--<a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text">Privacy Policy</a>-->
          <!--</li>-->
          <!--<li>-->
          <!--<a href="https://www.icpleague.com" target="_blank" class="footer_text">Terms of Use</a>-->
          <!--</li>-->
          <!--</ul>-->
          <!--</el-col>-->
          <!-- <el-col :md="8" :sm="8" :xs="24">
            <h4 class="footer_title">{{$t('footer.head.community')}}</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://medium.com/icp-league" target="_blank" class="footer_text">Medium</a>
              </li>
              <li>
                <a href="https://icpleague.com/" target="_blank" class="footer_text">Forum</a>
              </li>
              <li>
                <a href="https://www.icpleague.com" target="_blank" class="footer_text">Github</a>
              </li>
            </ul>
          </el-col>
          <el-col :md="8" :sm="8" :xs="24">
            <h4 class="footer_title">{{$t('footer.head.contactus')}}</h4>
            <ul class="list-unstyled mt-4">
              <li>
                <a href="https://twitter.com/icpleague_com" target="_blank" class="footer_text">Twitter</a>
              </li>
              <li>
                <a href="https://t.me/joinchat/qNiiCG5GAB9mZjc1" target="_blank" class="footer_text">Telegram</a>
              </li>
            </ul>
          </el-col>-->
        </el-row>
      </div>
      <!--end container-->
      <div class="container text-center mt-3">
        <p class="mb-0 copyright">© {{ new Date().getFullYear() }} ICPLeague. All rights reserved.</p>
      </div>
    </footer>
    <!--end footer-->
  </div>
</template>
<script>
import Forum from "./Forum.vue";
export default {
  components: {
    Forum
  }
};
</script>
<style lang="scss" scoped>
.footer {
  background: #000;
  padding: 50px 0 32px;
  color: #8590a6;
  z-index: 0;
  .footer-wrapper {
    display: flex;
    justify-content: center;
    align-content: center;
    text-align: center;
    color: #ffffff;
    margin-bottom: 120px !important;
  }
  .list-unstyled {
    display: flex;
    justify-content: space-around;
    margin-top: 60px !important;
  }
  &_title {
    letter-spacing: 1px;
    font-weight: 500;
    margin: 0;
  }

  &_text {
    color: #8590a6;
  }
  a.footer_text {
    color: #ffffff;
    i {
      font-size: 40px;
    }
  }
  a.footer_text:hover,
  a.footer_text:focus {
    color: #b6fd21 !important;
  }
  .text-center {
    color: #ffffff;
    opacity: 0.6;
    font-weight: 300;
    font-size: 12px;
    line-height: 14px;
  }
}
.copyright{
  opacity: 0.6;
}
.footer::after {
  width: 473px;
  height: 473px;
  content: "";
  position: absolute;
  right: -18%;
  top: 64%;
  transform: translate(-50%, -50%) rotate(-90deg);
  background: linear-gradient(
    180deg,
    rgba(231, 32, 57, 0.6) 0%,
    rgba(214, 168, 81, 0.6) 31.25%,
    rgba(55, 139, 188, 0.6) 61.46%,
    rgba(81, 44, 134, 0.6) 100%
  );
  filter: blur(100px);
  z-index: -1;
}
</style>
