
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {
    
    
    public type Bonus = {
        currency: Currency;
        amount: Nat;
        scale: Nat;
    };

    public type Currency = Text;
    
    public type Picture = {
        content: Blob;
        fileType: Text;
    };
    public type ProgressStage = Text;

    public type RichText = {
        format: Text;   /// 文本内容格式,例如text,html,markdown
        content: Text;
    };
    
    public type StatusEnum = Text;
    public type UserPrincipal = Text;
    public type Timestamp = Int;

    public type Id = Nat;

    public let idEq = Nat.equal;
    public let idHash = Hash.hash;

    public let userEq = Text.equal;
    public let userHash = Text.hash;

    public let tagEq = Text.equal;
    public let tagHash = Text.hash;

    public type IdOwner = {
        id: Id;
        owner: UserPrincipal;
    };
    
    /// 钱包地址
    public type WalletCategory = {
        walletAddress: Text;
        currency: Text;
        chain: Text;
    };

    /// 钱包地址及标识
    // public type WalletAddress = {
    //     symbol: Text ;
    //     address: Text;
    // };

    /// 错误类型定义
    public type Error = {
        #idDuplicated;
        #notFound;
        #alreadyExisted;
        #uploadPicFailed;
        #badRequest;

        #userNotFound;
        #userAlreadyExists : Text;
        #usernameAlreadyExists: Text;
        #adminAlreadyExists;
        #invalidUsername;
        #unauthorized;
        #invalidICPWalletAddress;

        // Activity
        #activityExpired;
        #winnerTooLargeQuantity;
        #votingRightTooFew;
        #votingAmountTooFew;
        #votingAmountTooLarge;

        // point
        #alreadySuccessExecuted;
        #airdropPointPlanTitleEmpty;
        #airdropPointPlanDescriptionEmpty;
        #airdropPointPlanAlreadyExecuted;
        #airdropPointPlanDataEmpty;

        // project joined activity
        #projectJoinedActivity;
        #projectNotEnable;
        #projectNameInValid;
        #projectContentInvalid;
        #projectWalletAddressInvalid;
        #projectWalletCurrencyInvalid;
        #projectWalletChainInvalid;
        #projectCreatorInvalid;
        #projectCreatorInfoInvalid;
        #projectTagsInvalid;
        #projectContactInfoInvalid;
        #projectLinksInvalid;

        // Eamil Subscription
        #emailAddressAlreadyExists;
        #emailAddressNotValid;

        // Banner
        #tooLargeQuantity;

        // Picture
        #picNotFound;
        #picAlreadyExisted;
    };
}