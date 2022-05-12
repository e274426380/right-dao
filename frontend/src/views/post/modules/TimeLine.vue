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
    <el-dialog v-model="timelineFormVisible" custom-class="post-timeLine-dialog" :title="t('post.timeline.add')" width="30%">
        <el-form :model="timelineForm" hide-required-asterisk>
            <el-form-item :label="$t('post.timeline.time')+'：'">
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
            <el-form-item :label="$t('post.status.status')+'：'">
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
                    <el-button type="primary" @click="addTimeline()" :loading="statusLoading">{{t('common.confirm')}}</el-button>
                </span>
        </template>
    </el-dialog>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed, defineProps, PropType} from 'vue';
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
    import {showMessageError} from "@/utils/message";
    const store = useStore();
    const locale = computed<SupportedLocale>(() => {
        return store.state.user.locale
    });

    const props = defineProps({
        postId: {
            type: Number,
            default: () => true,
        },
    });
    const timelineFormVisible = ref(false)
    const timelineLoading = ref(false)
    const timelineForm = ref({
        post_id: props.postId,
        event_time: 0,
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
    const elementPlusLocale = computed(() => {
        switch (locale.value) {
            case SupportedLocale.zhCN:
                return zhCn;
            default:
                return en;
        }
    });

    const addTimeline = () => {
        console.log("timelineForm",timelineForm.value)
        timelineLoading.value = true;
        addPostTimeline(timelineForm.value).then(res => {
            console.log("res", res)
            if (res.Ok) {
                timelineFormVisible.value = false;
            } else if (res.Err && res.Err.PostAlreadyCompleted !== undefined) {
                showMessageError(t('message.error.post.alreadyCompleted'));
            }
        }).finally(() => {
            timelineLoading.value = false;
        })
    }

    const changeStatus = () => {
        statusLoading.value = true;
        changePostStatus(statusForm.value).then(res => {
            console.log(res)
        }).finally(() => {
            statusLoading.value = false;
        })
    }

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
