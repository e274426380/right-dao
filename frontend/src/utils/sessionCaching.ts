import { deleteSessionCaching, getSessionCaching, setSessionCaching } from './storage';

type Item = {
    key: string;
    value: any;
    ttl: number;
};

export const setSessionCache = (key: string, value: any, ttl?: number) => {
    key = 'SESSION_' + key;
    ttl = ttl ?? -1;
    const item: Item = {
        key,
        value,
        ttl: ttl < 0 ? -1 : new Date().getTime() + ttl * 1000,
    };
    setSessionCaching(key, item);
    // console.error('session cache', key, value, item, getSessionCache(key.substring(8)));
};

export const getSessionCache = (key: string) => {
    key = 'SESSION_' + key;
    const item = getSessionCaching(key);
    // console.error('get session cache', key, item);
    if (!item) return null;
    const ttl = item.ttl;
    if (0 < ttl && ttl < new Date().getTime()) {
        deleteSessionCaching(key);
        return null;
    }
    return item.value;
};

export const clearSessionCache = (key: string) => deleteSessionCaching('SESSION_' + key);
