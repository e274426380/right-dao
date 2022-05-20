<template>
    <div class="post-reply-reply-container">
        <el-dialog
            v-model="visible"
            :before-close="onClose"
            :title="props.comments.length+' 条评论'"
            width="35%"
        >
            <template v-if="props.comments.length>0">
                <div class="replyReply" v-for="(item,index) in props.comments">
                    <div class="author">
                        <Avatar :username="item.authorData && item.authorData.name!=='' ?
                                item.authorData.name : item.author.toString()"
                                :principalId=item.author.toString()
                                :clickable="false"
                                :size="24"/>
                        <div class="authorName">
                            <b>{{item.authorData && item.authorData.name!=='' ? item.authorData.name:
                                item.author.toString()}}</b>
                        </div>
                    </div>
                    <div class="content">
                        {{item.content.content}}
                        <span>回复</span>
                    </div>
                </div>
            </template>
            <template #footer>
                <el-input class="replyInput" v-model="replyReply" placeholder="请输入你的评论..."></el-input>
              <span style="display: flex;justify-content: space-between">
                <el-button @click="onClose">取消</el-button>
                <el-button type="primary" @click="submit">提交评论</el-button>
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
    const replyReply = ref("")
    const emit = defineEmits(['update:visible'])
    onMounted(() => {
        init()
    });

    const init = () =>{
        console.log("props.comments",props.comments)
        for (let i = 0; i < props.comments.length; i++) {
            getTargetUser(props.comments[i].author.toString()).then(res => {
                console.log("props.comments[i].author",res)
                if (res.Ok) {
                    props.comments[i] = {
                        ...props.comments[i],
                        authorData: res.Ok,
                    }
                }
            })
        }
    }

    const submit = () => {
        addPostReplyReply(props.replyId, props.postId, replyReply.value).then(res => {
            console.log("addPostReplyReply", res)
            if(res.Ok){

            }
        })
    }

    const onClose = () => {
        emit('update:visible');
    }

    watch(
        () => props.visible,
        (nv) => {
            console.log("props.comments",props.comments)
        },
    );

</script>
<style lang="scss">
    .post-reply-reply-container {
        .el-dialog__body{
            padding-top: 0;
        }
        .replyInput{
            margin-bottom: 10px;
        }
        .replyReply{
            padding-top: 12px;
            padding-bottom: 10px;
            border-top: 1px solid rgb(246,246,246);
            .author{
                display: flex;
                align-items: center;
                .authorName{
                    margin-left: 10px;
                }
            }
            .content{
                padding-left: 34px;
            }
        }

    }
</style>
