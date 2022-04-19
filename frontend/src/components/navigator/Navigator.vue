<template>
    <div class="navigator-container">
        <nav
            class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top background-color-1100"
            :class="{ light: light }"
            v-if="isNavigatorShow"
            ref="navbarRef"
        >
            <div class="container-fluid">
                <!-- collapse -->
                <div
                    class="collapse adaptation-show-1100"
                    :class="{ show: navbarCollapseExpanded }"
                >
                    <div class="menu">
                        <i
                            class="iconfont icon-menu"
                            v-if="!navbarCollapseExpanded"
                            @click="onMenuExpand(true)"
                        ></i>
                        <i class="iconfont icon-menu-close" v-else @click="onMenuExpand(false)"></i>
                    </div>
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 pages" :class="{ light: light }">
                        <!-- tab -->
                        <li v-for="(item, i) in pages" :key="i">
                            <span
                                @click="chooseTab(i, item)"
                                :class="{
                                    'font-weight-bold': i == pageIndex,
                                    current: i == pageIndex,
                                    light: light,
                                }"
                            >
                                {{ t(item.text) }}
                                <div class="underline" v-if="light && i == pageIndex"></div>
                            </span>
                        </li>
                        <li>
                            <span
                                @click="onEnterApp"
                                :class="{
                                    light: light,
                                }"
                            >
                                {{ t('navbar.enterApp') }}
                            </span>
                        </li>
                    </ul>
                </div>
                <!-- logo -->
                <div class="icon">
                    <div>
                        <template v-if="light">
                            <img src="@/assets/images/logo.svg" @click="onHome" />
                        </template>
                        <template v-else>
                            <svg
                                @click="onHome"
                                width="133"
                                height="32"
                                viewBox="0 0 133 32"
                                fill="none"
                                xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                    fill-rule="evenodd"
                                    clip-rule="evenodd"
                                    d="M48.0889 4.98036V0.00146409H17.9726C17.9399 0.00146409 17.9015 0.00119139 17.8579 0.000881375C16.4459 -0.00915259 9.53277 -0.0582802 9.53277 7.83412V23.4994C9.53277 23.5181 9.53243 23.5436 9.532 23.5756C9.51841 24.5843 9.41851 32 17.3047 32H48.3925V27.1425H17.3047C16.5761 27.1425 14.451 26.6568 14.451 23.1351V8.80562C14.451 8.69141 14.4478 8.56922 14.4446 8.44125C14.4098 7.07229 14.3581 5.04108 17.9119 5.04108C21.7979 5.04108 48.0889 4.98036 48.0889 4.98036ZM0 0.00146409H5.10034V31.9393H0V0.00146409ZM82.0911 18.5813C84.6413 18.5813 89.6202 17.2455 89.6202 8.86633C89.6202 0.487209 83.5484 0.00146409 80.6339 0.00146409H52.7035V31.9393H57.6824V18.5813H82.0911ZM84.5806 9.29136C84.5806 5.16252 84.4591 5.04108 78.9945 5.04108H57.6217V13.6631H81.6661C83.2448 13.6631 84.5806 13.4202 84.5806 9.29136ZM101.278 31.9393C98.8494 31.9393 94.1133 30.3606 94.1133 24.0459V0.122901H98.9708V24.1673C98.9708 25.2603 99.4566 27.0818 101.764 27.0818H132.123V31.9393H101.278Z"
                                    fill="#F9F9F9"
                                />
                            </svg>
                        </template>
                    </div>
                </div>
                <div class="content adaptation-hidden-1100">
                    <div class="tabs" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0 pages">
                            <!-- tab -->
                            <li v-for="(item, i) in pages" :key="i">
                                <span
                                    @click="chooseTab(i, item)"
                                    :class="{
                                        'font-weight-bold': i == pageIndex,
                                        current: i == pageIndex,
                                        light: light,
                                    }"
                                >
                                    {{ t(item.text) }}
                                    <div class="underline" v-if="light && i == pageIndex"></div>
                                </span>
                            </li>
                        </ul>
                    </div>
                    <div class="enter-app">
                        <div
                            :class="{ zhCn: t(currentLanguage) === '简体中文' }"
                            @click="onEnterApp"
                        >
                            <div>
                                {{ t('navbar.enterApp') }}
                            </div>
                            <img src="@/assets/images/navigator/right-arrow.png" />
                        </div>
                    </div>
                </div>
                <div class="language">
                    <div>
                        <div class="icon" :class="{ light: light }">
                            <i
                                v-if="isEn"
                                class="iconfont icon-language-english"
                                @click="onChangeLanguage"
                            ></i>
                            <i
                                v-else
                                class="iconfont icon-language-chinese"
                                @click="onChangeLanguage"
                            ></i>
                        </div>
                        <span
                            @click="onChangeLanguage"
                            :class="{ light: light }"
                            class="adaptation-hidden-1615"
                        >
                            {{ t(currentLanguage) }}
                        </span>
                    </div>
                </div>
            </div>
        </nav>
        <el-backtop />
    </div>
