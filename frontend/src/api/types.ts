// 后端的错误
export type ApiError = {
    userAlreadyExists: string; // 在用户已经注册的情况下，返回的用户名
    unauthorized: null; // 未注册情况下，调用接口
    emailAddressAlreadyExists: null; // 邮箱已经注册
    emailAddressNotValid: null; // 邮箱格式不正确
    votingAmountTooLarge: null; // 投票数量过大
    votingAmountTooFew: null; // 投票数量过小
    alreadyExisted: null; // 项目 id 已经参与活动
};

// 后端的返回结果
export type ApiResult<T> = {
    ok?: T;
    err?: ApiError;
};
// 后端的返回结果 分页
export type ApiResultByPage<T> = {
    ok?: {
        data: T[];
        pageNum: bigint; // 当前页码
        pageSize: bigint; // 页面大小
        totalCount: bigint; // 总数
    };
    err?: ApiError;
};

export type ApiStatus = 'enable' | 'disable' | 'pending' | 'deleted';

export type RichText = {
    content: string; // 实际内容
    format: 'text' | 'markdown' | 'html'; // 标记内容类型 有 3 种: text | html | markdown
};

export type ApiBlogTag = {
    id: bigint;
    tag: string; // 标签名
    tagCn: string;
    tagEn: string;
};

export type ApiBlogProfile = {
    id: bigint;
    authorAvatarUri: string;
    authorName: string;
    contentCn: {
        title: string;
        readingTime: bigint;
        content: RichText;
        description: string;
        bannerUri: string;
    };
    contentEn: {
        title: string;
        readingTime: bigint;
        content: RichText;
        description: string;
        bannerUri: string;
    };
    createdAt: bigint;
    createdBy: string;
    publishTime: bigint;
    status: {
        draft?: null;
        toPublish?: null;
        published?: null;
    };
    tags: ApiBlogTag[];
    titleKey: string;
    updatedAt: bigint;
    updatedBy: string;
    displaySum: bigint;
    readingSum: bigint;
};
