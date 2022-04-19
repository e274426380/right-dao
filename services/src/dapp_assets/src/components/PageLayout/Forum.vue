<template>
  <section class="bg-half-170">
    <div class="container">
      <div class="forum">
        <el-button class="btn btn-primary" @click="openLink('https://icpleague.com/')">{{$t('footer.head.forum')}}</el-button>
      </div>
      <div class="Developer">
        <el-button class="btn btn-primary" @click="openLink('https://shuzhichengspace.gitbook.io/dfinity/yi-kuai-su-ru-men')">{{$t('footer.head.developer')}}</el-button>
        <!-- <el-button class="btn btn-primary" @click="openLink('https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html')">Developer Center</el-button> -->
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: "HomeForum",
  methods: {
    openLink(url) {
      window.open(url);
    }
  }
};
</script>

<style lang="scss" scoped>
.bg-half-170 {
  background: rgba(255, 255, 255, 0.06);
  //   height: 600px;
  margin: 100px 0;
  padding: 0;

  .container {
    display: flex;
    flex-wrap: wrap;
    height: 300px;
    .Developer {
      background: url("@/assets/images/Frame-1.png");
    }
    .forum {
      background: url("@/assets/images/Frame.png");
    }
    .Developer,
    .forum {
      display: flex;
      align-items: center;
      justify-content: center;
      flex-basis: 50%;
      .el-button {
        line-height: 37px;
        background: transparent;
        font-family: Roboto;
        font-style: normal;
        font-weight: bold;
        font-size: 24px;
        line-height: 37px;
        /* identical to box height */
        text-align: center;
        border: 1px solid #b6fd21;
        color: #ffffff;
      }
    }
  }
}
</style>
