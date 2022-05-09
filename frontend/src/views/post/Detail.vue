<template>
    <div class="post-detail-container">
        <Navigator/>
        <Head/>
        <TimeLine />
    </div>
</template>
<script lang="ts" setup>
    import Navigator from '@/components/navigator/Navigator.vue';
    import Head from './modules/Head.vue';
    import TimeLine from './modules/TimeLine.vue';

</script>
<style lang="scss">
    .post-detail-container {
        background-color: rgb(246,246,246);
    }
</style>