</template>
<script lang="ts" setup>
import { ref, watch, computed, onMounted, defineProps } from 'vue';
import { languages, SupportedLocale, t } from '@/locale';
import { ElBacktop, ElMessage } from 'element-plus/es';
import { getLocaleText, setLocaleText } from '@/store/modules/user';
import { useStore } from 'vuex';
import { useRouter } from 'vue-router';
import { UserText } from '@/store';
import { setSourceChannel } from '@/utils/storage';

const store = useStore();
const router = useRouter();

// 导航栏显示和位置控制
const navigatorHeight = 136; // 导航栏的高度 定死 动画需要
const animationDelta = 3; // 每次动画幅度
const animationDuration = 888; // 动画时长 ms
const animationMs = animationDuration / (navigatorHeight / animationDelta); // 每帧间隔
const navbarRef = ref<HTMLElement | null>(null); // 导航栏控制句柄
const screenWidth = ref(document.documentElement.clientWidth); // 当前屏幕宽度
const navbarHeight = ref(0); // 导航栏当前偏移高度
const navbarTargetHeight = ref(0); // 当前导航栏目标偏移
const navbarAnimationHandler = ref<number>(0); // 导航栏显示动画控制
const lastWindowScrollY = ref(window.scrollY);
// const isPageLoaded = ref(false); // 标记页面是否加载完成
const navbarCollapseExpanded = ref(false); // 响应式折叠内容是否展开
const onMenuExpand = (expand: boolean) => (navbarCollapseExpanded.value = expand);

// 导航设置
const pageIndex = ref(0);
const pages = ref<{ text: string; action: string }[]>([
    { text: 'navbar.tabs.media', action: '/media' },
    { text: 'navbar.tabs.nns', action: '' },
    { text: 'navbar.tabs.dao', action: '' },
    { text: 'navbar.tabs.explore', action: '' },
    { text: 'navbar.tabs.about', action: '/about' },
]);

const props = defineProps({
    isNavigatorShow: {
        type: Boolean,
        default: () => true,
    },
    light: {
        type: Boolean,
        default: () => false,
    },
    loadedHide: {
        type: Boolean,
        default: () => false,
    },
});

// 多语言设置
const locale = computed(() => store.getters[UserText + '/' + getLocaleText]);
const isEn = computed(() => locale.value === SupportedLocale.en);
const setLocale = (locale: SupportedLocale) =>
    store.dispatch(UserText + '/' + setLocaleText, locale);
const currentLanguage = computed<string>(
    () => languages.find((i) => i.payload == locale.value)?.title ?? languages[0].title,
);

const isCollapsed = computed(() => screenWidth.value < 992); // 小于 992 表示需要折叠导航栏
const refreshMenu = () => {
    const pathname = location.pathname;
    for (let i = pages.value.length - 1; 0 <= i; i--) {
        if (pages.value[i].action && pathname.startsWith(pages.value[i].action)) {
            if (i == 0 && pages.value[i].action == '/' && pathname != '/') {
                // 找到首页的标签，但是明明有很多路径，不能被首页的斜线拦截了
                break;
            }
            pageIndex.value = i;
            return; // 这里直接返回
        }
    }
    pageIndex.value = -1; // 没找到对应的页面，就所有的都不显示选中状态
};

