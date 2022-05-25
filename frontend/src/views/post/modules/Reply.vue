<template>
    <div class="post-detail-reply-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card>
                        <div class="head">
                            <b>{{list.length}}个 回答</b>
                        </div>
                        <div class="reply" v-for="(item,index) in list">
                            <div class="author">
                                <Avatar :username="item.authorData && item.authorData.name!=='' ?
                                            item.authorData.name : item.author.toString()"
                                        :principalId=item.author.toString()
                                        :clickable="false"
                                        :size="38"/>
                                <div class="authorName">
                                    <b>{{item.authorData && item.authorData.name!=='' ? item.authorData.name:
                                        item.author.toString()}}</b>
                                    <div class="sign" v-if="item.authorData && item.authorData.memo!==''">
                                        {{item.authorData.memo}}
                                    </div>
                                </div>
                            </div>
                            <div class="content ql-snow">
                                <div v-if="item.content.format==='html'"
                                     class="ql-editor hidden"
                                     ref="htmlInformation"
                                     v-html="item.content.content"
                                >
                                </div>
                                <div v-else>
                                    {{item.content.content}}
                                </div>
                            </div>
                            <div class="footer">
                                <div>
                                    <span @click="openReplyReply(index)">{{item.comments.length}} 条评论</span>
                                    <span>转发</span>
                                </div>
                                <div>
                                    <span>收起</span>
                                </div>
                            </div>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>
    </div>
    <ReplyReply v-if="showReplyReply" v-model:visible="showReplyReply" :comments="comments" :replyId="commentId"
                :postId="props.postId"
                @refreshCallback="init()"/>
</template>
<script lang="ts" setup>
    import {ref, onMounted, defineProps, defineExpose} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
    import ReplyReply from './ReplyReply.vue';
    import {ApiPostComments} from "@/api/types";
    import {getTargetUser} from "@/api/user";
    import {getPostComments} from "@/api/post";

    const props = defineProps({
        postId: {
            type: Number,
            required: true,
        },
    });
    const list = ref<ApiPostComments[]>([]);
    const showReplyReply = ref(false);
    const replyIndex = ref(-1);
    const commentId = ref(0);
    const comments = ref<ApiPostComments[]>([]);

    const openReplyReply = (index: number) => {
        replyIndex.value = index;
        comments.value = list.value[index].comments;
        showReplyReply.value = true;
        commentId.value = Number(list.value[index].id);
    }

    const init = async () => {
        await getPostComments(props.postId).then(res => {
            if (res.Ok) {
                console.log("getPostComments", res)
                list.value = res.Ok
            }
        })
        if (list.value.length > 0 && replyIndex.value !== -1 && showReplyReply.value) {
            //如果replyIndex不为0，说明用户目前在看评论区，需要重新加载一下评论区的数据
            openReplyReply(replyIndex.value);
        }
        console.log("list", list.value)
        for (let i = 0; i < list.value.length; i++) {
            getTargetUser(list.value[i].author.toString()).then(res => {
                if (res.Ok) {
                    list.value[i] = {
                        ...list.value[i],
                        authorData: res.Ok,
                    }
                }
            })
        }
    }

    onMounted(() => {
        init();
    });

    defineExpose({
        init
    })

</script>
<style lang="scss">
    .post-detail-reply-container {
        .el-card {
            margin-top: 10px;
            .reply {
                margin-top: 10px;
                padding-top: 10px;
                border-top: 1px solid rgb(246, 246, 246);
                .author {
                    display: flex;
                    align-items: center;
                    .authorName {
                        margin-left: 10px;
                    }
                }
                .footer {
                    display: flex;
                    justify-content: space-between;
                    color: rgb(133, 144, 166);
                    span:hover {
                        cursor: pointer;
                    }
                    span + span {
                        margin-left: 10px;
                    }
                }
            }
        }
    }
</style>
