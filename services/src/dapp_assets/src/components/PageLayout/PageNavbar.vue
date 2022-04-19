<template>
  <!-- Navbar STart -->
  <header id="topnav" class="defaultscroll sticky">
    <div class="container">
      <!-- Start Logo container-->
      <router-link class="logo" to="/">
        <img src="~@/assets/images/navigation/logo@2x.png" alt="logo"/>
      </router-link>
      <!-- End Logo container-->

      <!--Start Login Button-->
      <div class="buy-button">
        <el-link :underline="false" v-if="!identity" :loading="loginLoading" target="_blank"
                 class="btn btn-sm" @click="login">
          {{ $t('home.navbar.login') }}
        </el-link>
        <template v-else-if="user != null && user !== ''">
          <el-dropdown @command="deleteUser">
            <span class="btn user-text lang">
              <!-- {{ language }}
            <i v-if="$i18n.locale=='zh-CN'" class="iconfont icon-yingwen" @click="handleSetLang('zh-CN')"></i>
            <i v-if="$i18n.locale=='en-US'" class="iconfont icon-zhongwen" @click="handleSetLang('en-US')"></i> -->
              <el-link :underline="false" target="_blank" class="btn btn-sm"> {{ user.username }} </el-link>
              <chevron-down-icon class="user-drop-icon"></chevron-down-icon>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item>
                {{ user.username }}
              </el-dropdown-item>
              <el-dropdown-item command="logout">
                {{ $t('home.navbar.logout') }}
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <!-- <a target="_blank" class="btn user-text">{{ user.username }}，{{ $t('hello') }}!</a> -->
          <!--<a target="_blank" class="btn btn-primary btn-sm" @click="deleteUser()">{{$t('home.navbar.logout')}}</a>-->
          <!-- <a target="_blank" class="btn user-text" @click="deleteUser()">[{{ $t('home.navbar.logout') }}]</a> -->
        </template>
        <!-- <el-tooltip class="item" effect="dark" :content="wallet.principalId ? wallet.principalId : $t('home.navbar.connectWallet')" placement="bottom">
          <el-link :underline="false" v-if="user != null && user !== ''" :loading="walletLoading" @click="walletLogin('plug')" class="btn wallet-text">{{ wallet.principalId ? wallet.principalId : $t('home.navbar.connectWallet') }}
            <chevron-down-icon class="custom-class"></chevron-down-icon>
          </el-link>
        </el-tooltip>
        <el-dropdown @command="walletLogin" :loading="walletLoading" v-if="user != null && user !== ''">
          <span class="btn wallet-text">{{ wallet.principalId ? wallet.principalId : $t('home.navbar.connectWallet') }}
            <chevron-down-icon class="custom-class"></chevron-down-icon>
          </span>
          <el-link :underline="false" v-if="user != null && user !== ''" :loading="walletLoading" @click="walletLogin('plug')" class="btn wallet-text">{{ wallet.principalId ? wallet.principalId : $t('home.navbar.connectWallet') }}
            <chevron-down-icon class="custom-class"></chevron-down-icon>
          </el-link>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="plug">Plug</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown> -->

        <el-popover placement="bottom" width="215" trigger="hover" v-if="user">
          <el-card class="box-card">
            <div slot="header" class="title">
              <span>Plug Wallet</span>
            </div>
            <div v-if="wallet.principalId">
              <div class="sub-title">
                <img src="~@/assets/images/plug.png" :fit="fit" style="width: 24px; height: 24px"/>
                <span>Plug Wallet</span>
              </div>
              <div class="wallet-clipboard" v-clipboard="wallet.principalId"
                   v-clipboard:success="clipboardSuccessHandler" v-clipboard:error="clipboardErrorHandler">
                {{ wallet.principalId | walletInfoFilter }} <i class="iconfont icon-a-fuzhi1"></i></div>
              <div class="logout" @click="walletLogout">
                Log out
              </div>
            </div>
            <el-button v-else type="btn btn-primary btn-wallet" @click="walletLogin('plug')">
              {{ $t('home.navbar.connectWallet') }} <img src="~@/assets/images/plug.png" :fit="fit"
                                                         style="width: 24px; height: 24px"/></el-button>
          </el-card>
          <div slot="reference" class="wallet-wrapper">
            <img style="width: 24px; height: 24px" src="~@/assets/images/plug_b.png" :fit="fit"
                 v-if="!wallet.principalId" :loading="walletLoading"/>
            <!-- {{ wallet.principalId ? wallet.principalId : $t('home.navbar.connectWallet') }} -->
            <!-- <chevron-down-icon class="custom-class"></chevron-down-icon> -->
            <img v-else src="~@/assets/images/plug.png" :fit="fit" style="width: 24px; height: 24px"/>
            <chevron-down-icon class="wallet-icon"></chevron-down-icon>
          </div>
        </el-popover>

        <!--<a v-else target="_blank" class="btn btn-primary btn-sm" @click="dialogVisible = true">{{$t('home.navbar.register')}}</a>-->
        <!--<a target="_blank" class="btn btn-primary btn-sm" @click="test()">测试按钮</a>-->
        <!--<a target="_blank" class="btn btn-primary btn-sm" @click="doInitActor(identity)">actor创建</a>-->
        <!-- <span class="btn user-text lang">
          {{ language }}
          <i v-show="language=='English'" class="iconfont icon-zhongwen" @click="handleSetLang('en-US')"></i>
          <i v-show="language=='中文'" class="iconfont icon-yingwen" @click="handleSetLang('zh-CN')"></i>
          <chevron-down-icon class="custom-class"></chevron-down-icon>
        </span> -->
        <el-dropdown @command="handleLocale" class="language">
          <span class="btn user-text lang">
            <!-- {{ language }}
            <i v-if="$i18n.locale=='zh-CN'" class="iconfont icon-yingwen" @click="handleSetLang('zh-CN')"></i>
            <i v-if="$i18n.locale=='en-US'" class="iconfont icon-zhongwen" @click="handleSetLang('en-US')"></i> -->
            <i class="iconfont icon-language-globe"></i>
            <!-- <chevron-down-icon class="custom-class"></chevron-down-icon> -->
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="en-US">
              {{ $t('home.navbar.language.en-US') }}
            </el-dropdown-item>
            <el-dropdown-item command="zh-CN">
              {{ $t('home.navbar.language.zh-CN') }}
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
      <!--End Login Button-->

      <div class="menu-extras">
        <div class="menu-item">
          <!-- Mobile menu toggle-->
          <a class="navbar-toggle" @click="toggleMenu()" :class="{ open: isCondensed === true }">
            <div class="lines">
              <span v-for="index in 3" :key="index"></span>
            </div>
          </a>
          <!-- End mobile menu toggle-->
        </div>
      </div>

      <!--start navigation-->
      <div id="navigation">
        <!-- Navigation Menu-->
        <ul class="navigation-menu justify-content-start">
          <li class="navigation-menu">
            <router-link to="/" class="side-nav-link-ref">
              {{ $t('home.navbar.home') }}
            </router-link>
          </li>
          <li class="navigation-menu">
            <router-link to="/library" class="side-nav-link-ref">
              {{ $t('home.navbar.library') }}
            </router-link>
          </li>
          <li class="navigation-menu">
            <router-link to="/dapp" class="side-nav-link-ref">
              {{ $t('home.navbar.dapp') }}
            </router-link>
          </li>
          <!--<li class="navigation-menu">-->
          <!--<router-link to="/hackathon" class="side-nav-link-ref">{{ $t('home.navbar.hackathon') }}</router-link>-->
          <!--</li>-->
          <li class="navigation-menu">
            <a href="https://icpleague.com" class="side-nav-link-ref" target="_blank">
              {{ $t('home.navbar.forum') }}
            </a>
          </li>
          <li class="navigation-menu">
            <a href="https://dfinity.org/grants/" class="side-nav-link-ref" target="_blank">
              {{ $t('home.navbar.grant') }}
            </a>
          </li>
        </ul>
        <!--end navigation menu-->
      </div>
      <!--end navigation-->
    </div>
    <!--end container-->
    <!-- 这里存放一个对话框合适吗？ -->
    <el-dialog :title="'ICPL ' + $t('register')" :visible.sync="dialogVisible" :append-to-body="true"
               :before-close="handleClose" class="loading-area" width="30%">
      <el-form ref="form" :model="form" :label-position="right" label-width="80px" onsubmit="return false;"
               @keydown.enter.native="registerUser(form.name)">
        <el-form-item :label="$t('name')">
          <el-input v-model="form.name"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="handleClose()">{{ $t('button.cancel') }}</el-button>
        <el-button type="primary" @click="registerUser(form.name)">{{
            $t('button.confirm')
          }}</el-button>
      </span>
    </el-dialog>
  </header>
  <!--end header-->
  <!-- Navbar End -->
