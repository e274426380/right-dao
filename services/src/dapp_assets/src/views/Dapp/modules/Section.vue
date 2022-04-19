<template>
  <section class="bg-half-170">
    <el-scrollbar>
        <template v-for="(item,index) in banners">
          <el-image v-if="item.imgSrc" :src=item.imgSrc :key="index"></el-image>
          <a v-else :href=item.outerUri target="_blank">
            <el-image :src=fitlerBlobToBase64(item.pic) :key="index"></el-image>
          </a>
        </template>
    </el-scrollbar>
    <div class="container">
      <!--<el-carousel height="400px" v-if="carouselList.length > 3">-->
      <!--<el-carousel-item v-for="(item, index) in carouselList" :key="index">-->
      <!--<img-->
      <!--:src="fitlerBlobToBase64(item.img)"-->
      <!--alt=""-->
      <!--@click="handleClickDetail(item.dappId)"-->
      <!--/>-->
      <!--</el-carousel-item>-->
      <!--</el-carousel>-->
      <!--<el-carousel height="450px" v-else>-->
      <!--<el-carousel-item>-->
      <!--<img src="https://files.catbox.moe/cl85q5.jfif" />-->
      <!--</el-carousel-item>-->
      <!--<el-carousel-item>-->
      <!--<img src="https://files.catbox.moe/33y1wi.jfif" />-->
      <!--</el-carousel-item>-->
      <!--<el-carousel-item>-->
      <!--<img src="https://files.catbox.moe/3msxln.jfif" />-->
      <!--</el-carousel-item>-->
      <!--<el-carousel-item>-->
      <!--<img src="https://files.catbox.moe/pr1rzx.png" />-->
      <!--</el-carousel-item>-->
      <!--</el-carousel>-->

      <!-- Start -->
      <div id="Explore" style="margin-top: 120px">
        <div class="row">
          <ul class="col container-filter list-unstyled categories-filter mb-0" id="filter">
            <li class="list-inline-item">
              <a class="categories border d-block text-white rounded" @click="updateFilter('all')" :class="{ active: filterCategory == 'all' }">
                <span>ALL</span>
              </a>
            </li>
            <li class="list-inline-item">
              <a class="categories border d-block text-white rounded" @click="updateFilter('0')" :class="{ active: filterCategory == '0' }">
                <span>infrastructure</span>
              </a>
            </li>
            <li class="list-inline-item">
              <a class="categories border d-block text-white rounded" @click="updateFilter('1')" :class="{ active: filterCategory == '1' }">
                <span>Dapp</span>
              </a>
            </li>
            <li class="list-inline-item">
              <a class="categories border d-block text-white rounded" @click="updateFilter('2')" :class="{ active: filterCategory == '2' }">
                <span>DeFi</span>
              </a>
            </li>
            <li class="list-inline-item">
              <a class="categories border d-block text-white rounded" @click="updateFilter('3')" :class="{ active: filterCategory == '3' }">
                <span>Community</span>
              </a>
            </li>
          </ul>
          <!--<el-input-->
          <!--v-model="query.searchKey"-->
          <!--class="el-query"-->
          <!--clearable-->
          <!--prefix-icon="el-icon-search"-->
          <!--@input="searchInput"-->
          <!--:placeholder="$t('dapp.search.input.placeholder')"></el-input>-->
        </div>
        <!--end row-->
        <!--end row-->
      </div>
      <!--end container-->
      <!-- End -->
    </div>
    <div class="page">
      <!-- <i v-if="workData.length>0" class="iconfont icon-a-left-arrow arrow" @click="prePage()"></i> -->
      <div class="container">
        <div class="row projects-wrapper">
          <div class="col-lg-4 col-md-6 col-12 mt-4 pt-2 branding" v-for="(item, index) in filteredData" :key="index">
            <el-card shadow="hover">
              <div slot="header" class="card_header">
                <el-avatar :size="80" :src="fitlerBlobToBase64(item.logo)" shape="square" />
                <div class="ms-4">
                  <div>
                    <span class="h5 title me-3">{{
                      item.dappStats.profile.name
                    }}</span>
                  </div>
                  <!-- <div>
                    <el-tag type="danger" effect="dark">HOT</el-tag>
                  </div> -->
                  <div class="card_header_bottom">
                    <!--<span-->
                    <!--class="card_header_circle me-2"-->
                    <!--v-for="item in 3"-->
                    <!--:key="item"-->
                    <!--&gt;</span>-->
                    <span class="grant">DAPP owner</span>
                  </div>
                  <!--<div>-->
                  <!--<i class="iconfont icon-zhuanfa card-head-button"></i>-->
                  <!--</div>-->
                </div>
              </div>
              <div class="img-desc">
                <img width="100%" height="100%" :src="fitlerBlobToBase64(item.photo)">
              </div>
              <!-- <hr class="line" /> -->
              <div class="card_body">
                <h6 class="text tag mb-0">
                  {{ item.dappStats.profile.description }}
                </h6>
                <div class="mt-3">
                  <el-tag :hit="false" class="me-2 dapp-tag">{{
                    item.dappStats.profile.category | categoryFilter
                    }}
                  </el-tag>
                </div>
                <hr style="color: rgba(0, 0, 0, 0.1);" />
                <div class="mt-3 icon-list">
                  <template v-for="(uri, idx) in item.dappStats.profile.outerUri">
                    <span :key="idx" @click="handleUri(uri)">
                      <i class="iconfont icon-interter" v-if="uri[1] == 'website'"></i>
                      <i v-if="uri[1] == 'facebook'" class="iconfont icon-facebook"></i>
                      <i v-if="uri[1] == 'github'" class="iconfont icon-gethub"></i>
                      <i v-if="uri[1] == 'medium'" class="iconfont icon-medium"></i>
                      <i v-if="uri[1] == 'twitter'" class="iconfont icon-twitter"></i>
                      <i v-if="uri[1] == 'discord'" class="iconfont icon-discord"></i>
                      <i v-if="uri[1] == 'telegram'" class="iconfont icon-telegram1"></i>
                    </span>
                  </template>
                </div>
                <div class="card_body_button mt-3">
                  <div>
                    <i v-if="item.isLike" class="bottom-icon iconfont icon-Vector" :loading="item.likeLoading" style="color: #32E0C4;" @click="likeToggle(item.dappStats.profile.dappId, index)">
                      <span class="like-count">{{ item.dappStats.likeCount }}</span>
                    </i>
                    <i v-else class="bottom-icon iconfont icon-Vector-1" :loading="item.likeLoading" @click="likeToggle(item.dappStats.profile.dappId, index)">
                      <span class="like-count">{{ item.dappStats.likeCount }}</span>
                    </i>
                    <i style="margin-left: 25px" class="bottom-icon iconfont icon-zhuanfa card-head-button" @click="share(item.dappStats.profile.dappId)"></i>
                  </div>
                  <span class="card-view" @click="handleClickDetail(item.dappStats.profile.dappId)">View>></span>
                </div>
              </div>
            </el-card>
          </div>
          <!--<div class="pagination">-->
          <!--<el-pagination-->
          <!--background-->
          <!--@current-change="handleCurrentChange"-->
          <!--:current-page.sync="query.pageNum"-->
          <!--page-size="9"-->
          <!--layout="total, prev, pager, next"-->
          <!--:total="total"-->
          <!--&gt;-->
          <!--</el-pagination>-->
          <!--</div>-->
        </div>
      </div>
      <!-- <i v-if="workData.length>0" class="iconfont icon-a-right-arrow arrow" @click="nextPage()"></i> -->
    </div>
  </section>
