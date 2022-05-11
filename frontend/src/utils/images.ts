import {ElMessage} from 'element-plus/es';
import {PictureInfo} from "@/types/picture";
const photoServiceCanisterId = process.env['PHOTO_SERVICE_CANISTER_ID'] ?? '';

//通过http请求的方式获取图片，只需要返回网址赋予给图片标签的src即可显示图片
export function getUrlByPhotoServiceId(id: number | bigint) {
    id = Number(id);
    if (process.env['configMode'] === 'development') {
        //本地调试用本地图片
        const base_url = 'http://localhost:8000';
        return photoServiceCanisterId
            ? `${base_url}?canisterId=${photoServiceCanisterId}&picId=${id}`
            : '';
    }
    return photoServiceCanisterId
        ? `https://${photoServiceCanisterId}.raw.ic0.app/?picId=${id}`
        : '';
}

//计算富文本编辑器中的字数长度
export function calculatedICPIdLength(html): number {
    if (html) {
        //匹配编辑器中的img标签
        const imgReg = /<img.*?(?:>|\/>)/gi;
        //匹配img标签中src含有http的外链
        const httpReg = /src="http[\'\"]?([^\'\"]*)[\'\"]?/i;
        const arr = html.match(imgReg); //筛选出所有的img
        let length = 0;//计算此html字符串实际传到后端的长度
        let lengthHtml = html.toString();//用来计算html长度的备份html
        if (arr && arr.length) {
            for (let i = 0; i < arr.length; i++) {
                //筛选从其他网站直接复制过来的，src是外链的图片标签
                const http = arr[i].match(httpReg);
                //计算长度的lengthHtml把对应上传的图片标签置空，方便计算长度
                lengthHtml = lengthHtml.replace(arr[i], "");
                //存在外链图片，将此外链图片标签跳过上传到IC的步骤。
                if (http) {
                    //增加此标签的长度，保证返回的长度正常
                    length = length + arr[i].length;
                } else {
                    //不存在外链图片，说明是上传的图片，给length直接加长度
                    //例如<icpl.imgId.10028/>的长度
                    length = length + 19;
                }
            }
        }
        length = length + lengthHtml.length;
        return length;
    } else {
        return 0;
    }
}


