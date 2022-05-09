<template>
    <div class="post-detail-timeline-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card class="timeline-card">
                        <template #header>
                            <div style="display:flex;justify-content: space-between">
                                <h4>最新进展</h4>
                                <el-button type="primary">更新时间线</el-button>
                            </div>
                        </template>
                        <el-timeline>
                            <el-timeline-item
                                v-for="(activity, index) in activities"
                                :key="index"
                                placement="top"
                                :type="activity.type"
                                :hollow="activity.hollow"
                                :timestamp="activity.timestamp"
                            >
                                {{ activity.content }}
                            </el-timeline-item>
                        </el-timeline>
                    </el-card>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ElRow, ElCol, ElButton, ElTimeline, ElTimelineItem, ElCard} from 'element-plus/es';

    const activities = [
        {
            content: 'Event start',
            timestamp: '2018-04-15',
            type:'primary',
            hollow:true
        },
        {
            content: 'Approved',
            timestamp: '2018-04-13',
        },
        {
            content: 'Success',
            timestamp: '2018-04-11',
        },
    ]
</script>
<style lang="scss">
    .post-detail-timeline-container {
        margin-top: 10px;
        .timeline-card{
            box-shadow:0px 2px 6px rgba(0, 0, 0, 0.12);
            .el-card__header{
                padding-bottom: 9px!important;
            }
        }
    }
</style>
