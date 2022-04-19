<template>
  <section class="bg-half">
    <div class="container">
      <el-row>
        <el-col :span="24">
          <el-row class="flex-center item-head" type="flex" justify="space-between">
            <div>
              <span>{{$t('library.official.title')}}</span>
            </div>
          </el-row>
          <el-row>
            <div style="float: right">
              <!--<button class="btn btn-primary btn-sm">{{$t('button.more')}}</button>-->
              <!--<a class="href-button" href="">More and more>></a>-->
            </div>
          </el-row>
          <hr class="i-hr"/>
          <el-row>
            <el-col :span="24" class="item-card" v-for="(item, index) in forumData" :key="index">
              <el-col :sm="6" :xs="24" class="item-img">
                <el-image alt="" :src="item.imgSrc"  fit="fill">
                  <div slot="error" class="image-slot">
                  </div>
                </el-image>
              </el-col>
              <el-col :sm="18" :xs="24" class="item-text">
                <a target="_blank" :href="'https://www.icpleague.com/thread/'+item.threadId">
                  <div class="item-text-head">
                    <span>{{ item.title }}</span>
                  </div>
                  <div class="item-content">
                    {{ item.content }}
                  </div>
                  <div class="item-bottom">
                    <span>{{ item.createdAt }}</span>
                    <!--<span>{{ item.startDate }} - {{ item.endDate }}</span>-->
                  </div>
                </a>
              </el-col>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </div>
  </section>
</template>

<script>
  import request from '@/utils/request.js'
  export default {
    name: 'Official',
    data() {
      return {
        //论坛数据
        //现在使用threadId来定位超链接，而不是url
        forumData: [
        ],
      }
    },
    mounted() {
      this. getForumEssence();
    },
    methods:{
      getForumEssence(){
        //filter[isEssence] 是否顶置
        //filter[categoryId]分类ID
        //sort 按创建时间倒序
        request({
          url:"/threads",
          method:"get",
          params:{
            page:1,
            include:"firstPost.images",
            perPage:10,
            include:"user",
            "filter[categoryId]":1,
            sort:"-createdAt",
            // page:1,
            // perPage:10,
            // "filter[sticky]":0,
            // "filter[essence]":0,
            // "filter[attention]":0,
            // "filter[categoryids][0]":1,
          }
        }).then((resp)=>{
          //只取官方发布的最近3个
          const forumData=resp.data.slice(0,10);
          //正则表达式，过滤文章内容，移除[]，()，<>及其内容，还有感叹号！星号*，用于处理一些不协调的网页元素
          const regex=/\[.*?\]|\<.*?\>|\(.*?\)|[!*#]|\#.*?\#/g;
          //length=3，限制只显示3个公告
          for (let i = 0,length=3; i <length; i++) {
            let items={};
            //开始识别第一张图片
            let imgStart="https://icpleague.com/storage";
            const endPNG="_thumb.png";
            const endJPG="_thumb.jpg";
            let str=forumData[i].attributes.postContent;
            //开始位置
            const start = str.indexOf(imgStart);
            //结束位置，再加结尾的长度，即可知道整个字符串的位置
            let end = str.indexOf(endJPG)!==-1?str.indexOf(endJPG):str.indexOf(endPNG);
            end=end+endJPG.length;
            items.imgSrc=str.slice(start,end);
            if(items.imgSrc===""||items.imgSrc==null){
              //当图片不存在的时候，不显示这个文章
              length++;
              continue;
            }
            //结束识别第一张图片
            //只留首字母大写
            items.threadId=forumData[i].id;
            items.title=forumData[i].attributes.title;
            items.createdAt=forumData[i].attributes.createdAt;
            //slice去掉末尾的毫秒，并替换掉字符串中的T为空格
            items.createdAt=items.createdAt.slice(0,items.createdAt.length-6).replace("T"," ");
            forumData[i].attributes.postContent=forumData[i].attributes.postContent.replace(regex,'');
            //裁掉末尾，现在显示多少行字由CSS样式控制
            // this.forumData[i].content=forumData[i].attributes.postContent.slice(0,300)+"...";
            items.content=forumData[i].attributes.postContent;

            this.forumData.push(items);
          }
        }).catch((error)=>{

        })
      },
    },
  }
</script>
<style lang="scss" scoped>
  .bg-half {
    padding: 164px 0 36px 0;
  }

  .flex-center {
    display: flex;
    align-items: center;
  }
  .i-hr{
    color: #FFFFFF;
    width:110%;
    position: relative;
    right: 5%;
  }
  .item-head span:first-child {
    display: block;
    font-family: Roboto;
    font-style: normal;
    font-weight: bold;
    font-size: 48px;
    line-height: 66px;
    color: #FFFFFF;
  }
  .item-head span:nth-child(2) {
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 18px;
    line-height: 21px;
    color: #FFFFFF;
    opacity: 0.8;
  }
  .more-button {
    width: 88px;
    height: 40px;
    border-radius: 8px;
    padding-bottom: 0;
    padding-top: 0;
    font-size: 18px;
    font-family: SourceHanSansCN;
    font-weight: 400;
  }
  .item-card {
    /*background: rgba(255, 255, 255, 0.2);*/
    position: relative;
    border-radius: 8px;
    width: 100%;
    margin-top: 36px;
    margin-bottom: 36px;
  }
  .item-img {
    height: 210px;
  }
  .item-img img {
    width: 100%;
    height: 100%;
    border-radius: 24px;
  }
  .el-image{
    width: 100%;
    height: 100%;
    border-radius: 24px;
  }
  .item-text {
    padding: 0 20px 20px 20px;;
  }
  .item-text-head {
    font-family: Roboto;
    font-style: normal;
    font-weight: bold;
    font-size: 24px;
    line-height: 28px;
    padding-bottom: 14px;
    color: #FFFFFF;
  }
  .item-content {
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 18px;
    line-height: 21px;
    color: #FFFFFF;
    opacity: 0.6;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    /*保留X行文字*/
    -webkit-line-clamp: 3;
    overflow: hidden;
  }
  .item-bottom{
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 18px;
    line-height: 16px;
    color: #FFFFFF;
    position:absolute;
    bottom:0px;
    opacity: 0.6;
  }
  .href-button{
    font-family: Roboto;
    font-style: normal;
    font-weight: 300;
    font-size: 14px;
    line-height: 16px;
    text-decoration-line: underline!important;
    color: #B6FD21;
    opacity: 0.8;
  }
  .section-title {
    display: block;
    font-size: 26px;
    font-weight: 600;
    color: #333333;
  }
  .community-card {
    padding: 40px !important;
    background: #f0f2fe;
    border-radius: 8px;
  }
  .community-title {
    margin-top: 0;
    margin-bottom: 100px;
  }
  .footer-title {
    font-size: 26px;
    display: block;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #8590a6;
  }
  .footer-subtitle {
    display: block;
    margin-top: 19px;
    margin-bottom: 37px;
    font-size: 18px;
    font-family: JetBrains Mono;
    font-weight: 600;
    color: #8590a6;
  }
  .email-input {
    margin-bottom: 90px;
  }
  .email-input ::v-deep .el-input {
    width: 60%;
    min-width: 200px;
  }
  .email-input ::v-deep .el-input__inner {
    height: 48px;
    border-radius: 8px;
    font-weight: 400;
    font-size: 18px;
    font-family: SourceHanSansCN;
  }
  .sign {
    width: 116px !important;
    height: 40px;
    font-size: 18px;
    font-weight: 600;
    border-radius: 20px;
    margin-left: 36px;
  }
</style>
