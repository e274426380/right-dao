<template>
    <div class="post-list-container">
        <div class="container">
            <el-row justify="space-between">
                <el-col :span="16" style="display: flex">
                    <el-input
                        v-model="search"
                        class="search"
                        placeholder="搜索标题和内容"
                        :prefix-icon="Search"
                    />
                </el-col>
                <el-col :span="8" class="flex-right">
                    <el-button type="primary">求助</el-button>
                </el-col>
            </el-row>
            <div class="post-list">
                <el-row>
                    <el-col>
                        <el-card class="post-card" v-for="i in 4">
                            <el-row justify="space-between">
                                <el-col :span="16" class="card-info">
                                    <Avatar :username="'E'"
                                            :principal-id="'E'"
                                            :avatar-id="0"
                                            :clickable="false"
                                            :size="60"/>
                                    <div class="text">
                                        <div class="title">
                                            <span>标题标题标题标题标题标题标题</span>
                                        </div>
                                        <div class="info">
                                            <span>ElonMask</span>
                                            <span>| 2022.4.26</span>
                                        </div>
                                        <div class="need-type">
                                            求助类型：
                                            <el-tag>律师</el-tag>
                                            <el-tag style="margin-left: 5px;">资金</el-tag>
                                        </div>
                                    </div>
                                </el-col>
                                <el-col :span="8" class="flex-right">
                                    <el-button type="primary">贴子类型</el-button>
                                </el-col>
                            </el-row>
                            <div style="margin-top: 25px">
                                <div>
                                    贴子内容
                                </div>
                                贴子内容
                                <div>
                                    贴子内容
                                </div>
                                贴子内容
                            </div>
                            <div class="footer">
                                <div>
                                    还有 1 天
                                </div>
                                <div>
                                    回复 99
                                    <el-button>
                                        点赞
                                    </el-button>
                                </div>
                            </div>
                        </el-card>
                    </el-col>
                </el-row>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref} from 'vue';
    import {t} from '@/locale';
    import {ElRow, ElCol, ElInput, ElButton, ElCard, ElTag} from 'element-plus/es';
    import {Search} from '@element-plus/icons-vue'
    import Avatar from '@/components/common/Avatar.vue';

    const search = ref("");

</script>
<style lang="scss">
    .post-list-container {
        width: 100%;
        display: flex;
        justify-content: center;
        position: relative;
        .container {
            .flex-right {
                display: flex;
                justify-content: end;
                align-items: center;
            }
            .post-card {
                text-align: left;
                margin-top: 30px;
                .el-card__body {
                    padding: 20px 60px;
                }
                .card-info {
                    display: inherit;
                    .text {
                        margin-left: 20px;
                    }
                    .title {
                        font-size: 20px;
                        font-weight: bold;
                    }
                }
                .footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-top: 25px;
                }
            }
        }
    }
</style>
