<template>
    <div class="post-detail-head-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <div class="post-title">
                        <el-row justify="space-between">
                            <el-col :span="16" class="card-info">
                                <Avatar :username="author?.name as string"
                                        :principal-id=post.author.toString()
                                        :avatar-id="Number(author?.avatar_id)"
                                        :clickable="false"
                                        :size="60"/>
                                <div class="text">
                                    <div class="title">
                                        <span>{{post.title}}</span>
                                        <span class="post-status enable" v-if="post.status.Enable!==undefined">活跃</span>
                                        <span class="post-status completed" v-else-if="post.status.Completed!==undefined">完成</span>
                                        <span class="post-status closed" v-else-if="post.status.Closed!==undefined">关闭</span>
                                    </div>
                                    <div class="info">
                                        <span v-if="author!==undefined && author.name!==''">{{author.name}} </span>
                                        <span v-else>{{post.author.toString()}} </span>
                                        <span>|</span>
                                        <span class="createTime">{{formatDate(Number(post.created_at))}}</span>
                                    </div>
                                    <div class="need-type">
                                        希望参加者：
                                        <el-tag v-for="(item,index) in post.participants">{{item}}</el-tag>
                                        <el-tag>律师</el-tag>
                                    </div>
                                </div>
                            </el-col>
                            <el-col :span="8" class="flex-right">
                                <el-button type="primary" v-if="post.category.Tech!==undefined">{{t('post.help.category.tech')}}</el-button>
                                <el-button type="primary" v-else-if="post.category.Law!==undefined">{{t('post.help.category.law')}}</el-button>
                                <el-button type="primary" v-else>{{t('post.help.category.other')}}</el-button>
                            </el-col>
                        </el-row>
                        <div class="content">
                            <div v-if="post.content.format==='html'"
                                 class="ql-editor project-detail-information"
                                 ref="htmlInformation"
                                 v-html="post.content.content"
                            >
                            </div>
                            <div v-else>
                                {{post.content.content}}
                            </div>
                        </div>
                        <div class="footer">
                            <el-button type="primary" style="margin-right: 5px" @click="writeReply">写回答</el-button>
                            <el-button type="primary" style="margin-right: 5px">发起提案</el-button>
                            <span style="margin: 5px;">{{post.comments.length}} 条回复</span>
                            <span>收起</span>

                        </div>
                    </div>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, defineProps, PropType,defineEmits} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard, ElTag} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
    import {ApiPost, ApiUserInfo} from "@/api/types";
    import {getTargetUser} from "@/api/user";
    import {formatDate} from "@/utils/dates";
    import {t} from '@/locale';
    const author = ref<ApiUserInfo>();

    const props = defineProps({
        post: {
            type: Object as PropType<ApiPost>,
            required: true,
        },
    });

    onMounted(() => {
        init();
    });

    const init = () => {
        getTargetUser(props.post.author.toString()).then(res => {
            if (res.Ok) {
                author.value = res.Ok
            }
        })
    }

    const emit =defineEmits(['showWrite'])
    const writeReply = () => {
        emit('showWrite');
    }

</script>
<style lang="scss">
    .post-detail-head-container {
        background-color: white;
        -webkit-box-shadow: 0 1px 3px rgb(18 18 18 / 10%);
        box-shadow: 0 1px 3px rgb(18 18 18 / 10%);
        span+span{
            margin-left: 10px;
        }
        .post-title {
            margin-top: 40px;
            .card-info {
                text-align: left;
                display: inherit;
                .text {
                    margin-left: 20px;
                    .info{
                        .createTime{
                            color: rgb(133,144,166);
                            font-size:14px;
                        }
                    }
                }
                .title {
                    font-size: 20px;
                    font-weight: bold;
                }
                .need-type{
                    .el-tag{
                        /*margin-right: 5px;*/
                    }
                }
            }
            .flex-right {
                display: flex;
                justify-content: end;
                align-items: center;
            }
            .footer {
                margin-top: 15px;
                margin-bottom: 15px;
            }
        }
    }
</style>
