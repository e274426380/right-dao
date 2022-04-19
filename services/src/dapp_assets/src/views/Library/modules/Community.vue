<template>
  <section class="bg-half-170">
    <div class="container">
      <div class="forum">
        <el-button>{{$t('footer.head.community')}}</el-button>
      </div>
      <div class="Developer">
        <el-button>{{$t('library.community.blog')}}</el-button>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Community'
}
</script>

<style lang="scss" scoped>
  .bg-half-170 {
    background: rgba(255, 255, 255, 0.06);
    margin: 200px 0 150px 0;
    padding: 0;
    .container {
      display: flex;
      height: 300px;
      .Developer {
        background: url('@/assets/images/Frame-1.png');
      }
      .forum {
        background: url('@/assets/images/Frame.png');
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
          font-size: 32px;
          line-height: 37px;
          /* identical to box height */
          text-align: center;
          border: 1px solid #b6fd21;
          color: #ffffff;
        }
      }
    }
  }

.bg-half ::v-deep .el-card {
  background-color: #f0f2fe;
}

.bg-half ::v-deep .el-card__body {
  padding: 38px;
}

.card_box {
  display: flex;
  justify-content: space-between;

  &_left {
    flex: 1;

    h4 {
      line-height: 24px;
    }

    button {
      margin-top: 32px;
    }
  }
}
</style>
