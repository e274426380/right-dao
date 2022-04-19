<template>
  <section class="section">
    <div class="container">
      <div class="dapp-application">{{$t('home.Dapp.title')}}</div>
      <el-row>
        <el-col :span="24">
          <!--<el-button type="text" class="text-muted readmore" style="float: right">-->
          <!--查看更多<i class="el-icon-arrow-right el-icon&#45;&#45;right"></i>-->
          <!--</el-button>-->
        </el-col>
        <el-col :span="24">
          <el-row :gutter="24">
            <el-col :lg="8" :sm="8" :xs="24" v-for="(item, index) of dappData" :key="index">
              <div class="card dapp" @click="handleClickDetail(item.dappStats.profile.dappId)">
                <div class="card-body p-0 content">
                  <el-row :gutter="10">
                    <el-col style="width: 80px; height: 80px;">
                      <el-image style="width: 80px; height: 80px;border-radius: 10px" :src="fitlerBlobToBase64(item.logo)" />
                    </el-col>
                    <el-col class="dapp-name">
                      <div class="dapp-title">{{ item.dappStats.profile.name }}</div>
                      <p class="mb-0 dapp-type">{{ item.dappStats.profile.category | categoryFilter }}</p>
                    </el-col>
                  </el-row>
                  <div class="img-desc">
                    <img width="100%" height="100%" :src="fitlerBlobToBase64(item.photo)">
                  </div>
                  <div class="para mb-3 mt-3">
                    <p class="text-muted">{{ item.dappStats.profile.description }}</p>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="24" class="text-center" v-if="fasle">
          <el-tooltip class="item" effect="dark" :content="$t('button.notwork')" placement="bottom">
            <a href="javascript:void(0);" class="btn btn-primary" @click="$router.push('submitDapp')">{{ this.$t('button.submit.dapp') }}</a>
            <!-- <a href="javascript:void(0);" class="btn btn-disable">{{
              this.$t('button.submit.dapp')
            }}</a> -->
          </el-tooltip>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
import Bus from "@/utils/bus";
import { transformArrayBufferToBase64 } from "@/utils/utils";
export default {
  name: "HomeDApp",
  computed: {
    // features() {
    //   return [
    //     {
    //       title: "Plug",
    //       subtext: this.$t("dapp.plug.subtext"),
    //       url: "https://plugwallet.ooo/",
    //       tags: "Wallets",
    //       logoSrc: require("@/assets/images/dapps/plug-logo.jpg")
    //     },
    //     {
    //       title: "DSCVR",
    //       subtext: this.$t("dapp.dscvr.subtext"),
    //       url: "https://dscvr.one/",
    //       tags: "Social Networks",
    //       logoSrc: require("@/assets/images/dapps/dscvr.jpg")
    //     },
    //     {
    //       title: "Canistore",
    //       subtext: this.$t("dapp.canistore.subtext"),
    //       url: "https://canistore.io/",
    //       tags: "NFT",
    //       logoSrc: require("@/assets/images/dapps/canistore-logo.jpg")
    //     },
    //     {
    //       title: "OpenChat",
    //       subtext: this.$t("dapp.openchat.subtext"),
    //       url: "https://oc.app/",
    //       tags: "Social Networks",
    //       logoSrc: require("@/assets/images/dapps/openchat.jpg")
    //     },
    //     {
    //       title: "ICPSwap",
    //       subtext: this.$t("dapp.icpswap.subtext"),
    //       url: "https://3pbcj-viaaa-aaaah-qaajq-cai.raw.ic0.app/",
    //       tags: "DeFi",
    //       logoSrc: require("@/assets/images/dapps/icpswap-logo.jpg")
    //     },
    //     {
    //       title: "Axon",
    //       subtext: this.$t("dapp.axon.subtext"),
    //       url: "https://axon.ooo/",
    //       tags: "DAOs",
    //       logoSrc: require("@/assets/images/dapps/axon-logo.jpg")
    //     },
    //     {
    //       title: "Entrepot",
    //       subtext: this.$t("dapp.entrepot.subtext"),
    //       url: "https://entrepot.app/",
    //       tags: "NFT",
    //       logoSrc: require("@/assets/images/dapps/Untitled.png")
    //     },
    //     {
    //       title: "DFinance",
    //       subtext: this.$t("dapp.dfinance.subtext"),
    //       url: "https://dfinance.ai/",
    //       tags: "DeFi",
    //       logoSrc: require("@/assets/images/dapps/dfinance-logo.jpg")
    //     }
    //   ];
    // }
  },
  filters: {
    categoryFilter: item => {
      const allItem = ["Infrastructure", "Dapp", "DeFi", "Community"];
      return allItem[item];
    }
  },
  data() {
    return {
      dialogVisible: false,
      dappData: []
    };
  },
  mounted() {
    this.getPageDapp();
    Bus.$on("actorCreated", () => this.getPageDapp());
  },
  methods: {
    handleClose(done) {
      this.$confirm("确认关闭？")
        .then(_ => {
          done();
        })
        .catch(_ => {});
    },
    getPageDapp() {
      const actor = this.$store.state;
      if (!actor.dapp) {
        return false;
      }
      // .pageDappIgnoreStatus(this.query.pageSize, this.query.pageNum)
      actor.dapp.pageDapp(8, 0).then(res => {
        this.dappData = res.data;

        console.log(this.dappData);
      });
    },
    fitlerBlobToBase64(file) {
      return transformArrayBufferToBase64(file);
    },
    handleClickDetail(id) {
      this.$router.push({
        name: "Detail",
        params: { id }
      });
    }
  }
};
</script>

