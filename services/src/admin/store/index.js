import Vue from 'vue'
import Vuex from 'vuex'
// import {base64toData} from "@/utils/utils.js"
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user:JSON.parse(sessionStorage.getItem("user")),
    dapp:"",
    log:"",
    identity:JSON.parse(sessionStorage.getItem("identity")),
  },
  mutations: {
    SET_USER:(state,data)=>{
      //存用户名
      state.user=data;
      //user中含有bigint，需要转换
      sessionStorage.setItem('user',JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_DAPP:(state,data)=>{
      //存dapp actor
      state.dapp=data;
      console.log("SET_DAPP:");
      console.log(state.dapp);
      //user中含有bigint，需要转换
      // sessionStorage.setItem('dapp',JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_LOG:(state,data)=>{
      //存log actor
      state.log=data;
    },
    SET_IDE:(state,data)=>{
      //存identity
      state.identity=data;
      sessionStorage.setItem('identity',JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
  },
  actions: {
  },
  modules: {}
})
