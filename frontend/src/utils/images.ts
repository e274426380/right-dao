const photoServiceCanisterId = process.env['PHOTO_SERVICE_CANISTER_ID'] ?? '';

//通过http请求的方式获取图片，只需要返回网址赋予给图片标签的src即可显示图片
export function getUrlByPhotoServiceId(id: number | bigint) {
    id = Number(id);
    if (process.env['configMode'] === 'development') {
        //本地调试用本地图片
        return getLocalHttpPicSrc(id);
    }
    return photoServiceCanisterId
        ? `https://${photoServiceCanisterId}.raw.ic0.app/?picId=${id}`
        : '';
}

export function getLocalHttpPicSrc(picId: number): string {
    const base_url = 'http://localhost:8000';
    return photoServiceCanisterId
        ? `${base_url}?canisterId=${photoServiceCanisterId}&picId=${picId}`
        : '';
}