</template>

<script>
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
import Bus from "@/utils/bus";
import { transformArrayBufferToBase64 } from "@/utils/utils";
export default {
  name: "DappSection",
  data() {
    return {
      workData: [],
      filterCategory: "all",
      query: {
        searchKey: "",
        pageSize: 9,
        pageNum: 1
      },
      total: 0,
      carouselList: [],
      banners:[]
    };
  },
  filters: {
    categoryFilter: item => {
      const allItem = ["Infrastructure", "Dapp", "DeFi", "Community"];
      return allItem[item];
    }
  },
  computed: {
    filteredData: function() {
      if (this.filterCategory === "all" || this.filterCategory === "search") {
        return this.workData;
      } else {
        return this.workData.filter(
          x => x.dappStats.profile.category === this.filterCategory
        );
      }
    }
  },
  mounted() {
    Bus.$on("uploadDappSuccess", () => this.getPageDapp());
    Bus.$on("actorCreated", () => {
      this.getPageDapp();
      this.getBanner();
    });
    if(this.$store.state.dapp){
      this.getBanner()
    }
    this.getPageDapp();
    let dbody = document.getElementsByClassName("el-scrollbar__wrap")[0];
    objAddEvent(dbody, "mousewheel", function(e) {
      return mouse_scroll(e, dbody);
    });
  },
  methods: {
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
          }else if(banner.bannerCategory==='dapp'){
            //dapp库
            tableData.push(banner);
          }
        }
        this.banners=tableData;
      }else {
        // this.$message.error("获取轮播图失败");
        console.log("not get banner");
        console.log(res);
        this.banners = [
          {imgSrc: "https://files.catbox.moe/cl85q5.jfif"},
          {imgSrc: "https://files.catbox.moe/33y1wi.jfif"},
          {imgSrc: "https://files.catbox.moe/3msxln.jfif"},
          {imgSrc: "https://files.catbox.moe/pr1rzx.png"}
          ];
      }
    },
    updateFilter(filterName) {
      this.filterCategory = filterName;
    },
    async getPageDapp() {
      const actor = this.$store.state;
      if (!actor.dapp) {
        return false;
      }
      // .pageDappIgnoreStatus(this.query.pageSize, this.query.pageNum)
      actor.dapp
        .pageDapp(this.query.pageSize, this.query.pageNum - 1)
        .then(async res => {
          this.workData = res.data.map(v => {
            v.likeLoading = false;
            if (v.photo && this.carouselList.length < 4) {
              this.carouselList.push({
                img: v.photo,
                dappId: v.dappStats.profile.dappId
              });
            }
            return v;
          });
          this.total = Number(res.totalCount);
          this.pageMax(this.total);
        });
    },
    handleCurrentChange(val) {
      this.query.pageNum = val;
      this.getPageDapp();
    },
    //计算最大页码
    pageMax(total) {
      this.pageMaxNum = Math.ceil(total / this.query.pageSize) || 1;
      // if(this.pageMaxNum===1) {}
      return this.pageMaxNum;
    },
    nextPage() {
      if (this.query.pageNum >= this.pageMaxNum) {
        // 不循环，下面注解的地方是循环，要循环注解掉return，再恢复注解
        return 0;
        // this.currentPage= 0;
      } else {
        this.query.pageNum++;
        this.getPageDapp();
      }
    },
    prePage() {
      if (this.query.pageNum <= 1) {
        // 不循环，下面注解的地方是循环，要循环注解掉return，再恢复注解
        return 0;
        // this.currentPage=this.pageMaxNum-1;
      } else {
        this.query.pageNum--;
        this.getPageDapp();
      }
    },
    handleClickDetail(id) {
      this.$router.push({
        name: "Detail",
        params: { id }
      });
    },
    share(id) {
      var detail = window.location.host + "/#/detail";
      this.copyToClipboard(detail + "/" + id);
    },
    // 点击复制到剪贴板函数
    copyToClipboard(content) {
      if (window.clipboardData) {
        window.clipboardData.setData("text", content);
        this.$message.success(this.$t("success"));
      } else {
        (function(content) {
          document.oncopy = function(e) {
            e.clipboardData.setData("text", content);
            e.preventDefault();
            document.oncopy = null;
          };
        })(content);
        document.execCommand("Copy");
        this.$message.success(this.$t("success"));
      }
    },
    handleUri(uri) {
      window.open(uri[0]);
    },
    searchInput({ data }) {
      let searchKey = this.query.searchKey;
      this.query.pageSize = 9;
      this.query.pageNum = 1;
      if (searchKey) {
        this.$store.state.dapp
          .pageDappByName(
            searchKey,
            this.query.pageSize,
            this.query.pageNum - 1
          )
          .then(res => {
            this.workData = res.data.map(item => {
              item.likeLoading = false;
              return item;
            });
            this.filterCategory = "all";
            this.total = Number(res.totalCount);
          })
          .catch(err => {});
      } else {
        console.log("else getDapp");
        this.getPageDapp();
      }
      console.log("search end");
    },
    likeToggle(dappId, index) {
      //点赞，优化用户体验，先将页面调整到对应的效果
      //防止点击频率过快
      if (this.allowClick === false) {
        return;
      }
      this.allowClick = false;
      setTimeout(() => {
        this.allowClick = true;
      }, 500);
      this.workData[index].likeLoading = true;
      this.workData[index].isLike = !this.workData[index].isLike;
      this.workData[index].isLike
        ? this.workData[index].dappStats.likeCount++
        : this.workData[index].dappStats.likeCount--;
      this.$store.state.dapp
        .likeToggle(dappId)
        .then(res => {
          this.workData[index].likeLoading = false;
        })
        .catch(() => {
          this.workData[index].likeLoading = false;
        });
    },
    fitlerBlobToBase64(file) {
      return transformArrayBufferToBase64(file);
    }
  }
};
</script>
<style lang="scss" scoped>
.bg-half-170 ::v-deep {
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
.bg-half-170 {
  /*background: url("~@/assets/images/dapp_bg.png");*/
  width: 100% !important;
  background-repeat: no-repeat;
  padding: 60px 0 100px;
  background-size: 100% 100%;
  font-family: Roboto;
}

.bg-half-170 ::v-deep .el-card {
  border: 0;
  background: #fff;
  border-radius: 6px;
  .el-card__header {
    padding: 30px 30px 20px 30px;
    border-bottom: 0;
  }
}
.el-card.is-always-shadow,
.el-card.is-hover-shadow:focus,
.el-card.is-hover-shadow:hover {
  box-shadow: 8px -5px 20px 0 #4c4c4c, 0 2px 20px 0 #4c4c4c;
  transform: translate(0px, -10px);
}

.projects-wrapper {
  margin-top: 70px;
}
.card_header {
  display: flex;
  align-items: center;
  .ms-4 {
    flex: 1;
    height: 72px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    .title {
      font-family: Roboto;
      font-style: normal;
      font-weight: bold;
      font-size: 24px;
      line-height: 28px;
      color: #000000;
    }
    .grant {
      font-family: Roboto;
      font-style: normal;
      font-weight: normal;
      font-size: 14px;
      line-height: 16px;
      color: #000;
      opacity: 0.6;
    }
  }

  &_bottom {
    display: flex;
    align-items: center;
  }

  &_circle {
    display: inline-block;
    width: 16px;
    height: 16px;
    background: #cfcfcf;
    border-radius: 8px;
  }
}
.card-head-button {
  float: right;
  font-size: 24px;
  color: #ffffff;
  transition: 0.3s;
  &:hover {
    color: #32e0c4 !important;
  }
}

.categories {
  font-size: 28px;
  font-family: Roboto;
  line-height: 30px;
  border: unset !important;
  box-shadow: unset;
  border-radius: 0 !important;
}
.categories:hover {
  border: unset !important;
  box-shadow: unset;
  border-radius: 0 !important;
  span {
    display: block;
  }
}
.categories.active {
  font-weight: 700 !important;
}
.container-filter li a {
  font-weight: normal;
}
.card_body_button {
  display: flex;
  justify-content: space-between;
  align-items: center;
  .view_btn {
    width: 100%;
    display: flex;
    justify-content: space-evenly;
    align-items: center;
    padding: 0 40px;
    i {
      font-size: 27px !important;
    }
  }
  .card-view {
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 16px;
    color: #000000;
    opacity: 0.8;
    &:hover {
      cursor: pointer;
      color: #32e0c4;
    }
  }
  .like_btn {
    display: flex;
    padding: 5px 30px;
    align-items: center;
    font-size: 18px;
    white-space: nowrap;
    i {
      font-size: 22px !important;
      margin-right: 20px;
    }
  }
}
.bottom-icon {
  font-size: 24px !important;
}
.img-desc {
  background: #c4c4c4;
  height: 200px;
}
.card_body {
  padding: 20px 20px 0;
  .text {
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 16px;
    line-height: 19px;
    min-height: 18px;
    color: rgba(0, 0, 0, 0.8);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .icon-list {
    min-height: 40px;
    .iconfont {
      color: #c4c4c4;
    }
    .iconfont:hover {
      color: rgba(50, 224, 196, 0.6);
    }
  }
  .btn-sm,
  .icon-zhuanfa {
    font-size: 21px;
  }
  .iconfont {
    color: #000;
    font-size: 24px;
    cursor: pointer;
  }
}
#Explore .row:first-child {
  width: 100%;
  align-items: center;
  & > * {
    width: auto;
  }
  .search {
    width: 300px;
    height: 40px;
    background-color: #000000;
    border: 1px solid #ffffff;
    box-sizing: border-box;
    border-radius: 4px;
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 14px;
    line-height: 16px;
    color: #ffffff;
  }
}
.input-icon {
  color: white;
  font-size: 30px;
  opacity: 0.6;
}
.el-query ::v-deep {
  padding: 0;
  margin-left: 30px;
  width: 300px;
  &:focus,
  :hover {
    border-color: #b6fd21;
  }
  .el-input__inner {
    background: #000000;
  }
  .el-input__prefix {
    font-size: 19px;
  }
}
.el-card ::v-deep {
  .el-card__body {
    position: relative;
    padding: 20px 0;
  }
  -webkit-transition: all 0.5s ease;
  transition: all 0.5s ease;
}
.el-card ::v-deep .line {
  background: #ffffff;
  opacity: 0.3;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  margin: 0 auto;
  width: calc(100% - 40px);
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.card_header ::v-deep .el-tag {
  height: 16px;
  font-size: 14px;
  line-height: 16px;
}

.card_body ::v-deep .el-tag {
  font-family: Roboto;
  font-style: normal;
  font-weight: normal;
  font-size: 12px;
  line-height: 20px;
  border: 0;
  height: 20px;
  border-radius: 4px;
  color: #000;
  background: rgba(50, 224, 196, 0.6);
  padding: 0 12px;
}
.page {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  .arrow {
    color: #000;
    font-size: 40px;
    &:hover {
      cursor: pointer;
    }
  }
  .icon-a-left-arrow {
    margin-left: 30px;
  }
  .icon-a-right-arrow {
    margin-right: 30px;
  }
}
.like-count {
  margin-left: 5px;
  font-size: 19px;
  font-weight: bold;
}
.pagination {
  margin-top: 20px;
}
.el-carousel__item img {
  width: 100%;
  cursor: pointer;
}
.el-carousel__item:nth-child(2n) {
  background-color: #99a9bf;
}

.el-carousel__item:nth-child(2n + 1) {
  background-color: #d3dce6;
}
</style>
