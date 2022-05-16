<template>
    <div class="post-detail-write-reply-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card>
                        <h4>回答</h4>
                        <QuillEditor
                            ref="myTextEditor"
                            v-model:content="reply"
                            contentType="html"
                            :options="editorOption"
                            @update:content="isEditorChange = true"
                        />
                        <div class="footer">
                            <div>
                                <span class="fold" @click="foldReply">收起回答</span>
                            </div>
                            <div>
                                <span class="editorCalculate" :class="{ isCalcError: isEditorErr }">
                                    {{ showEditorLength }} / {{ limitLength }}
                                </span>
                                <el-button @click="submit()" :loading="loading">发布回答</el-button>
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref, computed, defineEmits} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
    import {QuillEditor} from '@vueup/vue-quill';
    import {t} from '@/locale';
    import {calculatedICPIdLength} from "@/utils/images";
    import {addPostReply} from "@/api/post";
    import {useRoute} from "vue-router";
    import {showMessageSuccess} from "@/utils/message";

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
        placeholder: '......',       //placeholder,在双语切换时不会即时响应
        readyOnly: false, //是否只读
        theme: 'snow', //主题 snow/bubble
        syntax: true, //语法检测
    };
    const loading = ref(false);
    const route = useRoute();
    const postId = Number(route.params.id);
    //编辑器是否发生变化
    const isEditorChange = ref(false);
    const isEditorErr = ref(false);
    //限制输入长度10000个字
    const limitLength = 10000;
    // 直接取出，没有额外逻辑，用 computed 变成响应式值
    const myTextEditor = ref<{ setHTML: Function; getText: Function } | null>(null);
    const reply = ref('');

    const emit =defineEmits(['foldWrite'])
    const foldReply = () => {
        emit('foldWrite');
    }

    const showEditorLength = computed(() => {
        const length = calculatedICPIdLength(reply.value);
        length > limitLength ? (isEditorErr.value = true) : (isEditorErr.value = false);
        return length;
    });

    const submit = () => {
        loading.value = true;
        addPostReply(postId,reply.value).then(res => {
            console.log(res);
            if (res.Ok) {
                showMessageSuccess(t('message.post.create'));

            }
        }).finally(() => {
            loading.value = false;
        })
    }

</script>
<style lang="scss">
    .post-detail-write-reply-container {
        .el-card {
            position: relative;
            margin-top: 10px;
            .footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 10px;
                .fold {
                    color: var(--el-color-info);
                    &:hover {
                        cursor: pointer;
                    }
                }
                .editorCalculate {
                    margin-right: 10px;
                    color: var(--el-color-info);
                    /*font-size: 12px;*/
                    /*position: absolute;*/
                    /*right: 25px;*/
                    /*bottom: 25px;*/
                }
            }
        }
    }
</style>
