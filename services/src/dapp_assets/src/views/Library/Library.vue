<template>
  <div class="home">
    <PageNavbar />
    <LibraryHero />
    <LibraryFeature />
    <LibraryWhant />
    <LibraryActivity />
    <LibraryOfficial/>
    <!--<LibraryCommunity />-->
    <PageFooter />
  </div>
</template>

<script>
import { PageNavbar, PageFooter } from '@/components'
import { LibraryHero, LibraryFeature, LibraryWhant, LibraryActivity, LibraryCommunity,LibraryOfficial } from './modules'
export default {
  name: 'Library',
  components: { PageNavbar, LibraryHero, LibraryFeature, LibraryWhant, LibraryActivity, LibraryCommunity,LibraryOfficial, PageFooter }
}

</script>
<style>
  .home {
    background: #000000;
  }
</style>
