<template>
    <div class="post-submit-container">
        <Navigator/>
        <div class="container">
            <div class="submit-title">
                <h3 class="title">
                    {{ $t('post.help.create') }}
                    <div class="back-button" @click="$router.back()"
                    >{{ '<' }}{{ $t('common.back') }}
                    </div>
                </h3>
            </div>
            <el-row class="post-form">
                <el-col :span="16" :offset="4">
                    <el-form :model="form" hide-required-asterisk>
                        <el-form-item prop="title" :label="$t('post.help.title.label')">
                            <el-input v-model="form.title"
                                      maxlength="20"
                                      show-word-limit
                                      :placeholder="$t('post.help.title.placeholder')"/>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.content.label')">
                            <QuillEditor
                                ref="myTextEditor"
                                v-model:content="form.content.content"
                                contentType="html"
                                :options="editorOption"
                                @update:content="isEditorChange = true"
                            />
                            <span class="editorCalculate" :class="{ isCalcError: isEditorErr }">
                            {{ showEditorLength }} / {{ limitLength }}
                        </span>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.category.label')">
                            <el-select class="i-select"
                                       popper-class="i-select-pop"
                                       v-model="form.category"
                                       :placeholder="$t('post.help.category.placeholder')"
                            >
                                <el-option
                                    v-for="item in category"
                                    :key="item.value"
                                    :label="item.label"
                                    :value="item.value"
                                />
                            </el-select>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.participants.label')">
                            <el-input v-model="form.participants[0]"
                                      maxlength="30"
                                      show-word-limit
                                      :placeholder="$t('post.help.participants.placeholder')"/>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.endTime.label')">
                            <el-config-provider :locale="elementPlusLocale">
                                <el-date-picker
                                    v-model="form.end_time[0]"
                                    type="datetime"
                                    :placeholder="$t('post.help.endTime.placeholder')"
                                    popper-class="i-date-pop"
                                    :editable="false"
                                    value-format="x"
                                />
                            </el-config-provider>
                        </el-form-item>
                    </el-form>
                </el-col>
            </el-row>
            <div style="text-align: center" class="form-footer">
                <el-button type="primary" class="submit-button" @click="submit()" :loading="loading">提交</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
    import {ref, onMounted, computed, nextTick } from 'vue';
    import Navigator from '@/components/navigator/Navigator.vue';
    import {
        ElRow, ElCol, ElButton, ElSelect, ElOption, ElForm, ElFormItem, ElInput, ElMessage, ElConfigProvider,
        ElDatePicker,
    } from 'element-plus/es';
    import {SupportedLocale, t} from '@/locale';
    import {QuillEditor} from '@vueup/vue-quill';
    import '@vueup/vue-quill/dist/vue-quill.snow.css';
    import {useRoute, useRouter} from 'vue-router';
    import en from 'element-plus/lib/locale/lang/en';
    import zhCn from 'element-plus/lib/locale/lang/zh-cn';
    import {useStore} from "vuex";
    import {submitPost} from "@/api/post";
    import {goBack} from "@/router/routers";
    import {showMessageError, showMessageSuccess} from "@/utils/message";
    import {calculatedICPIdLength, filterImgToICPId} from "@/utils/images";
    const store = useStore();
    const router = useRouter();
    const route = useRoute();

    const locale = computed<SupportedLocale>(() => {
        return store.state.user.locale
    });
    const currentUserPrincipal = computed<string>(() => store.state.user.principal);
    const loading = ref(false);
    //编辑器是否发生变化
    const isEditorChange = ref(false);
    const isEditorErr = ref(false);
    //限制输入长度10000个字
    const limitLength = 10000;
    // 直接取出，没有额外逻辑，用 computed 变成响应式值
    const myTextEditor = ref<{ setHTML: Function; getText: Function } | null>(null);
    const form = ref({
        title: "",
        content: {
            content: "",
            format: "html"
        },
        photos:[],
        category:"",
        participants: [""],//期待参与者
        end_time: [0],
    });
    const category = ref([{
        value:"Tech",
        label:t('post.help.category.tech')
    },{
        value:"Law",
        label:t('post.help.category.law')
    }])
    const editorOption = {
        modules: {
            toolbar: {
                container: [
                    ['bold', 'italic', 'underline', 'strike'], // 加粗 斜体 下划线 删除线
                    ['blockquote', 'code-block'], // 引用  代码块
                    [{header: 1}, {header: 2}], // 1、2 级标题
                    [{list: 'ordered'}, {list: 'bullet'}], // 有序、无序列表
                    [{script: 'sub'}, {script: 'super'}], // 上标/下标
                    // [{ indent: "-1" }, { indent: "+1" }], // 缩进
                    // [{'direction': 'rtl'}],                         // 文本方向
                    // [{ size: ["small", false, "large", "huge"] }], // 字体大小
                    [{header: [1, 2, 3, 4, 5, 6, false]}], // 标题
                    // [{ color: [] }, { background: [] }], // 字体颜色、字体背景颜色
                    // [{ font: [] }], // 字体种类
                    // [{ align: [] }], // 对齐方式
                    ['clean'], // 清除文本格式
                    ['image'], // 图片
                    // ["link", "image","video"], // 链接、图片、视频
                ], //工具菜单栏配置
            },
        },
        placeholder: '......',       //placeholder,在双语切换时不会即时响应，注释了
        readyOnly: false, //是否只读
        theme: 'snow', //主题 snow/bubble
        syntax: true, //语法检测
    };
    const elementPlusLocale = computed(() => {
        switch (locale.value) {
            case SupportedLocale.zhCN:
                return zhCn;
            default:
                return en;
        }
    });

    onMounted(() => {
        init()
    });


    const showEditorLength = computed(() => {
        const length = calculatedICPIdLength(form.value.content.content);
        length > limitLength ? (isEditorErr.value = true) : (isEditorErr.value = false);
        return length;
    });

    const submit = () => {
        loading.value = true
        console.log("form", form.value)
        submitPost(form.value).then(res => {
            console.log(res);
            if (res.Ok) {
                showMessageSuccess(t('message.post.create'));
                router.push('/post/detail/' + Number(res.Ok));
            }
        }).finally(() => {
            loading.value = false;
        })
    }

    const init = () =>{
        console.log("currentUserPrincipal.value",currentUserPrincipal.value)
        //验证是否登录
        nextTick(() => {
            if (!currentUserPrincipal.value) {
                showMessageError(t('message.error.noLogin'));
                setTimeout(() => {
                    //等用户看清了错误提示再弹
                    goBack(router);
                }, 1500);
            }
        });
    }

    const  filterEditorImg = async (html:string) =>{
        try {
            //限制图片大小2M
            const limitSize = 2;
            //全是空格不准提交
            if (myTextEditor.getText().trim() === '') {
                showMessageError(t('project.create.informationNull'));
                return null;
            }
            let res = await filterImgToICPId(html, limitSize, limitLength);
            //超过限制的长度，返回错误
            if (res.overLimitLength) {
                loading.value = false;
                return null;
            } else {
                return res;
            }
        } catch (e: any) {
            console.error(e);
            return null;
        }
    }
</script>

<style lang="scss">
.post-submit-container {
    .container{
        .submit-title{
            margin-top: 20px;
            text-align: center;
            .title{
                position: relative;
            }
            .back-button{
                position: absolute;
                right: 0;
                top: 0;
                font-size: 1.75rem;
                &:hover{
                    cursor: pointer;
                }
            }
        }
        .post-form{
            margin-top: 20px;
            .editorCalculate {
                color: var(--el-color-info);
                font-size: 12px;
                position: absolute;
                right: 13px;
                bottom: 0px;
            }
        }
        .form-footer{
            .submit-button{
                font-size: 1.45rem;
                min-width: 110px;
                min-height: 35px;
            }
        }
    }
}

</style>