type htmlItem = {
    overLimitLength?: boolean; // 此html字符串实际传到后端的长度是否超过限制长度
    haveImg: boolean;// 是否不存在图片
    html?: string; //html元素
};
//将传入的html元素中的图片上传，并替换成ICPID标签，例如：<icpl.imgId.10028/>
//limitSize:以m为图片体积大小单位，输入1，限制为1m，1兆以内的图片
//limitLength:以字数为单位，限制此html字符串实际传到后端的长度
export async function filterImgToICPId(html, limitSize: number, limitLength: number): Promise<htmlItem> {
    //匹配编辑器中的img标签
    const imgReg = /<img.*?(?:>|\/>)/gi;
    // 匹配图片中的src
    const srcReg = /src=[\'\"]?([^\'\"]*)[\'\"]?/i;
    //匹配img标签中src含有http的外链
    const httpReg = /src="http[\'\"]?([^\'\"]*)[\'\"]?/i;
    const arr = html.match(imgReg); //筛选出所有的img
    let length = 0;//计算此html字符串实际传到后端的长度
    let lengthHtml = html.toString();//用来计算html长度的备份html
    if (arr === null || arr === '') {
        return {haveImg: false};
    }
    // 存放所有图片的src
    const promiseArr: Promise<any>[] = [];
    for (let i = 0; i < arr.length; i++) {
        //筛选从其他网站直接复制过来的，src是外链的图片标签
        const http = arr[i].match(httpReg);
        //计算长度的lengthHtml把对应上传的图片标签置空，方便计算长度
        lengthHtml = lengthHtml.replace(arr[i], "");
        //存在外链图片，将此外链图片标签跳过上传到IC的步骤。
        if (http) {
            //增加此标签的长度，保证返回的长度正常
            length = length + arr[i].length;
            //不做任何处理，返回这个标签本身
            promiseArr.push(
                new Promise((resolve, reject) => {
                    resolve({
                        http: arr[i]
                    });
                }),
            );
            continue;
        } else {
            //不存在外链图片，说明是上传的图片，给length直接加长度
            //例如<icpl.imgId.10028/>的长度
            length = length + 19;
        }
        //使用promise保证执行顺序
        promiseArr.push(
            new Promise((resolve, reject) => {
                const src = arr[i].match(srcReg);
                // 获取图片地址
                const file = base64toFile(src[1], '');
                readPhotoUpload(file, (buffer, src) => {
                    //限制图片格式
                    const isImage =
                        file.type === 'image/jpg' ||
                        file.type === 'image/png' ||
                        file.type === 'image/jpeg';
                    //图片大小
                    const isLt1M = file.size / 1024 / 1024 <= limitSize;
                    if (!isImage) {
                        ElMessage({
                            showClose: true,
                            center: true,
                            message:
                                i18n.global.t('message.upload.image.error.format') +
                                '：JPG,PNG,JPEG',
                            type: 'error',
                        });
                        reject();
                        return;
                    }
                    if (!isLt1M) {
                        console.log("lt1m index", i)
                        console.log("lt1m isLt1M", isLt1M)
                        ElMessage({
                            showClose: true,
                            center: true,
                            dangerouslyUseHTMLString: true,
                            message:
                                i18n.global.t('message.upload.image.error.size') + '：< ' + limitSize + 'M'
                                + '<br/>' +
                                i18n.global.t('message.upload.image.error.place', {index: i + 1}),
                            type: 'error',
                        });
                        reject();
                        return;
                    }
                    const pic: PictureInfo = {
                        content: buffer,
                        fileType: file.type,
                    };
                    uploadImage(pic, 'project edit', '', '').then((res) => {
                        if (res.ok) {
                            resolve(res.ok);
                        } else {
                            //返回第几张图片上传错误和错误提示
                            // 使用此方法时，使用try catch捕获此返回值
                            // ElMessage({
                            //     showClose: true,
                            //     center: true,
                            //     dangerouslyUseHTMLString: true,
                            //     message:
                            //         'error:' +
                            //         res.err +
                            //         '<br/>' +
                            //         i18n.global.t('message.upload.image.error.place', {index: i + 1}),
                            //     type: 'error',
                            // });
                            reject();
                            return;
                        }
                    });
                });
            }),
        );
    }
    length = length + lengthHtml.length;
    console.log("overLimitLength", length)
    //如果长度过长，直接返回lengthHtml，交给调用方法的地方处理长度过长事件
    if (length > limitLength) {
        return {overLimitLength: true, haveImg: true};
    }
    const res = await Promise.all(promiseArr);
    for (let i = 0; i < arr.length; i++) {
        //如果不存在http外链img标签，就说明是上传到IC的图片，替换图片标签为我们特有的图片标签
        if (!res[i].http) {
            html = html.replace(arr[i], '<icpl.imgId.' + res[i] + '/>');
        }
    }
    console.log('html', html);
    return {html: html, haveImg: true};
}

export function base64toFile(dataurl, filename) {
    //将base64转换为文件
    let arr = dataurl.split(','),
        mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]),
        n = bstr.length,
        u8arr = new Uint8Array(n);
    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, {type: mime});
}

//图片上传前，执行上传方法，将图片转化为二进制存储在数据中
export function readPhotoUpload(file: any, resolve: (buffer: number[], src: string) => void): void {
    const reader = new FileReader();
    reader.readAsArrayBuffer(file);
    reader.onload = (e) => {
        if (e.target) {
            const buffer = Array.from(
                //可能会有隐患，比如result是string类型
                new Uint8Array(e.target.result as ArrayBuffer),
            );
            const src = transformArrayBufferToBase64({
                content: buffer,
                fileType: file.type,
            });
            resolve(buffer, src);
        }
    };
}

// 将图片信息转换为能被 html 显示的编码
export function transformArrayBufferToBase64(buffer: PictureInfo): string {
    let binary = '';
    const bytes = new Uint8Array(buffer.content);
    for (let len = bytes.byteLength, i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
    }
    return `data:${buffer.fileType};base64,` + window.btoa(binary);
}
