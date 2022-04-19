<template>
    <div class="footer-addition-container">
        <div class="wrap">
            <div class="logo-content">
                <div class="logo">
                    <svg
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
                </div>
                <div class="tip">
                    <div class="tip tip1">
                        <span>{{ t('footer.tip1') }}</span>
                    </div>
                    <div class="tip tip2">
                        <span>{{ t('footer.tip2') }}</span>
                    </div>
                </div>
            </div>
            <div class="addition">
                <div class="addition1">
                    <div class="name">{{ t('footer.service.title') }}</div>
                    <div class="content">
                        <div @click="comingSoon">
                            <span>{{ t('footer.service.forums') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.service.blog') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.service.repository') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.service.nns') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.service.donate') }}</span>
                        </div>
                    </div>
                </div>
                <div class="addition2">
                    <div class="name">{{ t('footer.community.title') }}</div>
                    <div class="content">
                        <div @click="comingSoon">
                            <span>{{ t('footer.community.dao') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.community.join') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.community.protocol') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.community.terms') }}</span>
                        </div>
                    </div>
                </div>
                <div class="addition3">
                    <div class="name">{{ t('footer.support.title') }}</div>
                    <div class="content">
                        <div @click="comingSoon">
                            <span>{{ t('footer.support.help') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.support.submit') }}</span>
                        </div>
                        <div @click="comingSoon">
                            <span>{{ t('footer.support.bug') }}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="subscribe-email">
                <div class="name">{{ t('footer.email.title') }}</div>
                <div class="sub">
                    <div class="content">
                        <span>{{ t('footer.email.content') }}</span>
                        <span class="adaptation-show-560-1300">👉</span>
                        <span class="adaptation-show-560">👇</span>
                    </div>
                    <div class="input">
                        <template v-if="subscribeResult === null && !subscribeLoading">
                            <input
                                type="text"
                                v-model="inputEmailValue"
                                :placeholder="t('footer.email.address')"
                            />
                            <div
                                class="subscribe"
                                :class="{ invalid: !validatedEmail.result }"
                                @click="onSubscribe"
                            >
                                {{ t('footer.email.subscribe.title') }}
                            </div>
                        </template>
                        <template v-else-if="subscribeLoading">
                            <div class="subscribe-tip subscribing">
                                <div class="spinner">
                                    <div class="double-bounce1"></div>
                                    <div class="double-bounce2"></div>
                                </div>
                                <span>{{ t('footer.email.subscribe.ing') }}</span>
                            </div>
                        </template>
                        <template v-else-if="subscribeResult === true">
                            <div class="subscribe-tip subscribe-success">
                                <span class="status success"></span>
                                <span>{{ t('footer.email.subscribe.success') }}</span>
                            </div>
                        </template>
                        <template v-else-if="subscribeResult === false">
                            <div class="subscribe-tip subscribe-failed">
                                <span class="status failed"></span>
                                <span>{{ t('footer.email.subscribe.failed') }}</span>
                            </div>
                        </template>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref, computed } from 'vue';
import { ElMessage } from 'element-plus/es';
import { t } from '@/locale';
import { subscribeByEmail } from '@/api/footer';
import { validateEmail } from '@/utils/validation';

const showMessageError = (message: string) =>
    ElMessage({
        showClose: true,
        message,
        center: true,
        type: 'error',
    });
const showMessageSuccess = (message: string) =>
    ElMessage({
        showClose: true,
        message,
        center: true,
        type: 'success',
    });

const inputEmailValue = ref('');
const validatedEmail = computed(() => validateEmail(inputEmailValue.value));
const subscribeLoading = ref(false);
const subscribeResult = ref<boolean | null>(null);
const onSubscribe = () => {
    if (validatedEmail.value.error) {
        showMessageSuccess(t(validatedEmail.value.error));
        return;
    }
    if (!validatedEmail.value.result) return;
    subscribeResult.value = null;
    subscribeLoading.value = true;
    subscribeByEmail(validatedEmail.value.result)
        .then((d) => {
            console.log(d);
            if (d.ok !== undefined) {
                subscribeResult.value = true;
            } else if (d.err) {
                if (d.err.emailAddressAlreadyExists !== undefined) {
                    subscribeResult.value = true;
                    inputEmailValue.value = '';
                } else if (d.err.emailAddressNotValid !== undefined) {
                    showMessageError(t('message.email.subscribe.errorFormat'));
                } else throw new Error(JSON.stringify(d));
            } else throw new Error(JSON.stringify(d));
        })
        .catch((e) => {
            console.error('subscribe error', e);
            inputEmailValue.value = '';
            subscribeResult.value = false;
        })
        .finally(() => {
            subscribeLoading.value = false;
            if (null != subscribeResult.value) {
                setTimeout(
                    () => (subscribeResult.value = null),
                    subscribeResult.value ? 8000 : 10000,
                );
            }
        });
};

const comingSoon = () =>
    ElMessage({
        // showClose: true,
        message: `${t('message.tip.comingSoon')}`,
        customClass:"i-message iconfont icon-development",
        center: true,
        type: '' as 'info',
        duration: 2000,
    });
</script>
<style lang="scss">
.footer-addition-container {
    background-color: black;
    text-align: left;
    > .wrap {
        display: flex;
        flex-direction: row;
        justify-content: center;
        > .logo-content {
            width: 225px;
            margin-right: 50px;
            display: flex;
            flex-direction: column;
            .logo {
                height: 22px;
                line-height: 22px;
                svg {
                    width: 92px;
                    height: 22px;
                    opacity: 0.8;
                }
            }
            .tip {
                line-height: 22px;
                font-size: 14px;
                color: #ffffff;
                opacity: 0.8;
            }
            .tip1 {
                margin-top: 57px;
            }
        }
        > .addition {
            display: flex;
            flex-direction: row;
            > div {
                width: 217px;
                > .name {
                    height: 22px;
                    line-height: 22px;
                    font-size: 20px;
                    vertical-align: middle;
                    color: #ffffff;
                }
                > .content {
                    margin-top: 50px;
                    > div {
                        margin-top: 20px;
                        > span {
                            color: #ffffff;
                            opacity: 0.8;
                            font-size: 14px;
                            line-height: 14px;
                            cursor: pointer;
                            &:hover {
                                font-weight: bold;
                                opacity: 1;
                            }
                        }
                    }
                }
            }
            > .addition3 {
                margin-right: 1px;
            }
        }
        > .subscribe-email {
            width: 288px;
            display: flex;
            flex-direction: column;
            > .name {
                height: 22px;
                line-height: 22px;
                font-size: 20px;
                vertical-align: middle;
                color: #ffffff;
            }
            > .sub {
                margin-top: 50px;
                > .content {
                    > span {
                        color: #ffffff;
                        opacity: 0.8;
                        font-size: 14px;
                        line-height: 14px;
                        cursor: default;
                        &:hover {
                            font-weight: normal;
                            opacity: 0.8;
                        }
                    }
                    > .adaptation-show-560-1300,
                    > .adaptation-show-560 {
                        display: none;
                    }
                }
                > .input {
                    margin-top: 47px;
                    width: 288px;
                    height: 48px;
                    border-radius: 24px;
                    border: 1px solid #8e0ab7ff;
                    display: flex;
                    flex-direction: row;
                    justify-content: space-between;
                    align-items: center;
                    padding-left: 21px;
                    padding-right: 3px;
                    > input {
                        background: transparent;
                        margin-right: 8px;

                        font-size: 14px;
                        line-height: 16px;

                        color: #ffffff;

                        border: 0;
                        outline: none;
                    }
                    ::-webkit-input-placeholder {
                        color: #ffffff !important;
                        opacity: 0.8;
                    }
                    :-moz-placeholder {
                        color: #ffffff !important;
                        opacity: 0.8;
                    }
                    ::-moz-placeholder {
                        color: #ffffff !important;
                        opacity: 0.8;
                    }
                    :-ms-input-placeholder {
                        color: #ffffff !important;
                        opacity: 0.8;
                    }
                    .subscribe {
                        width: 110px;
                        height: 42px;
                        color: #ffffff;
                        background-color: #8e0ab7ff;
                        border-radius: 21px;
                        text-align: center;
                        line-height: 42px;
                        font-size: 18px;
                        cursor: pointer;
                        &:hover {
                            font-weight: bold;
                            background-color: rgb(163, 30, 204);
                        }
                        &.invalid {
                            background-color: #8e0ab7ff;
                            opacity: 0.8;
                            &:hover {
                                font-weight: normal;
                                background-color: #8e0ab7ff;
                            }
                        }
                    }
                    .subscribe-tip {
                        width: 246px;
                        text-align: center;
                        color: #ffffff;
                        opacity: 0.8;
                        display: flex;
                        flex-direction: row;
                        justify-content: center;
                        align-items: center;

                        .spinner {
                            width: 16px;
                            height: 16px;
                            margin-right: 10px;
                            position: relative;
                        }
                        .double-bounce1,
                        .double-bounce2 {
                            width: 100%;
                            height: 100%;
                            border-radius: 50%;
                            background-color: #8e0ab7ff;
                            opacity: 0.6;
                            position: absolute;
                            top: 0;
                            left: 0;

                            -webkit-animation: bounce 2s infinite ease-in-out;
                            animation: bounce 2s infinite ease-in-out;
                        }
                        .double-bounce2 {
                            -webkit-animation-delay: -1s;
                            animation-delay: -1s;
                        }
                        @-webkit-keyframes bounce {
                            0%,
                            100% {
                                -webkit-transform: scale(0);
                            }
                            50% {
                                -webkit-transform: scale(1);
                            }
                        }
                        @keyframes bounce {
                            0%,
                            100% {
                                transform: scale(0);
                                -webkit-transform: scale(0);
                            }
                            50% {
                                transform: scale(1);
                                -webkit-transform: scale(1);
                            }
                        }

                        .status {
                            width: 20px;
                            height: 3px;
                            margin-right: 3px;
                        }
                        .status.success:before {
                            content: '\2714';
                            color: #22b122;
                        }
                        .status.failed:before {
                            content: '\2716';
                            color: #b20610;
                        }
                        .status.success {
                            transform: translateY(-9px);
                        }
                        .status.failed {
                            transform: translateY(-9.5px);
                        }
                    }
                }
            }
        }
    }
}
@media screen and (max-width: 1300px) {
    .footer-addition-container {
        display: flex;
        justify-content: center;
        .wrap {
            flex-direction: column;
            justify-content: center;
            width: 800px;
            > .logo-content {
                width: 100%;
                margin-right: 0;
                > .logo {
                    display: flex;
                    justify-content: center;
                    > svg {
                        transform: scale(1.8);
                    }
                }
                .tip {
                    margin-top: 70px;
                    width: 100;
                    display: flex;
                    flex-direction: row;
                    justify-content: center;
                    > div {
                        width: 250px;
                        margin-top: 0;
                        vertical-align: middle;
                        > span {
                            display: flex;
                            align-items: center;
                            font-size: 16px;
                        }
                        &.tip1 {
                            text-align: right;
                            padding-right: 30px;
                            border-right: 1px solid #ffffffbb;
                        }
                        &.tip2 {
                            justify-content: flex-start;
                            padding-left: 30px;
                        }
                    }
                }
            }
            > .addition {
                margin-top: 80px;
                display: flex;
                justify-content: space-between;
                > div {
                    width: auto;
                    > .name {
                        height: 27px;
                        line-height: 27px;
                        font-size: 25px;
                    }
                    > .content {
                        > div {
                            > span {
                                font-size: 16px;
                                line-height: 16px;
                            }
                        }
                    }
                }
            }
            > .subscribe-email {
                margin-top: 70px;
                width: 100%;
                > .name {
                    text-align: center;
                    height: 27px;
                    line-height: 27px;
                    font-size: 25px;
                }
                .sub {
                    display: flex;
                    flex-direction: row;
                    justify-content: center;
                    > .content {
                        width: 250px;
                        display: flex;
                        flex-direction: row;
                        align-items: center;
                        margin-right: 20px;
                        > span {
                            display: inline-block;
                        }
                        > .adaptation-show-560-1300 {
                            display: inline-block;
                            font-size: 24px;
                            margin-left: 10px;
                        }
                    }
                    > .input {
                        margin-top: 0;
                        margin-left: 20px;
                        width: 338px;
                    }
                }
            }
        }
    }
}
@media screen and (max-width: 880px) {
    .footer-addition-container {
        .wrap {
            width: 700px;
        }
    }
}
@media screen and (max-width: 780px) {
    .footer-addition-container {
        .wrap {
            width: 600px;
        }
        > .subscribe-email {
            .sub {
                > .content {
                    margin-right: 10px;
                    > .adaptation-show-560-1300 {
                        margin-left: 5px;
                    }
                }
                > .input {
                    margin-left: 10px;
                    width: 278px;
                }
            }
        }
    }
}
@media screen and (max-width: 650px) {
    .footer-addition-container {
        .wrap {
            width: 500px;
            > .subscribe-email {
                .sub {
                    > .content {
                        margin-right: 5px;
                        > .adaptation-show-560-1300 {
                            margin-left: 2px;
                        }
                    }
                    > .input {
                        margin-left: 5px;
                        width: 278px;
                    }
                }
            }
        }
    }
}
@media screen and (max-width: 560px) {
    .footer-addition-container {
        .wrap {
            width: 450px;
            > .addition {
                display: flex;
                flex-direction: column;
                > div {
                    display: block;
                    margin-top: 35px;
                    &:first-child {
                        margin-top: 0;
                    }
                    .name {
                        width: 100%;
                        text-align: center;
                    }
                    .content {
                        margin-top: 0px;
                        padding-left: 10px;
                        padding-right: 10px;
                        display: block;
                        /* flex-direction: row;
                        justify-content: space-between; */
                        > div {
                            margin-top: 20px;
                            width: 33.3%;
                            &:nth-child(5) {
                                width: 66%;
                            }
                            display: inline-block;
                            > span {
                                margin-top: 20px;
                            }
                        }
                    }
                }
            }
            > .subscribe-email {
                .sub {
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    > .content {
                        margin-bottom: 15px;
                        width: 350px;
                        > .adaptation-show-560-1300 {
                            display: none;
                        }
                        > .adaptation-show-560 {
                            display: inline-block;
                            margin-left: 5px;
                            font-size: 20px;
                        }
                    }
                    > .input {
                        margin-left: 0;
                        width: 400px;
                    }
                }
            }
        }
    }
}

@media screen and (max-width: 470px) {
    .footer-addition-container {
        .wrap {
            width: 400px;
            > .subscribe-email {
                .sub {
                    > .content {
                        width: 300px;
                    }
                    > .input {
                        width: 320px;
                    }
                }
            }
        }
    }
}
@media screen and (max-width: 430px) {
    .footer-addition-container {
        .wrap {
            width: 350px;
            > .logo-content {
                .tip {
                    > div {
                        &.tip1 {
                            padding-right: 15px;
                        }
                        &.tip2 {
                            padding-left: 15px;
                        }
                    }
                }
            }
            > .addition {
                > div {
                    .content {
                        > div {
                            width: 50%;
                            &:nth-child(5) {
                                width: 100%;
                            }
                        }
                    }
                }
            }
            > .subscribe-email {
                .sub {
                    > .content {
                        width: 300px;
                    }
                    > .input {
                        width: 320px;
                    }
                }
            }
        }
    }
}
</style>
