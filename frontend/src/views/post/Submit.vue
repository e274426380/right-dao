<template>
    <div class="post-submit-container">
        <Navigator/>
        <div class="container">
            <div class="submit-title">
                <h3 class="title">
                    {{ $t('post.help.create') }}
                </h3>
                <div class="back-button" @click="$router.back()"
                >{{ '<' }}{{ $t('common.back') }}
                </div>
            </div>
            <el-row class="post-form">
                <el-col :span="21" :offset="1">
                    <el-form :model="form" hide-required-asterisk="true">
                        <el-form-item prop="title" :label="$t('post.help.title.label')">
                            <el-input v-model="form.title"
                                      maxlength="20"
                                      show-word-limit
                                      placeholder="求助标题"/>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.content.label')">
                            <QuillEditor
                                ref="myTextEditor"
                                v-model:content="form.content.content"
                                contentType="html"
                                :options="editorOption"
                                @update:content="isEditorChange = true"
                            />
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
                            <el-input v-model="form.participants"
                                      maxlength="30"
                                      show-word-limit
                                      placeholder="期望的参与人"/>
                        </el-form-item>
                        <el-form-item :label="$t('post.help.endTime.label')">
                            <el-config-provider :locale="elementPlusLocale">
                                <el-date-picker
                                    v-model="form.end_time[0]"
                                    type="date"
                                    :placeholder="$t('post.help.endTime.placeholder')"
                                    popper-class="i-date-pop"
                                    :editable="false"
                                    format="YYYY-MM-DD"
                                    value-format="x"
                                />
                            </el-config-provider>
                        </el-form-item>
                    </el-form>
                </el-col>
            </el-row>
        </div>
    </div>
</template>

<script lang="ts" setup>
    import {ref, onMounted, computed} from 'vue';
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
    const store = useStore();
    const router = useRouter();
    const route = useRoute();

    const locale = computed<SupportedLocale>(() => {return store.state.user.locale;});
    // 直接取出，没有额外逻辑，用 computed 变成响应式值
    const myTextEditor = ref<{ setHTML: Function; getText: Function } | null>(null);
    const form = ref({
        title: "",
        content: {
            content:"",
            format:"html"
        },
        category: "",
        participants: "",//期待参与者
        end_time: [0],
    });
    const category = ref([{
        value:"Tech",
        label:t('post.category.tech')
    },{
        value:"Law",
        label:t('post.category.law')
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

</script>

<style lang="scss">
.post-submit-container {
    .container{
        .submit-title{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            .back-button{
                font-size: 1.75rem;
                &:hover{
                    cursor: pointer;
                }
            }
        }
        .post-form{
            margin-top: 20px;
        }
    }
}

</style>
