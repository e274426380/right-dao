import { getCache, TTL } from '@/common/cache';
import {getBackend} from "@/api/canister_pool";
import {ApiPost, ApiResult} from "@/api/types";

// 更新用户自己的信息
export async function submitPost(post: any | ApiPost): Promise<ApiResult<boolean>> {
    return getBackend().create_post(post);
}

// 获取贴子详情
export async function getPost(id: number): Promise<ApiResult<ApiPost>> {
    return getBackend().get_post({id: id});
}
