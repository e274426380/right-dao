<template>
  <div class="home">
    <PageNavbar />
    <DappHero />
    <DappSection />
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from '@/components'
import { DappHero, DappSection } from './modules'
export default {
  name: 'Dapp',
  components: { PageNavbar, PageFooter, DappHero, DappSection }
}
</script>
<style>
  .home {
    background: #000000;
  }
</style>
