<template>
    <div class="person-profile-container">
        <Navigator/>
        <ProfileUser />
        <ProfileList />
    </div>
</template>
<script lang="ts" setup>
    import Navigator from '@/components/navigator/Navigator.vue';
    import ProfileUser from './modules/ProfileUser.vue';
    import ProfileList from './modules/ProfileList.vue';

</script>
<style lang="scss">
    .person-profile-container{
        .user-edit-dialog{
            .el-form{
                .el-form-item{
                    .el-form-item__label{
                        padding: 6px 12px 0 0;
                    }
                }
                .el-form-item__content{
                    .el-input-group__append{
                        .el-button{
                            display: flex;
                        }
                    }
                }
                .el-icon{
                    font-size: 20px;
                }
            }
        }
    }
</style>
