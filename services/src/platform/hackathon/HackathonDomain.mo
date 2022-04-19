
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Order "mo:base/Order";
import Result "mo:base/Result";

import Constants "../constant/Constants";
import ProjectDomain "../project/ProjectDomain";
import Types "../base/Types";
import Utils "../base/Utils";
import PointDomain "../point/PointDomain";

/// 黑客松相关Domain模型
module {

    public type Result<X, Y> = Result.Result<X, Y>;
    public type Error = Types.Error;

    public type ActivityId = Types.Id;
    public type PrizeId = Types.Id; 
    public type Participant = Types.Id;
    public type ProjectProfile = ProjectDomain.ProjectProfile;
    public type ProgressStage = Types.ProgressStage;

    public type RichText = Types.RichText;

    public type StatusEnum = Constants.StatusEnum;
    public type StrategyOfVotes = {
        historyRatio: Nat;  // 历史积分兑换票数的比例
        periodRatio: Nat;   // 活动中获得积分兑换票数的比例:仅包含黑客松活动的捐赠的积分
        maxPerProject: Nat;      // 最大投票数量:活动中单个项目用户累计最大的投票数量
        minPerProject: Nat;      // 最小投票数量:活动中单个项目用户最小的投票数量
        maxPerActivity: Nat;      // 总投票数量:本次活动中用户一共可以投票的数量,可以为多个项目累计投票的最大数量
    };

    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;
    public type UserVotingRight = PointDomain.UserVotingRight;
    public type WalletCategory = Types.WalletCategory;

    /// 黑客松活动
    public type ActivityProfile = {
        id: ActivityId;
        title: Text;
        tags: [Text];
        coverPhotoUri: Text;
        mainPhotoUri: Text;
        publishTime: Timestamp;
        startTime: Timestamp;
        endTime: Timestamp;
        introduction: RichText;     
        strategy: StrategyOfVotes;
        bonus: [Text];
        bonusPool: Text;
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    public type ActivityCreateRequest = {
        title: Text;
        tags: [Text];
        coverPhotoUri: Text;
        mainPhotoUri: Text;
        publishTime: Timestamp;
        startTime: Timestamp;
        endTime: Timestamp;
        introduction: RichText;       
        strategy: StrategyOfVotes;
        bonus: [Text];
        bonusPool: Text;
    };

    public func createRequestToProfile(req: ActivityCreateRequest, activityId: ActivityId, createdBy: UserPrincipal, createdAt: Timestamp) : ActivityProfile {
        {
            id = activityId;
            title = req.title;
            tags = req.tags;
            coverPhotoUri = req.coverPhotoUri;
            mainPhotoUri = req.mainPhotoUri;
            publishTime = req.publishTime;
            startTime = req.startTime;
            endTime = req.endTime;
            introduction = req.introduction;
            strategy = req.strategy;
            bonus = req.bonus;
            bonusPool = req.bonusPool;
            status = Constants.STATUS_ENABLE;
            createdBy = createdBy;
            createdAt = createdAt;
        }
    };

    /// 黑客松活动投票数,参与项目,参与用户累计,捐赠金额累计
    public type ActivitySummary = {
        activityId: ActivityId; 
        votedSum: Nat;  // 投票总数累计
        projectSum: Nat;    // 项目总数累计
        userSum: Nat;       // 投票人数累计
        grantSum: Nat;      // 活动捐赠总额
    };

    public let activityEq = Nat.equal;
    public let activityHash = Hash.hash;

    public let tagEq = Types.tagEq;

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareActivityById(profile1: ActivityProfile, profile2: ActivityProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// 标签类型是否全部在列表中
    public func isValidTag(activity: ActivityProfile, tags: [Text]) : Bool {
        Utils.arrayContainsAll(tags, activity.tags, tagEq)
    };

    public func isStrategyOfVoteSame(s1: StrategyOfVotes, s2: StrategyOfVotes) : Bool {
        s1.historyRatio == s2.historyRatio and 
            s1.periodRatio == s2.periodRatio and
            s1.maxPerProject == s2.maxPerProject and
            s1.maxPerActivity == s2.maxPerActivity and
            s1.minPerProject == s2.minPerProject
    };

    public type Bonus = Types.Bonus;

    /// 黑客松活动奖项
    public type ActivityPrize = {
        id : PrizeId;
        activityId: ActivityId;
        ranking: Nat;
        name: Text;
        bonus: [Bonus];
        quantity: Nat;
        description: Text;
        winners: [Participant];
    };

    public type PrizeCreateRequest = {
        activityId: ActivityId;
        ranking: Nat;
        name: Text;
        bonus: [Bonus];
        quantity: Nat;
        description: Text;
    };

    /// 黑客松活动奖金
    public type ActivityAwards = {
        id: Types.Id;      
        activityId: ActivityId;
        sponsorName: Text;
        name: Text;
        bonus: [Bonus];
        description: Text;
        quantity: Nat;
        ranking: Nat;
        requirements:RichText;
        winners: [Participant];
    };

    /// AwardsCreateRequest
    public type AwardsCreateRequest = {
        activityId: ActivityId;
        sponsorName: Text;
        name: Text;
        bonus: [Bonus];    /// 奖金金额
        description: Text;
        quantity: Nat;  /// 资金人数
        ranking: Nat;
        requirements:RichText;
    };

    public func createRequestToAwards(req: AwardsCreateRequest, awardsId: Types.Id) : ActivityAwards {
        {
            id = awardsId;
            activityId = req.activityId;
            sponsorName = req.sponsorName;
            name = req.name;
            bonus = req.bonus;
            description = req.description;
            quantity = req.quantity;
            ranking = req.ranking;
            requirements = req.requirements;
            winners = [];
        }
    };

    public func updateActivityAwardsWinner(aa: ActivityAwards, winners: [Participant]) : Result<ActivityAwards, Error> {
        if (aa.quantity >= Utils.arraySize(winners)) {
            #ok({
                id = aa.id;
                activityId = aa.activityId;
                sponsorName = aa.sponsorName;
                name = aa.name;
                bonus = aa.bonus;
                description = aa.description;
                quantity = aa.quantity;
                ranking = aa.ranking;
                requirements = aa.requirements;
                winners = winners;
            })
        } else {
            #err(#winnerTooLargeQuantity)
        }
    };

    public func updateActivityPrizeWinner(ap: ActivityPrize, winners: [Participant]) : Result<ActivityPrize, Error> {
        if (ap.quantity >= Utils.arraySize(winners)) {
            #ok({
                id = ap.id;
                activityId = ap.activityId;
                name = ap.name;
                bonus = ap.bonus;
                quantity = ap.quantity;
                ranking = ap.ranking;
                description = ap.description;
                winners = winners;
            })
        } else {
            #err(#winnerTooLargeQuantity)
        }
    };

    public func createRequestToPrize(req: PrizeCreateRequest, prizeId: Types.Id) : ActivityPrize {
        {
            id = prizeId;
            activityId = req.activityId;
            name = req.name;
            bonus = req.bonus;
            quantity = req.quantity;
            ranking = req.ranking;
            description = req.description;
            winners = [];
        }
    };

    /// 修改指定活动的状态
    public func modifyActivityStatus(p: ActivityProfile, status: StatusEnum) : ActivityProfile {
        let s = if (status == Constants.STATUS_ENABLE or status == Constants.STATUS_DISABLE) status else Constants.STATUS_PENDING;
        {
            id = p.id;
            title = p.title;
            tags = p.tags;
            coverPhotoUri = p.coverPhotoUri;
            mainPhotoUri = p.mainPhotoUri;
            publishTime = p.publishTime;
            startTime = p.startTime;
            endTime = p.endTime;
            introduction = p.introduction;
            strategy = p.strategy;
            bonus = p.bonus;
            bonusPool = p.bonusPool;
            status = s;
            createdBy = p.createdBy;
            createdAt = p.createdAt;
        }
    };

    /// 项目在活动中的投票
    public type ActivityProjectVoted = {
        activityId: ActivityId;
        projectId: Types.Id;
        votedSum: Nat;
        startTime: Timestamp;           // 活动开始时间
        endTime: Timestamp;             // 活动结束时间
        participatingTime: Timestamp;   // 项目参与活动时间
        historyRatio: Nat;
        periodRatio: Nat;
        minPerProject: Nat;     // 每个活动中项目的投票数下限
        maxPerProject: Nat;      
        maxPerActivity: Nat;
    };
    
    /// 赞助商为活动的额度
    public type ActivitySponsorQuota = {
        activityId: ActivityId;
        sponsorId: Types.Id;
        bonus: [Bonus];
        updateTime: Timestamp;
    };

    /// 创建活动供应商额度请求
    public type ActivitySponsorQuotaCreateRequest = {
        activityId: ActivityId;
        sponsorId: Types.Id;
        bonus: [Bonus];
    };

    /// 活动供应商信息
    public type ActivitySponsorProfile = {
        activityId: ActivityId;
        sponsorId: Types.Id;
        name: Text;
        description: Text;
        link: Text;
        logoUri: Text;
        bonus: [Bonus];
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
        updateTime: Timestamp;
    };

    /// 黑客松活动关联关系
    public type ActivityRelationship = {
        #awards: ActivityAwards;
        #prize: ActivityPrize;
        #project: ActivityProjectVoted;
        #sponsor: ActivitySponsorQuota;
    };

    /// 更新黑客松活动奖励的获胜者
    public type ActivityAwardsWinnerUpdateRequest = {
        activityId: ActivityId;
        awardsId: Types.Id;
        winners: [Participant]; //获胜的项目id
    };

    /// 更新黑客松活动奖项的获胜者
    public type ActivityPrizeWinnerUpdateRequest = {
        activityId: ActivityId;
        prizeId: Types.Id;
        winners: [Participant]; //获胜的项目id
    };

    /// 活动项目信息+投票数
    public type ActivityProjectProfileVoted = {
        activityId: ActivityId;
        projectId: Types.Id;
        name: Text;
        information: RichText;
        logoUri: Text;
        creator: Text;
        creatorInfo: Text;
        wallet: WalletCategory;
        contactInfo: Text;
        startTime: Timestamp;
        links: [Text];      
        tags: [Text];
        progress: ProgressStage;    // 项目的进度
        owner: UserPrincipal;
        votedSum: Nat;          // 项目的总投票数
        participatingTime: Timestamp;   // 项目参与活动时间
        historyRatio: Nat;      // 历史积分兑换票数的比例
        periodRatio: Nat;       // 活动期间积分兑换票数的比例
        minPerProject: Nat;     // 每个活动中项目的投票数下限
        maxPerProject: Nat;     // 每个活动中项目的投票数上限
        maxPerActivity: Nat;    // 每个活动的投票数上限
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    ///  黑客松活动项目的用户投票权和活动已投票累计
    public type ActivityProjectUserVote = {
        activityId: ActivityId;
        projectId: Types.Id;
        participatingTime: Timestamp;   // 项目参与活动时间
        user: UserPrincipal;
        userVotingTotalSum: Nat;  // 活动中用户的的总投票数;
        userVotedSum: Nat;  // 活动中用户的已投票数
        projectVotedSum: Nat; // 项目的总投票数
        activityVotedSum: Nat;  // 活动中的总投票数
        historyRatio: Nat;      // 历史积分兑换票数的比例
        periodRatio: Nat;       // 活动期间积分兑换票数的比例
        minPerProject: Nat;     // 每个活动中项目的投票数下限
        maxPerProject: Nat;     // 每个活动中项目的投票数上限
        maxPerActivity: Nat;    // 每个活动的投票数上限
    };

    /// 创建黑客松活动赞助商转换
    public func createActivitySponsorQuota(req: ActivitySponsorQuotaCreateRequest, updateTime: Timestamp) : ActivitySponsorQuota {
        {
            activityId = req.activityId;
            sponsorId = req.sponsorId;
            bonus = req.bonus;
            updateTime = updateTime;
        }
    };

    /// 累加黑客松活动投票
    public func addActivityProjectVotedSum(apv: ActivityProjectVoted, votingAmount: Nat) : ActivityProjectVoted {
        {
            activityId = apv.activityId;
            projectId = apv.projectId;
            votedSum = apv.votedSum + votingAmount;
            startTime = apv.startTime;
            endTime = apv.endTime;
            participatingTime = apv.participatingTime;
            historyRatio = apv.historyRatio;
            periodRatio = apv.periodRatio;
            minPerProject = apv.minPerProject;
            maxPerProject = apv.maxPerProject;
            maxPerActivity = apv.maxPerActivity;
        }
    };

    public func newActivityProjectVoted(activityId: ActivityId, projectId: Types.Id, votedSum: Nat, startTime: Timestamp, endTime: Timestamp, 
        participatingTime: Timestamp, historyRatio: Nat, periodRatio: Nat, minPerProject: Nat, maxPerProject: Nat, maxPerActivity: Nat) : ActivityProjectVoted {
        {
            activityId = activityId;
            projectId = projectId;
            votedSum = votedSum;
            startTime = startTime;
            endTime = endTime;
            participatingTime = participatingTime;
            historyRatio = historyRatio;
            periodRatio = periodRatio;
            minPerProject = minPerProject;
            maxPerProject = maxPerProject;
            maxPerActivity = maxPerActivity;
        }
    };

    public func newActivityProjectUserVote(a: ActivityProfile, apv: ActivityProjectVoted, uvr: UserVotingRight,
        activityVotedSum: Nat) : ActivityProjectUserVote {
            assert(a.id == apv.activityId);
        {
            activityId = a.id;
            projectId = apv.projectId;
            participatingTime = apv.participatingTime;   // 项目参与活动时间
            user = uvr.user;
            userVotingTotalSum = uvr.totalSum;
            userVotedSum = uvr.votedSum;
            projectVotedSum = apv.votedSum;
            activityVotedSum = activityVotedSum;
            historyRatio = a.strategy.historyRatio;
            periodRatio = a.strategy.periodRatio;
            minPerProject = a.strategy.minPerProject;
            maxPerProject = a.strategy.maxPerProject;
            maxPerActivity = a.strategy.maxPerActivity;
        }
    };

}