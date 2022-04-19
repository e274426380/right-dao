<template>
  <!--Upload Dapp Start-->
  <div class="dapp-wrapper">
    <el-form :model="dappForm" class="el-form-detail" ref="dappForm" label-width="100px" label-position="right" v-loading="loading">
      <div class="back" @click="$router.back(1)">返回></div>
      <template>
        <el-form-item label="活动信息" class="form-item-title" label-width="200px">
          <!--<el-button @click="test()">测试</el-button>-->
        </el-form-item>
        <el-form-item prop="name" label="名 称:" class="form-item-name" :rules="{
            required: true,
            message: '名称不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-input v-model="dappForm.name" placeholder="请输入活动名称" maxlength="64" show-word-limit></el-input>
        </el-form-item>
        <el-form-item style="margin-bottom: 40px" label="类  型:" prop="category" :rules="{
            required: true,
            message: '类型不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-radio-group v-model="dappForm.category">
            <el-radio v-for="tag in tags" :key="tag.key" :label="tag.key">{{
              tag.label
            }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item style="margin-bottom: 40px" label="活动时间:" prop="category" :rules="{
            required: true,
            message: '时间不能为空',
            trigger: 'blur'
          }" label-width="100px">
              <el-date-picker v-model="startTime"
                              type="datetime"
                              placeholder="请选择开始时间"
                              prefix-icon="">
              </el-date-picker>
              <span> - </span>
              <el-date-picker v-model="signUpEndTime"
                              type="datetime"
                              placeholder="请选择报名结束时间"
                              prefix-icon="">
              </el-date-picker>
              <span> - </span>
              <el-date-picker v-model="endTime"
                              type="datetime"
                              placeholder="请选择比赛结束时间"
                              prefix-icon="">
              </el-date-picker>
          <span class="img-tip">建议像素：1920*1080px，JPG、PNG格式，大小不超过2MB。</span>
        </el-form-item>
        <el-form-item style="margin-bottom: 40px" prop="photoUri.src" label="图  片:" :rules="{
            required: true,
            message: 'photo不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-upload class="img-uploader" :show-file-list="false" :before-upload="beforePhotoUpload">
            <img v-if="dappForm.photoUri.src" :src="dappForm.photoUri.src" class="img-photo" />
            <i v-else class="el-icon-plus img-photo-uploader-icon">
              <!-- <span style="font-size:17px">上传图片</span>  -->
            </i>
          </el-upload>
          <span class="img-tip">建议像素：1920*1080px，JPG、PNG格式，大小不超过2MB。</span>
        </el-form-item>
        <el-form-item style="margin-bottom:40px" prop="description" label="活动描述:" class="form-item-name" :rules="{
            required: true,
            message: '活动描述不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-input v-model="dappForm.description" placeholder="请用一句话介绍此次的活动。"></el-input>
        </el-form-item>
        <div v-for="(item, index) in dappForm.sponsors"
             :key="index">
          <el-form-item style="margin-bottom: 40px" prop="logoUri.src" label="赞助方:" label-width="100px"
                        :rules="{required: true,message: 'logo不能为空',trigger: 'blur'}"
                        :prop="'sponsors.' + index + '.logo'">
            <el-upload class="img-uploader" :show-file-list="false" :before-upload="beforeLogoUpload">
              <img v-if="dappForm.logoUri.src" :src="dappForm.logoUri.src" class="img-logo"/>
              <i v-else class="el-icon-plus img-logo-uploader-icon"></i>
            </el-upload>
            <span class="img-tip">建议像素：120（宽）*120（高），JPG、PNG格式，大小不超过100K。</span>
            <el-button v-if="index > 0" @click.prevent="removeSponsors(item)">删除</el-button>
          </el-form-item>
          <el-form-item style="margin-bottom:40px" prop="description" label-width="100px"
                        :rules="{required: true,message: '名字不能为空',trigger: 'blur' }"
                        :prop="'sponsors.' + index + '.name'">
            <el-input v-model="item.name" placeholder="请输入赞助方的名字">
            </el-input>
          </el-form-item>
          <el-form-item prop="detail" label-width="100px" :rules="{required: true,message: '网址不能为空',trigger: 'blur'}"
                        :prop="'sponsors.' + index + '.website'">
            <el-input placeholder="请输入赞助方的网址" v-model="item.website">
            </el-input>
          </el-form-item>
          <el-form-item label-width="100px" style="margin-bottom:40px">
            <div class="add-button" @click="addSponsors">
              <i class="el-icon-plus flex-add-button">
                <span style="font-size:17px">添加赞助方信息</span>
              </i>
            </div>
          </el-form-item>
        </div>
      </template>
      <el-form-item>
        <!--<template v-if="!detailStatus">-->
          <!--<el-button v-if="!detailStatus" style="margin-top:20px" class="form-btn btn-submit" @click="confirm('dappForm')">确认</el-button>-->
          <!--&lt;!&ndash; <el-button class="form-btn btn-cancel" @click="detailStatus=false">取消</el-button> &ndash;&gt;-->
        <!--</template>-->
        <template>
          <el-button style="margin-top:50px" class="form-btn btn-submit" @click="submitForm('dappForm')">保存</el-button>
          <el-button class="form-btn btn-cancel" @click="$router.back(1)">确定</el-button>
        </template>
        <!-- <el-button class="form-btn btn-cancel" @click="resetForm('dappForm')">重置</el-button> -->
      </el-form-item>
    </el-form>
  </div>
  <!--Upload Dapp End-->
