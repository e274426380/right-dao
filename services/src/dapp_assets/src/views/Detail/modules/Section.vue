<template>
  <section>
    <div style="position: relative;">
      <div class="zhezhao"></div>
      <el-carousel height="1080px" v-if="dappDetail.photo">
        <el-carousel-item>
          <img :src="fitlerBlobToBase64(dappDetail.photo)" class="small" />
        </el-carousel-item>
      </el-carousel>
      <el-carousel height="450px" :indicator-position="none" v-else>
        <el-carousel-item>
          <img src="https://files.catbox.moe/pr1rzx.png" />
        </el-carousel-item>
        <!-- <el-carousel-item>
          <img src="https://files.catbox.moe/ha7zlh.jfif" />
        </el-carousel-item>
        <el-carousel-item>
          <img src="https://files.catbox.moe/zvry73.jfif" />
        </el-carousel-item>
        <el-carousel-item>
          <img src="https://files.catbox.moe/feuq4s.jfif" />
        </el-carousel-item>
        <el-carousel-item>
          <img src="https://files.catbox.moe/3msxln.jfif" />
        </el-carousel-item> -->
      </el-carousel>
    </div>
    <section class="bg-half">
      <div class="container">
        <section class="section">
          <div class="row">
            <div class="col-lg-8 col-md-6">
              <h5 @click="$router.back(1)" style="cursor: pointer">
                <i class="el-icon-arrow-left"></i> Back to DappList / Grant
              </h5>
              <div class="card_header">
                <el-avatar :size="120" v-if="dappDetail.logo" :src="fitlerBlobToBase64(dappDetail.logo)" />
                <div class="ms-4">
                  <div class="title-wrapper">
                    <span class="title me-3">{{
                    dappDetail.dappStats.profile.name
                  }}</span>
                    <el-tag type="danger" size="small" effect="dark" class="hot-tag">HOT</el-tag>
                  </div>
                  <div class="card_header_bottom">
                    <span class="text-muted tag mb-0" style="font-size: 14px">
                      {{ dappDetail.dappStats.profile.description }}
                    </span>
                    <div>
                      <el-tag color="#32E0C4" :hit="false" class="me-2 dapp-tag">{{
                        dappDetail.dappStats.profile.category | categoryFilter
                      }}</el-tag>
                    </div>
                  </div>
                </div>
                <div class="ms-3">
                  <!-- <el-button v-if="dappDetail.isLike" :loading="likeLoading" class="btn btn-primary btn-sm me-3 like_btn" @click="likeToggle(dappDetail.dappStats.profile.dappId)">
                    <i class="iconfont icon-dianzanxuanzhongzhuangtai1"></i>
                    {{ dappDetail.dappStats.likeCount }}
                  </el-button>
                  <el-button v-else :loading="likeLoading" class="btn btn-primary btn-sm me-3 like_btn" @click="likeToggle(dappDetail.dappStats.profile.dappId)">
                    <i class="iconfont icon-dianzan"></i>
                    {{ $t('dapp.detail.like') }}
                  </el-button> -->

                  <a v-if="dappDetail.isLike">
                    <i class="iconfont icon-Vector" style="color:#32E0C4" @click="likeToggle(dappDetail.dappStats.profile.dappId)"></i>{{dappDetail.dappStats.likeCount}}
                  </a>
                  <a v-else><i class="iconfont icon-Vector" @click="likeToggle(dappDetail.dappStats.profile.dappId)"></i>{{dappDetail.dappStats.likeCount}}</a>

                  <!-- <button class="btn btn-primary btn-sm me-3">
                  <i class=" icon-zhuanfa"></i>
                </button> -->
                  <!-- <button class="btn btn-primary btn-sm">
                  <i class="iconfont icon-shoucang"></i>
                </button> -->
                </div>
              </div>
              <div class="card_center">
                <div>
                  <!-- <template v-for="(uri, idx) in dappDetail.dappStats.profile.outerUri">
                    <a :key="idx" @click="handleUri(uri)">
                      <i class="iconfont icon-interter" v-if="uri[1] == 'website'"></i>
                      <i v-if="uri[1] == 'facebook'" class="iconfont icon-facebook"></i>
                      <i v-if="uri[1] == 'github'" class="iconfont icon-gethub"></i>
                      <i v-if="uri[1] == 'medium'" class="iconfont icon-medium"></i>
                      <i v-if="uri[1] == 'twitter'" class="iconfont icon-twitter"></i>
                      <i v-if="uri[1] == 'discord'" class="iconfont icon-discord"></i>
                      <i v-if="uri[1] == 'telegram'" class="iconfont icon-telegram"></i>
                    </a>
                  </template> -->
                  <ul v-for="(uri, idx) in dappDetail.dappStats.profile.outerUri" :key="idx">
                    <li :key="idx" @click="handleUri(uri)">
                      <a>{{uri[0]}}</a>
                    </li>
                  </ul>
                </div>
                <!-- <p class="mt-3">钱包地址: xxxxxx</p> -->
              </div>
              <el-tabs class="card_tabs" v-model="tabActiveName" @tab-click="handleClick">
                <el-tab-pane label="详细信息/" name="first">
                  <div class="card_bottom">
                    <div class="card_title">
                      <h4>Lifetime funding received</h4>
                      <p>{{ dappDetail.dappStats.rewardCount | rewardCountFilter }} ICP raised from all contributors & QF matching</p>
                    </div>
                    <div class="card_body">
                      <span>
                        <!-- <h4>About {{ dappDetail.dappStats.profile.name }}</h4> -->
                        {{ dappDetail.dappStats.profile.detail }}
                      </span>
                    </div>
                  </div>
                </el-tab-pane>
                <el-tab-pane label="捐款记录" name="second">
                  <div class="card border-0 sidebar sticky-bar rounded shadow mt-3">
                    <!-- TAG CLOUDS -->
                    <div class="widget">
                      <el-table :data="rewardList" style="width: 100%">
                        <el-table-column prop="username" label="user" min-width="50">
                        </el-table-column>
                        <el-table-column label="amount" min-width="120">
                          <template slot-scope="scope">
                            {{ scope.row.amount | rewardCountFilter}}
                          </template>
                        </el-table-column>
                        <el-table-column prop="createdAt" label="time" min-width="120">
                          <template slot-scope="scope">
                            {{ scope.row.createdAt | timestampToDateFilter}}
                          </template>
                        </el-table-column>
                        <el-table-column label="wallet" min-width="120">
                          <template slot-scope="scope">
                            <span style="cursor: pointer;" v-clipboard="scope.row.from" v-clipboard:success="clipboardSuccessHandler">
                              {{scope.row.from | walletInfoFitler}}
                              <i class="iconfont icon-a-fuzhi112"></i>
                            </span>
                          </template>
                        </el-table-column>
                      </el-table>
                    </div>
                    <!-- TAG CLOUDS -->
                  </div>
                </el-tab-pane>
              </el-tabs>
            </div>
            <div class="col-lg-4 col-md-6 col-12 mt-4 mt-sm-0 pt-2 pt-sm-0">
              <div class="card border-0 sidebar sticky-bar rounded shadow">
                <div class="card-body">
                  <!-- SEARCH -->
                  <div class="widget mb-4 pb-2 border-bottom grant">
                    <h5 class="widget-title text-left">Grant</h5>
                  </div>
                  <!-- SEARCH -->

                  <div class="widget pb-4 border-bottom vote">
                    <h5 class="widget-title">Vote</h5>
                    <el-row :gutter="5">
                      <el-col :span="10">
                        <el-input type="Number" size="small" style="display: inline-block" v-model="voteIcpValue" />
                      </el-col>
                      <el-col :span="5">
                        <span class="widget-text">ICP</span>
                      </el-col>
                      <el-col :span="9">
                        <el-button class="btn btn-primary btn-sm" size="medium" :loading="voteLoading" @click="voteICP">
                          vote
                        </el-button>
                      </el-col>
                    </el-row>
                    <div class="widget-money">{{ dappDetail.dappStats.rewardCount | rewardCountFilter}} ICP</div>
                    <div class="text-muted">raised from {{rewardList.length}} contributors</div>
                    <!-- <div class="widget-money-bottom">+ $ 1,234</div>
                    <div class="text-muted">estimated QF matching</div> -->
                  </div>

                  <!-- <div class="widget join">
                    <h5 class="widget-title">Grants Joined</h5>
                    <div class="tagcloud mt-4">
                      <el-tag color="#32E0C4" :hit="false" class="me-2 dapp-tag">open</el-tag>
                      <el-tag color="#32E0C4" :hit="false" class="me-2 dapp-tag">open</el-tag>
                      <button class="btn btn-primary bg-soft-primary btn-sm">
                        Difinity NFT Ground | OPEN
                      </button>
                      <button class="btn btn-primary bg-soft-primary btn-sm mt-3">
                        Difinity Grant #1 | DONE
                      </button>
                    </div>
                  </div> -->
                </div>
              </div>
              <div class="card border-0 sidebar sticky-bar rounded shadow mt-3" v-if="false">
                <!-- TAG CLOUDS -->
                <div class="widget p-4">
                  <h5 class="widget-title">Team</h5>
                  <div class="tagcloud mt-4">
                    <a href="javascript:void(0)" class="rounded">A</a>
                    <a href="javascript:void(0)" class="rounded">A</a>
                    <a href="javascript:void(0)" class="rounded">A</a>
                    <a href="javascript:void(0)" class="rounded">A</a>
                  </div>
                </div>
                <!-- TAG CLOUDS -->
              </div>
            </div>
          </div>
        </section>
      </div>
      <!-- <div class="infinite-list-wrapper" style="overflow:auto">
      <ul class="list" v-infinite-scroll="load" infinite-scroll-disabled="disabled">
        <li v-for="i in count" class="list-item" :key="i">{{ i }}</li>
      </ul>
      <p v-if="loading">加载中...</p>
      <p v-if="noMore">没有更多了</p>
    </div> -->
    </section>
  </section>
