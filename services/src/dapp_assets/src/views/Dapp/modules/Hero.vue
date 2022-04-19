<template>
  <!-- Hero Start -->
  <section class="bg-half-170 d-table w-100" id="home">
    <div class="container">
      <div class="row">
        <!--<div class="col-lg-5 offset-lg-1 col-md-6 mt-4 pt-2 mt-sm-0 pt-sm-0">-->
          <!--<img src="~@/assets/images/dapp.png" class="img-fluid img-to-bottom" alt="" />-->
        <!--</div>-->
        <!--end col-->
        <div>
          <div class="title-heading">
            <transition name="el-zoom-in-top" mode="in-out">
              <p v-if="show" apper="true" class="heading mb-3">{{ $t("dapp.banner.title") }}</p>
            </transition>
            <transition name="el-zoom-in-top" mode="in-out">
              <p v-if="show" class="text-muted">
                {{ $t("dapp.banner.subtext") }}
              </p>
            </transition>
            <div style="text-align: center">
              <!--<el-button data-v-199454ac="" type="button" class="btn btn-primary btn-sm" target="_blank" @click="clickExplore('Explore')">-->
                <!--<span>{{ $t("dapp.banner.explore") }}</span>-->
              <!--</el-button>-->
              <el-button data-v-199454ac="" type="button" class="btn btn-primary btn-lg" target="_blank" @click="$router.push('submitDapp')" v-if="$store.state.user">
                <span>{{ $t("dapp.banner.upload") }}</span>
              </el-button>
            </div>
          </div>
        </div>
        <!--end col-->
      </div>
      <!--end row-->
    </div>
    <!--end container-->
    <!--Upload Dapp Start-->
    <el-dialog center title="请填写您的应用信息" :visible.sync="dialogVisible" width="50%" :before-close="handleClose">
      <el-form :model="dappForm" ref="dappForm" label-width="100px" class="demo-dynamic" label-position="left" v-loading="loading">
        <el-form-item prop="name" label="名称" :rules="{
            required: true,
            message: '名称不能为空',
            trigger: 'blur',
          }">
          <el-input v-model="dappForm.name"></el-input>
        </el-form-item>
        <el-form-item prop="logoUri.src" label="logo" :rules="{
            required: true,
            message: 'logo不能为空',
            trigger: 'blur',
          }">
          <el-upload class="avatar-uploader" :show-file-list="false" :before-upload="beforeLogoUpload">
            <img v-if="dappForm.logoUri.src" :src="dappForm.logoUri.src" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item prop="photoUri.src" label="photo" :rules="{
            required: true,
            message: 'photo不能为空',
            trigger: 'blur',
          }">
          <el-upload class="avatar-uploader" :show-file-list="false" :before-upload="beforePhotoUpload">
            <img v-if="dappForm.photoUri.src" :src="dappForm.photoUri.src" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="Dapp Type" prop="category" :rules="{
            required: true,
            message: '类型不能为空',
            trigger: 'blur',
          }">
          <el-radio-group v-model="dappForm.category">
            <el-radio v-for="tag in tags" :key="tag.key" :label="tag.key">{{
              tag.label
            }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-for="(domain, index) in dappForm.outerUri" :label="`相关链接${index + 1}`" :key="`${domain.key}`" :prop="'outerUri.' + index + '.value'" :rules="{ required: true, message: '域名不能为空', trigger: 'blur' }">
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
              <el-button @click.prevent="removeDomain(domain)">删除</el-button>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="一句话描述" prop="description" :rules="{ required: true, message: '描述不能为空', trigger: 'blur' }">
          <el-input type="textarea" maxlength="300" show-word-limit placeholder="请输入内容" v-model="dappForm.description">
          </el-input>
        </el-form-item>
        <el-form-item label="详细介绍">
          <el-input type="textarea" show-word-limit placeholder="请输入内容" v-model="dappForm.detail">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm('dappForm')">提交</el-button>
          <el-button @click="addDomain">新增链接</el-button>
          <el-button @click="resetForm('dappForm')">重置</el-button>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
      </span>
    </el-dialog>
    <!--Upload Dapp End-->
  </section>
  <!--end section-->
  <!-- Hero End -->
</template>

<script>
import Bus from "@/utils/bus";
import {
  base64ToBlob,
  base64to2,
  transformArrayBufferToBase64
} from "@/utils/utils";
export default {
  name: "LibraryHero",
  data() {
    return {
      show: false,
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
      ]
    };
  },
  mounted() {
    setTimeout(() => {
      this.show = true;
    }, 500);
  },
  methods: {
    handleClose(done) {
      this.$confirm("确认关闭？")
        .then(_ => {
          done();
        })
        .catch(_ => {});
    },
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
          const owner = this.$store.state.user.principal;
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
          if (!photoUriId && logoUriId !== 0) {
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
            this.$message.success("上传成功");
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
            this.$message.error("上传失败");
          }
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    beforeLogoUpload(file) {
      this.dappForm.logoUri.type = file.type;
      const isLt1M = file.size / 1024 / 1024 < 1;

      // if (!isPng) {
      //   this.$message.error("上传头像的图片不是Png");
      //   return;
      // }
      if (!isLt1M) {
        this.$message.error("上传头像图片大小不能超过 1MB!");
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
      const isLt5M = file.size / 1024 / 1024 < 5;

      // if (!isPng) {
      //   this.$message.error("上传头像的图片不是Png");
      // }
      if (!isLt5M) {
        this.$message.error("上传头像图片大小不能超过 5MB!");
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
    }
  }
};
</script>

<style lang="scss" scoped>
  // css
  .fade-enter,
  .fade-leave-to {
    // 声明入场的开始和离场的结束的样式
    opacity: 0;
  }
  .fade-enter-active,
  .el-zoom-in-bottom,
  .fade-leave-active {
    // 声明过渡动画持续时间
    transition: opacity 3s;
  }
  .container::after{
    width: 473px;
    height: 473px;
    content: '';
    position: absolute;
    left: 50%;
    top:50%;
    transform:translate(-50%,-50%) rotate(-90deg);
    background: linear-gradient(
        180deg, rgba(231,32,57,0.6) 0%, rgba(214,168,81,0.6) 31.25%, rgba(55,139,188,0.6) 61.46%, rgba(81,44,134,0.6) 100%);
    filter: blur(100px);
    z-index: 1;
  }
.bg-half-170 {
  /*background: url("~@/assets/images/bg_dapp.png") top;*/
  background-repeat: no-repeat;
  background-size: 100% 100%;
  padding: 184px 0 200px 0;
}

.title-heading {
  min-height: 128px;
  line-height: 26px;
  /*margin-top: 3.5rem;*/
  position: relative;
  z-index: 2;
  .el-button {
    /*width: 141px;*/
    /*height: 40px;*/
    /*background: #425ce1;*/
    /*opacity: 0.85;*/
    /*border-radius: 6px;*/
    /*color: #fff;*/
    margin-top: 80px;
    /*float: right;*/
    /*span {*/
      /*font-family: Helvetica;*/
      /*font-weight: bold;*/
      /*color: #ffffff;*/
    /*}*/
  }
}

.title-heading .heading {
  font-family: Roboto;
  font-style: normal;
  font-weight: bold;
  font-size: 62px;
  line-height: 73px;
  text-align: center;
  color: #FFFFFF;
}

@media (max-width: 768px) {
  .title-heading .heading {
    font-size: 35px !important;
  }
}

.title-heading .text-muted {
  font-family: Roboto;
  font-style: normal;
  font-weight: 300;
  font-size: 20px;
  line-height: 23px;
  text-align: center;
  color: #FFFFFF!important;
  opacity: 0.8;
}

/*上传头像*/
.avatar-uploader >>> .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader >>> .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}
.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
.img-to-bottom {
  position: relative;
  top: 60px;
  z-index: 999;
}
</style>
