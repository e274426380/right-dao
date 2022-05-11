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
    import {useStore} from "vuex";

    const route = useRoute();
    const store = useStore();
    const postId = route.params.id;
    const currentUserPrincipal = computed<string>(() => store.state.user.principal);
    // 是否是本人。关联编辑按钮的显示与否
    const isOwner = computed<boolean>(
        //本地环境下，author和current会有冲突。
        () => currentUserPrincipal.value === post.value.author.toString()
    );
    const post = ref<ApiPost>();
    const loading = ref(false);

    onMounted(() => {
        init();
    });

    const init = () => {
        loading.value = true;
        getPost(Number(postId)).then(res => {
            console.log("getPost", res)
            if (res.Ok) {
                post.value = res.Ok
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