</template>

<script>
import { transformArrayBufferToBase64 } from "@/utils/utils";
import { timestampToDate } from "a@/utils/utils";
import Bus from "@/utils/bus";
export default {
  name: "DetailSection",
  data() {
    return {
      dappDetail: { dappStats: { profile: {} } },
      likeLoading: false,
      voteIcpValue: null,
      count: 100,
      loading: false,
      voteLoading: false,
      tabActiveName: "first",
      rewardList: []
    };
  },
  computed: {
    noMore() {
      return this.count >= 20;
    },
    disabled() {
      return this.loading || this.noMore;
    }
  },
  filters: {
    categoryFilter: item => {
      const allItem = ["Infrastructure", "Dapp", "DeFi", "Community"];
      return allItem[item];
    },
    walletInfoFitler(str) {
      // 中间显示省略号
      return (
        str.substring(0, 6) + "..." + str.substring(str.length - 6, str.length)
      );
    },
    rewardCountFilter(val) {
      val = Number(val);
      return val > 0 ? val * 0.00000001 : val;
    },
    timestampToDateFilter(val) {
      console.log(val, timestampToDate(val), "123123");
      return timestampToDate(val);
    }
  },
  created(){
    //将id转换为IC能够识别的bigint
    this.$route.params.id=BigInt(this.$route.params.id);
  },
  mounted() {
    this.getDappDetail();
    Bus.$on("actorCreated", () => this.getDappDetail());
  },
  methods: {
    getDappDetail() {
      console.log(this.$route);
      if (this.$route.params.id) {
        if (!this.$store.state.dapp) {
          return false;
        }
        this.$store.state.dapp
          .getDappDetails(BigInt(this.$route.params.id))
          .then(res => {
            console.log(res[0]);
            this.dappDetail = res[0];
          });
        this.getDappRewardsList();
      }
    },
    getDappRewardsList() {
      this.$store.state.dapp
        .findDappRewards(BigInt(this.$route.params.id))
        .then(res => {
          console.log(res);
          this.rewardList = res;
        });
    },
    handleUri(uri) {
      window.open(uri[0]);
    },
    likeToggle(dappId) {
      //点赞
      this.likeLoading = true;
      this.dappDetail.isLike = !this.dappDetail.isLike;
      this.dappDetail.isLike
        ? this.dappDetail.dappStats.likeCount++
        : this.dappDetail.dappStats.likeCount--;
      this.$store.state.dapp
        .likeToggle(dappId)
        .then(res => {})
        .catch(() => {
          this.dappDetail.isLike = !this.dappDetail.isLike;
          this.dappDetail.isLike
            ? this.dappDetail.dappStats.likeCount++
            : this.dappDetail.dappStats.likeCount--;
          this.$store.state.dapp;
        });
    },
    fitlerBlobToBase64(file) {
      return transformArrayBufferToBase64(file);
    },
    async voteICP() {
      if (!this.$store.state.user || !this.$store.state.user.principal) {
        this.$message.error("请先登录II");
        setTimeout(() => {
          Bus.$emit("IILogin");
        }, 1500);
        // return;
      } else if (!window.ic || !window.ic.plug) {
        this.$message.error("请安装Plug钱包");
        return;
      } else if (
        !sessionStorage.getItem("plug") ||
        !JSON.parse(sessionStorage.getItem("plug")).principalId
      ) {
        this.$message.error("请解锁Plug钱包");
        Bus.$emit("walletLogin");
        // return;
      } else if (this.voteIcpValue < 0 || !this.voteIcpValue) {
        this.$message.error("请输入要Vote的ICP数量");
        return false;
      } else if (!this.dappDetail.dappStats.profile.walletAddr) {
        this.$message.error("Dapp 未设置Vote钱包，暂时无法Vote");
        return false;
      } else {
        const params = {
          to: this.dappDetail.dappStats.profile.walletAddr,
          amount: this.voteIcpValue * 100000000,
          opts: {
            fee: "",
            // memo: 0
            memo: Number(Date.parse(new Date()))
          }
        };
        console.log(params);
        console.log(window.ic.plug);
        const result = await window.ic.plug.requestTransfer(params);
        if (result.height) {
          this.voteLoading = true;
          const { principal, username } = this.$store.state.user;
          // const data = this.validDappTran(result.height);
          console.log(
            this.dappDetail.dappStats.profile.dappId,
            principal,
            username,
            this.$store.state.wallet.plug.principalId,
            "plug",
            this.$store.state.wallet.plug.principalId,
            this.dappDetail.dappStats.profile.walletAddr,
            result.height,
            params.amount,
            params.opts.memo
          );
          const data = await this.$store.state.dapp.rewardDapp(
            this.dappDetail.dappStats.profile.dappId,
            principal,
            username,
            this.$store.state.wallet.plug.principalId,
            "plug",
            this.$store.state.wallet.plug.principalId,
            this.dappDetail.dappStats.profile.walletAddr,
            result.height,
            params.amount,
            params.opts.memo
          );
          if (data) {
            this.validDappReward(data.ok);
          }
          console.log("rewardDapp", data);
        }
        console.log(result);
      }
    },
    load() {
      this.loading = true;
      setTimeout(() => {
        this.count += 2;
        this.loading = false;
      }, 2000);
    },
    validDappReward(id) {
      this.$store.state.dapp
        .validDappReward(id)
        .then(res => {
          console.log("validDappReward", res, new Date().toLocaleTimeString());
          if (res == false) {
            setTimeout(() => {
              this.validDappReward(id);
            }, 10000);
          } else {
            this.$message.success(`Vote成功${res}`);
            this.voteLoading = false;
          }
        })
        .catch(err => {
          console.log("validDappReward err", err);
        });
    },
    validDappTran(height) {
      this.$store.state.dapp
        .validTransaction(height)
        .then(result => {
          console.log(
            "validTransaction",
            result,
            new Date().toLocaleTimeString()
          );
          if (result == false) {
            setTimeout(() => {
              this.validDappTran(height);
            }, 10000);
          } else {
            this.$message.success("投票成功");
            this.voteLoading = false;
          }
        })
        .catch(err => {
          console.log("validTransaction err", err);
        });
    },
    clipboardSuccessHandler() {
      this.$message.success("复制成功");
    }
  }
};
</script>

