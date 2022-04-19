import axios from 'axios';

const blogProxyHost = process.env['blog_proxy_host'] ?? 'https://blog.icpl.app';

export function getBlogProxyHost() {
    return blogProxyHost;
}

export async function getUserIp(): Promise<string> {
    const url = 'https://cip.icpl.app/';
    const res = await axios.get(url);
    if (res.status === 200) {
        // console.log('ip', res.data);
        return res.data;
    }
    return '';
}
