<template>
    <div class="post-detail-timeline-container">
        <div class="container">
            <el-row>
                <el-col :span="16" :offset="4">
                    <el-card class="timeline-card">
                        <template #header>
                            <div style="display:flex;justify-content: space-between">
                                <h4>最新进展</h4>
                                <div>
                                    <el-button type="primary" @click="statusFormVisible=true">{{t('post.status.title')}}</el-button>
                                    <el-button type="primary" @click="timelineFormVisible=true">{{t('post.timeline.add')}}</el-button>
                                </div>
                            </div>
                        </template>
                        <el-timeline>
                            <el-timeline-item
                                v-for="(item, index) in showList"
                                :key="index"
                                placement="top"
                                :type="item.type"
                                :hollow="item.hollow"
                                :timestamp="item.time"
                            >
                               {{ item.description }}
                            </el-timeline-item>
                        </el-timeline>
                        <div class="footer">
                            <span @click="showTimeline()" v-if="!timelineShowMore">展开全部进展</span>
                            <span @click="showTimeline()" v-else>收起全部进展</span>
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </div>
    </div>
    <el-dialog v-model="timelineFormVisible" custom-class="post-timeLine-dialog" :title="t('post.timeline.add')" width="30%">
        <el-form :model="timelineForm" hide-required-asterisk>
            <el-form-item :label="$t('post.timeline.time')+'：'"
                          prop="event_time"
                          :rules="[{
                required: true,
                message: t('form.time'),
                trigger: 'blur'}]">
                <el-config-provider :locale="elementPlusLocale">
                    <el-date-picker
                        v-model="timelineForm.event_time"
                        type="datetime"
                        :placeholder="$t('post.timeline.timePlaceholder')"
                        popper-class="i-date-pop"
                        :editable="false"
                        value-format="x"
                    />
                </el-config-provider>
            </el-form-item>
            <el-form-item prop="description" :rules="[{
                required: true,
                message: t('form.description'),
                trigger: 'blur'}]">
                <template #label>
                    <el-icon>
                        <Comment/>
                    </el-icon>
                </template>
                <el-input v-model="timelineForm.description"
                          maxlength="30"
                          show-word-limit
                          :placeholder="t('form.description')"/>
            </el-form-item>
        </el-form>
        <template #footer>
                <span class="dialog-footer">
                    <el-button @click="timelineFormVisible = false">{{t('common.cancel')}}</el-button>
                    <el-button type="primary" @click="addTimeline()" :loading="timelineLoading">{{t('common.confirm')}}</el-button>
                </span>
        </template>
    </el-dialog>
    <el-dialog v-model="statusFormVisible" custom-class="post-status-dialog" :title="t('post.status.title')" width="30%">
        <el-form :model="statusForm" hide-required-asterisk>
            <el-form-item :label="$t('post.status.status')+'：'"
                          prop="status"
                          :rules="[{
                required: true,
                message: t('form.status'),
                trigger: 'blur'}]">
                <el-select class="i-select"
                           popper-class="i-select-pop"
                           v-model="statusForm.status"
                           :placeholder="$t('post.status.status')"
                >
                    <el-option
                        v-for="item in status"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                    />
                </el-select>
            </el-form-item>
            <el-form-item prop="description" :rules="[{
                required: true,
                message: t('form.description'),
                trigger: 'blur'}]">
                <template #label>
                    <el-icon>
                        <Comment/>
                    </el-icon>
                </template>
                <el-input v-model="statusForm.description"
                          maxlength="30"
                          show-word-limit
                          :placeholder="t('form.description')"/>
            </el-form-item>
        </el-form>
        <template #footer>
                <span class="dialog-footer">
                    <el-button @click="statusFormVisible = false">{{t('common.cancel')}}</el-button>
                    <el-button type="primary" @click="changeStatus()" :loading="statusLoading">{{t('common.confirm')}}</el-button>
                </span>
        </template>
    </el-dialog>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed, watch, defineProps, defineEmits, PropType} from 'vue';
    import {
        ElRow,
        ElCol,
        ElButton,
        ElTimeline,
        ElTimelineItem,
        ElInput,
        ElCard,
        ElDialog,
        ElForm,
        ElFormItem,
        ElMessage,
        ElIcon,
        ElConfigProvider,
        ElDatePicker,
        ElSelect,
        ElOption
    } from 'element-plus/es';
    import {Comment} from '@element-plus/icons-vue';
    import {SupportedLocale, t} from '@/locale';
    import en from 'element-plus/lib/locale/lang/en';
    import zhCn from 'element-plus/lib/locale/lang/zh-cn';
    import {useStore} from "vuex";
    import {addPostTimeline, changePostStatus} from "@/api/post";
    import {showMessageError, showMessageSuccess} from "@/utils/message";
    import {ApiPostTimeline} from "@/api/types";
    import {formatDate} from "@/utils/dates";
    const store = useStore();
    const locale = computed<SupportedLocale>(() => {
        return store.state.user.locale
    });

    const props = defineProps({
        postId: {
            type: Number,
            required: true,
        },
        timeline: {
            type: Array as PropType<ApiPostTimeline[]>,
            required: true,
        },
    });
    const timelineShowMore =ref(false);
    const timelineMount = ref(3);
    const timelineFormVisible = ref(false);
    const timelineLoading = ref(false);
    const timelineForm = ref({
        post_id: props.postId,
        event_time: null,
        description: ""
    })
    const statusFormVisible = ref(false)
    const statusLoading = ref(false)
    const statusForm = ref({
        id: props.postId,
        status: "",
        description: ""
    })
    const status = [{
        value: "Enable",
        label: t('common.status.enable')
    }, {
        value: "Completed",
        label: t('common.status.completed')
    }, {
        value:"Closed",
        label: t('common.status.closed')
    }]
    const showItem = ref({});
    const elementPlusLocale = computed(() => {
        switch (locale.value) {
            case SupportedLocale.zhCN:
                return zhCn;
            default:
                return en;
        }
    });

    const emit =defineEmits(['addTimelineSuccess'])

    const init = () => {
        props.timeline.map((item, index) => {
            item.created_at = Number(item.created_at);
            item['time'] = formatDate(Number(item.event_time));
            if (index === 0) {
                item['type'] = 'primary';
                item['hollow'] = true;
            }
        })
    }

    const showList = computed(() => {
        const show = props.timeline.slice(0,timelineMount.value).map((item, index) => {
            item.created_at = Number(item.created_at);
            item['time'] = formatDate(Number(item.event_time));
            if (index === 0) {
                item['type'] = 'primary';
                item['hollow'] = true;
            }
            return item;
        })
        return show;
    });

    const showTimeline = () => {
        //控制时间线的展开与收起，默认是收起，false状态。
        timelineShowMore.value = !timelineShowMore.value;
        if (timelineShowMore.value) {
            timelineMount.value = props.timeline.length;
        } else {
            timelineMount.value = 3;
        }
    }

    const addTimeline = () => {
        console.log("timelineForm", timelineForm.value)
        timelineLoading.value = true;
        let timeline = {...timelineForm.value};
        timeline.event_time *= (1000 * 1000);
        addPostTimeline(timeline).then(res => {
            console.log("res", res)
            if (res.Ok) {
                showMessageSuccess(t('post.timeline.success'));
                emit('addTimelineSuccess');
                timelineFormVisible.value = false;
            } else if (res.Err && res.Err.PostAlreadyCompleted !== undefined) {
                showMessageError(t('message.error.post.alreadyCompleted'));
            } else {
                console.error(res)
            }
        }).finally(() => {
            timelineLoading.value = false;
        })
    }

    const changeStatus = () => {
        statusLoading.value = true;
        let status = {...statusForm.value};
        status.description += Object.keys(status.status);
        changePostStatus(statusForm.value).then(res => {
            if (res.Ok) {
                showMessageSuccess(t('post.status.success'));
                emit('addTimelineSuccess');
                statusFormVisible.value = false;
            } else if (res.Err && res.Err.PostAlreadyCompleted !== undefined) {
                showMessageError(t('message.error.post.alreadyCompleted'));
            } else {
                console.error(res)
            }
        }).finally(() => {
            statusLoading.value = false;
        })
    }

    onMounted(() => {
        init()
    });

    watch(
        () => props.timeline,
        () => {
            init()
        },
    );

</script>
<style lang="scss">
    .post-detail-timeline-container {
        margin-top: 10px;
        .timeline-card{
            box-shadow:0px 2px 6px rgba(0, 0, 0, 0.12);
            .el-card__header{
                padding-bottom: 9px!important;
            }
            .footer{
                text-align: right;
                padding-top: 10px;
                border-top: 1px solid var(--el-card-border-color);
                span{
                    color: rgb(148,158,177);
                }
                span:hover{
                    cursor: pointer;
                }
            }
        }
    }
</style>