</template>

<script>
import Bus from "a@/utils/bus";
import { transformArrayBufferToBase64 } from "a@/utils/utils";
export default {
  name: "LibraryHero",
  data() {
    return {
      dappData:"",
      dappForm: {
        name: "",
        description: "",
        logoUri: { src: "", type: "", buffer: "" },
        photoUri: { src: "", type: "", buffer: "" },
        sponsors:[
          {
            logo:"",
            name:"",
            website:""
          }
        ],
        category: "",
        detail: ""
      },
      startTime:"",
      signUpEndTime:"",
      endTime:"",
      logoChange: false,
      photoChange: false,
      loading: false,
      dialogVisible: false,
      tags: [
        {
          key: "0",
          label: "Infrastructure"
        },
        {
          key: "1",
          label: "Dapp"
        },
        {
          key: "2",
          label: "DeFi"
        },
        {
          key: "3",
          label: "Community"
        }
      ],
      detailStatus: false
    };
  },
  mounted(){
    // this.initForm()
  },
  methods: {
    test(){
      console.log("dappForm:");
      console.log(this.dappForm);
    },
    initForm(){
      let dappData=this.$route.query.dapp;
      let profile=dappData.dappStats.profile;
      this.dappForm.name = profile.name;
      this.dappForm.category = profile.category;
      this.dappForm.walletAddr = profile.walletAddr;
      this.dappForm.description = profile.description;
      this.dappForm.detail = profile.detail;
      this.dappForm.owner = profile.owner;
      this.dappForm.status = profile.status;
      this.dappForm.dappId =Number(profile.dappId);
      this.dappForm.logoId =Number(profile.logoId);
      this.dappForm.photoId =Number(profile.photoId);
      for (const item of profile.outerUri) {
        let content={
          value:"",
          valueKey:""
        };
        content.value=item[0];
        content.valueKey=item[1];
        this.dappForm.outerUri.push(content);
        console.log(  this.dappForm.outerUri);
      }
      this.dappForm.logoUri.type=dappData.logo.fileType;
      this.dappForm.logoUri.buffer=dappData.logo.content;
      this.dappForm.logoUri.src=transformArrayBufferToBase64(dappData.logo);
      this.dappForm.photoUri.type=dappData.photo.fileType;
      this.dappForm.photoUri.buffer=dappData.photo.content;
      this.dappForm.photoUri.src=transformArrayBufferToBase64(dappData.photo);
      console.log("dappData：");
      console.log(dappData);
      console.log("dappForm:");
      console.log(this.dappForm);

    },
    removeSponsors(item) {
      var index = this.dappForm.sponsors.indexOf(item);
      if (index !== -1) {
        this.dappForm.sponsors.splice(index, 1);
      }
    },
    addSponsors(){
      this.dappForm.sponsors.push({
        key: new Date(),
        logo:"",
        name:"",
        website:""
      });
    },
    async submitForm(formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          this.loading = true;
          // const owner = this.$store.state.user
          //   ? this.$store.state.user.principal
          //   : "";
          const outerUri = this.dappForm.outerUri
            .filter(item => item.value && item.valueKey)
            .map(item => [item.value, item.valueKey]);
          const {
            dappId,
            name,
            description,
            logoUri,
            photoUri,
            owner,
            walletAddr,
            category,
            detail,
            status,
          } = this.dappForm;
          let {
            logoId,
            photoId
          } = this.dappForm;
          //判断是否修改过图片
          if(this.logoChange===true){
            logoId = await this.uploadPhoto(logoUri);
            if (!logoId && logoId !== 0) {
              this.$message.error("logo图片上传失败");
              return false;
            }
          }
          if(this.photoChange===true){
            photoId = await this.uploadPhoto(photoUri);
            if (!photoId && photoId !== 0) {
              this.$message.error("photo图片上传失败");
              return false;
            }
          }
          const res = await this.$store.state.dapp.editDapp(
            dappId,
            name,
            description,
            logoId,
            photoId,
            outerUri,
            owner,
            walletAddr,
            category,
            detail,
            status
          );
          this.loading = false;
          if (Object.keys(res)[0] === "ok") {
            this.$message.success("提交修改成功");
            Bus.$emit("uploadDappSuccess");
          } else {
            this.$message.error("提交修改失败");
          }
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    beforeLogoUpload(file) {
      this.dappForm.logoUri.type = file.type;
      const isLt1M = file.size / 1024 / 1024 < 0.1;

      // if (!isPng) {
      //   this.$message.error("上传头像的图片不是Png");
      //   return;
      // }
      if (!isLt1M) {
        this.$message.error("上传头像图片大小不能超过 100k!");
        return false;
      }

      let reader = new FileReader();
      reader.readAsArrayBuffer(file);
      // reader.readAsDataURL(file);
      reader.onload = e => {
        this.dappForm.logoUri.buffer = Array.from(
          new Uint8Array(e.target.result)
        );
        this.dappForm.logoUri.src = transformArrayBufferToBase64({
          content: this.dappForm.logoUri.buffer,
          fileType: this.dappForm.logoUri.type
        });
        this.logoChange=true;
      };
      // this.dappForm.logoUri = URL.createObjectURL(file);
      // return isJPG && isLt2M;
    },
    beforePhotoUpload(file) {
      this.dappForm.photoUri.type = file.type;
      const isLt5M = file.size / 1024 / 1024 < 2;

      // if (!isPng) {
      //   this.$message.error("上传头像的图片不是Png");
      // }
      if (!isLt5M) {
        this.$message.error("上传头像图片大小不能超过 2MB!");
        return false;
      }

      let reader = new FileReader();
      reader.readAsArrayBuffer(file);
      // reader.readAsDataURL(file);
      reader.onload = e => {
        this.dappForm.photoUri.buffer = Array.from(
          new Uint8Array(e.target.result)
        );
        this.dappForm.photoUri.src = transformArrayBufferToBase64({
          content: this.dappForm.photoUri.buffer,
          fileType: this.dappForm.photoUri.type
        });
        this.photoChange=true;
      };
      // this.dappForm.logoUri = URL.createObjectURL(file);
      // return isJPG && isLt2M;
    },
    clickExplore(id) {
      // document.querySelector("#" + id).scrollIntoView();
    },
    async uploadPhoto(bytes) {
      return await this.$store.state.dapp
        .uploadDappPic(
          {
            content: bytes.buffer,
            fileType: bytes.type
          },
          ""
        )
        // .uploadPictureBlob(base64ToBlob(reader.result))
        .then(async res => {
          console.log(res);
          return res.ok;
        })
        .catch(err => {
          console.log(err);
          return "false";
        });
    },
    confirm(formName) {
      this.$refs[formName].validate(async valid => {});
      if (this.dappForm.name) {
        this.detailStatus = true;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.bg-half-170 {
  background: url("~@/assets/images/bg_dapp.png") top;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  z-index: -1;
}
.bg-half-170-detail {
  padding: 60px 0 20px;
}

.title-heading {
  line-height: 26px;
  margin-top: 3.5rem;
  .el-button {
    width: 141px;
    height: 40px;
    background: #425ce1;
    opacity: 0.85;
    border-radius: 6px;
    color: #fff;
    margin-top: 80px;
    float: right;
    span {
      font-family: Helvetica;
      font-weight: bold;
      color: #ffffff;
    }
  }
}

.title-heading .heading {
  font-size: 45px !important;
  letter-spacing: 1px;
  text-align: right;
}
.el-date-editor.el-input, .el-date-editor.el-input__inner {
  width: 200px;
}
.el-range__icon {
  display: none;
}
@media (max-width: 768px) {
  .title-heading .heading {
    font-size: 35px !important;
  }
}

.title-heading .text-muted {
  text-align: right;
  font-size: 36px;
  font-family: JetBrains Mono;
  font-weight: 400;
  color: #1f1f1f !important;
  line-height: 49px;
  opacity: 0.6;
}

/*上传头像*/
.img-uploader >>> .el-upload {
  background: #fbfdff;
  border: 2px dashed #9d9d9d;
  border-radius: 8px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.img-uploader >>> .el-upload:hover {
  border-color: #409eff;
}
.img-logo-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
}
.img-photo-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 641px;
  height: 190px;
  line-height: 190px;
  text-align: center;
}
.img-logo {
  width: 120px;
  height: 120px;
  display: block;
}
.img-photo {
  width: 641px;
  height: 190px;
  display: block;
}
.img-to-bottom {
  position: relative;
  top: 60px;
  z-index: 999;
}
.img-tip {
  font-size: 14px;
  font-family: PingFang SC;
  font-weight: 400;
  color: #a8a8a8;
  line-height: 30px;
  margin-bottom: 0;
}
.dapp-wrapper {
  z-index: 0;
}
/deep/.el-form {
  background-color: #fff;
  width: 70%;
  padding: 6% 10%;
  position: relative;
  .back {
    font-size: 24px;
    font-family: Adobe Heiti Std;
    font-weight: normal;
    color: #727272;
    line-height: 30px;
    cursor: pointer;
    position: absolute;
    right: 30px;
    top: 20px;
  }
  .el-form-item {
    .el-form-item__label {
      font-size: 16px;
      font-family: PingFang SC;
      font-weight: bold;
      color: #333333;
    }
    .outerUri-label {
      text-decoration: underline;
      text-underline-position: under;
      cursor: pointer;
    }
    .el-form-item__content {
      max-width: 646px;
      .el-radio {
        color: #a8a8a8;
        font-size: 18px;
        font-weight: bold;
      }
      .el-input {
        input {
          border-radius: 8px;
          border: 2px solid #9d9d9d;
        }
      }
      .el-textarea {
        textarea {
          border: 2px solid #9d9d9d;
          border-radius: 8px;
        }
      }
      .form-btn {
        border-radius: 8px;
        font-size: 18px;
        font-family: PingFang SC;
        font-weight: 400;
        color: #ffffff;
        line-height: 30px;
        padding: 4px 40px;
      }
      .btn-submit {
        background: #5c72e5;
      }
      .btn-cancel {
        border: 2px solid #9d9d9d;
        color: #727272;
      }
    }
  }
  .form-item-title {
    .el-form-item__label {
      text-align: left !important;
      font-size: 26px !important;
      font-family: PingFang SC;
      font-weight: bold !important;
    }
  }
}
.el-form-detail {
  width: 100% !important;
  margin: 10px auto 0 !important;
  padding: 1% 14% 7% !important;
}
  .add-button{
    background: #fbfdff;
    border: 2px dashed #9d9d9d;
    border-radius: 8px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    font-size: 28px;
    color: #8c939d;
    text-align: center;
    &:hover{
      border: 2px dashed #409EFF;
      transition: 0.2s;
    }
  }
  .flex-add-button{
    display: flex;
    justify-content:center;
    align-items: center;
    margin: 10px 0;
  }
</style>
