<template>
    <div class="error-404-container">
        <div class="inner" ref="mainRef">
            <div class="tip" ref="tipRef">抱歉，您访问的页面不存在</div>
            <div class="button-wrap" ref="buttonRef">
                <div class="button" ref="buttonRef" @click="onHome">
                    <div class="mark">
                        <div class="dot"></div>
                        <div class="line"></div>
                    </div>
                    <span>返回首页</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const mainRef = ref<HTMLElement | null>(null);
const tipRef = ref<HTMLElement | null>(null);
const buttonRef = ref<HTMLElement | null>(null);

const calcHeight = () => {
    if (mainRef.value != null) {
        const width = mainRef.value.offsetWidth;
        const height = (width * 1080) / 1920;
        mainRef.value.style.height = height + 'px';
        if (buttonRef.value != null) {
            buttonRef.value.style.transform = `translateY(${(height * 850) / 1080}px)`;
        }
        if (tipRef.value != null) {
            tipRef.value.style.top = `${(height * 356) / 1080}px`;
            tipRef.value.style.left = `${(width * 931) / 1920}px`;
        }
    }
};

onMounted(() => {
    calcHeight();
    window.onresize = calcHeight;
});

const onHome = () => router.push('/');
</script>

<style lang="scss">
.error-404-container {
    /* min-height: 2000px; */
    background: #2b1d6b !important;
    display: flex;
    position: absolute;
    top: 0px;
    left: 0px;
    right: 0px;
    bottom: 0px;
    .inner {
        background-image: url('https://file.icpl.info/file/2022/04/06/4922235444364120629.png');
        background-size: contain;
        background-position: center;
        background-repeat: no-repeat;
        width: 100%;
        position: absolute;
        top: 0;

        .tip {
            position: absolute;
            height: 50px;
            font-size: 36px;
            font-weight: 500;
            color: #d5aee8;
            line-height: 50px;
        }

        .button-wrap {
            width: 100%;
            display: flex;
            justify-content: center;
            .button {
                width: 210px;
                height: 60px;
                background: #9349b4;
                border-radius: 30px;
                position: relative;
                display: flex;
                justify-content: center;
                align-items: center;

                cursor: pointer;
                .mark {
                    position: absolute;
                    left: 26px;
                    top: 2px;
                    display: flex;
                    flex-direction: row;
                    justify-content: center;
                    align-items: center;
                    background-color: transparent;
                    > div {
                        background-color: #ffffff;
                    }
                    .dot {
                        width: 4px;
                        height: 4px;
                        border-radius: 2px;
                    }
                    .line {
                        width: 40px;
                        height: 4px;
                        border-radius: 2px;
                        margin-left: 4px;
                    }
                }

                span {
                    height: 28px;
                    font-size: 28px;
                    font-weight: 500;
                    color: #ffffff;
                    line-height: 28px;
                    letter-spacing: 1px;

                    transform: translateY(2px);
                }
            }
        }
    }
}
</style>
