import { clearCacheData, getCache, TTL } from '@/common/cache';
import { getCurrentPrincipal, getBackend } from './canister_pool';
import {ApiResult, ApiUserInfo} from "@/api/types";

// 注册用户接口，将当前登录用户 id 登记在后端 应当有缓存 不需要返回值
export async function registerUser(principalId: string): Promise<ApiResult<string>> {
    // return getBackend().registerUser(getSourceChannel());
    return await getCache({
        key: 'REGISTER_USER_' + principalId.toUpperCase(),
        execute: async () => {
            //注册一个空的用户，等之后用户自己处理
            const r = await getBackend().register_user({
                email:"",
                name:"",
                memo:""
            });
            if (r.err && r.err.userAlreadyExists != undefined) {
                // 拦截已经注册的情况 就当请求成功了
                return { ok: r };
            }
            return r;
        },
        ttl: TTL.day7, // 每一个 id 请求一次就够了，缓存 7 天没毛病
        // ttl: 60 * 10, // 目前开发阶段先设置短的时间
        isLocal: true, // 需要本地存储
    });
}

// 获取当前登录用户信息 导航条使用
export async function getUserInfo(): Promise<ApiResult<ApiUserInfo>> {
    return await getCache({
        key: 'USER_INFO_' + getCurrentPrincipal().toUpperCase(),
        execute: () => getBackend().get_self(),
        ttl: TTL.minute10,
        // ttl: 60 * 60, // 目前开发阶段先设置短的时间
        isLocal: true, // 需要本地存储
    });
}
