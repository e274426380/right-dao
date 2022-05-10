<template>
    <div class="post-detail-head-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <div class="post-title">
                        <h4>{{post.title}}</h4>
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
                            <el-button type="primary" style="margin-right: 5px">写回答</el-button>
                            <span style="margin: 5px;">1 条回复</span>
                            <span>收起</span>

                        </div>
                    </div>
                </el-col>
            </el-row>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, defineProps, PropType} from 'vue';
    import {ElRow, ElCol, ElButton} from 'element-plus/es';
    import {ApiPost} from "@/api/types";

    const props = defineProps({
        post: {
            type: Object as PropType<ApiPost>,
            default: () => true,
        },
    });

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
