
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Order "mo:base/Order";

import Constants "../constant/Constants";
import Types "../base/Types";
import UserDomain "../user/UserDomain";
import Utils "../base/Utils";

/// 积分领域相关,例如积分计算规则
module {

    public type AirdropPointPlanId = Types.Id;
    public type UserProfile = UserDomain.UserProfile;

    /// 执行状态
    public type ExecuteStatus = {
        #success;   // 全部成功
        #partialSuccess;    // 部分成功
        #pending;   // 待执行
        #failed;    // 全部失败
    };

    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;

    /// 空投积分计划,持久存储数据模型
    public type AirdropPointPlanProfile = {
        id: AirdropPointPlanId; // 空投积分计划id,唯一,无意义
        title: Text;            // 空投积分计划的标题
        description: Text;      // 空投积分计划的描述
        pointSum: Int;          // 空投积分计划的积分总额
        recordCount: Nat;         // 空投积积分计划的用户总数
        successCount: Nat;      // 成功的空投积分记录数
        failedCount: Nat;      // 失败的空投积分记录数
        executedTime: Timestamp;    // 空投积分计划的执行时间
        executor: UserPrincipal;    // 空投积分计划的执行者
        status: ExecuteStatus;         // 计划的状态,分在pending(未执行),success(执行成功),partialSuccess(部分成功),failed(执行失败)
        createdBy: UserPrincipal;   // 创建者
        createdAt: Timestamp;       // 创建时间
        data: [AirdropPointPlanResultRecord]    // 空投积分记录执行结查
    };

    /// 创建空投积分计划响应数据模型,用于创建空投计划接口返回数据格式
    public type AirdropPointPlanCreateResponse = {
        id: AirdropPointPlanId;     // 空投积分计划id,唯一,无意义
        createdAt: Timestamp;       // 空投积分计划创建时间
        data: [AirdropPointRequestRecord]   // 空数组
    };

    /// 空投积分执行的结果记录
    public type AirdropPointPlanResultRecord = {
        recipient: UserPrincipal;   // 空投积分的接收者
        amount: Int;                // 空投积分的积分数量
        status: ExecuteStatus;         // 空投积分执行状态,分为success
        memo: [Text];               // 空投积分执行的错误信息,如果有的话
    };  

    /// 更新空投积分计划数据模型,用于保存空投积分计划
    public type AirdropPointPlanSaveRequest = {
        id: AirdropPointPlanId;
        title: Text;
        description: Text;
        data: [AirdropPointRequestRecord]
    };

    /// 空投积分请求的记录
    public type AirdropPointRequestRecord = {
        recipient: UserPrincipal;   // 空投积分的接收者
        amount: Int;                // 空投积分的积分数量
    };

    /// 创建一个空的人空投积分计划
    public func createEmptyAirdropPointPlan(id: AirdropPointPlanId, createdBy: UserPrincipal, createdAt: Timestamp) : AirdropPointPlanProfile {
        { 
            id = id;
            title = "";
            description = "";
            pointSum = 0;
            recordCount = 0;
            successCount = 0;
            failedCount = 0;
            executedTime = 0;
            executor = "";
            status = #pending;
            createdBy = createdBy;
            createdAt = createdAt;
            data = [];
        }
    };

    /// 创建空投积分计划响应
    public func createEmptyAirdropPointPlanResponse(id: AirdropPointPlanId, createdAt: Timestamp) : AirdropPointPlanCreateResponse {
        {
            id = id;
            createdAt = createdAt;
            data = [];
        }
    };

    /// 检查空投积分计划是不否已经执行成功或部分成功,如果有记录成功,就不能重复执行
    public func isSuccessExecuted(profile: AirdropPointPlanProfile) : Bool {
        (profile.status == #success) or (profile.status == #partialSuccess)
    };

    /// 用SaveRequest中数据更新AirdropPointPlanProfile
    public func updateAirdropPointPlanProfileWithSaveRequest(profile: AirdropPointPlanProfile, saveRequest: AirdropPointPlanSaveRequest) : AirdropPointPlanProfile {
        assert(profile.id == saveRequest.id);
        var pointSum : Int = 0;
        var recordCount = 0;
        let updatedBuffer = Buffer.Buffer<AirdropPointPlanResultRecord>(0);
        for (record in saveRequest.data.vals()) {
            pointSum += record.amount;
            recordCount += 1;
            updatedBuffer.add({
                recipient = record.recipient;
                amount = record.amount;
                status = #pending;
                memo = [];
            });
        };

        let data = updatedBuffer.toArray();
        
        {
            id = profile.id;
            title = saveRequest.title;
            description = saveRequest.description;
            pointSum = pointSum;
            recordCount = recordCount;
            successCount = profile.successCount;
            failedCount = profile.failedCount;
            executedTime = profile.executedTime;
            executor = profile.executor;
            status = profile.status;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = data;
        }
    };

    /// 更新空投积分执行的结果记录
    public func updateAirdropPointPlanResultRecord(record: AirdropPointPlanResultRecord, status: ExecuteStatus, memo: [Text]) : AirdropPointPlanResultRecord {
        {
            recipient = record.recipient;
            amount = record.amount;
            status = status;
            memo = memo;
        }
    };

    // 检查title是否为空
    public func isEmptyTitle(profile: AirdropPointPlanProfile) : Bool {
        Utils.isSpaceText(profile.title)
    };

    // 检查description是否为空
    public func isEmptyDescription(profile: AirdropPointPlanProfile) : Bool {
        Utils.isSpaceText(profile.description)
    };

    /// 检查空投积分计划是否有符合要求
    // 1) 空投积分计划中积分记录的UserPrincipal重复的话,只有第一条生效,其他的重复记录标记失败,对应的UserPrincipal不获得对应的积分
    // 2) 如果用户不存在,则该记录标记有用户不存在错误
    public func validateAirdropPointPlan(profile: AirdropPointPlanProfile, executor: UserPrincipal, executedTime: Timestamp, existUsers: HashMap.HashMap<UserPrincipal, UserProfile>) : AirdropPointPlanProfile {
        var successCount = 0;
        var failedCount = 0;
        let recipients = HashMap.HashMap<UserPrincipal, ()>(0, userEq, userHash);
        let updatedBuffer = Buffer.Buffer<AirdropPointPlanResultRecord>(0);
        for (record in profile.data.vals()) {
            let user = record.recipient;
            let memos = Buffer.Buffer<Text>(0);
            let status : ExecuteStatus= if (not(Utils.containsKey(existUsers, user))) {
                failedCount += 1;
                memos.add("用户不存在");
                #failed
            } else if (Utils.containsKey(recipients,user)) {  
                failedCount += 1;
                memos.add("用户重复");
                #failed
            } else {
                recipients.put(user, ());
                successCount += 1;
                #success
            };

            updatedBuffer.add(updateAirdropPointPlanResultRecord(record, status, memos.toArray()));
        };

        let updatedData = updatedBuffer.toArray();
        // let updatedData = Array.map<AirdropPointPlanResultRecord, AirdropPointPlanResultRecord>(profile.data, func (record) : AirdropPointPlanResultRecord {
        //     let user = record.recipient;
        //     let memos = Buffer.Buffer<Text>(0);
        //     let status : ExecuteStatus= if (not(Utils.containsKey(existUsers, user))) {
        //         failedCount += 1;
        //         memos.add("用户不存在");
        //         #failed
        //     } else if (Utils.containsKey(recipients,user)) {  
        //         failedCount += 1;
        //         memos.add("用户重复");
        //         #failed
        //     } else {
        //         recipients.put(user, ());
        //         successCount += 1;
        //         #success
        //     };

        //     updateAirdropPointPlanResultRecord(record, status, memos.toArray());
        // });

        let executedStatus = if (failedCount == 0 and successCount > 0) {
            #success
        } else if (failedCount > 0 and successCount > 0) {
            #partialSuccess;    
        } else {
            #failed
        };
        
        {
            id = profile.id;
            title = profile.title;
            description = profile.description;
            pointSum = profile.pointSum;
            recordCount = profile.recordCount;
            successCount = successCount;
            failedCount = failedCount;
            executedTime = executedTime;
            executor = executor;
            status = executedStatus;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = updatedData;
        }
    };

    /// 用积分记录列表更新空投积计划
    public func updateAirdropPointPlanWithRecordData(profile: AirdropPointPlanProfile, newData: [AirdropPointPlanResultRecord]) : AirdropPointPlanProfile {
        {
            id = profile.id;
            title = profile.title;
            description = profile.description;
            pointSum = profile.pointSum;
            recordCount = profile.recordCount;
            successCount = profile.successCount;
            failedCount = profile.failedCount;
            executedTime = profile.executedTime;
            executor = profile.executor;
            status = profile.status;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = newData;
        }
    };

    /// 修改空投积分计划标题和描述
    public func modifyAirdropPointPlanTitleAndDesc(profile: AirdropPointPlanProfile, title: Text, description: Text) : AirdropPointPlanProfile {
        {
            id = profile.id;
            title = title;
            description = description;
            pointSum = profile.pointSum;
            recordCount = profile.recordCount;
            successCount = profile.successCount;
            failedCount = profile.failedCount;
            executedTime = profile.executedTime;
            executor = profile.executor;
            status = profile.status;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = profile.data;
        }
    };

    /// 修改空投积分计划标题
    public func modifyAirdropPointPlanTitle(profile: AirdropPointPlanProfile, title: Text) : AirdropPointPlanProfile {
        {
            id = profile.id;
            title = title;
            description = profile.description;
            pointSum = profile.pointSum;
            recordCount = profile.recordCount;
            successCount = profile.successCount;
            failedCount = profile.failedCount;
            executedTime = profile.executedTime;
            executor = profile.executor;
            status = profile.status;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = profile.data;
        }
    };

    /// 修改空投积分计划描述
    public func modifyAirdropPointPlanDescription(profile: AirdropPointPlanProfile, description: Text) : AirdropPointPlanProfile {
        {
            id = profile.id;
            title = profile.title;
            description = description;
            pointSum = profile.pointSum;
            recordCount = profile.recordCount;
            successCount = profile.successCount;
            failedCount = profile.failedCount;
            executedTime = profile.executedTime;
            executor = profile.executor;
            status = profile.status;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            data = profile.data;
        }
    };

    /// 空投积分计划是否已经执行
    public func isAirdropPointPlanAlreadyExecuted(profile: AirdropPointPlanProfile) : Bool {
        profile.executedTime > 0
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareAirdropPointPlanByIdDesc(profile1: AirdropPointPlanProfile, profile2: AirdropPointPlanProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// 空投积分计划中的积分记录是否已经执行成功
    public func isSuccessPointResultRecord(rr: AirdropPointPlanResultRecord) : Bool {
        rr.status == #success
    };

    /// 空投积分计划的用户数(记录数)是否为空
    public func isAirdropPointPlainDataEmpty(profile: AirdropPointPlanProfile) : Bool { 
        profile.recordCount == 0
    };

    /// 用户获得的积分
    public type UserPointView = {
        user: UserPrincipal;
        createdTime: Timestamp;
        amount: Int;
        sourceCategory: Text;
    };

    public func airdropPointResultRecordToUserPointView(rr: AirdropPointPlanResultRecord, createdTime: Timestamp) : UserPointView {
        { 
            user = rr.recipient;
            createdTime = createdTime;
            amount = rr.amount;
            sourceCategory = "airdrop";
        }
    };

    public type UserVotingRight = {     
        user: UserPrincipal;
        totalSum: Nat;  // 总投票数,由积分转化而来
        votedSum: Nat;  // 已经投票数量,已投票数不能超过总投票数
    };
    

    /// 根据捐助的ICP产生的积分,每捐助1ICP,获得100积分
    public let calcPointFromICP = Constants.calcPointFromICP;

    /// 累计投票权总数
    public func addVoteTotalSum(uvr: UserVotingRight, voteAmount: Nat) : UserVotingRight {
        {
            user = uvr.user;
            votedSum = uvr.votedSum;
            totalSum = uvr.totalSum + voteAmount;
        }
    };

    /// 用新数据替换UserVotingRight中的投票权
    public func replaceUserVotingRightTotalSum(uvr: UserVotingRight, newTotalSum: Nat) : UserVotingRight {
        {
            user = uvr.user;
            votedSum = uvr.votedSum;
            totalSum = newTotalSum;
        }
    };

    /// 累计已投票总数
    public func addVotedTotalSum(uvr: UserVotingRight, votedAmount: Nat) : UserVotingRight {
        {
            user = uvr.user;
            votedSum = uvr.votedSum + votedAmount;
            totalSum = uvr.totalSum;
        }
    };

    /// 创建新的用户投票权对象
    public func newUserVotingRight(user: UserPrincipal, votedSum: Nat, totalSum: Nat) : UserVotingRight {
        {
            user = user;
            votedSum = votedSum;
            totalSum = totalSum;
        }
    };

    /// 可用投票数
    public func availableVotingNum(uvr: UserVotingRight) : Nat {
        uvr.totalSum - uvr.votedSum
    };


    public let airdropPointPlanEq = Types.idEq;
    public let airdropPointPlanHash = Types.idHash;
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;
}