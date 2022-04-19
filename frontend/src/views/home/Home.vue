<template>
    <div class="home-container">
        123
    </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';

const light = ref(false);

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
    .dummy {
        background-color: #2a064bff;
        width: 100%;
        height: 136px;
        display: none;
    }
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
