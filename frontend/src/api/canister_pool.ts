import { Identity } from '@dfinity/agent';
import { Actor, HttpAgent } from '@dfinity/agent';
import {
    platform as anonymousActorPlatform,
    idlFactory as idlFactoryPlatform,
    canisterId as canisterIdPlatform,
} from 'canisters/platform';
import {
    photo_service as anonymousActorPhotoService,
    idlFactory as idlFactoryPhotoService,
    canisterId as canisterIdPhotoService,
} from 'canisters/photo_service';
import {
    community as anonymousActorCommunity,
    idlFactory as idlFactoryCommunity,
    canisterId as canisterIdCommunity,
} from 'canisters/community';
const createActor = (canisterId: string, idlFactory: any, options: any) => {
    const agent = new HttpAgent({ ...options?.agentOptions });

    // Fetch root key for certificate validation during development
    if (process.env.NODE_ENV !== 'production') {
        agent.fetchRootKey().catch((err) => {
            console.warn(
                'Unable to fetch root key. Check to ensure that your local replica is running',
            );
            console.error(err);
        });
    }

    // Creates an actor with using the candid interface and the HttpAgent
    return Actor.createActor(idlFactory, {
        agent,
        canisterId,
        ...options?.actorOptions,
    });
};

// console.error('init canister pool');

// 当前登录信息
let currentPrincipal = '';

// 缓存的 actor
const ACTOR_CACHE = {};

// 未登录的情况下也要初始化个匿名的
ACTOR_CACHE[''] = {
    platform: anonymousActorPlatform,
    photoService: anonymousActorPhotoService,
    community: anonymousActorCommunity,
};

// 4. 暴露设置方法
export function setCurrentIdentity(identity: Identity, principal: string) {
    currentPrincipal = principal;
    // console.log('set current identity', identity);
    // console.log('set current principal', principal);

    if (ACTOR_CACHE[currentPrincipal]) return; // 已经有了

    // 如果是本地调试，用 https://identity.ic0.app 进行身份认证是无法通过签名的，所以本地调试统一用匿名账户吧
    if (process.env.network != 'ic') {
        console.log('development mode use anonymous actor');
        ACTOR_CACHE[currentPrincipal] = ACTOR_CACHE[''];
        return;
    }

    // 把所有用到的 actor 初始化
    ACTOR_CACHE[currentPrincipal] = {
        platform: createActor(canisterIdPlatform as string, idlFactoryPlatform, {
            agentOptions: { identity },
        }),
        photoService: createActor(canisterIdPhotoService as string, idlFactoryPhotoService, {
            agentOptions: { identity },
        }),
        community: createActor(canisterIdCommunity as string, idlFactoryCommunity, {
            agentOptions: { identity },
        }),
    };
    // console.log('set current ACTOR_CACHE', ACTOR_CACHE);
}

export function getCurrentPrincipal(): string {
    return currentPrincipal;
}

// 提供取消登录方法
export function clearCurrentIdentity() {
    currentPrincipal = '';
    // console.log('set current principal', '');
}

/**
 * A ready-to-use agent for the platform canister
 * @type {import("@dfinity/agent").ActorSubclass<import("./../../../services/.dfx/local/canisters/platform/platform.did.js")._SERVICE>}
 */
export const getPlatform = (principal?: string) => {
    // console.error('current principal', principal ?? currentPrincipal);
    return ACTOR_CACHE[principal ?? currentPrincipal].platform;
};

/**
 * A ready-to-use agent for the platform canister
 * @type {import("@dfinity/agent").ActorSubclass<import("./../../../services/.dfx/local/canisters/photo_service/photo_service.did.js")._SERVICE>}
 */
export const getPhotoService = (principal?: string) => {
    return ACTOR_CACHE[principal ?? currentPrincipal].photoService;
};

/**
 * A ready-to-use agent for the community canister
 * @type {import("@dfinity/agent").ActorSubclass<import("./../../../services/.dfx/local/canisters/community/community.did.js")._SERVICE>}
 */
export const getCommunity = (principal?: string) => {
    return ACTOR_CACHE[principal ?? currentPrincipal].community;
};
