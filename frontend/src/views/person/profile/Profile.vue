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
</style>