<style lang="scss" scoped>
  .container::after {
  width: 473px;
  height: 473px;
  content: "";
  position: absolute;
  left: 2%;
  top: 18%;
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
.section {
  padding: 36px 0 0;
  color: #ffffff;
  .dapp-application {
    font-size: 48px;
    line-height: 66px;
    margin-bottom: 120px;
    position: relative;
    z-index: 2;

  }
}
.card:hover {
  /*box-shadow: 8px -5px 8px 0 #838383, 0 2px 4px 0 #838383;*/
  box-shadow: 8px -5px 20px 0 #4c4c4c, 0 2px 20px 0 #4c4c4c;
  transform: translate(0px, -10px);
}
.card {
  position: relative !important;
  border: 0;
  border-radius: 6px;
  padding: 1.5rem 0 0;
  margin-bottom: 40px;
  background-color: #f8f9fc !important;
  min-height: 210px;
  overflow: hidden !important;
  cursor: pointer;
  z-index: 3;
  .card-body {
    display: flex;
    flex-direction: column;
    .el-row {
      padding: 0 1.5rem 1.2rem;
      display: flex;
      align-items: center;
      .dapp-name {
        display: flex;
        flex-direction: column;
        justify-items: center;
        text-align: left;
        margin-left: 10px;
        .dapp-title {
          font-weight: bold;
          font-size: 24px;
          line-height: 28px;
          text-align: left;
          color: #17161d;
        }
        .dapp-type {
          font-size: 14px;
          text-align: left;
          line-height: 16px;
          color: #17161d;
          opacity: 0.6;
        }
      }
    }
    .img-desc {
      background: #c4c4c4;
      height: 200px;
    }
    .para {
      padding: 10px 30px 0 30px;
      .text-muted {
        font-weight: 300;
        font-size: 16px;
        line-height: 19px;
        color: #000000 !important;
        opacity: 0.6;
        height: 58px;
        text-overflow: ellipsis;
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
      }
    }
  }
}
.dapp {
  -webkit-transition: all 0.5s ease;
  transition: all 0.5s ease;
}
// .dapp:hover {
//   -webkit-box-shadow: 0 10px 25px rgba(60, 72, 88, 0.15);
//   box-shadow: 0 10px 25px rgba(60, 72, 88, 0.15);
//   background-color: #c8d9fa !important;
// }
</style>
