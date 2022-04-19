<template>
  <!-- Navbar STart -->
  <header id="topnav" class="defaultscroll sticky">
  <!--<header class="defaultscroll sticky">-->
    <div class="container">
      <!-- Start Logo container-->
      <router-link class="logo" to="/">
        <img src="~a@/assets/images/navigation/logo@2x.png" width="82" height="20" />
      </router-link>
      <!-- End Logo container-->
      <!--Start Login Button-->
      <div class="buy-button">
        <el-button v-if="identity == null || identity === ''"
                   :loading="loginLoading"
                   target="_blank" class="btn btn-primary btn-sm" @click="login()">{{$t('home.navbar.icplogin')}}</el-button>
        <template v-else-if="user != null && user !==''" >
          <a target="_blank" class="btn user-text">{{user.username}}，{{$t('hello')}}!</a>
          <!--<a target="_blank" class="btn btn-primary btn-sm" @click="deleteUser()">{{$t('home.navbar.logout')}}</a>-->
          <a target="_blank" class="btn user-text" @click="deleteUser()">[{{$t('home.navbar.logout')}}]</a>
        </template>
        <!--<a v-else target="_blank" class="btn btn-primary btn-sm" @click="dialogVisible = true">{{$t('home.navbar.register')}}</a>-->
        <!--<a target="_blank" class="btn btn-primary btn-sm" @click="test()">测试按钮</a>-->
        <!--<a target="_blank" class="btn btn-primary btn-sm" @click="initActor(identity)">actor创建</a>-->
        <!--<el-dropdown @command="handleSetLang">-->
          <!--<span class="btn user-text">{{ language }}  <chevron-down-icon class="custom-class"></chevron-down-icon></span>-->
          <!--<el-dropdown-menu slot="dropdown">-->
            <!--<el-dropdown-item command="zh-CN">{{ $t('home.navbar.language.zh-CN') }}</el-dropdown-item>-->
            <!--<el-dropdown-item command="en-US">{{ $t('home.navbar.language.en-US') }}</el-dropdown-item>-->
          <!--</el-dropdown-menu>-->
        <!--</el-dropdown>-->
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

      <!--<div id="navigation">-->
        <!--&lt;!&ndash; Navigation Menu&ndash;&gt;-->
        <!--<ul class="navigation-menu">-->
          <!--<li class="navigation-menu">-->
            <!--<router-link to="/" class="side-nav-link-ref">{{ $t('home.navbar.home') }}</router-link>-->
          <!--</li>-->
          <!--<li class="navigation-menu">-->
            <!--<router-link to="/library" class="side-nav-link-ref">{{ $t('home.navbar.library') }}</router-link>-->
          <!--</li>-->
          <!--<li class="navigation-menu">-->
            <!--<router-link to="/dapp" class="side-nav-link-ref">{{ $t('home.navbar.dapp') }}</router-link>-->
          <!--</li>-->
          <!--&lt;!&ndash;<li class="navigation-menu">&ndash;&gt;-->
            <!--&lt;!&ndash;<router-link to="/hackathon" class="side-nav-link-ref">{{ $t('home.navbar.hackathon') }}</router-link>&ndash;&gt;-->
          <!--&lt;!&ndash;</li>&ndash;&gt;-->
          <!--<li class="navigation-menu">-->
            <!--<a href="https://icpleague.com" target="_blank">{{ $t('home.navbar.forum') }}</a>-->
          <!--</li>-->
          <!--<li class="navigation-menu">-->
            <!--<a href="https://dfinity.org/grants/"  target="_blank">{{ $t('home.navbar.grant') }}</a>-->
          <!--</li>-->
        <!--</ul>-->
        <!--&lt;!&ndash;end navigation menu&ndash;&gt;-->
      <!--</div>-->
      <!--end navigation-->
    </div>
    <!--end container-->
    <el-dialog
      :title="'ICPL 后台管理'+$t('register')"
      :visible.sync="dialogVisible"
      :append-to-body='true'
      :before-close="handleClose"
      class="loading-area"
      width="30%">
      <el-form ref="form" :model="form"
               :label-position=right
               label-width="80px"
               onsubmit="return false;"
               @keydown.enter.native="registerUser(form.name)">
        <el-form-item :label="$t('name')">
          <el-input v-model="form.name"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
          <el-button @click="handleClose()">{{ $t('button.cancel') }}</el-button>
          <el-button type="primary" @click="registerUser(form.name)">{{ $t('button.confirm') }}</el-button>
      </span>
    </el-dialog>
  </header>
  <!--end header-->
  <!-- Navbar End -->
