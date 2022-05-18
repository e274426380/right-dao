<template>
    <div class="post-reply-reply-container">
        <el-dialog
            v-model="dialogVisible"
            title="Tips"
            width="30%"
            :before-close="handleClose"
        >
            <span>This is a message</span>
            <template #footer>
      <span class="dialog-footer">
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="dialogVisible = false"
        >Confirm</el-button
        >
      </span>
            </template>
        </el-dialog>
    </div>
</template>
<script lang="ts" setup>
    import {ref, onMounted, computed, defineProps} from 'vue';
    import {ElRow, ElCol, ElButton, ElCard, ElDialog} from 'element-plus/es';

    const props = defineProps({
        showDialog: {
            type: Boolean,
            required: true,
            default: false
        },
        replyId: {
            type: Number,
            required: true
        }
    });
    const dialogVisible =ref(props.showDialog);

    onMounted(() => {
    });


</script>
<style lang="scss">
    .post-reply-reply-container {
        background-color: rgb(246, 246, 246);
    }
</style>
