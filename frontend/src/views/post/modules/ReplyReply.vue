<template>
    <div class="post-reply-reply-container">
        <el-dialog
            v-model="visible"
            :before-close="onClose"
            :title="total === 1 || total ===0 ?
                    total + $t('post.item') + $t('post.comment'):
                    total + $t('post.item') + $t('post.comments')"
            width="35%"
        >
            <template v-if="showList.length>0">
                <div class="replyReply" v-for="(item,index) in showList">
                    <div class="head">
                        <div class="author">
                            <Avatar :username="item.authorData && item.authorData.name!=='' ?
                                item.authorData.name : item.author.toString()"
                                    :principalId=item.author.toString()
                                    :clickable="false"
                                    :size="24"/>
                            <div class="authorName">
                                <div>
                                    <b>{{item.authorData && item.authorData.name!=='' ? item.authorData.name:
                                        item.author.toString()}}</b>
                                    <span class="quote-name" v-if="item.quote_id.length >0">{{t('post.reply')+" "+item.quoteName}}</span>
                                </div>
                            </div>
                        </div>
                        <span>{{getTimeF(Number(item.created_at))}}</span>
                    </div>
                    <div class="content">
                        {{item.content.content}}
                        <span class="reply-button" v-if="item.isReply" @click="replyOther(item)">{{t('post.cancelReply')}}</span>
                        <span class="reply-button" v-else @click="replyOther(item)">{{t('post.reply')}}</span>
                    </div>
                </div>
                <div class="dialog-pagination">
                    <el-pagination layout="prev, pager, next"
                                   :page-size="pageSize"
                                   v-model:currentPage="pageNum"
                                   @current-change="paging()"
                                   :total="total"/>
                </div>
            </template>
            <template #footer>
                <el-input class="replyInput" v-model="replyReply" :placeholder="placeholder"></el-input>
                <span style="display: flex;justify-content: space-between">
                <el-button @click="onClose">{{t('common.cancel')}}</el-button>
                <el-button type="primary" @click="submit()" :loading="loading">{{t('post.submitComment')}}</el-button>
              </span>
            </template>
        </el-dialog>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, watch, defineProps, defineEmits, PropType} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard, ElDialog, ElInput, ElPagination} from 'element-plus/es';
    import {addPostReplyReply} from "@/api/post";
    import {ApiPostComments} from "@/api/types";
    import Avatar from '@/components/common/Avatar.vue';
    import {getTimeF} from "@/utils/dates";
    import {getTargetUser} from "@/api/user";
    import {showMessageError, showMessageSuccess} from "@/utils/message";
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
    const placeholder = ref(t('post.commentPlaceholder'))
    const quoteId = ref([] as number[])
    const showList = ref<ApiPostComments[]>([])
    const itemList = ref<ApiPostComments[]>([])
    const emit = defineEmits(['update:visible', 'refreshCallback'])
    const pageSize = ref(10);
    const pageNum = ref(1);
    const total = ref(0);

    onMounted(() => {
        init()
    });

    const init = () => {
        total.value = props.comments.length;
        //深拷贝props，防止修改props数据
        [...itemList.value] = props.comments;
        itemList.value.reverse();
        paging();
        console.log("showList.value", showList.value)
    }

    const paging = () => {
        showList.value = itemList.value.slice(pageSize.value * (pageNum.value - 1), pageSize.value * pageNum.value);
        for (let i = 0; i < showList.value.length; i++) {
            const quoteId = Number(showList.value[i].quote_id[0]);
            let quoteIndex: number = -1;
            //查询是否有引用的评论，先把principalId加进去。
            if (quoteId && quoteId !== 0) {
                showList.value.map((item, index) => {
                    if (Number(item.id) === quoteId) {
                        quoteIndex = index;
                    }
                })
                if (quoteIndex !== -1) {
                    showList.value[i].quoteName = showList.value[quoteIndex].author.toString();
                }
            }
            getTargetUser(showList.value[i].author.toString()).then(res => {
                if (res.Ok && showList.value[i].author.toString() === res.Ok.owner.toString()) {
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

    const replyOther = (item: any) => {
        replyReply.value = "";
        //取消回复
        if (item['isReply']) {
            item['isReply'] = false;
            placeholder.value = t('post.commentPlaceholder');
            quoteId.value = [];
        } else {
            //正常回复
            item['isReply'] = true;
            const name = item.authorData && item.authorData.name !== '' ? item.authorData.name :
                item.author.toString();
            placeholder.value = t('post.reply') + " " + name + "：";
            quoteId.value = [Number(item.id)];
        }
    }

    const submit = () => {
        if (replyReply.value.trim().length === 0) {
            showMessageError(t('message.post.error'))
            return
        }
        loading.value = true;
        addPostReplyReply(props.replyId, props.postId, replyReply.value, quoteId.value).then(res => {
            console.log("addPostReplyReply", res)
            if (res.Ok) {
                showMessageSuccess(t('message.post.reply'));
                replyReply.value = "";
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
        .el-dialog__header {
            border-bottom: 1px solid rgb(246, 246, 246);
        }
        .el-dialog__body {
            padding-top: 0;
            padding-bottom: 5px;
        }
        .replyInput {
            margin-bottom: 10px;
        }
        .dialog-pagination .el-pagination {
            border-bottom: 1px solid rgb(246, 246, 246);
            border-top: 1px solid rgb(246, 246, 246);
            padding-top: 10px;
            padding-bottom: 10px;
            justify-content: center;
            .number {
                padding-top: 4px;
            }
        }
        .replyReply {
            padding-top: 12px;
            padding-bottom: 10px;
            border-top: 1px solid rgb(246, 246, 246);
            .head {
                display: flex;
                align-items: center;
                justify-content: space-between;
                .author {
                    display: flex;
                }
                .authorName {
                    margin-left: 10px;
                    .quote-name {
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
