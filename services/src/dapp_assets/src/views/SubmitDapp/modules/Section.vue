<template>
  <!--Upload Dapp Start-->
  <div class="dapp-wrapper">
    <div class="bg-half-170" :class="detailStatus? 'bg-half-170-detail' : ''"></div>
    <el-form :model="dappForm" :class="detailStatus? 'el-form-detail' : ''" ref="dappForm" label-width="100px" label-position="right" v-loading="loading">
      <div class="back" @click="$router.back(1)">返回></div>
      <template v-if="!detailStatus">
        <el-form-item label="提交项目" class="form-item-title" label-width="200px" placeholder="请输入项目名称"></el-form-item>
        <el-form-item prop="name" label="名 称:" class="form-item-name" :rules="{
            required: true,
            message: '名称不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-input v-model="dappForm.name" maxlength="64" show-word-limit></el-input>
        </el-form-item>
      </template>
      <template v-else>
        <el-form-item label="添加详情" class="form-item-title" label-width="200px"></el-form-item>
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
        <el-form-item v-show="false" style="margin-bottom: 40px" prop="photoUri.src" label="图  片:" :rules="{
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
          <span class="img-tip">建议像素：1352*400px，JPG、PNG格式，大小不超过2MB。</span>
        </el-form-item>
        <el-form-item style="margin-bottom: 40px" prop="logoUri.src" label="L o g o:" :rules="{
            required: true,
            message: 'logo不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-upload class="img-uploader" :show-file-list="false" :before-upload="beforeLogoUpload">
            <img v-if="dappForm.logoUri.src" :src="dappForm.logoUri.src" class="img-logo" />
            <i v-else class="el-icon-plus img-logo-uploader-icon"></i>
          </el-upload>
          <span class="img-tip">建议像素：120（宽）*120（高），JPG、PNG格式，大小不超过100K。</span>
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
          <span class="img-tip">建议像素：1352*400px，JPG、PNG格式，大小不超过2MB。</span>
        </el-form-item>
        <el-form-item v-for="(domain, index) in dappForm.outerUri" :key="`${domain.key}`" :prop="'outerUri.' + index + '.value'" :rules="{ required: true, message: '链接不能为空', trigger: 'blur' }" label-width="100px">
          <span slot="label" class="outerUri-label" @click="addDomain">{{ index == 0 ? '联系我们:' : ''}}</span>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-select v-model="domain['valueKey']" placeholder="链接类型">
                <el-option label="官网" value="website"></el-option>
                <el-option label="Twitter" value="twitter"></el-option>
                <el-option label="Medium" value="medium"></el-option>
                <el-option label="GitHub" value="github"></el-option>
                <el-option label="FaceBook" value="facebook"></el-option>
                <el-option label="Telegram" value="telegram"></el-option>
                <!-- <el-option label="Discord" value="discord"></el-option> -->
              </el-select>
            </el-col>
            <el-col :span="10">
              <el-input v-model="domain['value']"></el-input>
            </el-col>
            <el-col :span="4">
              <el-button v-if="index > 0" class="btn-cancel" @click.prevent="removeDomain(domain)">删除</el-button>
            </el-col>
          </el-row>
          <span class="img-tip" v-if="index ==  dappForm.outerUri.length -1">提示：点击联系我们，添加链接</span>
        </el-form-item>
        <el-form-item style="margin-bottom:40px" prop="walletAddr" label="钱包地址:" class="form-item-name" :rules="{
            required: true,
            message: '钱包地址不能为空',
            trigger: 'blur'
          }" label-width="100px">
          <el-input v-model="dappForm.walletAddr"></el-input>
        </el-form-item>
        <el-form-item style="margin-bottom:40px" label="项目描述:" placeholder="请用一句话介绍你的项目" prop="description" :rules="{ required: true, message: '描述不能为空', trigger: 'blur' }" label-width="100px">
          <el-input type="textarea" maxlength="300" show-word-limit placeholder="请详细介绍你的项目" v-model="dappForm.description">
          </el-input>
        </el-form-item>
        <el-form-item prop="detail" label="详细介绍:" label-width="100px" :rules="{
            required: true,
            message: '详细介绍不能为空',
            trigger: 'blur'
          }">
          <el-input type="textarea" show-word-limit placeholder="请输入内容" v-model="dappForm.detail">
          </el-input>
        </el-form-item>
      </template>
      <el-form-item>
        <template v-if="!detailStatus">
          <el-button v-if="!detailStatus" style="margin-top:20px" class="form-btn btn-submit" @click="confirm('dappForm')">确认</el-button>
          <!-- <el-button class="form-btn btn-cancel" @click="detailStatus=false">取消</el-button> -->
        </template>
        <template v-else>
          <el-button style="margin-top:50px" class="form-btn btn-submit" @click="submitForm('dappForm')">提交</el-button>
          <el-button class="form-btn btn-cancel btn-primary" @click="detailStatus=false">返回</el-button>
        </template>
        <!-- <el-button class="form-btn btn-cancel" @click="resetForm('dappForm')">重置</el-button> -->
      </el-form-item>
    </el-form>
  </div>
  <!--Upload Dapp End-->
