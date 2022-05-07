import { getCache, TTL } from '@/common/cache';
import {getBackend} from "@/api/canister_pool";
import {ApiPost, ApiResult} from "@/api/types";

// 更新用户自己的信息
export async function submitPost(post: any | ApiPost): Promise<ApiResult<boolean>> {
    return getBackend().create_post({
        title: "123",
        participants: ["1", "2"],
        content: {
            content: "123",
            format: "html"
        },
        end_time: [1000],
        category: { Law: null },
        photos: [1, 2]
    });
}
