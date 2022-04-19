import { getUserIp } from '@/utils/hosts';
import { getPlatform } from './canister_pool';
import { ApiResult } from './types';

// 订阅邮箱
export async function subscribeByEmail(email: string): Promise<ApiResult<string>> {
    return await getPlatform().subscribe({
        email: email,
        ipAddress: await getUserIp(),
    });
}
