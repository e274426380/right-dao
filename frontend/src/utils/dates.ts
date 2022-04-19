import { SupportedLocale } from '@/locale';

// 英文月份
const TOTAL_MONTHS = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
];

// 字符左边补 0
const leftPaddingZero = (value: string, length: number): string => {
    while (value.length < length) {
        value = '0' + value;
    }
    return value;
};

//将纳秒的时间戳转换为毫秒的日期类型，方便前端数据回显
export const parseNs2Date = (time: number): Date => {
    return new Date(time / (1000 * 1000));
};

// 根据语言选择格式化日期，显示顺序是日期 月份 年份
export const formatDateWithTotalMonth = (locale: SupportedLocale, date: Date): string => {
    let year = '';
    let month = '';
    let day = '';
    switch (locale) {
        case SupportedLocale.zhCN:
            // 中文要特别处理一下
            year = date.getFullYear().toString();
            month = (date.getMonth() + 1).toString();
            day = date.getDate().toString();
            return year + '年' + leftPaddingZero(month, 2) + '月' + leftPaddingZero(day, 2) + '日';
        default:
    }
    // 默认英文日期
    return date.getDate() + '  ' + TOTAL_MONTHS[date.getMonth()] + '  ' + date.getFullYear();
};
