<template>
    <div class="post-detail-reply-container" v-infinite-scroll="onScroll" :infinite-scroll-distance="200">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card>
                        <div class="head">
                            <b>{{list.length}}个 回答</b>
                        </div>
                        <div class="reply" v-for="(item,index) in showList">
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
                                     class="ql-editor"
                                     :class="{hidden:!foldIndex[index]}"
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
                                    <span v-if="!foldIndex[index]" @click="fold(index)">{{t('common.expand')}}</span>
                                    <span v-else @click="fold(index)">{{t('common.fold')}}</span>
                                </div>
                            </div>
                        </div>
                        <div class="reply" v-if="list.length===0">
                            暂时还没有其他人回答
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
    import {t} from '@/locale';

    const props = defineProps({
        postId: {
            type: Number,
            required: true,
        },
    });
    const list = ref<ApiPostComments[]>([]);
    const showList = ref<ApiPostComments[]>([]);
    const showReplyReply = ref(false);
    const pageLoading = ref(false);
    const foldIndex = ref([false]);
    const pageSize = ref(5);
    const pageNum = ref(0);
    const totalCount = ref(0);
    const replyIndex = ref(-1);
    const commentId = ref(0);
    const comments = ref<ApiPostComments[]>([]);

    const onScroll = () => {
        //初始化时会运行一次此方法，所以懒加载分页从1开始
        //不能加载分页的时候停止请求博客列表，免得陷入死循环
        console.log("onScroll", pageNum.value)
        if (totalCount.value !== 0 && showList.value.length !== totalCount.value) {
            pageNum.value++;
            paging()
        }
    };

    const fold = (index: number) => {
        foldIndex.value[index] = !foldIndex.value[index];
    }

    const openReplyReply = (index: number) => {
        replyIndex.value = index;
        comments.value = list.value[index].comments;
        showReplyReply.value = true;
        commentId.value = Number(list.value[index].id);
    }

    const paging = () => {
        if (totalCount.value > 0) {
            const length = showList.value.length;
            showList.value.push(...list.value.slice(pageSize.value * (pageNum.value - 1), pageSize.value * pageNum.value));
            //需要获取user数据的index区间在(length, length + pageSize)
            for (let i = length; i < showList.value.length; i++) {
                getTargetUser(showList.value[i].author.toString()).then(res => {
                    if (res.Ok) {
                        showList.value[i] = {
                            ...showList.value[i],
                            authorData: res.Ok,
                        }
                    }
                })
            }
        }
    }

    const init = async () => {
        await getPostComments(props.postId).then(res => {
            if (res.Ok) {
                console.log("getPostComments", res)
                list.value = res.Ok.reverse();
                totalCount.value = list.value.length;
            }
        })
        if (list.value.length > 0 && replyIndex.value !== -1 && showReplyReply.value) {
            //如果replyIndex不为0，说明用户目前在看评论区，需要重新加载一下评论区的数据
            openReplyReply(replyIndex.value);
        } else {
            //不在看评论区，得清空分页数据重新来，免得写回答后没有反应。
            showList.value = [];
            pageNum.value = 0;
            onScroll();
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
            .el-card__body{
                /*padding-left: 30px;*/
                /*padding-right: 30px;*/
            }
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
