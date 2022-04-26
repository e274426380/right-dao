<template>
    <div class="home-container">
        <Navigator/>
        <Public/>
    </div>
</template>

<script lang="ts" setup>
import Navigator from '@/components/navigator/Navigator.vue';
import Public from './modules/Public.vue';

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