onMounted(() => {
    refreshMenu(); // 高亮当前选中的 tab
    // 动态检测宽度
    window.onresize = () => {
        screenWidth.value = document.documentElement.clientWidth;
        // if (isCollapsed.value) {
        //     setNavbarTranslate(0); // 在折叠情况下需要设置一直显示，不弄动画了
        // }
    };
    // 滚动事件
    document.addEventListener('scroll', onScroll);
    // 检测 url 取出 channel 并设置，注册的时候要取出渠道
    checkChannelSource();
    if (props.isNavigatorShow == false) setNavbarTranslate(-navigatorHeight);
    if (props.loadedHide) setNavbarTranslate(-navigatorHeight);
});

const setNavbarTranslate = (offset: number) => {
    navbarHeight.value = offset;
    navbarRef.value?.setAttribute('style', 'transform: translate(0px, ' + offset + 'px);');
};

// 滚动监听
const onScroll = () => {
    // if (lastWindowScrollY.value > 0 && !isPageLoaded.value) {
    //     isPageLoaded.value = true;
    //     return;
    // }
    if (!props.isNavigatorShow) {
        setNavbarTranslate(-navigatorHeight); // 如果是要求不显示，那么就直接偏移
        return;
    }
    if (isCollapsed.value) {
        setNavbarTranslate(0); // 导航栏已经是折叠情况下没有动画 要还原
        return;
    }
    // console.log('window.scrollY', window.scrollY);
    if (window.scrollY < 0) return;
    // 先判断往上滚还是往下滚
    if (lastWindowScrollY.value > window.scrollY) {
        navbarTargetHeight.value = 0; // 往上 显示动画 设置目标偏移
    } else if (lastWindowScrollY.value < window.scrollY) {
        navbarTargetHeight.value = -navigatorHeight; // 往下 隐藏动画 设置目标偏移
    }
    if (navbarHeight.value != navbarTargetHeight.value) {
        // 位置不对就一定开启定时器
        if (!navbarAnimationHandler.value) {
            // 没有定时器，就开启定时器 转换成数字
            navbarAnimationHandler.value = Number(
                setInterval(() => {
                    if (navbarHeight.value > navbarTargetHeight.value) {
                        navbarHeight.value -= animationDelta;
                        if (navbarHeight.value < navbarTargetHeight.value)
                            navbarHeight.value = navbarTargetHeight.value;
                    } else if (navbarHeight.value < navbarTargetHeight.value) {
                        navbarHeight.value += animationDelta;
                        if (navbarHeight.value > navbarTargetHeight.value)
                            navbarHeight.value = navbarTargetHeight.value;
                    } else {
                        clearInterval(navbarAnimationHandler.value);
                        navbarAnimationHandler.value = 0;
                    }
                    // 这里设置 style 位置
                    setNavbarTranslate(navbarHeight.value);
                }, animationMs),
            );
        }
    } else if (navbarAnimationHandler.value) {
        clearInterval(navbarAnimationHandler.value);
        navbarAnimationHandler.value = 0;
    }
    lastWindowScrollY.value = window.scrollY; // 更新记录
};
// 检查来源
const checkChannelSource = () => {
    let search = location.search;
    if (search.match(/source=/)) {
        const channel = search.split('source=')[1].split('&')[0];
        // console.log('set source channel', channel);
        setSourceChannel(channel);
    }
};

const comingSoon = () =>
    // 路径不全的 就当做还未完成
    ElMessage({
        // showClose: true,
        message: `${t('message.tip.comingSoon')}`,
        customClass:"i-message iconfont icon-development",
        center: true,
        type: '' as 'info',
        duration: 2000,
    });

const chooseTab = (i: number, item: { action: string }) => {
    if (item.action === '') {
        comingSoon();
        return;
    }
    if (item.action.startsWith('http')) {
        window.open(item.action, '_blank');
    } else {
        router.push(item.action);
    }
};

