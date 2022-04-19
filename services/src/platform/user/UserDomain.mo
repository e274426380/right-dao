
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

import Constants "../constant/Constants";
import Types "../base/Types";
import Utils "../base/Utils";

module {

    public type Timestamp = Types.Timestamp;
    public type StatusEnum = Types.StatusEnum;
    public type Error = Types.Error;

    /// 用户数据
    public type UserId = Types.Id;
    public type UserPrincipal = Types.UserPrincipal;

    public type UserProfile = {
        id : UserId;
        owner : UserPrincipal;
        username : Text;
        avatarUri : Text;
        introduction: Text;
        contactInfo: Text;
        projectUri: [Text];
        registerFrom: Text;
        ipAddress: Text;    // 第一次注册时携带的参数
        lastLoginTime: Timestamp;       // 第一次注册时设置为当前时间戳
        status : StatusEnum;
        createdBy : UserPrincipal;
        createdAt : Timestamp;
    };

    /// 用户公开数据信息
    public type UserPublicInfo = {
        id: UserId;
        owner: UserPrincipal;
        username: Text;
        avatarUri: Text;
        introduction: Text;
        projectUri: [Text];
    };

    /// 用户数据+平台行为数据汇总
    public type UserBehaviourSummary = {
        owner: UserPrincipal;
        grantSum: Nat;  // 个人打赏给他人的累计金额
        pointSum: Int;  // 个人累计积分
        projectCount: Nat;  // 个人发布项目的累计总数
        votingCount: Nat;   // 个人投票的次数
        commentCount: Nat;  // 个人评论的次数
        applyingCount: Nat; // 个人申请的次数
    };

    /// 用户登录会话
    public type UserSession = {
        owner: UserPrincipal;
        loginTime: Timestamp;
    };

    /// 用户分页查询请求值对象
    public type UserPageQuery = {
        principalId: UserPrincipal;
        username: Text;
        contactInfo: Text;
        startTime: Timestamp;
        endTime: Timestamp;
        pageSize: Nat;
        pageNum: Nat;
    };

    /// 更新用户登录时间请求
    public type UserUpdateLoginTimeCommand = {
        loginTime: Timestamp
    };

    /// 给用户授权管理员权限命令
    public type AssignAdminRoleCommand = {
        user: UserPrincipal;
        name: ?Text;
    };

    /// profile information provided by service to front end views -- Pic is separate query
    public type ProfileInfo = {
        username: Text;
        following: [UserPrincipal];
        followers: [UserPrincipal];
        // uploadedVideos: [VideoId];
        // likedVideos: [VideoId];
        hasPic: Bool;
        // rewards: Nat;
        abuseFlagCount: Nat; // abuseFlags counts other users' flags on this profile, for possible blurring.
    };

    /// 辅助方法 User.equal
    public let userEq = Text.equal;
    public let userHash = Text.hash;

    /// 创建新用户
    public func newUser(userId: UserId, owner: UserPrincipal, registerFrom: Text, ipAddress: Text, 
        createdBy: UserPrincipal, createdAt: Timestamp, avatarUri: Text) : UserProfile {
        {
            id = userId;
            owner = owner;
            username = "";
            avatarId = 0;
            introduction = "";
            contactInfo = "";
            projectUri = [];
            registerFrom = registerFrom;
            ipAddress = ipAddress;
            lastLoginTime = createdAt;
            status = Constants.STATUS_ENABLE;
            createdBy = createdBy;
            createdAt = createdAt;
            avatarUri = avatarUri;
        }
    };

    /// 修改用户名
    public func editUsername(u: UserProfile, newName: Text) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = newName;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            contactInfo = u.contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 修改用户最近登录时间
    public func updateUserLastLoginTime(u: UserProfile, loginTime: Timestamp) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            contactInfo = u.contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = loginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 修改用户头像 uri
    public func editAvatarUri(u: UserProfile, avatarUri: Text) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = avatarUri;
            introduction = u.introduction;
            contactInfo = u.contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 修改用户介绍
    public func editIntroduction(u: UserProfile, intro: Text) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = intro;
            contactInfo = u.contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 修改用户联系方式
    public func editContactInfo(u: UserProfile, contactInfo: Text) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            contactInfo = contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 修改项目uri
    public func editProjectUri(u: UserProfile, newProjectUris: [Text]) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            contactInfo = u.contactInfo;
            projectUri = newProjectUris;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = u.status;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 增加用户单个项目链接
    public func addSingleProjectUri(u: UserProfile, uri: Text) : UserProfile{
        let currentProjectUri = u.projectUri;
        /// 如果同样内容的联系方式已经存在,直接返回UserProfile
        if (Option.isSome(Array.find<Text>(currentProjectUri, func (t) : Bool { t == uri }))) {
            return u;
        };

        let newProjectUris = Array.append(currentProjectUri, Array.make<Text>(uri));
        editProjectUri(u, newProjectUris)
    };

    /// 修改用户项目链接, idx是原来联系方式在个人联系方式中的索引
    public func editSingleProjectUri(u: UserProfile, idx: Nat, uri: Text) : UserProfile {
        let uriSize = Utils.arraySize<Text>(u.projectUri);
        if (idx >= uriSize) {
            return u;
        };

        let projectUriVar = Array.thaw<Text>(u.projectUri);
        projectUriVar[idx] := uri;
        let projectUris = Array.freeze<Text>(projectUriVar);
        editProjectUri(u, projectUris)
    };

    /// 删除用户项目链接, idx是原来联系方式在个人联系方式中的索引
    public func deleteSingleProjectUri(u: UserProfile, idx: Nat) : UserProfile {
        let uris = u.projectUri;
        let uriSize = Utils.arraySize<Text>(uris);
        if (idx >= uriSize) {
            return u;
        };

        let buffer = Buffer.Buffer<Text>(uriSize - 1);
        for (i in u.projectUri.keys()) {
            if (i != idx) {
                buffer.add(uris[i])
            };
        };
        let projectUris = buffer.toArray();
        editProjectUri(u, projectUris)
    };

    /// 修改用户状态
    public func editUserStatus(u: UserProfile, newStatus: StatusEnum) : UserProfile {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            contactInfo = u.contactInfo;
            projectUri = u.projectUri;
            registerFrom = u.registerFrom;
            ipAddress = u.ipAddress;
            lastLoginTime = u.lastLoginTime;
            status = newStatus;
            createdBy = u.createdBy;
            createdAt = u.createdAt;
        }
    };

    /// 禁用用户
    public func disableUser(u: UserProfile) : UserProfile{
        editUserStatus(u, Constants.STATUS_DISABLE)
    };

    /// 启用用户
    public func enableUser(u: UserProfile) : UserProfile {
        editUserStatus(u, Constants.STATUS_ENABLE)
    };

    /// 用户是否 被禁用
    public func userIsDisabled(u: UserProfile) : Bool {
        u.status == Constants.STATUS_DISABLE
    };

    /// 判断是否包含指定的principal,不区分大小写
    public func userContainsPrincipal(u: UserProfile, str: Text) : Bool {
       Utils.containsStr(Utils.toLowerCase(u.owner), Utils.toLowerCase(str))
    };

    /// 判断用户是否包含指定的用户名,不区分大小写
    public func userContainsUsername(u: UserProfile, str: Text) : Bool {
       Utils.containsStr(Utils.toLowerCase(u.username), Utils.toLowerCase(str))
    };

    /// 判断用户是否包含指定的联系方式,不区分大小写
    public func userContainsContactInfo(u: UserProfile, str: Text) : Bool {
       Utils.containsStr(Utils.toLowerCase(u.contactInfo), Utils.toLowerCase(str))
    };

    /// 判断用户是否在对应创建时间内
    public func userBetweenCreatedTime(profile: UserProfile, startTime: Timestamp, endTime: Timestamp) : Bool {
       profile.createdAt >= startTime and profile.createdAt <= endTime
    };

    /// 按创建时间倒序，越大表示越新，排在前面
    public func userOrderByCreatedAtDesc(profile1: UserProfile, profile2: UserProfile) : Order.Order {
        Int.compare(profile2.createdAt, profile1.createdAt)
    };

    public func userPublicInfo(u: UserProfile) : UserPublicInfo {
        {
            id = u.id;
            owner = u.owner;
            username = u.username;
            avatarUri = u.avatarUri;
            introduction = u.introduction;
            projectUri = u.projectUri;
        }
    };

    public func profileToText(profile: UserProfile) : Text {
        "{\"userId\": " # Nat.toText(profile.id) # ", \"owner\": \"" # profile.owner #
        "\", \"username\": \"" # profile.username # "\", \"status\": \"" # profile.status # "\", \"createdBy\": \"" #
        profile.createdBy # "\", \"createdAt\": " # Int.toText(profile.createdAt) # "}"
    };

    /// UserBehaviourSummary

    /// 用户是否有积分
    public func userHasPoint(ubs: UserBehaviourSummary) : Bool {
        ubs.pointSum > 0
    };
    
    /// 新建UserBehaviourSummary,各数据为0
    public func newUserBehaviourSummary(owner_ : UserPrincipal) : UserBehaviourSummary {
        {
            owner = owner_;
            grantSum = 0;
            pointSum = 0;
            projectCount = 0;
            votingCount = 0;
            commentCount = 0;
            applyingCount = 0;
        }
    };

    /// 行为数据增加一个项目
    public func addBehaviourProject(m: UserBehaviourSummary, amount: Nat) : UserBehaviourSummary {
        {
            owner = m.owner;
            grantSum = m.grantSum;
            pointSum = m.pointSum;
            projectCount = m.projectCount + amount;
            votingCount = m.votingCount;
            commentCount = m.commentCount;
            applyingCount = m.applyingCount;
        }
    };

    /// 行为数据增加一个评论
    public func addBehaviourComment(m: UserBehaviourSummary, amount: Nat) : UserBehaviourSummary {
        {
            owner = m.owner;
            grantSum = m.grantSum;
            pointSum = m.pointSum;
            projectCount = m.projectCount;
            votingCount = m.votingCount;
            commentCount = m.commentCount + amount;
            applyingCount = m.applyingCount;
        }
    };

    /// 行为数据增加一次申请
    public func addBehaviourApplying(m: UserBehaviourSummary, amount: Nat) : UserBehaviourSummary {
        {
            owner = m.owner;
            grantSum = m.grantSum;
            pointSum = m.pointSum;
            projectCount = m.projectCount ;
            votingCount = m.votingCount;
            commentCount = m.commentCount;
            applyingCount = m.applyingCount + amount;
        }
    };

    /// 行为数据增加一次投票
    public func addBehaviourVoting(m: UserBehaviourSummary, amount: Nat) : UserBehaviourSummary {
        {
            owner = m.owner;
            grantSum = m.grantSum;
            pointSum = m.pointSum;
            projectCount = m.projectCount;
            votingCount = m.votingCount + amount;
            commentCount = m.commentCount;
            applyingCount = m.applyingCount;
        }
    };

    /// 行为数据增加捐助总额
    public func addBehaviourGrantSum(m: UserBehaviourSummary, amount: Nat) : UserBehaviourSummary {
        {
            owner = m.owner;
            grantSum = m.grantSum + amount;
            pointSum = m.pointSum;
            projectCount = m.projectCount;
            votingCount = m.votingCount;
            commentCount = m.commentCount;
            applyingCount = m.applyingCount;
        }
    };

    /// 行为数据增加积分总额
    public func addBehaviourPointSum(m: UserBehaviourSummary, amount: Int) : UserBehaviourSummary {
        let res : Int = m.pointSum + amount;
        let pointSum = if (res < 0) { 0 } else res;
        {
            owner = m.owner;
            grantSum = m.grantSum;
            pointSum = pointSum;
            projectCount = m.projectCount;
            votingCount = m.votingCount;
            commentCount = m.commentCount;
            applyingCount = m.applyingCount;
        }
    };

    /// Check if User name is valid, which is defined as:
    /// 1. Between 3 and 50 characters long
    /// 2. Alphanumerical. Special characters like  '_' and '-' are also allowed.
    /// 3. must start with Alpha
    public func validUsername(name: Text): Bool {
        
        let str : [Char] = Iter.toArray(Text.toIter(name));
        if (str.size() < 3 or str.size() > 50) {
            return false;
        };

        for (i in Iter.range(0, str.size() - 1)) {
            let c = str[i];
            if (not (Char.isDigit(c) or Char.isAlphabetic(c) or (c == '_') or (c == '-'))) {
                return false;
            }
        };
        true
    };

    /// 检查注册来源是几个约定的渠道
    public func checkRegisterFrom(text: Text) : Text {
        if (text == "web") {
            text
        } else { "other" }
    };

    /// 检查用户项目链接是否超过5个限制
    public func isProjectUriExceedMaxLimit(u: UserProfile) : Bool {
        Utils.arraySize(u.projectUri) >= Constants.PROJECT_URI_MAX_LIMIT
    };
}
