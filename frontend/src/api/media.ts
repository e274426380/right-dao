import { getCache, TTL } from '@/utils/cache';
import { getCommunity } from './canister_pool';
import { ApiBlogProfile, ApiResult, ApiResultByPage } from './types';

// 查询博客列表，有分页，长时间缓存意思是，尽量直接读取到数据
export async function getBlogByPageWithCachingPriority(
    pageSize: number,
    pageNum: number,
    tags: string[],
    category: string,
    updatedCallback?: (_data: ApiResultByPage<ApiBlogProfile>) => void,
): Promise<ApiResultByPage<ApiBlogProfile>> {
    const key = 'BLOG_PAGE_' + pageSize + '_' + pageNum + '_' + tags.join(',') + '_' + category;
    console.error('pageBlogByTagFromCache', key);
    const execute = () =>
        getCommunity().pageBlogByTagFromCache({
            pageSize: pageSize,
            pageNum: pageNum,
            tags: tags,
            category: category,
        });
    return getCache<ApiResultByPage<ApiBlogProfile>>({
        key,
        execute,
        ttl: TTL.minute(30), // 每次从缓存中读取，则可以时间长一点
        isLocal: true,
        update: true, // 需要异步更新
        updatedCallback,
    });
}

// 根据titleKey查询博客详情
export async function getBlogDetailByTitleKey(
    titleKey: string,
    updatedCallback?: (_data: ApiResult<ApiBlogProfile[]>) => void,
): Promise<ApiResult<ApiBlogProfile[]>> {
    console.error('get blog detail by title key', titleKey);
    const d = await getCache({
        key: 'BLOG_DETAIL_' + titleKey,
        execute: () =>
            getCommunity().getBlogByTitleKey({
                titleKey: titleKey,
            }),
        ttl: TTL.minute(30), // 每次从缓存中读取，则可以时间长一点
        isLocal: true,
        update: true, // 需要异步更新
        updatedCallback,
    });
    console.error('get blog detail', d);
    return d;
}

export async function getBlogDetailById(
    id: number,
    updatedCallback?: (_data: ApiResult<ApiBlogProfile[]>) => void,
): Promise<ApiResult<ApiBlogProfile[]>> {
    console.error('get blog detail by id', id);
    return getCache({
        key: 'BLOG_DETAIL_ID_' + id,
        execute: () =>
            getCommunity().getBlog({
                id: id,
            }),
        ttl: TTL.minute(30), // 每次从缓存中读取，则可以时间长一点
        isLocal: true,
        update: true, // 需要异步更新
        updatedCallback,
    });
}

// 根据id给对应博客展示次数+1
export async function incrementBlogShowTimes(id: number): Promise<ApiResult<boolean>> {
    return await getCommunity().incrementBlogDisplay({
        id: id,
    });
}

// 根据id给对应博客阅读次数+1
export async function incrementBlogReadingTimes(id: number): Promise<ApiResult<boolean>> {
    return await getCommunity().incrementBlogReading({
        id: id,
    });
}
