import {Principal} from "@dfinity/principal/lib/cjs";

// 后端的错误
export type ApiError = {
    userAlreadyExists: string; // 在用户已经注册的情况下，返回的用户名
    unauthorized: null; // 未注册情况下，调用接口
    emailAddressAlreadyExists: null; // 邮箱已经注册
    emailAddressNotValid: null; // 邮箱格式不正确
    UserNotFound: null; // 找不到目标用户
    UserEmailInvalid: null; // 用户的邮箱格式存在问题
    PostAlreadyCompleted: null; //贴子已经完成
};

// 后端的返回结果
export type ApiResult<T> = {
    Ok?: T;
    Err?: ApiError;
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
export type ApiPostStatus = {
    Enable?: null,
    Completed?: null,
    Closed?: null,
};// 正常 | 完成 | 关闭

export type RichText = {
    content: string; // 实际内容
    format: 'text' | 'markdown' | 'html'; // 标记内容类型 有 3 种: text | html | markdown
};

export type PostCategory = {
    Tech?: null,
    Law?: null
};

export type ApiUserInfo = {
    id: bigint; //id
    owner: Principal | string; // 用户principal，唯一。从后端接受时是principal格式，再通过toString显示成字符串格式。
    email: string;
    name: string;
    memo: string;
    status: string;
    created_at: bigint;
    avatar_uri: string; //头像网址，暂时没用
    avatar_id: bigint; //头像id，暂时没用
    biography: string; //类似于个人签名
    interests: string[]; //兴趣，类似于标签
};

export type ApiPost = {
    id: bigint; //id
    author: Principal | string; // 作者
    title: string;
    comments?: ApiPostComments[];
    content: RichText;
    category: PostCategory;
    photos: number[];
    participants: string[];//期待参与的人
    end_time: [number]; //结束时间  opt格式，类似于[1000]，数组中只有一个数据。
    events?: ApiPostTimeline[];
    likes_count: number;
    ask_for_money: any;
    status: ApiPostStatus;
    created_at: number;
    updated_at: number;
};

export type ApiPostTimeline = {
    author: Principal | string; // 作者
    created_at: number;
    description: string;
    event_time: number;
    type?: string;
    hollow?: boolean;
    time?: string;
}


export type ApiPostComments = {
    author: Principal | string; // 作者principalID
    authorData?: ApiUserInfo; //作者详细资料 通过id获取对应资料
    comment_id: number[];
    comments: [];
    content: RichText;
    created_at: bigint;
    id: bigint;
    post_id: bigint;
}
