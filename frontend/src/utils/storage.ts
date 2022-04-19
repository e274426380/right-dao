// 注册渠道
export const setSourceChannel = (channel: string): void => {
    if (channel) localStorage.setItem('SOURCE_CHANNEL', channel);
};
export const getSourceChannel = (): string => {
    const channel = localStorage.getItem('SOURCE_CHANNEL');
    if (channel) return channel;
    return 'web';
};

// 本地保存语言选择
export const setLocaleStorage = (locale: string): void => {
    localStorage.setItem('LANGUAGE_LOCALE', locale);
};

export const getLocaleStorage = (): string => {
    const locale = localStorage.getItem('LANGUAGE_LOCALE');
    return locale ? locale : 'en';
};

// 保存博客标签
export const setBlogTag = (tag: { tag: string; tagCn: string; tagEn: string }): void => {
    sessionStorage.setItem('TAG_' + tag.tag, JSON.stringify(tag));
};
export const getBlogTag = (tag: string): { tag: string; tagCn: string; tagEn: string } | null => {
    const result = sessionStorage.getItem('TAG_' + tag);
    if (result) {
        return JSON.parse(result);
    }
    return null;
};

// 保存博客详情信息
export const setSessionCaching = (key: string, value: any): void => {
    // console.error('session result 1', key, value);
    sessionStorage.setItem(
        key,
        JSON.stringify(value, (_, v) => (typeof v === 'bigint' ? Number(v) : v)),
    );
    // console.error('session result 2', key, sessionStorage.getItem(key));
};
export const getSessionCaching = (key: string): any | null => {
    const result = sessionStorage.getItem(key);
    // console.error('session result', key, result);
    if (result) {
        return JSON.parse(result);
    }
    return null;
};
export const deleteSessionCaching = (key: string): void => {
    sessionStorage.deleteItem(key);
};
