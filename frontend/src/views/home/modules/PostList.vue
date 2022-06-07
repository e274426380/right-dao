<template>
    <div class="post-list-container" v-infinite-scroll="onScroll">
        <div class="container">
            <el-row justify="space-between">
                <el-col :span="16" style="display: flex">
                    <el-input
                        v-model="search"
                        class="search"
                        :placeholder="t('post.help.search')"
                        :prefix-icon="Search"
                    />
                </el-col>
                <el-col :span="8" class="flex-right">
                    <el-button type="primary" @click="router.push('/post/submit')">{{t('post.help.create')}}</el-button>
                </el-col>
            </el-row>
            <div class="post-list">
                <el-row>
                    <el-col :span="18" :offset="3">
                        <el-card class="post-card" v-for="(item,inex) in showList"
                                 @click="onClick(Number(item.id))">
                            <el-row justify="space-between">
                                <el-col :span="16" class="card-info">
                                    <Avatar :username="item.authorData && item.authorData.name!=='' ?
                                                item.authorData.name : item.author.toString()"
                                            :principalId=item.author.toString()
                                            :clickable="false"
                                            :size="60"/>
                                    <div class="text">
                                        <div class="title">
                                            <span @click="onClick(Number(item.id))">{{item.title}}</span>
                                            <span class="post-status enable"
                                                  v-if="item.status.Enable!==undefined">{{t('common.status.enable')}}</span>
                                            <span class="post-status completed"
                                                  v-else-if="item.status.Completed!==undefined">{{t('common.status.completed')}}</span>
                                            <span class="post-status closed" v-else-if="item.status.Closed!==undefined">{{t('common.status.closed')}}</span>
                                        </div>
                                        <div class="info">
                                            <span>{{item.authorData && item.authorData.name!=='' ? item.authorData.name:
                                        item.author.toString()}}</span>
                                            <span>|</span>
                                            <span class="createTime">{{getTimeF(Number(item.created_at))}}</span>
                                        </div>
                                        <div class="need-type">
                                            {{t('post.help.participants.label')}}
                                            <el-tag v-for="(item,index) in item.participants">{{item}}</el-tag>
                                        </div>
                                    </div>
                                </el-col>
                                <el-col :span="8" class="flex-right">
                                    <el-button type="primary" v-if="item.category.Tech!==undefined">
                                        {{t('post.help.category.tech')}}
                                    </el-button>
                                    <el-button type="primary" v-else-if="item.category.Law!==undefined">
                                        {{t('post.help.category.law')}}
                                    </el-button>
                                    <el-button type="primary" v-else>{{t('post.help.category.other')}}</el-button>
                                </el-col>
                            </el-row>
                            <div @click="onClick(Number(item.id))" class="content">
                                {{item.content.content}}
                            </div>
                            <div class="footer">
                                <div>
                                </div>
                                <div class="reply">
                                    {{t('post.reply')+" "+item.comments.length}}
                                </div>
                            </div>
                        </el-card>
                    </el-col>
                </el-row>
                <el-row :class="{ empty: list.length === 0 }" justify="center" class="loading-tip">
                    <div class="note" v-if="pageLoading">
                        {{ $t('common.loading') }}
                    </div>
                    <div class="note" v-else-if="totalCount === 0 || totalCount === list.length">
                        {{ $t('common.noMore') }}
                    </div>
                </el-row>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed} from 'vue';
    import {t} from '@/locale';
    import {ElRow, ElCol, ElInput, ElButton, ElCard, ElTag} from 'element-plus/es';
    import {Search} from '@element-plus/icons-vue'
    import Avatar from '@/components/common/Avatar.vue';
    import {useRoute, useRouter} from 'vue-router';
    import {getTimeF} from "@/utils/dates";
    import {getPostPage} from "@/api/post";
    import {ApiPost} from "@/api/types";
    import {cleanHtml} from "@/common/utils";
    import {getTargetUser} from "@/api/user";

    const router = useRouter();

    const search = ref("");
    const pageSize = ref(5);
    const pageNum = ref(0);
    const totalCount = ref(0);
    const pageLoading = ref(false);
    const list = ref<ApiPost[]>([]);

    const onClick = (id: number) => {
        router.push('/post/detail/' + id);
    }

    // 过滤显示的内容
    const showList = computed<Recordable<any>[]>(() => {
        return list.value.map((item) => {
            return {
                ...item,
                content: {
                    //移除html标签
                    content: cleanHtml(item.content.content),
                    format: "html"
                }
            };
        });
    });

    const onScroll = () => {
        //初始化时会运行一次此方法，所以懒加载分页从1开始
        //不能加载分页的时候停止请求博客列表，免得陷入死循环
        if (totalCount.value !== 0 && list.value.length !== totalCount.value) {
            pageNum.value++;
            init()
        }
    };

    const init = () => {
        pageLoading.value = true;
        getPostPage(pageNum.value, pageSize.value, search.value).then(res => {
            console.log("page",pageNum.value, res)
            if (res.Ok) {
                totalCount.value = Number(res.Ok.total_count);
                const length = list.value.length;
                list.value.push(...res.Ok.data);
                //需要获取user数据的index区间在(length, length + res.Ok.data.length)
                for (let i = length; i < list.value.length; i++) {
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
        }).finally(() => {
            pageLoading.value = false;
        })
    }

    onMounted(() => {
        init();
    });

</script>
<style lang="scss">
    .post-list-container {
        width: 100%;
        display: flex;
        justify-content: center;
        position: relative;
        margin-top: 24px;
        .empty{
            margin-top: 200px;
        }
        .loading-tip{
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .container {
            .flex-right {
                display: flex;
                justify-content: end;
                align-items: center;
            }
            .post-card {
                text-align: left;
                margin-top: 20px;
                &:hover{
                    cursor: pointer;
                }
                .el-card__body {
                    padding: 20px 60px;
                }
                .card-info {
                    display: inherit;
                    .text {
                        margin-left: 20px;
                    }
                    .info {
                        span + span {
                            margin-left: 10px;
                        }
                        .createTime {
                            color: rgb(133, 144, 166);
                            font-size: 16px;
                        }
                    }
                    .title {
                        font-size: 20px;
                        font-weight: bold;
                        span:first-child:hover {
                            cursor: pointer;
                        }
                        span + span {
                            margin-left: 10px;
                        }
                    }
                }
                .content {
                    margin-top: 10px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 6;
                    -webkit-box-orient: vertical;
                    &:hover {
                        cursor: pointer;
                    }
                }
                .footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-top: 25px;
                    .reply{
                        color: rgb(133, 144, 166);
                    }
                }
            }
        }
    }
</style>