</template>
<script>
  //环境变量，本地环境=local，主网环境=ic
  const env = 'ic';
  let canisterIds=null;
  if(env==='local'){
    //本地
    canisterIds=require('root@/.dfx/local/canister_ids.json');
  }else if(env==='ic'){
    //主网
    canisterIds=require('root@/canister_ids.json');
  }
  //定义actor所需要的内容
  import { AuthClient } from '@dfinity/auth-client';
  // import { Ed25519KeyIdentity } from "@dfinity/identity";
  import { Actor, HttpAgent } from '@dfinity/agent';
  // import { idlFactory as dapp_idl } from 'dfx-generated/dapp/dapp.did.js';
  import { idlFactory as dapp_idl } from 'dfx-generated/dapp';
  import { idlFactory as log_idl } from 'dfx-generated/log_service';
  // import { idlFactory as email_idl } from 'dfx-generated/email_subscription';

  const dapp_id = new URLSearchParams(window.location.search).get("dappId") || canisterIds.dapp.local || canisterIds.dapp.ic;
  const log_id = canisterIds.log_service.local || canisterIds.log_service.ic;
  const method = new URLSearchParams(window.location.search).get("method") || "healthcheck()";
  //本地II的容器ID
  const ii_id=null;
  // const ii_id="rwlgt-iiaaa-aaaaa-aaaaa-cai";

  import { ChevronDownIcon } from 'vue-feather-icons'
  /**
   * Navbar component
   */
  export default {
    name: 'PageNavbar',
    components: { ChevronDownIcon},
    data() {
      return {
        language:'English',
        isCondensed: false,
        dialogLoading:false,
        loginLoading:false,
        dapp:"",
        principal:null,
        identity:"",
        dialogVisible: false,
        form:{
          name:"",
        },
        //从vuex中读取actor，如果没有就为空
        actor:this.$store.state.dapp|| "",
        user:"",
      }
    },
    mounted() {
      // this.onwindowScroll();
      this.getMenuItem();
      this.getLang();
    },
    async created(){
     await this.getUser();
      //默认创建一个匿名actor供用户使用
      let identity=this.identity;
      if(this.actor==null||this.actor===""){
        if(identity==null||identity===""){
          this.initActor(null);
          console.log("actor create");
          console.log(identity);
        }else {
          //如果已经登录，则调用登录功能创建一个新的actor
          //可能会造成授权过期后用户重新登录的问题
          this.login();
          console.log("actor not create,and login!");
        }
      }else {
        console.log("vuex load actor");
        console.log(this.actor);
      }
    },
    methods: {
      emitToOK(){
        //控制组件渲染顺序，优先渲染导航条
        this.$emit('ok',true);
      },
      async test(){
        //测试II授权剩余时间
        // const nextExpiration = this.identity.getDelegation().delegations
        //   .map(d => d.delegation.expiration)
        //   .reduce((current, next) => next < current ? next : current);
        // const expirationDuration  = nextExpiration - BigInt(Date.now()) * BigInt(1000_000);
        // console.log("time:"+expirationDuration);
       let res=await this.actor.getSelf();
       console.log(res);
       console.log(res1);
       this.dialogVisible=true;

      },
      startLoading() {
        this.loading = this.$loading({
          lock: true,
          text: "Loading...",
          target: document.querySelector('.el-dialog')//设置加载动画区域
        });
      },
      endLoading(){
        this.loading.close();
      },
      handleClose(done) {
        this.$confirm(this.$t('message.close.confirm'))
          .then(_ => {
            this.deleteUser();
            this.dialogVisible=false;
            done();
          })
          .catch(_ => {});
      },
      getUser(){
        //从vuex中获取存储的user信息
        this.user=this.$store.state.user;
        this.identity=this.$store.state.identity;
      },
      deleteUser(){
        this.user=null;
        this.identity=null;
        sessionStorage.removeItem('user');
        sessionStorage.removeItem('identity');
        localStorage.removeItem('ic-identity');
        localStorage.removeItem('ic-delegation');
        this.$store.commit("SET_USER",null);
        this.$store.commit("SET_IDE",null);
      },
      async registerUser(username){
        if(username==null||username===''){
          this.$message({
            message: this.$t('message.notValid'),
            type: 'error'
          });
          return;
        }
        // this.dialogLoading=true;
        this.startLoading();
        //admin 后台注册, front 前台注册
        let res =await this.actor.registerUser(username,"admin");
        //状态码,ok为没问题,err为有问题
        let state=Object.keys(res)[0];
        if(state==="ok"){
          // this.getSelf();
          //等候一下时间，防止后端数据还未处理完成
          await setTimeout(() => {
            this.login();
          }, 3000);
          this.dialogVisible = false;
          this.$message({
            message: this.$t('message.welcome')+","+res.ok,
            type: 'success'
          });
        }else{
          //错误提示
          let error=Object.keys(res.err)[0];
          if(error==="userAlreadyExists"){
            this.$message({
              dangerouslyUseHTMLString: true,
              message: this.$t('message.error.userExists')+",<br/>"+this.principal,
              type: 'error'
            });
          }else if(error==='invalidUsername'){
            this.$message({
              message: this.$t('message.notValid'),
              type: 'error'
            });
          }else if(error==='usernameAlreadyExists'){
            this.$message({
              message: this.$t('message.error.usernameExists')+","+username,
              type: 'error'
            });
          }else {
            this.$message({
              message: this.$t('message.unknown')+":"+JSON.stringify(res.err),
              type: 'error'
            });
          }
        }
        // this.dialogLoading=false;
        this.endLoading();
      },
      async getSelf(){
        console.log("getSelf:");
        let res =await this.actor.getSelf();
        console.log(res);
        if(Object.keys(res)[0]==="ok"){
          const user=res.ok[0];
          this.user=user;
          this.$store.commit("SET_USER",user);
        }else {
          //没有注册时打开注册面板
          this.dialogVisible=true;
          // this.$message({
          //   message: this.$t('message.error.notRegistOrMatch'),
          //   type: 'error'
          // });
        }
      },
      async initActor(identity){
        // let x_identity=this.$store.state.identity;
        // if((identity==null||identity==="")&&(x_identity!=null||x_identity!=="")){
        //   //初始化匿名容器时，检查用户是否登录，如果已经登录，则不创建匿名容器
        //   identity=x_identity;
        // }
        //读取actor的方法
        console.log("initActor identity:");
        console.log(identity);
        console.log(this.principal);
        var agent=null;
        if (env === 'local') {
          agent = new HttpAgent({
            host: "http://localhost:8000",
            // identity
          }); // identity是经过II认证的identity，如果为null，则默认为匿名identity。
          // 主网不能使用rootKey
          await agent.fetchRootKey();
        } else if (env === 'ic') {
          agent = new HttpAgent({identity});
        }
        const actor = Actor.createActor(dapp_idl, {
          // agent:
          agent,
          //   new HttpAgent({
          //   identity,
          // }),
          canisterId:dapp_id,
        });
        const log_actor = Actor.createActor(log_idl, {
          // agent:
          agent,
          //   new HttpAgent({
          //   identity,
          // }),
          canisterId:log_id,
        });
        // const email_actor = Actor.createActor(email_idl, {
        //   agent,
        //   canisterId:email_id,
        // });
        this.$store.commit("SET_DAPP",actor);
        this.$store.commit("SET_LOG",log_actor);
        this.actor=this.$store.state.dapp;
        // this.$store.commit("SET_EMAIL",email_actor);
        //测试actor的方法
        // console.log("method:");
        // console.log(method);
        // const res =await eval("actor."+method);
        // console.log("res:");
        // console.log(res);
      },
      async login(){
        this.loginLoading=true;
        let identityProvider = null;
        if(ii_id!=null){
          identityProvider = 'http://'+ii_id+'.localhost:8000';
        }
        let identity;
        try {
          const authClient = await AuthClient.create();
          if (await authClient.isAuthenticated()) {
            identity = authClient.getIdentity();
            this.principal=String(identity.getPrincipal());
          } else {
            identity = await new Promise((resolve, reject) => {
              let timer = setTimeout(() => {
                timer = null;
                reject('do II auth timeout!');
                this.$message({
                  message: "II"+this.$t('message.error.authTimeOut'),
                  type: 'error'
                });
                this.loginLoading=false;
              }, 30 * 1000 * 3);
              authClient.login({
                identityProvider,
                maxTimeToLive: BigInt(60_000_000_000_000),
                onSuccess: () =>{
                  if (timer != null) {
                    clearTimeout(timer);
                    timer = null;
                    resolve(authClient.getIdentity());
                  }
                },
                onError: (err) => {
                  if (timer != null) {
                    clearTimeout(timer);
                    timer = null;
                    reject(err);
                  }
                  this.loginLoading=false;
                },
              });
            });
            this.principal=String(identity.getPrincipal());
          }
        } catch (e) {
          console.log(e);
        }
        if(identity!=null && identity !==''){
          this.identity=identity;
          this.$store.commit("SET_IDE",identity);
          // console.log("identity.getPrincipal:");
          // console.log(identity.getPrincipal);
          await this.initActor(identity);
          this.getSelf();
          //登录完成时，显示内容
          this.emitToOK();
        }
        this.loginLoading=false;
      },
      onwindowScroll() {
        window.onscroll = function () {
          if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
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
      getMenuItem() {
        const links = document.getElementsByClassName('side-nav-link-ref')
        let matchingMenuItem = null;
        for (let i = 0; i < links.length; i++) {
          if (window.location.pathname === links[i].pathname) {
            matchingMenuItem = links[i];
            break;
          }
        }

        if (matchingMenuItem) {
          matchingMenuItem.classList.add('active');
          const parent = matchingMenuItem.parentElement;

          /**
           * TODO: This is hard coded way of expading/activating parent menu dropdown and working till level 3.
           * We should come up with non hard coded approach
           */
          if (parent) {
            parent.classList.add('active')
            const parent2 = parent.parentElement
            if (parent2) {
              parent2.classList.add('active')
              const parent3 = parent2.parentElement
              if (parent3) {
                parent3.classList.add('active')
                const parent4 = parent3.parentElement
                if (parent4) {
                  const parent5 = parent4.parentElement
                  parent5.classList.add('active')
                }
              }
            }
          }
        }
      },
      toggleMenu() {
        this.isCondensed = !this.isCondensed
        if (this.isCondensed) {
          document.getElementById('navigation').style.display = 'block'
        } else document.getElementById('navigation').style.display = 'none'
      },
      handleSetLang(lang) {
          this.$i18n.locale = lang;
          localStorage.setItem("lang",lang);
          this.addLang();
      },
      getLang(){
        let savelang=localStorage.getItem("lang");
        if(savelang==null||savelang===''){
          return 0;
        }else {
          this.$i18n.locale=savelang;
        }
        this.addLang();
      },
      addLang(){
        let lang=this.$i18n.locale;
        if(lang==='zh-CN'){
          this.language='English'
        }else {
          this.language='中文'
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  #topnav .navigation-menu > li > a {
    font-size: 16px;
  }
  #topnav{
    position: static!important;
  }
 .user-text {
    font-size: 16px;
    font-family:"Microsoft YaHei";
    font-weight: normal;
    color: #3c4858;
  }
  .user-black {
    font-size: 16px;
    font-family:"Microsoft YaHei";
    font-weight: normal;
    color: #FFFFFF;
  }

</style>
