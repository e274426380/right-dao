<template>
  <section class="bg-half">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-12 text-center">
          <div class="section-title mb-4 pb-2">
            <h4 class="title mt-3">{{ $t('home.partners.title') }}</h4>
            <!-- <span class="title-badge"></span> -->
            <p class="text-muted para-desc mb-0 mx-auto">{{ $t('home.partners.title.desc') }}</p>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->

      <div class="row dev-wapper">
        <div class="col-lg-6 col-md-6 col-12 mt-4 pt-2 pe-5">
          <div class="text-start features feature-clean rounded">
            <h4 class="text-dark">{{ $t('home.partners.developers') }}</h4>
            <p class="text-muted mt-3 mb-4">{{ $t('home.partners.developers.desc') }}</p>
            <el-tooltip class="item" effect="dark" :content="$t('button.notwork')" placement="bottom">
              <a href="javascript:void(0)" class="btn btn-disable">{{ $t('home.partners.developers.button') }}</a>
            </el-tooltip>
          </div>
        </div>
        <!--end col-->

        <div class="col-lg-6 col-md-6 col-12 mt-4 pt-2">
          <div class="text-start features feature-clean rounded">
            <h4 class="text-dark">{{ $t('home.partners.team') }}</h4>
            <p class="text-muted mt-3 mb-4">{{ $t('home.partners.team.desc') }}</p>
            <el-tooltip class="item" effect="dark" :content="$t('button.notwork')" placement="bottom">
              <!--<a href="javascript:void(0)" class="btn btn-primary">{{ $t('home.partners.team.button') }}</a>-->
              <a href="javascript:void(0)" class="btn btn-disable">{{ $t('home.partners.team.button') }}</a>
            </el-tooltip>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->

      <div class="row justify-content-center" style="margin-top: 80px">
        <div class="col-12">

        </div>
        <div class="row email-wrapper">
          <div class="col-12 col-md-4">
            <h4>{{ $t('home.partners.input.title') }}</h4>
          </div>
          <div class="col-12 col-md-8">
            <div class="form-group">
              <div class="input-group">
                <input name="email" id="email" type="email" v-model="email" class="form-control rounded input-email" :placeholder="$t('home.partners.input.placeholder')" required aria-describedby="newssubscribebtn" />
                <div class="ms-4">
                  <el-button class="btn btn-primary" type="submit" id="newssubscribebtn" :loading="loading" @click="sendEmail()">
                    {{ $t('home.partners.input.button') }}
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!--end col-->
      </div>

      <!-- Partners start 合作伙伴 -->
      <!--<section class="py-4">-->
      <!--<div class="container">-->
      <!--<div class="row justify-content-center">-->
      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/odaily.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/tangent.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/panews.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/ipfsnews.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/chainnews.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/boliancaijing.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/tuoniaox.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/coinvoice.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-4 col-md-4 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/Dfinityclub.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-2 col-md-2 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/2link.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/toudengcang.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->

      <!--<div class="col-lg-3 col-md-3 col-6 text-center py-4">-->
      <!--<img src="~@/assets/images/logo/Blocklike.png" class="avatar avatar-ex-sm" alt="" />-->
      <!--</div>-->
      <!--&lt;!&ndash;end col&ndash;&gt;-->
      <!--</div>-->
      <!--&lt;!&ndash;end row&ndash;&gt;-->
      <!--</div>-->
      <!--&lt;!&ndash;end container&ndash;&gt;-->
      <!--</section>-->
      <!--end section-->
      <!-- Partners End -->
    </div>
  </section>
</template>

<script>
export default {
  name: "HomePartners",
  data() {
    return {
      actor: "",
      email: "",
      loading: false
    };
  },
  mounted() {},
  methods: {
    async submitEmail() {
      this.loading = true;
      const actor = this.$store.state.dapp;
      this.actor = actor;
      const res = await actor.subscribe(this.email);
      if (Object.keys(res)[0] === "ok") {
        this.$message.success(this.$t("message.email.success"));
      } else if (Object.keys(res.err)[0] == "emailAddressAlreadyExists") {
        this.$message.error(this.$t("message.email.exist"));
      } else if (Object.keys(res.err)[0] == "emailAddressNotValid") {
        this.$message.error(this.$t("message.notValid"));
      } else {
        this.$message.error(this.$t("message.unknown"));
      }
      this.loading = false;
      // this.$message.success(this.$t('message.email.success'));
    },
    //校验邮箱格式
    sendEmail() {
      let regEmail = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
      if (regEmail.test(this.email)) {
        this.submitEmail();
      } else if (this.email === "" || this.email == null) {
        this.$message.error(this.$t("message.email.error"));
      } else {
        this.$message.error(this.$t("message.email.error"));
      }
    }
  }
};
</script>

<style lang="scss" scoped>
$input-placeholder: #a1a1a1;
$input-color: #333333;
.bg-half {
  background-color: #000000 !important;
  width: 100% !important;
  background-repeat: no-repeat;
  padding: 150px 0 90px;
  .row {
    padding-left: unset;
  }

  .section-title {
    color: #ffffff;
    .title {
      font-weight: bold;
      font-size: 48px !important;
      line-height: 66px;
      /* identical to box height */
      text-align: center;
    }
  }
  .text-muted {
    font-size: 18px;
    line-height: 21px;
    text-align: center;
    color: #ffffff !important;
    opacity: 0.8;
    font-weight: 300;
  }
  .dev-wapper {
    display: flex;
    flex-direction: column;
    .col-lg-6 {
      font-family: Roboto;
      font-style: normal;
      // font-weight: bold;
      margin-bottom: 40px;
      margin-top: 60px !important;
      .text-dark {
        line-height: 28px;
        color: #ffffff !important;
        font-size: 24px;
      }
      .text-muted {
        text-align: left;
      }
      .btn {
        border: 1px solid #b6fd21 !important;
        padding: 15px 60px;
        font-family: Roboto;
        font-style: normal;
        font-weight: 500;
        font-size: 14px;
        line-height: 16px;
        text-align: center;
        color: #b6fd21;
        background: #000 !important;
      }
    }
  }
  .email-wrapper {
    display: flex;
    flex-direction: column;
    color: #ffffff;
    h4 {
      font-family: Roboto;
      font-style: normal;
      font-weight: bold;
      font-size: 32px;
      line-height: 37px;
    }
    input {
      border: 1px solid #b6fd21;
      box-sizing: border-box;
      border-radius: 4px;
      background: #000;
      color: #fff;
      font-size: 14px;
    }
    .col-12 {
      margin-top: 10px;
    }
  }
}

.title-badge {
  display: inline-block;
  width: 67px;
  height: 6px;
  background-color: #425ce1;
  border-radius: 3px;
  margin: 28px 0;
}
.input-email {
  color: $input-color;
}
.input-email::-webkit-input-placeholder {
  /* WebKit browsers 适配谷歌 */
  color: $input-placeholder;
}
.input-email:-moz-placeholder {
  /* Mozilla Firefox 4 to 18 适配火狐 */
  color: $input-placeholder;
}
.input-email::-moz-placeholder {
  /* Mozilla Firefox 19+ 适配火狐 */
  color: $input-placeholder;
}
.input-email:-ms-input-placeholder {
  /* Internet Explorer 10+  适配ie*/
  color: $input-placeholder;
}
</style>