<style lang="scss" scoped>
.bg-half {
  padding: 140px 100px;
  // background: url("~@/assets/images/dapp_bg.png") top;
  background: #000000;
  width: 100% !important;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  font-family: Roboto !important;
  color: #fff;
}

.section {
  padding: 0;
}

.card_header {
  display: flex;
  align-items: flex-start;
  padding: 30px 0 20px;
  border-bottom: 1px solid #2b2b2b;
  .ms-4 {
    flex: 1;
    .title-wrapper {
      display: flex;
      .title {
        color: #fff;
        font-size: 24px;
        line-height: 28px;
        margin-right: 10px;
      }
    }
  }
  .hot-tag,
  .dapp-tag {
    font-size: 12px;
    color: #000;
  }
  .card_header_bottom {
    .dapp-tag {
      border-color: rgb(50, 224, 196);
      margin-top: 26px;
      height: 20px;
      line-height: 19px;
    }
    .mb-0 {
      flex: 1;
      color: #fff;
      opacity: 0.6;
    }
  }
  .like_btn {
    font-size: 16px !important;
    i {
      margin-right: 10px;
    }
  }
  .ms-3 {
    a {
      display: flex;
      align-items: center;
      font-size: 19px;
    }
    i {
      font-size: 24px !important;
      margin-right: 10px;
      cursor: pointer;
    }
    .iconfont:hover {
      color: #32e0c4;
    }
  }
}

