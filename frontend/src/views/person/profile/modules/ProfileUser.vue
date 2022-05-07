<template>
    <div class="person-profile-user-container">
        <div class="container">
            <el-row>
                <el-col :span="3" :offset="3" style="display: inherit;">
                    <Avatar :username=user.name
                            :principal-id=targetPrincipal
                            :avatar-id="0"
                            :clickable="false"
                            :size="120"/>
                </el-col>
                <el-col :span="15">
                    <div class="user-profile">
                        <el-row justify="space-between" class="title">
                            <div class="flex-y-center">
                                <el-icon>
                                    <UserFilled/>
                                </el-icon>
                                {{user.name}}
                            </div>
                            <el-button v-if="isOwner" @click="dialogFormVisible = true">
                                编辑
                            </el-button>
                        </el-row>
                        <el-row>
                            {{ targetPrincipal }}
                        </el-row>
                        <el-row>
                            <el-icon>
                                <Message/>
                            </el-icon>
                            {{user.email}}
                        </el-row>
                        <el-row>
                            <el-icon>
                                <Comment/>
                            </el-icon>
                            {{user.memo}}
                        </el-row>
                        <el-row justify="space-between">
                            <div class="flex-y-center">
                                <el-icon>
                                    <StarFilled/>
                                </el-icon>
                                <el-tag v-for="(item,index) in user.interests">{{item}}</el-tag>
                            </div>
                            <div>
                                {{"加入于 " + formatDate(Number(user?.created_at ? user?.created_at : 0))}}
                            </div>
                        </el-row>
                    </div>
                </el-col>
            </el-row>
        </div>
    </div>
    <el-dialog v-model="dialogFormVisible" custom-class="user-edit-dialog" title="编辑信息" width="30%">
        <Avatar :username=form.name
                :principal-id=targetPrincipal
                :avatar-id="0"
                :clickable="false"
                :size="100"/>
        <el-form :model="form" hide-required-asterisk>
            <el-form-item prop="name" :rules="[{
                required: true,
                message: '请输入用户名',
                trigger: 'blur'}]">
                <template #label>
                    <el-icon>
                        <UserFilled/>
                    </el-icon>
                </template>
                <el-input v-model="form.name"
                          maxlength="20"
                          show-word-limit
                          placeholder="用户名"/>
            </el-form-item>
            <el-form-item>
                <template #label>
                    <el-icon>
                        <Message/>
                    </el-icon>
                </template>
                <el-input v-model="form.email"
                          maxlength="30"
                          show-word-limit
                          placeholder="邮箱"/>
            </el-form-item>
            <el-form-item>
                <template #label>
                    <el-icon>
                        <Comment/>
                    </el-icon>
                </template>
                <el-input v-model="form.memo"
                          type="textarea"
                          :rows="2"
                          maxlength="120"
                          show-word-limit
                          placeholder="签名"/>
            </el-form-item>
            <el-form-item v-for="(item, index) in form.interests"
                          label-width="32px"
                          :key="index"
                          :prop="'interests.' + index"
                          :rules="{
                            required: true,
                            message: '兴趣领域不能为空',
                            trigger: 'blur',
                            }">
                <template #label>
                    <el-icon v-if="index===0">
                        <StarFilled/>
                    </el-icon>
                    <span v-else></span>
                </template>
                <el-input v-model="form.interests[index]"
                          maxlength="10"
                          show-word-limit
                          placeholder="兴趣领域">
                    <template #append>
                        <el-button :icon="Close" @click.prevent="removeInterest(index)"></el-button>
                    </template>
                </el-input>
            </el-form-item>
        </el-form>
        <template #footer>
            <div style="display: flex;justify-content: space-between">
                <el-button @click="addInterest">增加兴趣</el-button>
                <span class="dialog-footer">
                    <el-button @click="dialogFormVisible = false">取消</el-button>
                    <el-button type="primary" @click="updateSelf()" :loading="loading">确认</el-button>
                </span>
            </div>
        </template>
    </el-dialog>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed} from 'vue';
    import {useStore} from 'vuex';
    import {useRoute, useRouter} from 'vue-router';
    import {t} from '@/locale';
    import {ElRow, ElCol, ElButton, ElDialog, ElForm, ElFormItem,
        ElInput, ElMessage, ElTag, ElIcon} from 'element-plus/es';
    import {UserFilled, Message, Comment, Close, StarFilled} from '@element-plus/icons-vue';
    import Avatar from '@/components/common/Avatar.vue';
    import Navigator from '@/components/navigator/Navigator.vue';
    import {formatDate} from '@/utils/dates';
    import {editUserSelf, getTargetUser} from "@/api/user";
    import {showMessageError, showMessageSuccess} from "@/utils/message";
    const store = useStore();
    const router = useRouter();
    const route = useRoute();
    const dialogFormVisible = ref(false);
    const form = ref({
        owner: "",
        email: "",
        name: "",
        memo: "",
        created_at: 0,
        interests: [""]
    });
    const user = ref({
        owner: "",
        email: "",
        name: "",
        memo: "",
        created_at: 0,
        interests: []
    });
    const currentUserPrincipal = computed<string>(() => store.state.user.principal);
    const targetPrincipal = ref('');
    // 是否是本人。关联编辑按钮的显示与否
    const isOwner = computed<boolean>(
        () => currentUserPrincipal.value === targetPrincipal.value
    );
    const loading = ref(false);

    onMounted(() => {
        initPrincipal();
        initUser();
    });

    const initPrincipal = () => {
        // 获取 路由中的principal
        const principal = route.params.principal;
        targetPrincipal.value = principal.toString() || '';
        if (!targetPrincipal.value) {
            targetPrincipal.value = currentUserPrincipal.value;
        }
        // console.log('target principal', targetPrincipal.value);
        // console.log('current user principal', currentUserPrincipal.value);
        if (!targetPrincipal.value) {
            // 既没有登录也没有目标的 principal 就跳转首页
            console.log(
                'person profile: target principal is empty. goto home',
                currentUserPrincipal.value,
            );
            // router.push('/');
            return;
        }
    }

    const initUser = () => {
        getTargetUser(targetPrincipal.value).then(res => {
            console.log("getTargetUser", res)
            if (res.Ok) {
                user.value = res.Ok;
                form.value = {...user.value};
                //如果没有兴趣领域，添加一个空的先给表单用
                if (form.value.interests.length == 0) {
                    form.value.interests = [""];
                }
                console.log("getTargetUseruser.value", user.value)
                console.log("form.value", form.value)
            } else if (res.Err && res.Err.UserNotFound) {
                showMessageError("找不到目标用户信息");
                router.push('/');
            }
        })
    }

    const updateSelf = () => {
        loading.value = true;
        //TODO 想个办法给form加个初始值
        if (form.value) {
            editUserSelf(form.value).then(res => {
                console.log("edit", res)
                if (res.Ok) {
                    showMessageSuccess('信息更新成功');
                    dialogFormVisible.value = false;
                } else {
                    console.error("edit false", res)
                }
            }).finally(() => {
                loading.value = false
            })
        }
    }

    const addInterest = () => {
        form.value.interests.push("");
        console.log("user",user.value)
        console.log("form",form.value)
    }

    const removeInterest = (index) => {
        if (index !== -1) {
            form.value.interests.splice(index, 1)
        }
    }

</script>
<style lang="scss">
    .person-profile-user-container {
        margin-top: 30px;
        .el-icon {
            color: rgb(96, 98, 102);
            font-size: 20px;
        }
        .container {
            padding: 40px 40px;
            .avatar-container {
                align-items: start;
            }
            .user-profile {
                .el-row {
                    margin-bottom: 5px;
                    align-items: center;
                }
                .el-icon {
                    margin-right: 4px;
                }
                .title {
                    margin-bottom: 5px;
                }
            }
        }
    }
    .user-edit-dialog {
        .el-dialog__body {
            padding-top: 0;
        }
        .avatar-container {
            margin-bottom: 20px;
        }
    }
</style>
