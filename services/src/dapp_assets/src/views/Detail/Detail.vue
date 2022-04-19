<template>
  <div class="detail-wrapper">
    <PageNavbar />
    <DetailSection />
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from '@/components'
import DetailSection from './modules/Section.vue'
export default {
  name: 'Detail',
  components: { PageNavbar, PageFooter, DetailSection }
}
</script>
<style lang="scss">
  .detail-wrapper {
    background: #000000;
  }
</style>