<template>
    <div class="post-detail-container">
        <Navigator/>
        <Head :post="post" v-if="post!==undefined"/>
        <TimeLine />
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed} from 'vue';
    import Navigator from '@/components/navigator/Navigator.vue';
    import Head from './modules/Head.vue';
    import TimeLine from './modules/TimeLine.vue';
    import {useRoute} from 'vue-router';
    import {getPost} from "@/api/post";
    import {ApiPost} from "@/api/types";

    const route = useRoute();
    const postId = route.params.id;
    const post = ref<ApiPost>();
    const loading = ref(false);

    onMounted(() => {
        init();
    });

    const init = () => {
        console.log(post.value)
        loading.value = true;
        getPost(Number(postId)).then(res => {
            console.log("getPost", res)
            if (res.Ok) {
                post.value = res.Ok
                console.log(post.value)
            }
        }).finally(() => {
            loading.value = false
        })
    }

</script>
<style lang="scss">
    .post-detail-container {
        background-color: rgb(246,246,246);
    }
</style>
