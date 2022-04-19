<template>
    <div class="footer-container">
        <FollowUs class="follow-us" />
        <Additions class="additions" />
        <Copyright class="copyright" />
    </div>
</template>
<script lang="ts" setup>
import FollowUs from './FollowUs.vue';
import Additions from './Additions.vue';
import Copyright from './Copyright.vue';
</script>
<style lang="scss">
.footer-container {
    background-color: black;
    padding-top: 100px;
    padding-bottom: 50px;
    .additions {
        margin-top: 100px;
    }
    .copyright {
        margin-top: 100px !important;
    }
}
</style>
