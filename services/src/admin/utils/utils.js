/**
 * Base64转Blob
 */
export function base64ToBlob(base64) {
  var arr = base64.split(',');
  var mime = arr[0].match(/:(.*?);/)[1] || 'image/png';
  // 去掉url的头，并转化为byte
  var bytes = window.atob(arr[1]);
  // 处理异常,将ascii码小于0的转换为大于0
  var ab = new ArrayBuffer(bytes.length);
  // 生成视图（直接针对内存）：8位无符号整数，长度1个字节
  var ia = new Uint8Array(ab);

  for (var i = 0; i < bytes.length; i++) {
    ia[i] = bytes.charCodeAt(i);
  }

  return new Blob([ab], {
    type: mime
  });
}
/**
 * 二进制转base64
 */
export function blobToDataURL(blob, callback) {
  var a = new FileReader();
  a.onload = function (e) {
    callback(e.target.result);
  }
  a.readAsDataURL(blob);
  return a;
}
/**
 * base64转换成正常数据
 * **/
export function base64toData(data){
  if(data!=null||data!==''){
    return atob(data);
  }
}
/**
 * bigint的纳秒级别时间戳转换为YYYY-MM-DD hh:mm:ss
 * **/
export function timestampToDate(data){
  if(data!=null||data!==''){
    //减去纳秒级精度，以便js将时间戳转换为日期
    if(typeof data =="bigint"){
      const time=new Date(Number(data /BigInt(1000_000)));
      return time.toLocaleDateString().replace(/\//g, "-") + " " + time.toTimeString().substr(0, 8);
    }else {
      return data;
    }
  }
}

// base64编码表
const map = { "0": 52, "1": 53, "2": 54, "3": 55, "4": 56, "5": 57, "6": 58, "7": 59, "8": 60, "9": 61, "A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7, "I": 8, "J": 9, "K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15, "Q": 16, "R": 17, "S": 18, "T": 19, "U": 20, "V": 21, "W": 22, "X": 23, "Y": 24, "Z": 25, "a": 26, "b": 27, "c": 28, "d": 29, "e": 30, "f": 31, "g": 32, "h": 33, "i": 34, "j": 35, "k": 36, "l": 37, "m": 38, "n": 39, "o": 40, "p": 41, "q": 42, "r": 43, "s": 44, "t": 45, "u": 46, "v": 47, "w": 48, "x": 49, "y": 50, "z": 51, "+": 62, "/": 63 }

export function base64to2(base64) {
  let len = base64.length * .75 // 转换为int8array所需长度
  base64 = base64.replace(/=*$/, '') // 去掉=号（占位的）

  const int8 = new Int8Array(len) //设置int8array视图
  let arr1, arr2, arr3, arr4, p = 0

  for (let i = 0; i < base64.length; i += 4) {
    arr1 = map[base64[i]] // 每次循环 都将base644个字节转换为3个int8array直接
    arr2 = map[base64[i + 1]]
    arr3 = map[base64[i + 2]]
    arr4 = map[base64[i + 3]]
    // 假设数据arr 数据 00101011 00101111 00110011 00110001
    int8[p++] = arr1 << 2 | arr2 >> 4
    // 上面的操作 arr1向左边移动2位 变为10101100
    // arr2 向右移动4位：00000010
    // | 为'与'操作: 10101110
    int8[p++] = arr2 << 4 | arr3 >> 2
    int8[p++] = arr3 << 6 | arr4

  }
  return int8
}

/**
 * 二进制转base64
 */
function binaryTobase64(code) {
  let base64Code = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  let res = '';
  // 1 bytes = 8bit，6bit 位替换成一个 base64 字符
  // 所以每 3 bytes 的数据，能成功替换成 4 个 base64 字符

  // 对不足 24 bit (也就是 3 bytes) 的情况进行特殊处理
  if (code.length % 24 === 8) {
    code += '0000';
    res += '=='
  }
  if (code.length % 24 === 16) {
    code += '00';
    res += '='
  }

  let encode = '';
  // code 按 6bit 一组，转换为
  for (let i = 0; i < code.length; i += 6) {
    let item = code.slice(i, i + 6);
    encode += base64Code[parseInt(item, 2)];
  }
  return encode + res;
}


export function transformArrayBufferToBase64(buffer) {
  var binary = '';
  var bytes = new Uint8Array(buffer.content);
  for (var len = bytes.byteLength, i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return `data:${buffer.fileType};base64,` + window.btoa(binary);
}

