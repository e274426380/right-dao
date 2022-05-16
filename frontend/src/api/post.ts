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

// 增加贴子的时间线
export async function addPostTimeline(timeline: { post_id: number, event_time: number, description: string }): Promise<ApiResult<boolean>> {
    return getBackend().add_post_event(timeline);
}

// 修改贴子状态，后台会顺便更新时间线
export async function changePostStatus(timeline: { id: number, status: string, description: string }): Promise<ApiResult<boolean>> {
    return getBackend().change_post_status(timeline);
}


// 增加贴子的回贴
export async function addPostReply(id:number,content:string): Promise<ApiResult<boolean>> {
    return getBackend().add_post_comment({
        post_id:id,
        content:{
            content:content,
            format:"html"
        }
    });
}
