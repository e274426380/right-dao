<template>
    <div class="home-public-container">
        <div class="container">
            <h2 class="hello">{{t('post.public.hello')}}✍</h2>
            <span>{{t('post.public.text')}}</span>
        </div>
    </div>
</template>
<script lang="ts" setup>
    import {t} from '@/locale';
</script>
<style lang="scss">
    .home-public-container {
        border-bottom: 1px solid rgb(228, 228, 231);
        background-color: rgb(255,255,255);
        .container{
            padding-top: 100px;
            padding-bottom: 100px;
            .hello{
                font-weight: 800;
            }
        }
    }
</style>
