<template>
    <div class="post-detail-reply-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card>
                        <div class="head">
                            <b>{{comments.length}}个 回答</b>
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
                            <div class="content">
                                <div v-if="item.content.format==='html'"
                                     class="ql-editor project-detail-information"
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
                                    <span>1 条评论</span>
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
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed, watch, defineProps, defineEmits, PropType} from 'vue';
    import {ElRow, ElCol, ElButton,ElCard} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
    import {ApiPostComments} from "@/api/types";
    import {getTargetUser} from "@/api/user";

    const props = defineProps({
        comments: {
            type: Array as PropType<ApiPostComments[]>,
            required: true,
        },
    });

    const list = ref<ApiPostComments[]>(props.comments);


    const init = () => {
        console.log("list",list.value)
        for (let i = 0; i < list.value.length; i++) {
            getTargetUser(list.value[i].author.toString()).then(res => {
                console.log("res", res)
                if (res.Ok) {
                    list.value[i] = {
                        ...list.value[i],
                        authorData:res.Ok,
                    }
                }
            })
        }
    }

    onMounted(() => {
        init();
    });

</script>
<style lang="scss">
    .post-detail-reply-container {
        .el-card{
            margin-top: 10px;
            .reply{
                margin-top: 10px;
                padding-top: 10px;
                border-top: 1px solid rgb(246,246,246);
                .author{
                    display: flex;
                    align-items: center;
                    .authorName{
                        margin-left: 10px;
                    }
                }
                .footer{
                    display: flex;
                    justify-content: space-between;
                    color:rgb(133, 144, 166);
                    span:hover{
                        cursor: pointer;
                    }
                    span+span{
                        margin-left: 10px;
                    }
                }
            }
        }
    }
</style>