</template>

<script>
import Bus from "@/utils/bus";
import { transformArrayBufferToBase64 } from "@/utils/utils";
export default {
  name: "LibraryHero",
  data() {
    return {
      dappForm: {
        name: "",
        description: "",
        logoUri: { src: "", type: "", buffer: "" },
        photoUri: { src: "", type: "", buffer: "" },
        outerUri: [
          {
            key: new Date(),
            valueKey: "website",
            value: ""
          }
        ],
        owner: "",
        walletAddr: "",
        category: "",
        detail: ""
      },
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
  methods: {
    removeDomain(item) {
      console.log(item);
      var index = this.dappForm.outerUri.indexOf(item);
      if (index !== -1) {
        this.dappForm.outerUri.splice(index, 1);
      }
    },
    addDomain() {
      this.dappForm.outerUri.push({
        key: new Date(),
        valueKey: "website",
        value: ""
      });
    },
    async submitForm(formName) {
      this.$refs[formName].validate(async valid => {
        if (valid) {
          this.loading = true;
          const owner = this.$store.state.user
            ? this.$store.state.user.principal
            : "";
          const outerUri = this.dappForm.outerUri
            .filter(item => item.value && item.valueKey)
            .map(item => [item.value, item.valueKey]);
          const {
            name,
            description,
            logoUri,
            photoUri,
            walletAddr,
            category,
            detail
          } = this.dappForm;
          const logoUriId = await this.uploadPhoto(logoUri);
          const photoUriId = await this.uploadPhoto(photoUri);
          if (!logoUriId && logoUriId !== 0) {
            this.$message.error("logo图片上传失败");
            return false;
          }
          if (!photoUriId && photoUriId !== 0) {
            this.$message.error("photo图片上传失败");
            return false;
          }
          const res = await this.$store.state.dapp.createDapp(
            name,
            description,
            logoUriId,
            photoUriId,
            outerUri,
            owner,
            walletAddr,
            category,
            detail
          );
          // const veryify = await this.$store.state.dapp.verifyDapp(res.ok,'enable')
          this.loading = false;
          if (res.ok) {
            this.$message.success("提交成功,请勿重复提交");
            this.detailStatus = false;
            Bus.$emit("uploadDappSuccess");
            this.dappForm = {
              name: "",
              description: "",
              logoUri: { src: "", type: "", buffer: "" },
              photoUri: { src: "", type: "", buffer: "" },
              outerUri: [
                {
                  key: new Date(),
                  valueKey: "website",
                  value: ""
                }
              ],
              owner: "",
              walletAddr: "",
              category: "",
              detail: ""
            };
          } else {
            this.$message.error("提交失败");
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
  // background: url("~@/assets/images/bg_dapp.png") top;
  // background-repeat: no-repeat;
  // background-size: 100% 100%;
  background: #000000;
  padding: 330px 0 20px;
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

@media (max-width: 768px) {
  .title-heading .heading {
    font-size: 35px !important;
  }
}

.title-heading .text-muted {
  text-align: right;
  font-size: 36px;
  font-family: Roboto;
  font-weight: 400;
  color: #1f1f1f !important;
  line-height: 49px;
  opacity: 0.6;
}

/*上传头像*/
.img-uploader >>> .el-upload {
  background: #17161d;
  border: 2px dashed #ffffff;
  border-radius: 8px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.img-uploader >>> .el-upload:hover {
  border-color: #b6fd21;
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
  font-family: Roboto;
  font-weight: 400;
  color: #a8a8a8;
  line-height: 30px;
  margin-bottom: 0;
}
.dapp-wrapper {
  z-index: 0;
  background: #000000;
  color: #ffffff !important;
}
/deep/.el-form {
  background-color: #17161d;
  width: 70%;
  margin: -150px auto 30px;
  padding: 6% 10%;
  position: relative;
  border: 1px solid #b6fd21;
  border-radius: 8px;
  .back {
    font-size: 24px;
    font-family: Roboto;
    font-weight: normal;
    color: #ffffff;
    line-height: 30px;
    cursor: pointer;
    position: absolute;
    right: 30px;
    top: 20px;
  }
  .back:hover {
    color: #b6fd21;
  }
  .el-form-item {
    .el-form-item__label {
      font-size: 16px;
      font-family: Roboto;
      font-weight: bold;
      color: #ffffff;
    }
    .el-radio__input.is-checked .el-radio__inner {
      background: #b6fd21;
      border-color: #b6fd21;
    }

    .el-radio__input.is-checked + .el-radio__label {
      color: #b6fd21;
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
          border: 1px solid #ffffff;
          background-color: transparent !important;
          color: #fff;
        }
        .el-input__count-inner {
          background: transparent;
          color: #9d9d9d;
        }
      }
      .el-textarea {
        textarea {
          border: 1px solid #ffffff;
          border-radius: 8px;
          color: #ffffff;
          background: transparent;
        }
        .el-input__count {
          background: transparent;
        }
      }
      .form-btn {
        border-radius: 8px;
        font-size: 18px;
        font-family: Roboto;
        color: #ffffff;
        line-height: 30px;
        padding: 4px 40px;
        font-weight: bold;
      }
      .btn-submit {
        background: #b6fd21;
        color: #000000;
        border-color: #b6fd21;
      }
      .btn-cancel {
        border: 2px solid #9d9d9d;
        color: #a8a8a8;
        background: transparent;
      }
    }
  }
  .form-item-title {
    .el-form-item__label {
      text-align: left !important;
      font-size: 26px !important;
      font-family: Roboto;
      font-weight: bold !important;
    }
  }
}
.el-form::after {
  width: 273px;
  height: 273px;
  content: "";
  position: absolute;
  left: 50%;
  top: 15%;
  transform: translate(-50%, -50%) rotate(-90deg);
  background: linear-gradient(
    180deg,
    rgba(231, 32, 57, 0.6) 0%,
    rgba(214, 168, 81, 0.6) 31.25%,
    rgba(55, 139, 188, 0.6) 61.46%,
    rgba(81, 44, 134, 0.6) 100%
  );
  filter: blur(100px);
  z-index: -1;
}
.el-form-detail {
  width: 100% !important;
  margin: 10px auto 0 !important;
  padding: 4% 14% 7% !important;
  background: #000000;
  border: none;
}
.el-form-detail::after {
  width: 273px;
  height: 273px;
  content: "";
  position: absolute;
  left: 50%;
  top: 15%;
  transform: translate(-50%, -50%) rotate(-90deg);
  background: linear-gradient(
    180deg,
    rgba(231, 32, 57, 0.6) 0%,
    rgba(214, 168, 81, 0.6) 31.25%,
    rgba(55, 139, 188, 0.6) 61.46%,
    rgba(81, 44, 134, 0.6) 100%
  );
  filter: blur(100px);
  z-index: 1;
}
</style>