</template>
<script>

import {getIdentityProvider, getAuthClient, initActor} from '@/api/identify'
import Bus from "@/common/bus.js";

import {ChevronDownIcon} from "vue-feather-icons";

/**
 * Navbar component
 */
export default {
  name: "PageNavbar",
  components: {ChevronDownIcon},
  data() {
    return {
      language: "English", // 显示当前显示的语言
      loginLoading: false, // 登录按钮 防止连续点击
      dialogVisible: false, // 显示对话框

      user: null, // 用户信息
      identity: null, // 登录标识
      principal: null, // 用户

      actor: this.$store.state.dapp || "", // 从vuex中读取actor，如果没有就为空

      isCondensed: false,
      dialogLoading: false,
      dapp: "",
      form: {
        name: ""
      },
      wallet: this.$store.state.wallet.plug || {},
      walletLoading: false,
      plugLogo: require("@/assets/images/plug.png")
    };
  },
  mounted() {
    // this.onWindowScroll(); // 窗口滚动显示返回顶部按钮
    this.getMenuItem();
    this.initLocale();
    Bus.$on("IILogin", () => this.login());
    Bus.$on("walletLogin", () => this.walletLogin("plug"));
    //默认创建一个匿名actor供用户使用
  },
  async created() {
    this.getUser();
    //默认创建一个匿名actor供用户使用
    let identity = this.identity;
    this.actor = this.$store.state.dapp || "";
    if (!this.actor) {
      if (!identity) {
        await this.doInitActor(null);
        console.log("actor create");
        console.log(identity);
      } else {
        //如果已经登录，则调用登录功能创建一个新的actor
        //可能会造成授权过期后用户重新登录的问题
        await this.login();
        console.log("actor not create,and login!");
      }
    } else {
      console.log("vuex load actor");
      console.log(this.actor);
    }
  },
  filters: {
    walletInfoFilter(str) {
      // 中间显示省略号
      return (
          str.substring(0, 6) + "..." + str.substring(str.length - 6, str.length)
      );
    }
  },
  methods: {
    async test() {
      //测试II授权剩余时间
      // const nextExpiration = this.identity.getDelegation().delegations
      //   .map(d => d.delegation.expiration)
      //   .reduce((current, next) => next < current ? next : current);
      // const expirationDuration  = nextExpiration - BigInt(Date.now()) * BigInt(1000_000);
      // console.log("time:"+expirationDuration);
    },
    startLoading() {
      this.loading = this.$loading({
        lock: true,
        text: "Loading...",
        target: document.querySelector(".el-dialog") //设置加载动画区域
      });
    },
    endLoading() {
      this.loading.close();
    },
    handleClose(done) {
      this.$confirm(this.$t("message.close.confirm"))
          .then(_ => {
            this.deleteUser();
            this.dialogVisible = false;
            done();
          })
          .catch(_ => {
          });
    },
    getUser() {
      //从vuex中获取存储的user信息
      this.user = this.$store.state.user;
      this.identity = this.$store.state.identity;
      console.log('user', this.user)
      console.log('identity', this.identity)
    },
    deleteUser(param) {
      if (param) {
        this.user = null;
        this.identity = null;
        sessionStorage.removeItem("user");
        sessionStorage.removeItem("identity");
        localStorage.removeItem("ic-identity");
        localStorage.removeItem("ic-delegation");
        this.$store.commit("SET_USER", null);
        this.$store.commit("SET_IDE", null);
      }
    },
    async registerUser(username) {
      //消除用户名中的空格
      username = username.trim();
      if (username == null || username === "") {
        this.$message({
          message: this.$t("message.notValid"),
          type: "error"
        });
        return;
      }
      // this.dialogLoading=true;
      this.startLoading();
      //admin 后台注册, front 前台注册
      let res = await this.actor.registerUser(username, "front");
      //状态码,ok为没问题,err为有问题
      let state = Object.keys(res)[0];
      if (state === "ok") {
        // this.getSelf();
        //等候一下时间，防止后端数据还未处理完成
        await setTimeout(() => {
          this.login();
        }, 3000);
        this.dialogVisible = false;
        this.$message({
          message: this.$t("message.welcome") + "," + res.ok,
          type: "success"
        });
      } else {
        //错误提示
        let error = Object.keys(res.err)[0];
        if (error === "userAlreadyExists") {
          this.$message({
            dangerouslyUseHTMLString: true,
            message:
                this.$t("message.error.userExists") + ",<br/>" + this.principal,
            type: "error"
          });
        } else if (error === "invalidUsername") {
          this.$message({
            message: this.$t("message.notValid"),
            type: "error"
          });
        } else if (error === "usernameAlreadyExists") {
          this.$message({
            message: this.$t("message.error.usernameExists") + "," + username,
            type: "error"
          });
        } else {
          this.$message({
            message: this.$t("message.unknown") + ":" + JSON.stringify(res.err),
            type: "error"
          });
        }
      }
      // this.dialogLoading=false;
      this.endLoading();
    },
    async getSelf() {
      console.log("getSelf:", this.actor);
      let res = await this.actor.getSelf();
      console.log(res);
      if (Object.keys(res)[0] === "ok") {
        const user = res.ok[0];
        this.user = user;
        this.$store.commit("SET_USER", user);
      } else {
        //没有注册时打开注册面板
        this.dialogVisible = true;
        // this.$message({
        //   message: this.$t('message.error.notRegistOrMatch'),
        //   type: 'error'
        // });
      }
    },
    async doInitActor(identity) {
      await initActor(identity,
          (ps) => this.$store.commit("SET_PHOTO_SERVICE", ps),
          (a) => this.$store.commit("SET_DAPP", a))
      this.actor = this.$store.state.dapp;
    },
    async login() {
      this.loginLoading = true;
      let identityProvider = getIdentityProvider();
      // console.error('identityProvider', identityProvider)

      let identity;
      try {
        const authClient = await getAuthClient();
        // console.error('authClient', authClient)
        if (await authClient.isAuthenticated()) {
          identity = authClient.getIdentity();
          this.principal = String(identity.getPrincipal());
        } else {
          identity = await new Promise((resolve, reject) => {
            let timer = setTimeout(() => {
              timer = null;
              reject("do II auth timeout!");
              this.$message({
                message: "II" + this.$t("message.error.authTimeOut"),
                type: "error"
              });
              this.loginLoading = false;
            }, 30 * 1000 * 3);
            authClient.login({
              identityProvider,
              // maxTimeToLive: BigInt(60_000_000_000),
              onSuccess: () => {
                if (timer != null) {
                  clearTimeout(timer);
                  timer = null;
                  resolve(authClient.getIdentity());
                }
              },
              onError: err => {
                if (timer != null) {
                  clearTimeout(timer);
                  timer = null;
                  reject(err);
                }
                this.loginLoading = false;
              }
            });
          });
          this.principal = String(identity.getPrincipal());
        }
        console.log('principal', this.principal)
      } catch (e) {
        console.error(e);
      }
      if (identity) {
        this.identity = identity;
        this.$store.commit("SET_IDE", identity);
        // console.log("identity.getPrincipal:");
        // console.log(identity.getPrincipal);
        await this.doInitActor(identity);
        await this.getSelf();
      }
      this.loginLoading = false;
    },
    onWindowScroll() {
      window.onscroll = function () {
        if (
            document.body.scrollTop > 50 ||
            document.documentElement.scrollTop > 50
        ) {
          document.getElementById("topnav").classList.add("nav-sticky");
        } else {
          document.getElementById("topnav").classList.remove("nav-sticky");
        }
        // 页面右下角返回顶部按钮
        // if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
        //   document.getElementById('back-to-top').style.display = 'inline'
        // } else {
        //   document.getElementById('back-to-top').style.display = 'none'
        // }
      };
    },
    getMenuItem() {
      const links = document.getElementsByClassName("side-nav-link-ref");
      let matchingMenuItem = null;
      for (let i = 0; i < links.length; i++) {
        // if (window.location.pathname === links[i].pathname) {
        if (window.location.hash === links[i].hash) {
          matchingMenuItem = links[i];
          break;
        }
      }

      if (matchingMenuItem) {
        matchingMenuItem.classList.add("active");
        const parent = matchingMenuItem.parentElement;

        /**
         * TODO: This is hard coded way of expading/activating parent menu dropdown and working till level 3.
         * We should come up with non hard coded approach
         */
        if (parent) {
          parent.classList.add("active");
          const parent2 = parent.parentElement;
          if (parent2) {
            parent2.classList.add("active");
            const parent3 = parent2.parentElement;
            if (parent3) {
              parent3.classList.add("active");
              const parent4 = parent3.parentElement;
              if (parent4) {
                const parent5 = parent4.parentElement;
                parent5.classList.add("active");
              }
            }
          }
        }
      }
    },
    toggleMenu() {
      this.isCondensed = !this.isCondensed;
      if (this.isCondensed) {
        document.getElementById("navigation").style.display = "block";
      } else document.getElementById("navigation").style.display = "none";
    },
    handleLocale(locale) {
      // console.log(locale);
      this.$i18n.locale = locale;
      localStorage.setItem("locale", locale);
      this.refreshLocale();
    },
    initLocale() {
      let locale = localStorage.getItem("locale");
      if (!locale) {
        return ;
      } else {
        this.$i18n.locale = locale;
      }
      this.refreshLocale();
    },
    refreshLocale() {
      let locale = this.$i18n.locale || 'en-US';
      switch (locale) {
        case "zh-CN": this.language = "简体中文"; break;
        default: this.language = "English";
      }
    },
    walletLogin() {
      // const result = await window.ic.plug.requestConnect()
      // const connectionState = result ? 'allowed' : 'denied'
      // console.log(`The Connection was ${connectionState}!`)
      // Canister Ids
      this.walletLoading = true;
      this.$store
          .dispatch("plugWalletLogin")
          .then(result => {
            this.wallet = result;
            this.$message.success("成功链接Plug钱包");
            this.walletLoading = false;
          })
          .catch(err => {
            this.wallet = false;
          });
    },
    walletLogout() {
      sessionStorage.removeItem("plug");
      this.wallet = this.$store.state.wallet.plug = {};
    },
    clipboardSuccessHandler() {
      this.$message.success("复制成功");
    },
    clipboardErrorHandler() {
    }
  }
};
</script>

