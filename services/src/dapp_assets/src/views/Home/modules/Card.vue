<template>
  <section class="section">
    <div class="container">
      <el-row :gutter="40" class="card_row">
        <el-col :md="12" :xs="24">
          <el-card class="mb-3">
            <div slot="header" class="card_header">
              <el-image class="card_header_image" :src="developer" />
              <span class="card_header_title">{{ $t('home.feature.card.left') }}</span>
            </div>
            <div>
              <a href="https://shuzhichengspace.gitbook.io/dfinity/yi-kuai-su-ru-men" class="text-dark">
                一、快速入门 DFINITY Canister软件...
              </a>
              <el-divider></el-divider>
              <a href="https://shuzhichengspace.gitbook.io/dfinity/er-ji-ben-gai-nian" class="text-dark">
                二、基本概念 在Internet Computer...
              </a>
              <el-divider></el-divider>
              <a href="https://shuzhichengspace.gitbook.io/dfinity/san-shou-ba-shou" class="text-dark">
                三、手把手 Canister SDK-开发工具...
              </a>
              <el-divider></el-divider>
              <a href="https://shuzhichengspace.gitbook.io/dfinity/si-.-jiao-cheng" class="text-dark">
                四、教程 接下来，我们将探索编写...
              </a>
              <el-divider></el-divider>
              <a href="https://shuzhichengspace.gitbook.io/dfinity/">
                <el-button class="bottom-button" type="primary">{{ $t('home.feature.card.buttonleft') }} </el-button>
              </a>
            </div>
          </el-card>
        </el-col>
        <el-col :md="12" :xs="24">
          <el-card>
            <div slot="header" class="card_header">
              <el-image class="card_header_image" :src="book" />
              <span class="card_header_title">{{ $t('home.feature.card.right') }}</span>
            </div>
            <div class="card-text" v-for="(data, index) in forumData" :key="index">
              <a :href="'https://www.icpleague.com/thread/' + data.threadId" class="text-dark">
                {{ data.title }}
                <!--最后一根线不显示-->
                <el-divider />
                <!-- <div v-else style="padding-bottom: 20px"></div> -->
              </a>
            </div>
            <a href="https://www.icpleague.com/">
              <el-button class="bottom-button" type="primary">{{ $t('home.feature.card.buttonright') }}</el-button>
            </a>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
import request from '@/utils/request'
import developer from '../../../assets/images/developer.png'
import book from '../../../assets/images/book.png'
export default {
  name: 'HomeCard',
  data() {
    return {
      book,
      developer,
      forumData: [
        {
          title: 'DFINITY链上钱包创建流程',
          content:
            '一、准备好环境及相关硬件\n' + '\n' + '1.1 因为Dfinity钱包是与U2F硬件设备绑定的，所以iPhone,带指纹识别...',
          url: 'https://www.icpleague.com/thread/59',
          threadId: '59',
          username: 'Turbo',
          // 头像地址
          avatarUrl: ''
        },
        {
          title: '如何使用DFINITY的治理系统赚取ICP？',
          content:
            '注意：目前NNS刚投入使用100小时，可能存在BUG，请保证手续费充足，谨慎操作！\n' +
            '\n' +
            '上一篇文章介绍了如何...',
          url: 'https://www.icpleague.com/thread/47',
          threadId: '47',
          username: 'Turbo',
          // 头像地址
          avatarUrl: ''
        },
        {
          title: 'DFINITY链上钱包创建流程',
          content:
            '一、准备好环境及相关硬件\n' + '\n' + '1.1 因为Dfinity钱包是与U2F硬件设备绑定的，所以iPhone,带指纹识别...',
          url: 'https://www.icpleague.com/thread/59',
          threadId: '59',
          username: 'Turbo',
          // 头像地址
          avatarUrl: ''
        },
        {
          title: '如何使用DFINITY的治理系统赚取ICP？',
          content:
            '注意：目前NNS刚投入使用100小时，可能存在BUG，请保证手续费充足，谨慎操作！\n' +
            '\n' +
            '上一篇文章介绍了如何...',
          url: 'https://www.icpleague.com/thread/47',
          threadId: '47',
          username: 'Turbo',
          // 头像地址
          avatarUrl: ''
        }
      ],
      rightText: [
        '我是文本描述文本描述文本描述文本描述1',
        '我是文本描述文本描述文本描述文本描述2',
        '我是文本描述文本描述文本描述文本描述3',
        '我是文本描述文本描述文本描述文本描述4'
      ]
    }
  },
  mounted() {
    this.getForumEssence()
  },
  methods: {
    getForumEssence() {
      request({
        url: '/threads',
        method: 'get',
        params: {
          include: 'user',
          'filter[isEssence]': 'yes',
          sort: '-createdAt'
        }
      }).then(resp => {
        // 只取精华贴的最近4个
        const forumData = resp.data.slice(0, 4)
        // 获取精华贴中包含的用户名，用来和贴子的作者匹配
        let user = resp.included.filter(function (user) {
          return user.type === 'users'
        })
        // 正则表达式，过滤文章内容，移除[]，()及其内容，还有感叹号！星号*，用于处理一些不协调的网页元素
        // eslint-disable-next-line no-useless-escape
        let regex = /\[.*?\]|\(.*?\)|[!*]|\#.*?\#/g
        // 提前定义length，优化下for循环效率
        for (let i = 0, length = forumData.length; i < length; i++) {
          // 标题只留0到25个字符，并在结尾加上...
          this.forumData[i].title = forumData[i].attributes.title.slice(0, 25) + '...'
          const poster = user.find(user => user.id === forumData[i].relationships.user.data.id)
          // 只留首字母大写
          this.forumData[i].username = poster.attributes.username.slice(0, 1).toUpperCase()
          this.forumData[i].threadId = forumData[i].id
          // 正则表达式筛选贴子内容
          forumData[i].attributes.postContent = forumData[i].attributes.postContent.replace(regex, '')
          // 内容只留0到55个字符，并在结尾加上...
          this.forumData[i].content = forumData[i].attributes.postContent.slice(0, 55) + '...'
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.section {
  background-color: #eaeef6;
  padding: 0;
}

.section ::v-deep .el-card {
  border-radius: 36px;
}

.card_row {
  position: relative;
  top: 120px;
  z-index: 999;
}

.card_header {
  display: flex;
  align-items: center;

  &_image {
    width: 50px;
    height: 50px;
    border-radius: 50%;
  }

  &_title {
    font-size: 18px;
    margin-left: 20px;
  }
}

.bottom-button {
  border-radius: 8px;
  float: right;
  margin-top: 36px;
  margin-right: 20px;
  margin-bottom: 20px;
  padding: 5px 10px;
  height: 40px;
  /*width: 89px;*/
  border-color: rgba(66, 92, 225, 0.85)!important;
  font-size: 18px;
  font-weight: 400;
  color: #fefeff;
  background-color: rgba(66, 92, 225, 0.85)!important;
  transition: 0.2s;
}
.bottom-button:hover {
  /*border:2px solid rgba(66, 92, 225, 0.85);*/
  background-color: rgba(66, 92, 225, 1) !important;
  border-color: rgba(66, 92, 225, 1) !important;
  font-weight: 600;
  color: #ffffff;
}
</style>
