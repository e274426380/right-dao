import {clearCacheData, getCache, TTL} from '@/common/cache';
import {getCurrentPrincipal, getBackend} from './canister_pool';
import {ApiProfilePost, ApiResult, ApiResultByPage, ApiUserInfo} from "@/api/types";
import {Principal} from "@dfinity/principal/lib/cjs";

// 注册用户接口，将当前登录用户 id 登记在后端 应当有缓存 不需要返回值
export async function registerUser(principalId: string): Promise<ApiResult<string>> {
    // return getBackend().registerUser(getSourceChannel());
    return await getCache({
        key: 'REGISTER_USER_' + principalId.toUpperCase(),
        execute: async () => {
            //注册一个空的用户，等之后用户自己处理
            const r = await getBackend().register_user({
                email: "",
                name: "",
                memo: ""
            });
            if (r.err && r.err.userAlreadyExists != undefined) {
                // 拦截已经注册的情况 就当请求成功了
                return {ok: r};
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

// 获取目标用户信息
export async function getTargetUser(principal: string): Promise<ApiResult<any | ApiUserInfo>> {
    return await getCache({
        key: 'USER_INFO_' + getCurrentPrincipal().toUpperCase(),
        //TODO 记得改成方法参数
        // execute: () => getBackend().get_user(Principal.fromText(principal)),
        execute: () => getBackend().get_user(Principal.fromText("2vxsx-fae")),
        ttl: TTL.minute10,
        isLocal: true, // 需要本地存储
    });
}

// 获取目标用户发贴记录
export async function getTargetUserPost(pageNum: number, pageSize: number, query: string, principal: string): Promise<ApiResultByPage<ApiProfilePost>> {
    return getBackend().other_posts({
        page_num: pageNum,
        page_size: pageSize,
        querystring: query,
        other: principal
    })
}

// 获取目标用户回答记录
export async function getTargetUserPostComments(pageNum: number, pageSize: number, query: string, principal: string): Promise<ApiResultByPage<ApiProfilePost>> {
    return getBackend().other_post_comments({
        page_num: pageNum,
        page_size: pageSize,
        querystring: query,
        other: principal
    })
}

// 获取目标用户评论记录
export async function getTargetUserComments(pageNum: number, pageSize: number, query: string, principal: string): Promise<ApiResultByPage<ApiProfilePost>> {
    return getBackend().other_comments({
        page_num: pageNum,
        page_size: pageSize,
        querystring: query,
        other: principal
    })
}

// 更新用户自己的信息
export async function editUserSelf(user: any | ApiUserInfo): Promise<ApiResult<boolean>> {
    return getBackend().edit_user(user);
}