const onEnterApp = () => comingSoon();

const onChangeLanguage = () => {
    let current = languages.find((i) => i.payload == locale.value)?.payload;
    // console.error('current locale', current);
    if (current != null) {
        let index = languages.map((i) => i.payload).indexOf(current);
        if (index == languages.length - 1) index = -1;
        index++;
        current = languages[index].payload;
    } else {
        current = languages[0].payload;
    }
    // console.error('set locale', current);
    setLocale(current);
};

const onHome = () => router.push('/');

watch(
    () => props.isNavigatorShow,
    () => {
        if (props.isNavigatorShow == false) setNavbarTranslate(-navigatorHeight);
    },
);
</script>
<style lang="scss" scoped>
.navigator-container {
    background-color: transparent !important;
    color: white;
    width: 100%;
    /* font-family: RobotoRemote; */
    display: flex;
    justify-content: center;
    align-items: center;
    .navbar {
        margin: 0 auto;
        background-color: transparent !important;
        display: inline-block;
        height: 136px; // 应当和代码里面一致
        padding: 0;
        .container-fluid {
            width: 1200px;
            position: relative;
            padding: 0;
            .adaptation-show-1100 {
                display: none;
            }
            > .icon {
                position: absolute;
                left: -100px;
                top: 52px;
                z-index: 100;
                > div {
                    width: 132px;
                    height: 32px;
                    img,
                    svg {
                        width: 132px;
                        height: 32px;
                        cursor: pointer;
                    }
                }
            }
            > .content {
                height: 136px; // 应当和代码里面一致
                width: 100%;
                display: flex;
                flex-direction: row;
                justify-content: flex-end;
                align-items: center;
                > div {
                    width: auto;
                    display: inline-block;
                }
                > .tabs {
                    display: flex;
                    flex-direction: row;
                    justify-content: flex-end;
                    align-items: center;
                    > ul {
                        display: flex;
                        width: 100%;
                        justify-content: flex-end;
                        > li {
                            display: inline-block;
                            margin-right: 80px;
                            text-align: center;
                            display: flex;
                            align-items: center;
                            > span {
                                font-size: 26px;
                                line-height: 26px;
                                user-select: none;
                                cursor: pointer;
                                position: relative;
                                .underline {
                                    position: absolute;
                                    width: calc(100% + 10px);
                                    height: 8px;
                                    top: 34px;
                                    left: -5px;
                                    background: #0fb8e0;
                                    border-radius: 7.5px;
                                }
                                &.light {
                                    font-weight: 500 !important;
                                    color: #333333;
                                }
                            }
                            > span:hover {
                                font-weight: bold;
                            }
                            .current {
                                font-weight: bold;
                            }
                        }
                    }
                }
                .enter-app {
                    > div {
                        margin: 0 auto;
                        background-color: #0fb8e0ff;
                        width: 174px;
                        height: 56px;
                        border-radius: 28px;
                        display: flex;
                        flex-direction: row;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        &:hover {
                            background-color: rgb(45, 203, 238);
                        }
                        > div {
                            font-size: 22px;
                            line-height: 30px;
                            vertical-align: middle;
                        }
                        > img {
                            width: 13px;
                            height: 24px;
                            margin-left: 6px;
                        }
                    }
                    .zhCn {
                        > div {
                            transform: translateY(1px);
                        }
                    }
                }
            }
            > .language {
                width: 200px;
                height: 100%;
                position: absolute;
                right: -250px;
                > div {
                    width: auto;
                    height: 100%;
                    display: flex;
                    flex-direction: row;
                    align-items: center;
                    .icon {
                        width: 24px;
                        height: 24px;
                        transform: translateY(-4px);
                        opacity: 0.8;
                        cursor: pointer;
                        &:hover {
                            opacity: 1;
                        }
                        &.light {
                            color: #999999;
                        }
                        > i {
                            font-size: 22px;
                        }
                    }
                    > span {
                        text-align: left;
                        line-height: 28px;
                        font-size: 20px;
                        margin-left: 16px;
                        word-wrap: nowrap;
                        opacity: 0.8;
                        cursor: pointer;
                        &:hover {
                            opacity: 1;
                        }
                        &.light {
                            color: #999999;
                        }
                    }
                }
            }
        }
        &.light {
            background-color: #ffffff !important;
            box-shadow: 0px 0px 10px 10px #0fbae00e;
        }
    }
    @media screen and (max-width: 1615px) {
        .navbar {
            .container-fluid {
                > .icon {
                    left: -60px;
                }
                .content > .tabs > ul > li {
                    margin-right: 70px;
                }
                .language {
                    width: 100px;
                    right: -150px;
                    .adaptation-hidden-1615 {
                        display: none;
                    }
                }
            }
        }
    }
    @media screen and (max-width: 1480px) {
        .navbar > .container-fluid {
            width: 1100px;
            .content > .tabs > ul > li {
                margin-right: 60px;
            }
        }
    }
    @media screen and (max-width: 1355px) {
        .navbar > .container-fluid {
            width: 1000px;
            .content > .tabs > ul > li {
                margin-right: 40px;
            }
            .language {
                width: 24px;
                right: -80px;
            }
        }
    }
    @media screen and (max-width: 1200px) {
        .navbar > .container-fluid {
            width: 950px;
            .content > .tabs > ul > li {
                margin-right: 30px;
            }
            .language {
                right: -70px;
            }
        }
    }
    @media screen and (max-width: 1150px) {
        .navbar > .container-fluid {
            width: 920px;
            .content > .tabs > ul > li {
                margin-right: 25px;
            }
        }
    }
    @media screen and (max-width: 1100px) {
        nav.navbar.background-color-1100 {
            background-color: #2a064bff !important;
            &.light {
                background-color: #ffffff !important;
            }
        }
        .navbar > .container-fluid {
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 136px;
            .adaptation-show-1100 {
                display: block;
                &.collapse {
                    position: absolute;
                    width: 100%;
                    left: 0;
                    top: 0;
                    display: flex;
                    flex-direction: column;
                    .menu {
                        display: flex;
                        justify-content: flex-start;
                        align-items: center;
                        height: 136px;
                        padding-left: 54px;
                        width: 40px;
                        i {
                            font-size: 22px;
                            cursor: pointer;
                            color: #999999;
                        }
                    }
                    > .navbar-nav {
                        display: none;
                    }
                    &.show {
                        > ul.navbar-nav {
                            display: block;
                            color: black;
                            border-top: 1px solid #00000059;
                            border-bottom: 1px solid #00000059;
                            background-color: #2a064bff;
                            &.light {
                                background-color: #ffffff;
                                li {
                                    > span {
                                        color: black;
                                        &.current,
                                        &:hover {
                                            color: #0fb8e0;
                                        }
                                    }
                                }
                            }
                            width: 100%;
                            padding-top: 10px;
                            padding-bottom: 10px;
                            li {
                                margin-left: 54px;
                                margin-right: 54px;
                                height: 60px;
                                text-align: left;
                                border-bottom: 1px solid #00000059;
                                &:last-child {
                                    border-bottom: none;
                                }
                                display: flex;
                                align-items: center;
                                > span {
                                    font-size: 26px;
                                    line-height: 26px;
                                    cursor: pointer;
                                    user-select: none;
                                    color: white;
                                    opacity: 0.8;
                                    &.current,
                                    &:hover {
                                        font-weight: bold;
                                        opacity: 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .icon {
                position: static;
            }
            .adaptation-hidden-1100 {
                display: none !important;
            }
            .language {
                right: 54px;
            }
        }
    }
    @media screen and (max-width: 450px) {
        .navbar > .container-fluid {
            .adaptation-show-1100.collapse .menu {
                padding-left: 24px;
            }
            .adaptation-show-1100.collapse.show > ul.navbar-nav li {
                margin-left: 24px;
                margin-right: 24px;
            }
            .language {
                right: 24px;
            }
        }
    }
}
</style>
