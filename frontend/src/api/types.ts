import {Principal} from "@dfinity/principal/lib/cjs";

// 后端的错误
export type ApiError = {
    userAlreadyExists: string; // 在用户已经注册的情况下，返回的用户名
    unauthorized: null; // 未注册情况下，调用接口
    emailAddressAlreadyExists: null; // 邮箱已经注册
    emailAddressNotValid: null; // 邮箱格式不正确
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

export type RichText = {
    content: string; // 实际内容
    format: 'text' | 'markdown' | 'html'; // 标记内容类型 有 3 种: text | html | markdown
};

export type ApiUserInfo = {
    id: bigint; //id
    owner: Principal | string; // 用户principal，唯一。从后端接受时是principal格式，再通过toString显示成字符串格式。
    email: string;
    name: string;
    memo: string;
    status: string;
    createdAt: bigint;
    avatarUri: string; //头像网址，暂时没用
    avatarId: bigint; //头像id，暂时没用
    biography: string; //类似于个人签名
    interests:string[]; //兴趣，类似于标签
};
