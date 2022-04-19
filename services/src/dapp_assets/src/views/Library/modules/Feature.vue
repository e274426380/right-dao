<template>
  <section class="bg-half">
    <div class="container">
      <el-row>
        <el-col :span="24">
          <p class="para-title">{{$t('library.feature.getStart')}}</p>
          <p class="para-subtext">{{$t('library.feature.subtext')}}</p>
        </el-col>
        <el-col :span="24" class="flex-center copy-input mb-4 mt-4">
          <el-col :lg="12" :md="12" :xs="24">
            <span class="input-title">1.{{$t('library.feature.install')}}</span>
          </el-col>
          <el-col :lg="12" :md="12" :xs="24">
            <p class="mb-0 code-show">
              <span v-html="code"></span>
            </p>
          </el-col>
          <!--<el-input v-model="code" readonly>-->
            <!--<template v-slot:suffix>-->
              <!--<i class="input-icon el-icon-document-copy" @click="copyToClipboard(code)"></i>-->
            <!--</template>-->
          <!--</el-input>-->
        </el-col>
        <el-col class="flex-center copy-input mb-4" v-for="(item,index) in features" :key="index">
          <el-col :lg="12" :md="12" :xs="24">
            <span class="input-title">{{index+2}}.{{item.title}}</span>
          </el-col>
          <el-col :lg="12" :md="12" :xs="24">
            <p class="mb-0 code-show">
              <span v-html="item.code"></span>
            </p>
          </el-col>
        </el-col>
      </el-row>
      <div class="row"></div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Feature',
  data() {
    return {
      code: '$ sh -ci "$(curl -fsSL https://sdk.dfinity.org/install.sh)"',
    }
  },
  computed:{
    features() {
      return [
        {
          title: this.$t('library.feature.start0'),
          code: "$ sudo apt install nodejs-legacy <br/>$ sudo apt install npm"
        },
        {
          title: this.$t('library.feature.start1'),
          code: "$ dfx new hello <br/>$ cd hello"
        },
        {
          title: this.$t('library.feature.start2'),
          code: "$ dfx start --background"
        },
        {
          title: this.$t('library.feature.start3'),
          code: "$ npm install <br/>$ dfx deploy"
        },
        {
          title: this.$t('library.feature.start4'),
          code: "$ dfx canister call hello greet everyone (\"Hello, everyone!\")"
        },
      ]
    }
  },
  methods: {
    // 复制模板内容
    copyTemplate() {
      this.copyToClipboard(this.code) // 需要复制的文本内容
    },
    // 点击复制到剪贴板函数
    copyToClipboard(content) {
      if (window.clipboardData) {
        window.clipboardData.setData('text', content)
        this.$message.success(this.$t('success'))
      } else {
        ;(function (content) {
          document.oncopy = function (e) {
            e.clipboardData.setData('text', content)
            e.preventDefault()
            document.oncopy = null
          }
        })(content)
        document.execCommand('Copy')
        this.$message.success(this.$t('success'))
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.bg-half {
  font-family: Roboto;
  color: #ffffff;
  padding: 0!important;
  .para-title {
    font-style: normal;
    font-weight: bold;
    font-size: 48px;
    line-height: 66px;
  }
  .para-subtext {
    font-style: normal;
    font-weight: 300;
    font-size: 18px;
    line-height: 21px;
    color: #ffffff;
    opacity: 0.8;
    margin-top: 24px;
  }
}
.flex-center {
  display: flex;
  align-items: flex-start;
  flex-wrap:wrap;
  padding-left: 0px !important;
  /*justify-content: space-between;*/
}

.copy-input ::v-deep .el-input {
  width: 60%;
  min-width: 200px;
}

.copy-input ::v-deep .el-input__inner {
  height: 48px;
  border-radius: 8px;
  font-size: 18px;
  font-weight: 400;
  color: #a1a1a1;
}
.input-title {
  font-family: Roboto;
  font-style: normal;
  font-weight: 500;
  font-size: 24px;
  line-height: 33px;
  display: inline-block;
  margin-bottom: 20px;
}
.input-icon {
  height: 48px;
  width: 27px;
  opacity: 0.8;
  line-height: 48px;
  cursor: pointer;
}
  .code-show{
    padding: 20px;
    border: 1px solid #B6FD21;
    border-radius: 20px;
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 18px;
    line-height: 21px;
    color: #B6FD21;
    opacity: 0.8;
    background-color: #17161D;
  }
</style>