.card_center {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  background-color: transparent;
  padding: 30px 0;
  border-bottom: 1px solid #2b2b2b;
  li {
    color: #b6fd21;
    opacity: 0.8;
    a {
      text-decoration-line: underline;
      font-size: 14px;
      cursor: pointer;
    }
  }
  .iconfont {
    font-size: 50px;
    color: #9c9ead;
    margin-left: 10px;
    cursor: pointer;
  }
  .iconfont:hover {
    color: #32e0c4;
  }
}

.card_title {
  padding: 24px 0 8px;
  border-bottom: 1px solid #2b2b2b;
  font-family: Roboto;
  font-weight: 400;
  h4 {
    font-size: 18px !important;
    color: #ffffff;
    line-height: 30px;
  }
  p {
    font-size: 14px;
    color: #ffffff;
    margin-top: 10px;
    opacity: 0.6;
    line-height: 30px;
  }
}

.card_bottom {
  background-color: transparent;
  padding: 0 0 36px;
  // min-height: 550px;
  font-size: 14px;
  line-height: 16px;
  color: #ffffff;
  font-family: Roboto;
  font-weight: normal;
  word-wrap: break-word;
}

/deep/ .card_tabs {
  margin-top: 40px;
  .el-tabs__nav-wrap::after {
    display: none;
  }
  .el-tabs__item.is-active {
    font-size: 24px;
    opacity: 1;
  }
  .el-tabs__active-bar {
    display: none;
  }
  .el-tabs__item {
    color: #fff;
    opacity: 0.6;
    padding: 0;
    font-weight: 700;
  }
  .el-table,
  .el-table__expanded-cell {
    background: transparent;
  }
  .el-table th,
  .el-table tr {
    background: transparent;
  }
  .el-table td,
  .el-table th.is-leaf {
    border-bottom: 1px solid #2b2b2b;
  }
  .card_body {
    margin-top: 24px;
    opacity: 0.6;
    text-indent: 30px;
  }
  .el-table__header-wrapper .cell {
    font-size: 12px;
    line-height: 14px;
    color: #ffffff;
    opacity: 0.6;
    font-weight: 300;
  }
  .el-table__body-wrapper .cell {
    color: #ffffff;
  }
  .el-table--enable-row-hover .el-table__body tr:hover > td {
    background: transparent;
  }
  .el-table__header-wrapper .cell {
    font-size: 16px;
  }
}
.card {
  background-color: transparent;
}
.card-body {
  .grant {
    font-size: 24px;
    line-height: 28px;
    color: #ffffff;
  }
  .vote,
  .join {
    margin-top: 20px;
    .widget-title {
      font-weight: 500;
      font-size: 16px;
      line-height: 19px;
      color: #ffffff;
    }
    .el-row {
      display: flex;
      align-items: center;
    }
    /deep/ .el-input__inner {
      border: 1px solid #ffffff;
      background-color: transparent !important;
      color: #fff;
    }
    .btn-sm {
      font-size: 12px;
    }
    .text-muted {
      font-size: 14px;
      line-height: 16px;
      color: #ffffff;
      opacity: 0.6;
    }
    .dapp-tag {
      border-color: #32e0c4;
      color: #fff;
      height: 20px;
      line-height: 19px;
    }
  }
}

.border-bottom {
  border-bottom: 1px solid #2b2b2b !important;
}

.widget-text {
  font-size: 16px;
  line-height: 19px;
  color: #ffffff;
  color: #fff;
}

.widget-money {
  font-family: Roboto;
  line-height: 30px;
  margin: 20px 0 12px;
  margin-top: 60px;
  font-size: 24px;
  line-height: 28px;
  color: #ffffff;
  opacity: 0.9;
}

.widget-money-bottom {
  font-size: 24px;
  font-family: Roboto;
  font-weight: 400;
  color: #fff;
  line-height: 30px;
  margin: 35px 0 12px;
}

.el-carousel__item img {
  width: 100%;
  height: 100%;
}

.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n + 1) {
  background-color: #d3dce6;
}

.zhezhao {
  width: 100%;
  height: 100%;
  background-color: #000;
  filter: alpha(opacity=30);
  -moz-opacity: 0.3;
  opacity: 0.3;
  position: absolute;
  left: 0px;
  top: 0px;
  // display: none;
  z-index: 1000;
}
</style>
<style>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
input[type="number"] {
  -moz-appearance: textfield;
}
</style>
>>>>>>> 31d03d55aa2a0c6cb0a595b3ecada68ffabe6317
