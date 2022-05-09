<template>
    <div class="post-detail-head-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <div class="post-title">
                        <h4>5 月 8 日上海新增本土「322+3625」，新增死亡 11 例，目前疫情情况如何？</h4>
                        <div class="content">
                            上海市卫健委今早（9日）通报：2022年5月8日0—24时，新增本土新冠肺炎确诊病例322例和无症状感染者3625例，
                            其中230例确诊病例为既往无症状感染者转归，92例确诊病例和3616例无症状感染者在隔离管控中发现。
                            新增境外输入性新冠肺炎确诊病例2例和无症状感染者1例，均在闭环管控中发现。
                        </div>
                        <div class="footer">
                            <el-button type="primary" style="margin-right: 5px">写回答</el-button>
                            <span style="margin: 5px;">1 条评论</span>
                            <span>收起</span>

                        </div>
                    </div>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ElRow, ElCol, ElButton} from 'element-plus/es';
</script>
<style lang="scss">
    .post-detail-head-container {
        background-color: white;
        -webkit-box-shadow: 0 1px 3px rgb(18 18 18 / 10%);
        box-shadow: 0 1px 3px rgb(18 18 18 / 10%);
        .post-title {
            margin-top: 40px;
            .footer {
                margin-top: 30px;
                margin-bottom: 15px;
            }
        }
    }
</style>
