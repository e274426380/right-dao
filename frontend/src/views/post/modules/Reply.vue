<template>
    <div class="post-detail-reply-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card>
                        <div class="head">
                            <b>100个 回答</b>
                        </div>
                        <div class="reply">
                            <div class="author">
                                <Avatar :username="T"
                                        :principalId='T'
                                        :clickable="false"
                                        :size="38"/>
                                <div class="authorName">
                                    <b>MASK</b>
                                    <div>
                                        twitter
                                    </div>
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
    import {ElRow, ElCol, ElButton,ElCard} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
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
                    .authorName{
                        margin-left: 10px;
                    }
                }
            }
        }
    }
</style>
