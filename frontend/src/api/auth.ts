import { Identity } from '@dfinity/agent';
import { AuthClient } from '@dfinity/auth-client';

export class AuthInfo {
    client: AuthClient;
    info?: {
        identity: Identity;
        principal: string;
    };
    constructor(
        client: AuthClient,
        info?: {
            identity: Identity;
            principal: string;
        },
    ) {
        this.client = client;
        this.info = info;
    }
}

export class IdentityInfo {
    identity: Identity;
    principal: string;
    constructor(identity: Identity, principal: string) {
        this.identity = identity;
        this.principal = principal;
    }
}

// 初始化环境
// 提供后续链接的 client 对象 得到客户端对象表明已经准备好链接了
// 通过客户端对象判断是否已经登录，如果登录记录登录信息
export async function initAuth(): Promise<AuthInfo> {
    const client = await AuthClient.create(); // 创建链接对象
    // 链接对象已经准备好
    // 取得当前登录信息
    const isAuthenticated = await client.isAuthenticated();

    if (isAuthenticated) {
        // 如果已经登录，取得信息
        const identity = client.getIdentity();
        const principal = identity.getPrincipal().toString();

        // console.log('got identity by init auth', identity);
        // console.log('got principal by init auth', principal);

        //调用更新登录时间方法，更新用户登录时间
        // setTimeout(() => updateUserLoginTime(), 8333); // 延时调用

        return new AuthInfo(client, {
            identity: identity,
            principal: principal,
        });
    }

    return new AuthInfo(client);
}

// 登录动作
export async function signIn(client: AuthClient): Promise<IdentityInfo> {
    const days = BigInt(1);
    const hours = BigInt(24);
    const nanoseconds = BigInt(3600000000000);
    const result: IdentityInfo = await new Promise((resolve, reject) => {
        // 进行登录
        client.login({
            identityProvider: 'https://identity.ic0.app', // 用线上的 II 认证，本地没法搭建II认证
            onSuccess: () => {
                // 登录成功后取出用户信息
                const identity = client.getIdentity();
                const principal = identity.getPrincipal().toString();
                resolve(new IdentityInfo(identity, principal));
                // console.error('signIn', identity, principal);
            },
            onError: reject,
            // Maximum authorization expiration is 8 days
            maxTimeToLive: days * hours * nanoseconds,
        });
    });
    // console.log('got identity by sign in', result.identity);
    console.log('got principal by sign in', result.principal);
    return result;
}

// 登出动作
export async function signOut(client: AuthClient): Promise<void> {
    if (client) await client.logout();
}