<style lang="scss">
.el-popper .popper__arrow {
  display: none;
}

.el-popover {
  background-color: #1c1c1c;
  border-color: #1c1c1c;
  padding: 5px;

  .el-card {
    background-color: #1c1c1c;
    border-color: #1c1c1c;

    .el-card__header {
      border-bottom: unset;
      padding: 18px 20px 5px;
    }

    .title {
      font-size: 12px;
      line-height: 14px;
      /* identical to box height */
      font-weight: bold;
      color: #ffffff;
    }

    .el-card__body {
      padding-bottom: 0;
    }

    .sub-title {
      font-weight: 300;
      font-size: 12px;
      line-height: 14px;
      /* identical to box height */
      color: #ffffff;
      display: flex;
      align-items: center;

      img {
        margin-right: 10px;
      }
    }

    .wallet-clipboard {
      font-size: 16px;
      line-height: 19px;
      /* identical to box height */
      color: #ffffff;
      margin-top: 20px;
      cursor: pointer;

      i {
        font-size: 14px;
        margin-left: 20px;
      }
    }

    .logout {
      font-weight: 300;
      font-size: 14px;
      line-height: 16px;
      color: rgba(255, 255, 255, 0.8);
      border-top: 1px solid rgba(255, 255, 255, 0.04);
      height: 60px;
      margin-top: 20px;
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;
    }

    .el-button {
      font-size: 12px;
      margin-bottom: 20px;
      padding-left: 10px;
      padding-right: 10px;
      border: 1px solid #ffffff4d !important;
      background: transparent !important;
      width: 167px;
      text-align: left;

      span {
        display: flex;
        align-items: center;
        color: rgba(255, 255, 255, 0.3);
        justify-content: space-between;
      }

      box-shadow: unset;

      img {
        float: right;
      }
    }

    .el-button:hover {
      span {
        color: #fff;
      }

      border: 1px solid #b6fd21 !important;
    }

    color: #fff;
  }
}
</style>
<style lang="scss" scoped>
#topnav {
  .container {
    padding-left: 0;
    padding-right: 0;

    .logo {
      padding: 0 0 0 0;
      line-height: unset;

      img {
        width: 104px;
        height: 25px;
        margin-left: 30px;
        margin-top: 27.5px;
      }
    }

    #navigation {
      padding-left: 195px;

      .side-nav-link-ref {
        line-height: 80px;
        display: inline-block;
        padding: 0 20px;
        text-transform: none;
        opacity: 1;

        font-family: RobotoRemote, 'JetBrains Mono', Helvetica, Tahoma, Arial, "PingFang SC", "Hiragino Sans GB", "Heiti SC", "Microsoft YaHei", "WenQuanYi Micro Hei", serif;
        font-style: normal;
        font-weight: 300;
        font-size: 14px;
      }

      .side-nav-link-ref:hover {
        color: white !important;
        font-weight: bold;
      }

      .navigation-menu > li.active > a {
        color: white !important;
        font-weight: bold;
      }
    }

    .buy-button {
      margin-right: 10px;
      height: 80px;

      > a {
        line-height: 80px;
        height: 80px;
        font-family: RobotoRemote, 'JetBrains Mono', Helvetica, Tahoma, Arial, "PingFang SC", "Hiragino Sans GB", "Heiti SC", "Microsoft YaHei", "WenQuanYi Micro Hei", serif;
        font-style: normal;
        font-weight: 300;
        font-size: 14px;
      }

      > a:hover {
        color: white !important;
        font-weight: bold;
      }

      .language {

        > span {
          display: inline-block;
          padding: 0 25px;
          height: 80px;
          text-align: center;

          i {
            margin: 0 auto;
            display: inline-block;
            line-height: 80px;
          }

          i:hover {
            font-weight: bold;
          }
        }
      }
    }
  }

}


