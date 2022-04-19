import {getMode} from '../env'
import {AuthClient} from "@dfinity/auth-client";
import {Actor, HttpAgent} from "@dfinity/agent";
import {idlFactory as dapp_idl} from "dfx-generated/dapp";
import {idlFactory as photo_service_idl} from "dfx-generated/photo_service";

import Bus from "@/common/bus.js";

let canisterIds =  getMode() === 'production' ? require("root@/canister_ids.json") : require("root@/.dfx/local/canister_ids.json");
// console.log('canisterIds', canisterIds)

// 这是后端的 id
const dapp_id =
    new URLSearchParams(window.location.search).get("dappId") ||
    canisterIds.dapp.local ||
    canisterIds.dapp.ic;
const photo_service_id =
    new URLSearchParams(window.location.search).get("photo_service") ||
    canisterIds.photo_service.local ||
    canisterIds.photo_service.ic;

function getIcpIdentity() {
    return canisterIds['dapp_assets'].ic || canisterIds['dapp_assets'].local;
}
export function getIdentityProvider () {
    switch (getMode()) {
        case 'production': return null;
        // default: return 'http://' + require("root@/.dfx/local/wallets.json").identities['default'].local + '.localhost:8000';
        default: return null;
    }
}
export async function  getAuthClient() {
    switch (getMode()) {
        default: return await AuthClient.create()
    }
}
export async function initActor(identity, setPhotoService, setActor) {
    // let x_identity=this.$store.state.identity;
    // if((identity==null||identity==="")&&(x_identity!=null||x_identity!=="")){
    //   //初始化匿名容器时，检查用户是否登录，如果已经登录，则不创建匿名容器
    //   identity=x_identity;
    // }
    //读取actor的方法
    // console.log("initActor identity:");
    // console.log(identity);
    // console.log(this.principal);
    let agent = null;
    switch (getMode()) {
        case "production": agent = new HttpAgent({identity}); break;
        default:
            agent = new HttpAgent({
                host: "http://localhost:8000"
                // identity
            }); // identity是经过II认证的identity，如果为null，则默认为匿名identity。
            // 主网不能使用rootKey
            await agent.fetchRootKey();
    }
    const actor = Actor.createActor(dapp_idl, {
        // agent:
        agent,
        //   new HttpAgent({
        //   identity,
        // }),
        canisterId: dapp_id
    });
    // 新建 photo_service Actor
    const photo_service_actor = Actor.createActor(photo_service_idl, {
        agent,
        canisterId: photo_service_id
    });
    // const email_actor = Actor.createActor(email_idl, {
    //   agent,
    //   canisterId:email_id,
    // });

    setPhotoService(photo_service_actor)
    setActor(actor)
    Bus.$emit("actorCreated");
    // this.$store.commit("SET_EMAIL",email_actor);
    //测试actor的方法
    // console.log("method:");
    // console.log(method);
    // const res =await eval("actor."+method);
    // console.log("res:");
    // console.log(res);
}
// //环境变量，本地环境=local，主网环境=ic
// const env = "ic";
// let canisterIds = null;
// if (env === "local") {
//     //本地
//     canisterIds = require("root@/.dfx/local/canister_ids.json");
// } else if (env === "ic") {
//     //主网
//     canisterIds = require("root@/canister_ids.json");
// }
//
// //定义actor所需要的内容
// // import { Ed25519KeyIdentity } from "@dfinity/identity";
// // import { idlFactory as dapp_idl } from 'dfx-generated/dapp/dapp.did.js';
// // import { idlFactory as email_idl } from 'dfx-generated/email_subscription';


// const method =
//     new URLSearchParams(window.location.search).get("method") || "healthcheck()";
// //本地II的容器ID
// const ii_id = null;
// // const ii_id="rwlgt-iiaaa-aaaaa-aaaaa-cai";
