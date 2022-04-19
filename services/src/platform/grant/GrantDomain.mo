
import Bool "mo:base/Bool";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Order "mo:base/Order";

import Constants "../constant/Constants";
import PointDomain "../point/PointDomain";
import Types "../base/Types";

/// Grant领域模型
module {

    public type GrantId = Types.Id;
    public type Memo = Nat64;
    public type RewardAddress = Text;
    public type TargetId = Types.Id;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;
    public type WalletAddress = Text;
    public type GrantStatus = Types.StatusEnum;
    public type GrantTarget = { 
        targetId: TargetId;
        category: Text;
    };

    public type GrantProfile = {
        id: GrantId;                // 捐助记录id,主键
        grantTarget: GrantTarget;   // 捐助目标(目标id+类型)
        username: Text;             // 捐助者的名字
        walletPrincipal: UserPrincipal;    // 捐助者的principal
        walletAddress: WalletAddress;       // 捐助者的钱包地址(或者principal)
        from: RewardAddress;                // 捐助者的捐钱的钱包地址
        to: RewardAddress;                  // 接受捐助的钱包地址
        blockHeight: Nat64;                 // 交易区块高度
        amount: Nat64;                      // 捐助的金额
        memo: Memo;                         // 备注,随机数
        owner: UserPrincipal;               // 捐助者
        status: GrantStatus;                // 捐助记录状态
        isFinalized : Bool;                 // 交易在链上是否已经Finalized,初始是false,链上验证成功后为true,表示已经交易成功
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    /// 用户获得的积分
    public type UserPointView = PointDomain.UserPointView;

    public type GrantCreateRequest = {
        targetId: TargetId;
        username: Text;
        walletPrincipal: UserPrincipal;
        walletAddress: WalletAddress;
        from: RewardAddress;
        to: RewardAddress;
        blockHeight: Nat64;
        amount: Nat64;
        memo: Memo;
    };

    public type GrantUpdateBlockHeightRequest = {
        grantId: GrantId;
        blockHeight: Nat64;
        memo: Memo;
        amount: Nat64;
    };

    public func createRequestToProfile(req: GrantCreateRequest, grantId: GrantId, targetCategory: Text, caller: UserPrincipal, currentTime: Timestamp) : GrantProfile {
        { 
            id = grantId;
            grantTarget = { targetId = req.targetId; category = targetCategory };
            username = req.username;
            walletPrincipal = req.walletPrincipal;
            walletAddress = req.walletAddress;
            from = req.from;
            to = req.to;
            blockHeight = req.blockHeight;
            amount = req.amount;
            memo = req.memo;
            owner = caller;
            status = Constants.STATUS_DISABLE;
            isFinalized = false;
            createdBy = caller;
            createdAt = currentTime;
        }
    };

    public func updateGrantBlockHeightAndStatus(g: GrantProfile, blockHeight: Nat64, status: GrantStatus) : GrantProfile {
        {
            id = g.id;
            grantTarget = g.grantTarget;
            username = g.username;
            walletPrincipal = g.walletPrincipal;
            walletAddress = g.walletAddress;
            from = g.from;
            to = g.to;
            blockHeight = blockHeight;
            amount = g.amount;
            memo = g.memo;
            owner = g.owner;
            status = status;
            isFinalized = g.isFinalized;
            createdBy = g.createdBy;
            createdAt = g.createdAt;
        }
    };

    public func finalizeGrant(gp: GrantProfile) : GrantProfile {
        { 
            id = gp.id;
            grantTarget = gp.grantTarget;
            username = gp.username;
            walletPrincipal = gp.walletPrincipal;
            walletAddress = gp.walletAddress;
            from = gp.from;
            to = gp.to;
            blockHeight = gp.blockHeight;
            amount = gp.amount;
            memo = gp.memo;
            owner = gp.owner;
            status = gp.status;
            isFinalized = true;
            createdBy = gp.createdBy;
            createdAt = gp.createdAt;
        }
    };

    public func grantProfileToUserPointView(gp: GrantProfile) : UserPointView {
        {
            user = gp.owner;
            createdTime = gp.createdAt;
            amount =  Constants.calcPointFromICP(Nat64.toNat(gp.amount));
            sourceCategory = gp.grantTarget.category;
        }
    };
    
    public func grantToText(dr: GrantProfile) : Text {
        "{\"id\": " # Nat.toText(dr.id) # ", \"target d\": " # Nat.toText(dr.grantTarget.targetId) #
        ", \"owner\": \"" # dr.owner # "\", \"username\": \"" # dr.username # 
        "\", \"walletPrincipal\": \"" # dr.walletPrincipal # "\", \"walletAddress\": \"" # dr.walletAddress #  
        "\", \"from\": \"" # dr.from # "\", \"to\": \"" # dr.to #
        "\", \"blockHeight\": " # Nat64.toText(dr.blockHeight) # ", \"amount\": " # Nat64.toText(dr.amount) # 
        ", \"memo\": " # Nat64.toText(dr.memo) # ", \"isFinalized\": " # Bool.toText(dr.isFinalized) # 
        ", \"createdAt\": " # Int.toText(dr.createdAt) # "}"
    };

    public func isGrantActivity(p: GrantProfile) : Bool {
        p.grantTarget.category == Constants.CATEGORY_ACTIVITY
    };

    public func isGrantProject(p: GrantProfile) : Bool {
        p.grantTarget.category == Constants.CATEGORY_PROJECT
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareById(profile1: GrantProfile, profile2: GrantProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    public let grantEq = Types.idEq;
    public let grantHash = Types.idHash;

    public let targetEq = Types.idEq;
    public let targetHash = Types.idHash;

    public let GRANT_STATUS_NOT_START : GrantStatus = "notstart";
    public let GRANT_STATUS_AT_EVENT : GrantStatus = "atevent";
    public let GRANT_STATUS_ENDED : GrantStatus = "ended";
}