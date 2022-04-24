<template>
    <div class="home-container">
        <Navigator/>
    </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import Navigator from '@/components/navigator/Navigator.vue';

const light = ref(true);

const onScroll = () => {
    // 当前滚动位置
    let scrollTop =
        window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
    light.value = scrollTop !== 0;
};

onMounted(() => {
    window.onscroll = onScroll;
});
</script>

<style lang="scss">
.home-container {
    background-color: white;
    color: black;
    width: 100%;
    height: 100%;
    .homeNav {
        position: relative;
        z-index: 1200;
    }
}
@media screen and (max-width: 1100px) {
    .home-container {
        .dummy {
            display: block;
        }
    }
}
</style>
