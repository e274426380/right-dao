declare type ApiUserInfo = {
    id: bigint; //id
    owner: string; // 用户principal，唯一
    email: string;
    name: string;
    memo: string[];
    status: string;
    createdAt: bigint;
    avatarUri: string; //头像网址，暂时没用
    avatarId: bigint; //头像id，暂时没用
};

declare type ApiUserPublicInfo = {
    id: bigint;
    avatarUri: string;
    introduction: string;
    owner: string;
    projectUri: string[];
    username: string;
    registerFrom: string; // 注册来源
    ipAddress: string; // 注册ip地址
    lastLoginTime: bigint; // 时间戳格式
    status: string;
    createdBy: string;
    createdAt: bigint;
};