#topnav .navigation-menu > li > a {
  font-size: 16px;
  color: #ffffff;
  font-weight: normal;
  opacity: 0.8;
}

.el-dropdown-menu {
  background-color: #1c1c1c;
  border-color: #000;

  .el-dropdown-menu__item {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.7);
    padding: 0 60px;
    text-align: center;
  }

  .el-dropdown-menu__item:hover {
    background-color: transparent;
    color: #fff;
  }
}

.container {
  width: 100% !important;
  max-width: unset;

  .buy-button {
    display: flex;
    align-items: center;

    .el-popper .popper__arrow {
      display: none;
    }
  }

  .wallet-wrapper {
    display: flex;
    margin: 0 30px;

    .wallet-icon {
      color: #ffffff;
      margin-left: 6px;
      font-size: 12px;
    }
  }

  .icon-Language {
    font-size: 30px;
    color: #ffffff;
  }

  .justify-content-start {
    justify-content: flex-start;
  }
}

.btn-sm {
  color: #fff !important;
  font-size: 16px;
  padding: 0;
}

.btn-sm:hover {
  color: #b6fd21 !important;
}

.user-text {
  font-size: 14px;
  font-family: Roboto;
  font-weight: normal;
  // color: #b6fd2199;
  color: #fff;
}

.lang {
  .user-drop-icon {
    font-size: 12px;
  }

  i {
    color: #ffffff;
    font-size: 24px;
  }

  // i:hover {
  //   color: #b6fd21;
  // }
}

.wallet-text {
  font-family: Roboto;
  font-style: normal;
  font-weight: 500;
  font-size: 14px;
  line-height: 16px;
  text-align: center;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  // color: #b6fd2199;
  color: #fff;
}

.el-link.el-link--default:hover {
  color: #ffffff;
}

.user-black {
  font-size: 16px;
  font-family: "Microsoft YaHei";
  font-weight: normal;
  color: #ffffff;
}

#topnav .navigation-menu > li.active > a {
  color: #b6fd21 !important;
  font-weight: 700;
}
</style>
