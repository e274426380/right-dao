<template>
    <div class="person-profile-user-container">
        <div class="container">
            <el-row>
                <el-col :span="3" :offset="3" style="display: inherit;">
                    <Avatar :username="'E'"
                            :principal-id="'E'"
                            :avatar-id="0"
                            :clickable="false"
                            :size="120"/>
                </el-col>
                <el-col :span="15">
                    <div class="user-profile">
                        <el-row justify="space-between" class="title">
                            <div class="flex-y-center">
                                {{user?.name ?  user?.name : "ELON MASK"}}
                            </div>
                            <el-button v-if="isOwner" @click="dialogFormVisible = true">
                                编辑
                            </el-button>
                        </el-row>
                        <el-row>
                            {{ targetPrincipal }}
                        </el-row>
                        <el-row>
                            {{user?.email ?  user?.email : "undead@gmail.com"}}
                        </el-row>
                        <el-row>
                            {{user?.memo ?  user?.memo : "签名签名签名签名"}}
                        </el-row>
                        <el-row justify="space-between">
                            <div>
                                兴趣领域：律师
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
        <Avatar :username="'E'"
                :principal-id="'E'"
                :avatar-id="0"
                :clickable="false"
                :size="100"/>
        <el-form :model="form">
            <el-form-item label="用户名：">
                <el-input v-model="form.name" />
            </el-form-item>
            <el-form-item label="邮箱：">
                <el-input v-model="form.email" />
            </el-form-item>
            <el-form-item label="签名：">
                <el-input v-model="form.memo" />
            </el-form-item>
        </el-form>
        <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogFormVisible = false">Cancel</el-button>
        <el-button type="primary" @click="updateSelf()" :loading="loading">Confirm</el-button>
      </span>
        </template>
    </el-dialog>
</template>
<script lang="ts" setup>
    import {ref, onMounted,computed} from 'vue';
    import { useStore } from 'vuex';
    import {useRoute, useRouter} from 'vue-router';
    import {t} from '@/locale';
    import  {ElRow, ElCol, ElButton, ElDialog, ElForm, ElFormItem, ElInput,ElMessage} from 'element-plus/es';
    import Avatar from '@/components/common/Avatar.vue';
    import Navigator from '@/components/navigator/Navigator.vue';
    import { formatDate, parseNs2Date } from '@/utils/dates';
    import {ApiUserInfo} from "@/api/types";
    import {editUserSelf, getTargetUser} from "@/api/user";
    import {showMessageError, showMessageSuccess} from "@/utils/message";
    import {UserInfo} from "@/types/user";
    const store = useStore();
    const router = useRouter();
    const route = useRoute();

    const dialogFormVisible = ref(false);
    type User = ApiUserInfo;
    const form = ref<User>(new UserInfo());
    const user = ref<User>();
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
        targetPrincipal.value = principal?.toString() || '';
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
                form.value = res.Ok;
                console.log("getTargetUseruser.value", user.value)
            }else if(res.Err && res.Err.UserNotFound){
                showMessageError("找不到目标用户信息");
                router.push('/');
            }
        })
    }

    const updateSelf = () => {
        loading.value = true;
        //TODO 想个办法给form加个初始值
        if(form.value){
            editUserSelf(form.value).then(res => {
                console.log("eidt", res)
                if(res.Ok){
                    showMessageSuccess('信息更新成功');
                    dialogFormVisible.value = false;
                } else {
                    console.error("edit false",res)
                }
            }).finally(() => {
                loading.value = false
            })
        }
    }

</script>
<style lang="scss">
    .person-profile-user-container {
        margin-top: 30px;
        .container{
            padding: 40px 40px;
            .avatar-container{
                align-items:start;
            }
            .user-profile{
                .el-row{
                    margin-bottom: 5px;
                }
                .title{
                    margin-bottom: 5px;
                }
            }
        }

    }
    .user-edit-dialog{
        .el-dialog__body{
            padding-top: 0;
        }
        .avatar-container{
            margin-bottom: 20px;
        }
    }
</style>
