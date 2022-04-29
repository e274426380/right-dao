<template>
    <div class="person-profile-list-container">
        <div class="container">
            <el-row>
                <el-button>发起的</el-button>
                <el-button>参与的</el-button>
            </el-row>
            <div class="list">
                <div v-for="i in 4" class="list-post">
                    <el-card class="user-post-card">
                        <div class="title">标题标题标题标题标题标题标题</div>
                        <div class="content">简短的内容</div>
                        <el-row justify="space-between">
                            <div>倒计时</div>
                            <div>
                                <span>回复数量</span>
                                <span>发布时间</span>
                            </div>
                        </el-row>
                    </el-card>
                </div>

            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref} from 'vue';
    import {t} from '@/locale';
    import {ElRow, ElCol, ElInput, ElButton, ElCard, ElTag} from 'element-plus/es';
    import {Search} from '@element-plus/icons-vue'

</script>
<style lang="scss">
    .person-profile-list-container {
        margin-top: 30px;
        padding: 20px;
        .container{
            background-color: rgb(246,246,246);
            padding: 20px 120px;
        }
        .list{
            padding: 30px;
            .user-post-card{
                margin-bottom: 50px;
                text-align: left;
                .title{
                    font-size: 20px;
                    font-weight: bold;
                }
            }
        }
    }
</style>
