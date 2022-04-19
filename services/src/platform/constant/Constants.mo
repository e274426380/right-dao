
import Text "mo:base/Text";

import Types "../base/Types";
import Utils "../base/Utils";

module {

    public type ProgressStage = Types.ProgressStage;
    public type StatusEnum = Types.StatusEnum;
    
    public let STATUS_ENABLE : StatusEnum = "enable";
    public let STATUS_DISABLE : StatusEnum = "disable";
    public let STATUS_PENDING : StatusEnum = "pending";
    public let STATUS_DELETED : StatusEnum = "deleted";

    public let REGISTER_FROM_ADMIN : Text = "admin";
    public let REGISTER_FROM_FRONT : Text = "front";
    
    public let WALLET_CATEGORY_PLUG : Text = "plug";
    public let WALLET_CATEGORY_STOIC : Text = "stoic";

    public let BANNER_CATEGORY_DAPP : Text = "dapp";
    public let BANNER_CATEGORY_HOMEPAGE : Text = "homepage";
    public let BANNER_CATEGORY_LIBRARY : Text = "library";
    public let BANNER_CATEGORY_HACKATHON : Text = "hackathon";

    public let PROJECT_URI_MAX_LIMIT : Nat = 5;

    public let PROGRESS_IN_PREPARATION : ProgressStage = "inpreparation";
    public let PROGRESS_IN_PROGRESS : ProgressStage = "inprogress";
    public let PROGRESS_COMPLETED : ProgressStage = "completed";

    public let CATEGORY_PROJECT : Text = "project";
    public let CATEGORY_ACTIVITY : Text = "activity";

    // public type WalletAddress = Types.WalletAddress;
    public type WalletCategory = Types.WalletCategory;

    public let PLATFROM_WALLET_ADDRESS_ICP : WalletCategory = {
        currency = "ICP";
        walletAddress = "8e73375c5f9320cfeb220c1e1320b80791adc66149b0a6c57b4e926fb2b5435d";
        chain = "DFINITY";
    };

    public let ICP_SYMBOL : Text = "ICP";
    
    public let ICP_WALLET_ADDRESS_LENGTH : Nat = 64;

    /// 每ICP 100积分
    public let POINT_PER_ICP : Nat = 100;

    /// 转账ICP的单位
    public let ICP_TRANSFER_UNIT : Nat = 100_000_000;

    /// ICP钱包地址是否符合规范,长度64,字母和数字组成
    public func isValidICPWalletAddress(walletCategory: WalletCategory) : Bool {
        let walletAddress = walletCategory.walletAddress;
        walletCategory.currency == ICP_SYMBOL and 
            Utils.isAllAlpharAndNumberAndWhitespace(walletAddress) and Text.size(walletAddress) == ICP_WALLET_ADDRESS_LENGTH;
    };

    /// 根据捐助的ICP产生的积分,每捐助1ICP,获得100积分
    public func calcPointFromICP(num: Nat) : Nat {
        POINT_PER_ICP  * num / ICP_TRANSFER_UNIT
    };
}