<template>
    <div class="person-profile-list-container" v-infinite-scroll="onScroll">
        <div class="container">
            <el-row>
                <el-button>发起的</el-button>
                <el-button>参与的</el-button>
            </el-row>
            <div class="list">
                <div v-for="(item,index) in list" class="list-post">
                    <el-card class="user-post-card" shadow="hover" @click="onClick(Number(item.id))">
                        <div class="title">{{item.title}}</div>
                        <div class="content">{{item.content.content}}</div>
                        <el-row justify="space-between" class="footer">
                            <span>{{t('common.reply')+" "+item.length}}</span>
                            <div>
                                <span>{{formatDate(Number(item.created_at))}}</span>
                            </div>
                        </el-row>
                    </el-card>
                </div>

            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref,onMounted} from 'vue';
    import {t} from '@/locale';
    import {useRoute, useRouter} from 'vue-router';
    import {ElRow, ElCol, ElInput, ElButton, ElCard, ElTag} from 'element-plus/es';
    import {Search} from '@element-plus/icons-vue'
    import {formatDate} from "@/utils/dates";
    import {getTargetUserComments, getTargetUserPost, getTargetUserPostComments} from "@/api/user";
    import {ApiProfilePost} from "@/api/types";
    import {cleanHtml} from "@/common/utils";

    const router = useRouter();
    const route = useRoute();
    const pageSize = ref(5);
    const pageNum = ref(0);
    const totalCount = ref(0);
    const query = ref(''); //查询，暂时没用
    const list = ref<ApiProfilePost[]>([]);

    const targetPrincipal = ref(route.params.principal);

    onMounted(() => {
        init()
    });

    const init = () => {
        // getPost();
        getPostComment();
        getComments();
    }

    const onClick = (id: number) => {
        router.push('/post/detail/' + id);
    }

    const onScroll = () => {
        //初始化时会运行一次此方法，所以懒加载分页从1开始
        //不能加载分页的时候停止请求博客列表，免得陷入死循环
        console.log("pageNum",pageNum.value)
        if (totalCount.value !== 0 && list.value.length !== totalCount.value) {
            pageNum.value++;
            init()
        }
    }

    const getPost = () => {
        getTargetUserPost(pageNum.value, pageSize.value, query.value, targetPrincipal.value).then(res => {
            console.log("getTargetUserPost", res)
            if (res.Ok) {
                totalCount.value = Number(res.Ok.total_count);
                list.value.push(...res.Ok.data.map(item => {
                    return {
                        id: item.id,
                        created_at: item.created_at,
                        title: item.title,
                        content: {
                            content: cleanHtml(item.content.content),
                            format: "text" as 'text'
                        },
                        length: item.comments.length
                    }
                }))
            }
        })
    }

    const getPostComment = () => {
        getTargetUserPostComments(pageNum.value, pageSize.value, query.value, targetPrincipal.value).then(res => {
            console.log("getTargetUserPostComments", res)
            if (res.Ok) {
                totalCount.value = Number(res.Ok.total_count);
                list.value.push(...res.Ok.data.map(item => {
                    return {
                        id: item.id,
                        created_at: item.created_at,
                        title: item.title,
                        content: {
                            content: cleanHtml(item.content.content),
                            format: "text" as 'text'
                        },
                        length: item.comments.length
                    }
                }))
            }
        })
    }

    const getComments = () => {
        getTargetUserComments(pageNum.value, pageSize.value, query.value, targetPrincipal.value).then(res => {
            console.log("getTargetUserComments", res)
        })
    }


</script>
<style lang="scss">
    .person-profile-list-container {
        margin-top: 30px;
        padding: 20px;
        background-color: rgb(246, 246, 246);
        .container{
            background-color: rgb(246,246,246);
            padding: 20px 120px;
        }
        .list{
            padding: 30px;
            .user-post-card{
                margin-bottom: 10px;
                text-align: left;
                &:hover{
                    cursor: pointer;
                }
                div+div{
                    margin-top: 10px;
                }
                .title{
                    font-size: 20px;
                    font-weight: bold;
                }
                .content{
                    overflow: hidden;
                    text-overflow: ellipsis;
                    display: -webkit-box;
                    -webkit-line-clamp: 3;
                    -webkit-box-orient: vertical;
                }
                .footer{
                    color: rgb(133, 144, 166);
                }
            }
        }
    }
</style>
