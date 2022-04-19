

import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";

import Types "../base/Types";
import Utils "../base/Utils";
import Constants "../constant/Constants";

module {

    public type ActivityId = Types.Id;
    public type Bonus = Types.Bonus;
    public type UserPrincipal = Types.UserPrincipal;
    public type Timestamp = Types.Timestamp;
    public type ProjectStatus = Types.StatusEnum;

    public type ProjectId = Types.Id;
    public type ProjectTag = Text;
    public type ProgressStage = Types.ProgressStage;

    public type RichText = Types.RichText;

    public type WalletCategory = Types.WalletCategory;

    public type ProjectProfile = {
        id : ProjectId;
        name: Text;
        information: RichText;
        logoUri: Text;
        creator: Text;
        creatorInfo: Text;
        wallet: WalletCategory;
        contactInfo: Text;
        startTime: Timestamp;
        links: [Text];      
        tags: [ProjectTag];
        progress: ProgressStage;    // 项目的进度
        owner: UserPrincipal;
        status: ProjectStatus;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    public type ProjectCreateRequest = {
        name: Text;
        information: RichText;
        logoUri: Text;
        creator: Text;
        creatorInfo: Text;
        wallet: WalletCategory;
        contactInfo: Text;
        startTime: Timestamp;
        links: [Text];
        tags: [ProjectTag];
        progress: ProgressStage;    
    };

    public func projectToText(profile: ProjectProfile) : Text {
        "{\"id\": " # Nat.toText(profile.id) # ", \"name\": \"" # profile.name #
        "\", \"creator\": \"" # profile.creator # "\", \"logoId\": " # profile.logoUri # 
        ", \"owner\": \"" # profile.owner # "\", \"contactInfo\": \"" # profile.contactInfo # 
        "\", \"progress\": \"" # profile.progress # "\", \"startTime\": \"" # Int.toText(profile.startTime) # 
        "\", \"status\": \"" # profile.status # "\", \"createdBy\": \"" #
        profile.createdBy # "\", \"createdAt\": " # Int.toText(profile.createdAt) # "}"
    };

    /// ProjectProfile是否可用状态
    public func isEnableProject(projectProfile: ProjectProfile) : Bool {
        projectProfile.status  == Constants.STATUS_ENABLE
    };

    /// 检查指定用户是否Project的Owner
    public func isProjectOwner(projectProfile: ProjectProfile, userPrincipal: UserPrincipal) : Bool {
        projectProfile.owner == userPrincipal
    };

    public func projectContainsTag(projectProfile: ProjectProfile, tag: ProjectTag) : Bool {
        Option.isSome(Array.find<ProjectTag>(projectProfile.tags, func (t) : Bool { t == tag }))
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareById(profile1: ProjectProfile, profile2: ProjectProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// 修改项目的项目状态
    public func modifyProjectStatus(p: ProjectProfile, status: ProjectStatus) : ProjectProfile {
        let s = if (status == Constants.STATUS_ENABLE or status == Constants.STATUS_DISABLE) status else Constants.STATUS_PENDING;
        {
            id = p.id;
            name = p.name;
            information = p.information;
            logoUri = p.logoUri;
            creator = p.creator;
            creatorInfo = p.creatorInfo;
            wallet = p.wallet;
            contactInfo = p.contactInfo;
            startTime = p.startTime;
            links = p.links;
            owner = p.owner;
            tags = p.tags;
            progress = p.progress;
            status = s;
            createdBy = p.createdBy;
            createdAt = p.createdAt;
        }
    };

    /// 修改项目的项目状态
    public func modifyProjectProgress(p: ProjectProfile, progress: ProgressStage) : ProjectProfile {
        {
            id = p.id;
            name = p.name;
            information = p.information;
            logoUri = p.logoUri;
            creator = p.creator;
            creatorInfo = p.creatorInfo;
            wallet = p.wallet;
            contactInfo = p.contactInfo;
            startTime = p.startTime;
            links = p.links;
            owner = p.owner;
            tags = p.tags;
            progress = progress;
            status =  p.status;
            createdBy = p.createdBy;
            createdAt = p.createdAt;
        }
    };

    public func isLegalProgress(progress: Text) : Bool {
        progress == Constants.PROGRESS_IN_PROGRESS or
        progress == Constants.PROGRESS_IN_PREPARATION or
        progress == Constants.PROGRESS_COMPLETED
    };

    /// 按创建时间倒序
    public func compareByCreateTimeDesc(profile1: ProjectProfile, profile2: ProjectProfile) : Order.Order {
        Int.compare(profile2.createdAt, profile1.createdAt)
    };

    /// 项目名称 首尾去空格 20 个字符
    public func isValidProjectName(name: Text) : Bool {
        let n = Utils.trim(name);
        Utils.lessOrEqCharNumber(n, 20)
    };

    /// 项目介绍 10000个字符，图片格式字符问自行解决 <img xx
    public func isValidProjectIntro(t: Text) : Bool {
        Utils.lessOrEqCharNumber(t, 10000)
    };

    /// 钱包地址:限制字符长度为100位
    public func isValidWalletAddress(walletCategory: WalletCategory) : Bool {
        let address = walletCategory.walletAddress;
        Utils.lessOrEqCharNumber(address, 100)
    };

    /// 币种长度:限制字符长度为100位
    public func isValidCurrency(c: Text) : Bool {
        Utils.lessOrEqCharNumber(c, 100)
    };

    /// 公链:限制字符长度为20位
    public func isValidChainName(t: Text) : Bool {
        Utils.lessOrEqCharNumber(t, 10)
    };

    /// 创建团队 20 字符
    public func isValidUserName(t: Text) : Bool {
        Utils.lessOrEqCharNumber(t, 20)
    };

    /// 团队简介限制300字符
    public func isValidUserIntro(intro: Text) : Bool {
        Utils.lessOrEqCharNumber(intro, 300)
    };

    /// 标签类型是否全部在列表中
    public func isValidTag(tags: [Text], projectTags: [Text]) : Bool {
        Utils.arrayContainsAll(tags, projectTags, tagEq)
    };

    /// 联系方式30字符
    public func isValidContactInfo(contactInfo: Text) : Bool {
        Utils.lessOrEqCharNumber(contactInfo, 30)
    };

    /// 项目链接 每个连接 最多 5 个链接至少 1 个链接 不能是空列表
    public func isValidLinks(links: [Text]) : Bool {
        let linksSize = Utils.arraySize(links);
        linksSize > 0 and linksSize <= 5
    };

    /// 钱包地址是否符合规范,长度64,字母和数字组成
    public let isValidICPWalletAddress = Constants.isValidICPWalletAddress;
    

    /// 检查创建项目时各字段是否符合要求
    public func isValidProjectField(profile: ProjectProfile, tags: [Text]) : Bool {
        isValidProjectName(profile.name) and isValidProjectIntro(profile.information.content) and isValidWalletAddress(profile.wallet) and
            isValidCurrency(profile.wallet.currency) and isValidChainName(profile.wallet.chain) and 
            isValidUserName(profile.creator) and isValidUserIntro(profile.creatorInfo) and isValidTag(tags, profile.tags)
    };

    /// 辅助方法 Project.equal
    public let projectEq = Nat.equal;

    public let projectHash = Hash.hash;

    /// Project与User 对
    public let projectUserPairEqual = (Nat.equal, Text.equal);
    public let projectUserPairHash = (Hash.hash, Text.hash);

    /// Project Tag equal
    public let tagEq = Types.tagEq;

    /// 项目的获奖信息
    public type ProjectActivityAwardsPrizeVoted = {
        projectId: ProjectId;
        activityId: ActivityId;      
        activityTitle: Text;
        projectOwner: UserPrincipal;
        participatingTime: Timestamp;   // 项目参与活动时间
        awards: [Types.Id];     // [AwardsId]
        prize: [Types.Id];      // [PrizeId]
        votedSum: Nat;
        historyRatio: Nat;      // 历史积分兑换票数的比例
        periodRatio: Nat;       // 活动期间积分兑换票数的比例
        minPerProject: Nat;     // 每个活动中项目的投票数下限
        maxPerProject: Nat;     // 每个活动中项目的投票数上限
        maxPerActivity: Nat;    // 每个活动的投票数上限
    };

    public func newProjectActivityAwardsPrizeVoted(projectId: ProjectId, activityId: ActivityId, activityTitle: Text, awards: [Types.Id], prize: [Types.Id], votingAmount: Nat, 
        historyRatio: Nat, periodRatio: Nat, minPerProject: Nat, maxPerProject: Nat, maxPerActivity: Nat, projectOwner: UserPrincipal, participatingTime: Timestamp) : ProjectActivityAwardsPrizeVoted {
        {
            projectId = projectId;
            activityId = activityId;
            activityTitle = activityTitle;
            projectOwner = projectOwner;
            participatingTime = participatingTime;
            awards = awards;
            prize = prize;
            votedSum = votingAmount;
            historyRatio = historyRatio;
            periodRatio = periodRatio;
            minPerProject = minPerProject;
            maxPerProject = maxPerProject;
            maxPerActivity = maxPerActivity;
        }
    };

    public func addAwardsOfProjectActivityAwardsPrizeVoted(paapv: ProjectActivityAwardsPrizeVoted, awardsId: Types.Id) : ProjectActivityAwardsPrizeVoted {
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            projectOwner = paapv.projectOwner;
            participatingTime = paapv.participatingTime;
            awards = Array.append<Nat>(paapv.awards, [awardsId]);
            prize = paapv.prize;
            votedSum = paapv.votedSum;
            historyRatio = paapv.historyRatio;
            periodRatio = paapv.periodRatio;
            minPerProject = paapv.minPerProject;
            maxPerProject = paapv.maxPerProject;
            maxPerActivity = paapv.maxPerActivity;
        }
    };

    public func removeAwardsOfProjectActivityAwardsPrizeVoted(paapv: ProjectActivityAwardsPrizeVoted, awardsId: Types.Id) : ProjectActivityAwardsPrizeVoted {
        let awards = Array.filter<Nat>(paapv.awards, func (aId) : Bool { not(aId == awardsId) });
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            projectOwner = paapv.projectOwner;
            participatingTime = paapv.participatingTime;
            awards = awards;
            prize = paapv.prize;
            votedSum = paapv.votedSum;
            historyRatio = paapv.historyRatio;
            periodRatio = paapv.periodRatio;
            minPerProject = paapv.minPerProject;
            maxPerProject = paapv.maxPerProject;
            maxPerActivity = paapv.maxPerActivity;
        }
    };

    public func addPrizeOfProjectActivityAwardsPrizeVoted(paapv: ProjectActivityAwardsPrizeVoted, prizeId: Types.Id) : ProjectActivityAwardsPrizeVoted {
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            projectOwner = paapv.projectOwner;
            participatingTime = paapv.participatingTime;
            awards = paapv.awards;
            prize = Array.append<Nat>(paapv.prize, [prizeId]);
            votedSum = paapv.votedSum;
            historyRatio = paapv.historyRatio;
            periodRatio = paapv.periodRatio;
            minPerProject = paapv.minPerProject;
            maxPerProject = paapv.maxPerProject;
            maxPerActivity = paapv.maxPerActivity;
        }
    };

    public func removePrizeOfProjectActivityAwardsPrizeVoted(paapv: ProjectActivityAwardsPrizeVoted, prizeId: Types.Id) : ProjectActivityAwardsPrizeVoted {
        let prize = Array.filter<Nat>(paapv.prize, func (pId) : Bool { not(pId == prizeId) });
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            projectOwner = paapv.projectOwner;
            participatingTime = paapv.participatingTime;
            awards = paapv.awards;
            prize = Array.append<Nat>(paapv.prize, [prizeId]);
            votedSum = paapv.votedSum;
            historyRatio = paapv.historyRatio;
            periodRatio = paapv.periodRatio;
            minPerProject = paapv.minPerProject;
            maxPerProject = paapv.maxPerProject;
            maxPerActivity = paapv.maxPerActivity;
        }
    };

    public func addVotedSumOfProjectActivityAwardsPrizeVoted(paapv: ProjectActivityAwardsPrizeVoted, votingAmount: Nat) : ProjectActivityAwardsPrizeVoted {
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            projectOwner = paapv.projectOwner;
            participatingTime = paapv.participatingTime;
            awards = paapv.awards;
            prize = paapv.prize;
            votedSum = paapv.votedSum + votingAmount;
            historyRatio = paapv.historyRatio;
            periodRatio = paapv.periodRatio;
            minPerProject = paapv.minPerProject;
            maxPerProject = paapv.maxPerProject;
            maxPerActivity = paapv.maxPerActivity;
        }
    };

    /// 创建项目时,状态默认是未审核(PENING)
    public func createRequestToProfile(request: ProjectCreateRequest, projectId: ProjectId, createdBy: UserPrincipal, createdAt: Timestamp) : ProjectProfile {
        { 
            id = projectId;
            name = request.name;
            information = request.information;
            logoUri = request.logoUri;
            creator = request.creator;
            creatorInfo = request.creatorInfo;
            wallet = request.wallet;
            contactInfo = request.contactInfo;
            startTime = request.startTime;
            links = request.links;
            owner = createdBy;
            tags = request.tags;
            progress = request.progress;
            status = Constants.STATUS_PENDING;
            createdBy = createdBy;
            createdAt = createdAt;
        }
    };

    /// 项目获取的荣誉, 在项目详情页显示参与活动获得的荣誉标签页上使用
    public type ProjectActivityAwardsView = {
        projectId: ProjectId;
        activityId: ActivityId;
        activityTitle: Text;
        awardsId: Types.Id;
        awardsName: Text;
        bonus: [Bonus];
        ranking: Nat;
        participatingTime: Timestamp;   // 项目参与活动时间
    };

    public func createProjectActivityAwardsView(paapv: ProjectActivityAwardsPrizeVoted, awardsId: Types.Id, awardsName: Text, 
        bonus: [Bonus], ranking: Nat) : ProjectActivityAwardsView {
        {
            projectId = paapv.projectId;
            activityId = paapv.activityId;
            activityTitle = paapv.activityTitle;
            awardsId = awardsId;
            awardsName = awardsName;
            bonus = bonus;
            ranking = ranking;
            participatingTime = paapv.participatingTime;
        }
    };
    
};

