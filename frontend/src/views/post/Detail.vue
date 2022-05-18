<template>
    <div class="post-detail-container">
        <Navigator/>
        <Head :post="post" @showWrite="showWriteReply(true)" v-if="post!==undefined"/>
        <WriteReply @foldWrite="showWriteReply(false)" @replySuccess="replyInit" v-show="showWrite"/>
        <div v-show="post!==undefined">
            <TimeLine :postId="postId" @changeStatusSuccess="init"/>
            <Reply :postId="postId" :ref="reply"/>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed} from 'vue';
    import Navigator from '@/components/navigator/Navigator.vue';
    import Head from './modules/Head.vue';
    import TimeLine from './modules/TimeLine.vue';
    import WriteReply from './modules/WriteReply.vue';
    import Reply from './modules/Reply.vue';
    import {useRoute} from 'vue-router';
    import {getPostInfo} from "@/api/post";
    import {ApiPost} from "@/api/types";
    import {useStore} from "vuex";

    const route = useRoute();
    const store = useStore();
    const postId = Number(route.params.id);
    const currentUserPrincipal = computed<string>(() => store.state.user.principal);
    // 是否是本人。关联编辑按钮的显示与否
    //本地环境下，author和current会有冲突。
    const isOwner = computed(() => {
        if (post.value) {
            return currentUserPrincipal.value === post.value.author.toString()
        }
    });
    const post = ref<ApiPost>();
    const reply = ref()
    const loading = ref(false);
    const showWrite = ref(false)

    onMounted(() => {
        init();
    });

    const replyInit = () => {
        reply.value.init();
    }

    const init = () => {
        loading.value = true;
        getPostInfo(postId).then(res=>{
            console.log("getPostInfo",res)
            if (res.Ok) {
                post.value = res.Ok
            }
        }).finally(() => {
            loading.value = false
        })
    }

    const showWriteReply = (show: boolean) => {
        showWrite.value = show
    }

</script>
<style lang="scss">
    .post-detail-container {
        background-color: rgb(246, 246, 246);
    }
</style>
