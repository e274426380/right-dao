<template>
    <div class="post-reply-reply-container">
        <el-dialog
            v-model="visible"
            :before-close="onClose"
            :title="showList.length+' 条评论'"
            width="35%"
        >
            <template v-if="showList.length>0">
                <div class="replyReply" v-for="(item,index) in showList">
                    <div class="author">
                        <Avatar :username="item.authorData && item.authorData.name!=='' ?
                                item.authorData.name : item.author.toString()"
                                :principalId=item.author.toString()
                                :clickable="false"
                                :size="24"/>
                        <div class="authorName">
                            <b>{{item.authorData && item.authorData.name!=='' ? item.authorData.name:
                                item.author.toString()}}</b>
                            <span class="quote-name" v-if="Number(item.quote_id[0])!==0">回复{{" "+item.quoteName}}</span>
                        </div>
                    </div>
                    <div class="content">
                        {{item.content.content}}
                        <span class="reply-button" @click="replyOther(item)">回复</span>
                    </div>
                </div>
            </template>
            <template #footer>
                <el-input class="replyInput" v-model="replyReply" :placeholder="placeholder"></el-input>
                <span style="display: flex;justify-content: space-between">
                <el-button @click="onClose">取消</el-button>
                <el-button type="primary" @click="submit()" :loading="loading">提交评论</el-button>
              </span>
            </template>
        </el-dialog>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, watch, defineProps, defineEmits, PropType} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard, ElDialog, ElInput} from 'element-plus/es';
    import {addPostReplyReply} from "@/api/post";
    import {ApiPostComments} from "@/api/types";
    import Avatar from '@/components/common/Avatar.vue';
    import {getTargetUser} from "@/api/user";
    import {showMessageSuccess} from "@/utils/message";
    import {t} from "@/locale";

    const props = defineProps({
        visible: {
            type: Boolean,
            required: true,
            default: false
        },
        comments: {
            type: Array as PropType<ApiPostComments[]>,
            required: true
        },
        replyId: {
            type: Number,
            required: true
        },
        postId: {
            type: Number,
            required: true,
        },
    });
    const dialogVisible = ref(false);
    const loading = ref(false);
    const replyReply = ref("")
    const placeholder=ref("请输入你的评论...")
    const quoteId=ref(0)
    const showList = ref<ApiPostComments[]>([])
    const emit = defineEmits(['update:visible', 'refreshCallback'])
    onMounted(() => {
        init()
    });

    const init = () => {
        console.log("props.comments", props.comments)
        showList.value = props.comments;
        for (let i = 0; i < showList.value.length; i++) {
            const quoteId = Number(showList.value[i].quote_id[0]);
            let quoteIndex: number = null;
            //查询是否有引用的评论，先把principalId加进去。
            if (quoteId !== 0) {
                showList.value.map((item, index) => {
                    if (Number(item.id) === quoteId) {
                        quoteIndex = index;
                    }
                })
                showList.value[i].quoteName = showList.value[quoteIndex].author.toString();
            }
            getTargetUser(showList.value[i].author.toString()).then(res => {
                if (res.Ok) {
                    showList.value[i] = {
                        ...showList.value[i],
                        authorData: res.Ok,
                    }
                    if (Number(showList.value[i].quote_id) === quoteId) {
                        //此时把真实的名字返回给quote
                        showList.value[i].quoteName = res.Ok.name;
                    }
                }
            })
        }
    }

    const replyOther = (item: ApiPostComments) => {
        replyReply.value = "";
        const name = item.authorData && item.authorData.name !== '' ? item.authorData.name :
            item.author.toString();
        placeholder.value = "回复 " + name + " ：";
        quoteId.value = Number(item.id);
    }

    const submit = () => {
        loading.value = true;
        addPostReplyReply(props.replyId, props.postId, replyReply.value, quoteId.value).then(res => {
            console.log("addPostReplyReply", res)
            if (res.Ok) {
                showMessageSuccess(t('message.post.reply'));
                emit('refreshCallback');
            }
        }).finally(() => {
            loading.value = false;
        })
    }

    const onClose = () => {
        emit('update:visible');
        //关闭时清空输入，先别启用，感觉不友好
        // replyReply.value = "";
    }

    watch(
        () => props.comments,
        (nv) => {
            init();
        },
    );

</script>
<style lang="scss">
    .post-reply-reply-container {
        .el-dialog__header{
            border-bottom: 1px solid rgb(246, 246, 246);
        }
        .el-dialog__body {
            padding-top: 0;
        }
        .replyInput {
            margin-bottom: 10px;
        }
        .replyReply {
            padding-top: 12px;
            padding-bottom: 10px;
            border-top: 1px solid rgb(246, 246, 246);
            .author {
                display: flex;
                align-items: center;
                .authorName {
                    margin-left: 10px;
                    .quote-name{
                        margin-left: 10px;
                    }
                }
            }
            .reply-button {
                margin-left: 10px;
                color: #8590a6;
                &:hover {
                    cursor: pointer;
                }
            }
            .content {
                padding-left: 34px;
            }
        }
    }
</style>
