import Vue from 'vue'
import Vuex from 'vuex'
// import {base64toData} from "@/utils/utils.js"
Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    user: JSON.parse(sessionStorage.getItem("user")),
    dapp: "",
    photo_service: "",
    email: JSON.parse(sessionStorage.getItem("email")),
    identity: JSON.parse(sessionStorage.getItem("identity")),
    wallet: {
      plug: JSON.parse(sessionStorage.getItem("plug")),
    }
  },
  mutations: {
    SET_USER: (state, data) => {
      //存用户名
      state.user = data;
      //user中含有bigint，需要转换
      sessionStorage.setItem('user', JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_DAPP: (state, data) => {
      //存dapp actor
      state.dapp = data;
      console.log("SET_DAPP:");
      console.log(state.dapp);
      //user中含有bigint，需要转换
      // sessionStorage.setItem('dapp',JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_PHOTO_SERVICE: (state, data) => {
      state.photo_service = data;
      console.log('photo_service actor', state.photo_service);

    },
    SET_EMAIL: (state, data) => {
      //存email
      state.email = data;
      //user中含有bigint，需要转换
      // sessionStorage.setItem('email',JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_IDE: (state, data) => {
      //存identity
      state.identity = data;
      sessionStorage.setItem('identity', JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
    },
    SET_PLUG_WALLET: (state, data) => {
      state.wallet.plug = data
      sessionStorage.setItem('plug', JSON.stringify(data, (_, v) => typeof v === 'bigint' ? v.toString() : v));
      console.log('state.wallet.plug', data)
    }
  },
  actions: {
    plugWalletLogin({ commit, state }) {
      // plug钱包登录
      return new Promise(async (resolve, reject) => {
        try {
          let wallet = {}
          const nnsCanisterId = 'qoctq-giaaa-aaaaa-aaaea-cai'

          // Whitelist
          const whitelist = [nnsCanisterId]

          // Host
          const host = 'https://mainnet.dfinity.network'

          // Make the request
          const result = await window.ic.plug.requestConnect({
            whitelist,
            host
          })

          wallet.connectionState = result ? 'allowed' : 'denied'
          // console.log(`The Connection was ${connectionState}!`)
 
          // console.log(`window is ${window.ic}`)
          // Get the user principal id
          wallet.principalId = (await window.ic.plug.agent.getPrincipal()).toText()

          console.info('tag',wallet)
          // console.log(`Plug's user principal Id is ${principalId.toText()}`)

          // wallet.balance = await window.ic.plug.requestBalance()
          commit('SET_PLUG_WALLET', wallet)
          resolve(wallet)
        } catch (error) {
          reject(error)
        }

      })
    },
    plugWalletIsLogin() {
      // plug钱包重连
      return new Promise(async (resolve, reject) => {
        const connected = await window.ic.plug.isConnected()
        if (!connected) await window.ic.plug.requestConnect({ whitelist, host })
        if (connected && !window.ic.plug.agent) {
          await window.ic.plug.createAgent({ whitelist, host })
        }
      })
    }
  },
  modules: {}
})
