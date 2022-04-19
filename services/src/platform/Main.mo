
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import List "mo:base/List";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";

import Access "./validation/Access";
import BannerDomain "./banner/BannerDomain";
import BannerRepositories "./banner/BannerRepositories";
import BountyDomain "./bounty/BountyDomain";
import BountyRepositories "./bounty/BountyRepositories";
import Constants "./constant/Constants";
import EmailDomain "./email/EmailDomain";
import EmailRepositories "./email/EmailRepositories";
import HackathonDomain "./hackathon/HackathonDomain";
import HackathonRepositories "./hackathon/HackathonRepositories";
import Global "./state/Global";
import GrantDomain "./grant/GrantDomain";
import GrantRepositories "./grant/GrantRepositories";
import HashMapRepositories "./repositories/HashMapRepositories";
import LedgerServices "./ledger/LedgerServices";
import PageHelper "./base/PageHelper";
import Param "./base/Param";
import PointDomain "./point/PointDomain";
import PointRepositories "./point/PointRepositories";
import ProjectDomain "./project/ProjectDomain";
import ProjectRepositories "./project/ProjectRepositories";
import RecordingDomain "./recording/RecordingDomain";
import RecordingRepositories "./recording/RecordingRepositories";
import Rel "./base/Rel";
import RelObj "./base/RelObj";
import RoleDomain "./validation/RoleDomain";
import RoleRepositories "./validation/RoleRepositories";
import SponsorDomain "./sponsor/SponsorDomain";
import SponsorRepositories "./sponsor/SponsorRepositories";
import TagDomain "./tag/TagDomain";
import TagRepositories "./tag/TagRepositories";
import Types "./base/Types";
import UserDomain "./user/UserDomain";
import UserRepositories "./user/UserRepositories";
import Utils "./base/Utils";

import Logger "canister:log_service";

/// 平台功能Canister，对外提供相应API
 actor Platform {

    public type List<X> = List.List<X>;
    public type Result<X, Y> = Result.Result<X, Y>;

    public type StatusEnum = Types.StatusEnum;
    public type Timestamp = Types.Timestamp;
    public type WalletCategory = Types.WalletCategory;

    /// User
    public type AssignAdminRoleCommand = UserDomain.AssignAdminRoleCommand;
    public type AvatarId = Types.Id;
    public type UserId = UserDomain.UserId;
    public type UserPrincipal = UserDomain.UserPrincipal;
    public type UserProfile = UserDomain.UserProfile;
    public type UserPage = UserRepositories.UserPage;
    public type UserPageQuery = UserDomain.UserPageQuery;
    public type UserUpdateLoginTimeCommand = UserDomain.UserUpdateLoginTimeCommand;
    public type UserPublicInfo = UserDomain.UserPublicInfo;
    public type UserSession = UserDomain.UserSession;
    public type UserBehaviourSummary = UserDomain.UserBehaviourSummary;

    public type UserDB = UserRepositories.UserDB;
    public type UserCache = UserRepositories.UserCache;
    public type UserRepository = UserRepositories.UserRepository;
    public type UserBehaviourSummaryDB =UserRepositories.UserBehaviourSummaryDB;
    public type UserBehaviourSummaryCache = UserRepositories.UserBehaviourSummaryCache;
    public type UserBehaviourSummaryRepository = UserRepositories.UserBehaviourSummaryRepository;

    public type Page<X> = PageHelper.Page<X>;

    public type Error = Types.Error;

    public type Role = RoleDomain.Role;
    public type RoleProfile  = RoleDomain.RoleProfile;
    public type RoleDB = RoleRepositories.RoleDB;
    public type RoleRepository = RoleRepositories.RoleRepository;

    /// 黑客松活动
    public type ActivityId = HackathonDomain.ActivityId;
    public type ActivityCreateRequest = HackathonDomain.ActivityCreateRequest;
    public type ActivityProfile = HackathonDomain.ActivityProfile;
    public type ActivitySummary = HackathonDomain.ActivitySummary;
    public type ActivityAwards = HackathonDomain.ActivityAwards;
    public type AwardsCreateRequest = HackathonDomain.AwardsCreateRequest;
    public type ActivityAwardsWinnerUpdateRequest = HackathonDomain.ActivityAwardsWinnerUpdateRequest;
    public type ActivityPrize = HackathonDomain.ActivityPrize;
    public type PrizeCreateRequest = HackathonDomain.PrizeCreateRequest;
    public type ActivityPrizeWinnerUpdateRequest = HackathonDomain.ActivityPrizeWinnerUpdateRequest;
    public type ActivityProjectVotingCreateRequest = RecordingDomain.ActivityProjectVotingCreateRequest;
    public type ActivityProjectProfileVoted = HackathonDomain.ActivityProjectProfileVoted;
    public type ActivityProjectVoted = HackathonDomain.ActivityProjectVoted;
    public type ActivityProjectUserVote = HackathonDomain.ActivityProjectUserVote;
    public type ActivitySponsorProfile = HackathonDomain.ActivitySponsorProfile;
    public type ActivitySponsorQuota = HackathonDomain.ActivitySponsorQuota;
    public type ActivitySponsorQuotaCreateRequest = HackathonDomain.ActivitySponsorQuotaCreateRequest;
    public type ActivityPage = HackathonRepositories.ActivityPage;
    public type ActivityDB = HackathonRepositories.ActivityDB;
    public type ActivityCache = HackathonRepositories.ActivityCache;
    public type ActivityRepository = HackathonRepositories.ActivityRepository;

    public type ActivityRelDB = HackathonRepositories.ActivityRelDB;
    public type ActivityRelCache = HackathonRepositories.ActivityRelCache;
    public type ActivityRelRepository = HackathonRepositories.ActivityRelRepository;

    /// 轮播图
    public type BannerId = BannerDomain.BannerId;
    public type BannerCategory = BannerDomain.BannerCategory;
    public type BannerProfile = BannerDomain.BannerProfile;
    public type BannerIdWithData = BannerRepositories.BannerIdWithData;
    public type BannerDB = BannerRepositories.BannerDB;

    /// Bounty
    public type BountyId = BountyDomain.BountyId;
    public type BountyProfile = BountyDomain.BountyProfile;
    public type BountyDB = BountyRepositories.BountyDB;
    public type BountyCache = BountyRepositories.BountyCache;
    public type BountyRepository = BountyRepositories.BountyRepository;

    /// 邮箱地址
    public type EmailAddress = EmailDomain.EmailAddress;
    public type EmailSubscribeCommand = EmailDomain.EmailSubscribeCommand;
    public type EmailPageQuery = EmailDomain.EmailPageQuery;
    public type EmailSubscription = EmailDomain.EmailSubscription;
    public type EmailPage = EmailRepositories.EmailPage;
    public type EmailAddressDB = EmailRepositories.EmailAddressDB;
    public type EmailAddressRepository = EmailRepositories.EmailAddressRepository;

    /// Grant
    public type GrantId = GrantDomain.GrantId;
    public type GrantProfile = GrantDomain.GrantProfile;
    public type GrantCreateRequest = GrantDomain.GrantCreateRequest;
    public type GrantUpdateBlockHeightRequest = GrantDomain.GrantUpdateBlockHeightRequest;
    public type UserPointView = GrantDomain.UserPointView;
    public type GrantPage = GrantRepositories.GrantPage;
    public type GrantDB = GrantRepositories.GrantDB;
    public type GrantCache = GrantRepositories.GrantCache;
    public type GrantRepository = GrantRepositories.GrantRepository;

    /// Point 
    public type AirdropPointPlanId = PointDomain.AirdropPointPlanId;
    public type AirdropPointPlanSaveRequest = PointDomain.AirdropPointPlanSaveRequest;
    public type AirdropPointPlanCreateResponse = PointDomain.AirdropPointPlanCreateResponse;
    public type AirdropPointPlanProfile = PointDomain.AirdropPointPlanProfile;
    public type AirdropPointPlanPage = PointRepositories.AirdropPointPlanPage;
    public type TargetId = PointRepositories.TargetId;
    public type UserVotingRight = PointDomain.UserVotingRight;
    public type AirdropPointPlanDB = PointRepositories.AirdropPointPlanDB;
    public type AirdropPointPlanCache = PointRepositories.AirdropPointPlanCache;
    public type AirdropPointPlanRepository = PointRepositories.AirdropPointPlanRepository;

    public type VotingRightDB = PointRepositories.VotingRightDB;
    public type VotingRightCache = PointRepositories.VotingRightCache;
    public type VotingRightRepository = PointRepositories.VotingRightRepository;

    /// Project
    public type ProjectId = ProjectDomain.ProjectId;
    public type ProjectProfile = ProjectDomain.ProjectProfile;
    public type ProjectStatus = ProjectDomain.ProjectStatus;
    public type ProgressStage = ProjectDomain.ProgressStage;
    public type ProjectCreateRequest = ProjectDomain.ProjectCreateRequest;
    public type ProjectActivityAwardsPrizeVoted = ProjectDomain.ProjectActivityAwardsPrizeVoted;
    public type ProjectActivityAwardsView = ProjectDomain.ProjectActivityAwardsView;
    public type ProjectPage = ProjectRepositories.ProjectPage;
    public type ProjectDB = ProjectRepositories.ProjectDB;
    public type ProjectCache = ProjectRepositories.ProjectCache;
    public type ProjectRepository = ProjectRepositories.ProjectRepository;
    public type ProjectCommentCreateRequest = RecordingDomain.ProjectCommentCreateRequest;
    public type ProjectRecordingRelDB = ProjectRepositories.ProjectRecordingRelDB;
    public type ProjectRecordingRelCache = ProjectRepositories.ProjectRecordingRelCache;
    public type ProjectRecordingRelRepository = ProjectRepositories.ProjectRecordingRelRepository;
    public type ProjectActivityRelDB = ProjectRepositories.ProjectActivityRelDB;
    public type ProjectActivityRelCache = ProjectRepositories.ProjectActivityRelCache;
    public type ProjectActivityRelRepository = ProjectRepositories.ProjectActivityRelRepository;

    /// Recording
    public type RecordingId = RecordingDomain.RecordingId;
    public type RecordingProfile = RecordingDomain.RecordingProfile;
    public type RecordingPage = RecordingRepositories.RecordingPage;
    public type RecordingDB = RecordingRepositories.RecordingDB;
    public type RecordingCache = RecordingRepositories.RecordingCache;
    public type RecordingRepository = RecordingRepositories.RecordingRepository;

    /// Sponsor
    public type SponsorId = SponsorDomain.SponsorId;
    public type SponsorProfile = SponsorDomain.SponsorProfile;
    public type SponsorCreateRequest = SponsorDomain.SponsorCreateRequest;
    public type SponsorPage = SponsorRepositories.SponsorPage;
    public type SponsorDB = SponsorRepositories.SponsorDB;
    public type SponsorCache = SponsorRepositories.SponsorCache;
    public type SponsorRepository = SponsorRepositories.SponsorRepository;

    /// 标签类型相关
    public type TagCategory = TagDomain.TagCategory;
    public type TagDB = TagRepositories.TagDB;
    public type TagRepository = TagRepositories.TagRepository;

    /// 权限相关
    public type AccessEvent = Access.AccessEvent;

    /// 应用状态，保存在内存中，非持久存储
    public type GlobalCache = Global.GlobalCache;

    /// Ledger Canister Query 
    public type AccountIdentifier = LedgerServices.AccountIdentifier;
    public type Block = LedgerServices.Block;
    public type BlockHeight = LedgerServices.BlockHeight;
    public type CanisterId = LedgerServices.CanisterId;
    public type Certification = LedgerServices.Certification;
    public type Hash = LedgerServices.Hash;
    public type ICPTs = LedgerServices.ICPTs;
    public type Memo = LedgerServices.Memo;
    public type TimeStamp = LedgerServices.TimeStamp;
    public type TipOfChain = LedgerServices.TipOfChain;
    public type Transaction = LedgerServices.Transaction;
    public type Transfer = LedgerServices.Transfer;

    public type LedgerActor = LedgerServices.LedgerActor;
    
    let QUREY_LEDGER_CANISTER_ID = "ockk2-xaaaa-aaaai-aaaua-cai";
    
    /// Constants
    let STATUS_DISABLE = Constants.STATUS_DISABLE;
    let STATUS_ENABLE = Constants.STATUS_ENABLE;
    let STATUS_PENDING = Constants.STATUS_PENDING;

    /// the Canister owner 
    var owner_ = "";
    // let owner_ = Principal.toText(Principal.fromActor(Platform));
    

    /// ID Generator
    stable var idGenerator : Nat = 10001;

    var canisterIdOpt: ?Text = null;
    func getCanisterId() : Text {
        Principal.toText(Principal.fromActor(Platform))
        // switch (canisterIdOpt) {
        //     case (?cid) cid ; 
        //     case (_) {               
        //         // let cid = Principal.toText(Principal.fromActor(this));
        //         let cid = "npoty-zqaaa-aaaai-qakcq-cai";
        //         canisterIdOpt := ?cid;
        //         cid
        //     };
        // }
    };

    /// Access
    let access = Access.Access();
    
    /// User DB and Repository 
    stable var userDB : UserDB = UserRepositories.newUserDB();
    // var userCache: UserCache = UserRepositories.newUserCache();
    let userRepository : UserRepository = UserRepositories.newUserRepository();

    stable var userBehaviourSummaryDB : UserBehaviourSummaryDB = UserRepositories.newUserBehaviourSummaryDB();
    let userBehaviourSummaryRepository : UserBehaviourSummaryRepository = UserRepositories.newUserBehaviourSummaryRepository();

    /// 邮箱订阅存储
    stable var emailAddressDB: EmailAddressDB = EmailRepositories.newEmailAddressDB();
    let emailAddressRepository: EmailAddressRepository = EmailRepositories.newEmailAddressRepository();

    /// 轮播图存储
    stable var banners: BannerDB = List.nil();

    /// Activity DB and Repository
    stable var activityDB : ActivityDB = HackathonRepositories.newActivityDB();
    let activityRepository: ActivityRepository = HackathonRepositories.newActivityRepository();
    stable var activityRelDB : ActivityRelDB = HackathonRepositories.newActivityRelDB();
    let activityRelRepository: ActivityRelRepository = HackathonRepositories.newActivityRelRepository();

    /// Bounty DB and Repository
    stable var bountyDB : BountyDB = BountyRepositories.newBountyDB();
    let bountyRepository: BountyRepository = BountyRepositories.newBountyRepository();

    /// Grant DB and Repository
    stable var grantDB : GrantDB = GrantRepositories.newGrantDB();
    let grantRepository: GrantRepository = GrantRepositories.newGrantRepository();
    // let grantUserTargetRelRepository = GrantRepositories.newGrantUserTargetRelRepository();

    /// AirdropPointPlan DB and Repository
    stable var airdropPointPlanDB : AirdropPointPlanDB = PointRepositories.newAirdropPointPlanDB();
    let airdropPointPlanRepository: AirdropPointPlanRepository = PointRepositories.newAirdropPointPlanRepository();

    /// Project DB and Repository
    stable var projectDB : ProjectDB = ProjectRepositories.newProjectDB();
    let projectRepository: ProjectRepository = ProjectRepositories.newProjectRepository();

    /// Project Comment DB and Repository
    stable var projectRecordingRelDB : ProjectRecordingRelDB = ProjectRepositories.newProjectRecordingRelDB();
    let projectRecordingRelRepository: ProjectRecordingRelRepository = ProjectRepositories.newProjectRecordingRelRepository();

    /// Project Activity DB and Repository
    stable var projectActivityRelDB : ProjectActivityRelDB = ProjectRepositories.newProjectActivityRelDB();
    let projectActivityRelRepository: ProjectActivityRelRepository = ProjectRepositories.newProjectActivityRelRepository();

    /// Recording DB and Repository
    stable var recordingDB : RecordingDB = RecordingRepositories.newRecordingDB();
    let recordingRepository: RecordingRepository = RecordingRepositories.newRecordingRepository();

    

    /// Sponsor DB and Repository
    stable var sponsorDB : SponsorDB = SponsorRepositories.newSponsorDB();
    let sponsorRepository: SponsorRepository = SponsorRepositories.newSponsorRepository();

    /// Tag DB and Repository
    stable var tagDB : TagDB = TagRepositories.newTagDB();
    let tagRepository: TagRepository = TagRepositories.newTagRepository();

    /// VotingRight DB and Repository
    stable var votingRightDB : VotingRightDB = PointRepositories.newVotingRightDB();
    let votingRightRepository: VotingRightRepository = PointRepositories.newVotingRightRepository();

    /// 整个应用的临时存储，重启需要从持久化存储中加载   
    stable var adminDB = ["v4r3s-nn353-xms6p-37w4r-okcn5-xxp6v-cnod7-4xqfl-sw5to-gcgue-bqe", "na327-64o7y-4esyn-pjdfu-fbzkt-st2au-ujc6h-3qmgm-7zezw-bpjsw-bqe", "diw2c-paqnk-7algi-3hmz3-i5pbl-7zrbu-zoenn-lsnd2-i4tqo-guxo7-2ae"];
    
    // Role DB and Repository
    stable var adminRoleDB = RoleRepositories.newRoleDB();

    // 初始化角色数据
    if (adminRoleDB.size() == 0) {
        adminRoleDB :=  Array.map<Text, (Text, RoleProfile)>(adminDB, func (u) : (Text, RoleProfile) { (u, RoleDomain.newAdminRoleProfile(u)) });
    };

    let roleReposiotry = RoleRepositories.newRoleRepository();

    var globalCache = Global.init(adminRoleDB, userDB, projectDB, grantDB, userBehaviourSummaryDB, recordingDB, activityDB, 
       votingRightDB, airdropPointPlanDB, sponsorDB, projectRecordingRelDB, projectActivityRelDB, activityRelDB);

    stable var ledgerActor_ : ?LedgerActor = null;

    func getOrCreateLedgerActor() : LedgerActor {
        switch (ledgerActor_) {
            case (?la) la;
            case _ {
                let la : LedgerActor = actor(QUREY_LEDGER_CANISTER_ID);
                ledgerActor_ := ?la;
                la
            }
        }
    };

    /// Canister Upgrades 
    /// Canister停止前把非stable转成stable保存到内存中
    system func preupgrade() {
        Debug.print("Starting preupgrade");
        
        // @Deprecated 管理员 Principal 数组, 被 adminRoleDB 代替
        adminDB := HashMapRepositories.cacheToKeyDB<UserPrincipal, RoleProfile>(globalCache.adminCache);   
        /// Role
        adminRoleDB := RoleRepositories.roleCacheToDB(globalCache.adminCache);
        /// Activity
        activityDB :=  HackathonRepositories.activityCacheToDB(globalCache.activityCache);
        activityRelDB :=  HackathonRepositories.activityRelCacheToDB(globalCache.activityRelCache);

        /// Bounty
        // bountyDB := 
        
        /// Grant
        grantDB := GrantRepositories.grantCacheToDB(globalCache.grantCache);

        // AirdropPointPlan
        airdropPointPlanDB := PointRepositories.airdropPointPlanCacheToDB(globalCache.airdropPointPlanCache);

        /// Project 
        projectDB := ProjectRepositories.projectCacheToDB(globalCache.projectCache);
        projectRecordingRelDB := ProjectRepositories.projectRecordingRelCacheToDB(globalCache.projectRecordingRelCache);
        projectActivityRelDB := ProjectRepositories.projectActivityRelCacheToDB(globalCache.projectActivityRelCache);

        /// Recording
        recordingDB := RecordingRepositories.recordingCacheToDB(globalCache.recordingCache);

        // User
        userDB := UserRepositories.userCacheToDB(globalCache.userCache);
        userBehaviourSummaryDB := UserRepositories.userBehaviourSummaryCacheToDB(globalCache.userBehaviourSummaryCache);

        // Sponsor
        sponsorDB := SponsorRepositories.sponsorCacheToDB(globalCache.sponsorCache);

        // VotingRight
        votingRightDB := PointRepositories.votingRightCacheToDB(globalCache.votingRightCache);

        Debug.print("preupgrade Done!!");
    };

    system func postupgrade() {
        Debug.print("Starting postupgrade");

        /// Role
        adminRoleDB := RoleRepositories.newRoleDB();

        /// ActivityDB
        activityDB := HackathonRepositories.newActivityDB();
        activityRelDB := HackathonRepositories.newActivityRelDB();
        
        /// Bounty
        bountyDB := BountyRepositories.newBountyDB();

        /// Grant
        grantDB := GrantRepositories.newGrantDB();

        // AirdropPointPlan
        airdropPointPlanDB := PointRepositories.newAirdropPointPlanDB();

        /// Project
        projectDB := ProjectRepositories.newProjectDB();
        projectRecordingRelDB := ProjectRepositories.newProjectRecordingRelDB();
        projectActivityRelDB := ProjectRepositories.newProjectActivityRelDB();

        /// Recording
        recordingDB := RecordingRepositories.newRecordingDB();

        

        /// Sponsor
        sponsorDB := SponsorRepositories.newSponsorDB();

        /// User
        userDB := UserRepositories.newUserDB();
        userBehaviourSummaryDB := UserRepositories.newUserBehaviourSummaryDB();

        /// VotingRight
        // votingRightDB := PointRepositories.newVotingRightDB();

        Debug.print("postupgrade Done!!");
    };

    /// ---------------------- public API ------------------------ ///
 
    /// 最新还没应用的id序列号, 比已经保存的记录大1
    public query func nextId() : async Result<Nat, Error> { #ok(idGenerator) };

    /// 返回本Canister的Controller
    public query func owner() : async Result<Text, Error> {
        #ok(owner_)
    };

    public query func canisterId() : async Text {
        canisterId_()
    };

    func canisterId_() : Text {
        Principal.toText(Principal.fromActor(Platform))
    };

    /// 获取平台当前用户, 项目, Grant的总数
    public query func buildSummary() : async Result<Global.BuildSummary, Error> {
        #ok(Global.stateToSummary(globalCache))
    };

    /// 获取用户公开信息
    public query func getUserPublicInfo(userPrincipal: UserPrincipal) : async Result<?UserPublicInfo, Error> {
        #ok(Option.map<UserProfile, UserPublicInfo>(getUser_(userPrincipal), UserDomain.userPublicInfo))
    };

    /// 获取正在使用中的钱包地址
    public query func getPlatformWalletAddress(symbol: Text) : async Result<?WalletCategory, Error> {
        if (symbol == "ICP" or symbol == "icp") {
            #ok(?Constants.PLATFROM_WALLET_ADDRESS_ICP)
        } else {
            #err(#notFound)
        }
    };

    /// ---------------------- Admins ---------------------------- ///
    public shared query func admins() : async Result<[RoleProfile], Error> {
        #ok(RoleRepositories.getAllAdminAndOrderByAuthorizationTime(globalCache.adminCache, RoleDomain.roleOrderByAuthorizationTime))
    };

    /// Assign a new role to a principal
    public shared(msg) func assignAdminRole(cmd: AssignAdminRoleCommand) : async Result<(), Error> {

        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #admin, #all);
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let user = cmd.user;

            if (user == owner_) {
                return #err(#unauthorized);
            };

            switch (UserRepositories.getUser(globalCache.userCache, userRepository, user)) {
                case (?u) { 
                    switch (cmd.name) {
                        case (?n) {
                            let newUser = UserDomain.editUsername(u, n);
                            let _ = updateUser_(newUser);
                        };
                        case (_) {};
                    };

                    #ok(access.addAdminRole(globalCache, user))
                };
                case null { #err(#userNotFound) };
            }
          
        } else {
            #err(#unauthorized)
        }          
    };

    /// Remove the role
    public shared(msg) func removeAdminRole(user: UserPrincipal) : async Result<(), Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #admin, #all);
        ignore logCheckEvent(ae, caller);
        
        if (user == owner_) {
            return #err(#unauthorized);
        };

        if (ae.isOk) {
            #ok(access.removeAdminRole(globalCache, user))
        } else {
            #err(#unauthorized)
        }    
    };

    /// 获取所有用户
    public query(msg) func allUsers() : async Result<UserDB, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        validAndProcess(ae, func() : Result<UserDB, Error> {
            #ok(UserRepositories.userCacheToDB(globalCache.userCache))
        })
    };

    /// 分页查询所有用户
    // 如果没有查询参数，代表不过滤。
    // 如果存在创建用户开始时间，但没有存在结束时间，说明查询创建用户开始时间以后的所有用户
    // 模糊查询，不区分大小写的参数：principalId，昵称，联系方式
    public query(msg) func pageUser(q: UserPageQuery) : async Result<UserPage, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        validAndProcess(ae, func() : Result<UserPage, Error> {
            let qPrincipalId = q.principalId;
            let qUsername = q.username;
            let qContactInfo = q.contactInfo;
            let qStartTime = q.startTime;
            let qEndTime = if (qStartTime > 0 and q.endTime <= 0) { timeNow_() + 1000000000000 } else { q.endTime };

            let hasNoPrincipal = Utils.isSpaceText(qPrincipalId);
            let hasNoUsername = Utils.isSpaceText(qUsername);
            let hasNoContactInfo = Utils.isSpaceText(qContactInfo);
            let hasNoTime = qStartTime <= 0 and qEndTime <= 0;

            #ok(UserRepositories.pageUser(globalCache.userCache, userRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                (hasNoPrincipal or UserDomain.userContainsPrincipal(profile, qPrincipalId)) and 
                    (hasNoUsername or UserDomain.userContainsUsername(profile, qUsername)) and
                    (hasNoContactInfo or UserDomain.userContainsContactInfo(profile, qContactInfo)) and 
                    (hasNoTime or UserDomain.userBetweenCreatedTime(profile, qStartTime, qEndTime))
                }, 
                UserDomain.userOrderByCreatedAtDesc
            ))
        })
    };

    /// 获取用户信息
    public query(msg) func getUser(userPrincipal: UserPrincipal) : async Result<?UserProfile, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #update, #user userPrincipal);

        validAndProcess(ae, func() : Result<?UserProfile, Error> {
            #ok(getUser_(userPrincipal))
        })
    };


    /// --------------- Ledger Query ------------- ///
    /// 通过外部的Ledger Service(外部个人开发者提供)验证交易是否已经上链,可能存在不确定性.
    /// Args:
    ///     |blockHeight|   区块高度
    /// Returns:
    ///     如果提供的blockHeight和memo匹配,则返回true,否则返回false
    public shared(msg) func validTransaction(blockHeight: BlockHeight) : async Result<Bool, Error>{ 
        let tx = await getOrCreateLedgerActor().block(blockHeight);
        
        switch (tx) {
            case (#Ok(#Ok(block))) {
                return #ok(true);
            };
            case _ { return #ok(false); };
        }
    };

    /// --------------- User Query --------------- ///
    /// 总用户数
    public query func countUserTotal() : async Result<Nat, Error> {
        #ok(globalCache.userCount)
    };

    /// 获取自己的用户信息
    public query(msg) func getSelf() : async Result<?UserProfile, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #view, #pubView);

        validAndProcess(ae, func() : Result<?UserProfile, Error> {
            #ok(getUser_(caller))
        })
    };

    /// 获取自己的用户行为数据汇总
    public query(msg) func getSelfBehaviourSummary() : async Result<?UserBehaviourSummary, Error> {
        let caller = Principal.toText(msg.caller);           
        #ok(UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, caller))     
    };

    /// 获取指定用户行为数据汇总
    public query func getUserBehaviourSummary(user: UserPrincipal) : async Result<?UserBehaviourSummary, Error> {
       #ok(UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, user))
    };

    /// 分页查询用户project,按时间段过滤,创建时间倒序排序
    public query(msg) func pageMyProject(pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<ProjectPage, Error> {
        let caller = Principal.toText(msg.caller);

        let sortWith =  ProjectDomain.compareByCreateTimeDesc;
        #ok(ProjectRepositories.pageProjectByOwnerAndTime(globalCache.projectCache, projectRepository, caller, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询指定用户project,按时间段过滤,创建时间倒序排序
    public query func pageUserProject(user: UserPrincipal, pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<ProjectPage, Error> {
        let sortWith =  ProjectDomain.compareByCreateTimeDesc;
        #ok(ProjectRepositories.pageProjectByOwnerAndTime(globalCache.projectCache, projectRepository, user, pageSize, pageNum, sortWith, startTime, endTime))
    };


    /// 分页查询用户申请,按时间段过滤,创建时间倒序排序   
    public query(msg) func pageMyApplying(pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let caller = Principal.toText(msg.caller);

        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageApplyingByOwnerAndTime(globalCache.recordingCache, recordingRepository, caller, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询指定用户申请,按时间段过滤,创建时间倒序排序   
    public query func pageUserApplying(user: UserPrincipal, pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageApplyingByOwnerAndTime(globalCache.recordingCache, recordingRepository, user, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询用户评论,按时间段过滤,创建时间倒序排序   
    public query(msg) func pageMyComment(pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let caller = Principal.toText(msg.caller); 

        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageCommentByOwnerAndTime(globalCache.recordingCache, recordingRepository, caller, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询指定用户评论,按时间段过滤,创建时间倒序排序   
    public query func pageUserComment(user: UserPrincipal, pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageCommentByOwnerAndTime(globalCache.recordingCache, recordingRepository, user, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询用户投票,按时间段过滤,创建时间倒序排序  
    public query(msg) func pageMyVoting(pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let caller = Principal.toText(msg.caller);

        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageVotingByOwnerAndTime(globalCache.recordingCache, recordingRepository, caller, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 分页查询指定用户投票,按时间段过滤,创建时间倒序排序  
    public query func pageUserVoting(user: UserPrincipal, pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageVotingByOwnerAndTime(globalCache.recordingCache, recordingRepository, user, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 获取用户自己的Grant列表
    public query(msg) func pageMyGrant(pageSize: Nat, pageNum: Nat) : async Result<GrantPage, Error> {
        let caller = Principal.toText(msg.caller);

        #ok(GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.owner == caller and profile.status == STATUS_ENABLE
        }, GrantDomain.compareById))
    };

    /// 获取指定用户的Grant列表
    public query func pageGrantByOwner(user: UserPrincipal, pageSize: Nat, pageNum: Nat) : async Result<GrantPage, Error> {
        #ok(GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.owner == user and profile.status == STATUS_ENABLE
        }, GrantDomain.compareById))
    };

    /// 获取用户自己的积分列表,包含捐赠和空投获得的积分
    public query(msg) func pageMyPoint(pageSize: Nat, pageNum: Nat) : async Result<Page<UserPointView>, Error> {
        let caller = Principal.toText(msg.caller);

        #ok(pageUserPointRecord(caller, pageSize, pageNum))
    };

    /// 获取指定用户的积分列表,包含捐赠和空投获得的积分
    public query func pagePointByOwner(user: UserPrincipal, pageSize: Nat, pageNum: Nat) : async Result<Page<UserPointView>, Error> {
        // let pageGrant = GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
        //     profile.owner == user and profile.status == STATUS_ENABLE
        // }, GrantDomain.compareById);

        // let dataBuffer = Buffer.Buffer<UserPointView>(0);

        // // 捐赠获得的积分记录
        // for (g in pageGrant.data) {
        //     dataBuffer.add(GrantDomain.grantProfileToUserPointView(g))
        // };
        // // 空投获得的积分记录
        // for (app in globalCache.airdropPointPlanCache.entries()) {
        //     for (rr in app.data.vals()) {
        //         if (PointDomain.isSuccessPointResultRecord(rr) and rr.recipient == caller) {
        //             dataBuffer.add(PointDomain.airdropPointResultRecordToUserPointView(rr, app.executedTime))
        //         };
        //     }
        // };

        // #ok({
        //     data = dataBuffer.toArray();
        //     pageSize = pageGrant.pageSize;
        //     pageNum = pageGrant.pageNum;
        //     totalCount = pageGrant.totalCount;
        // })
        #ok(pageUserPointRecord(user, pageSize, pageNum))
    };

    /// --------------- User Update -------------- ///
    /// 用户注册，如果用户存在，返回存在的用户名
    public shared(msg) func registerUser(registerFrom: Text, ipAddress: Text) : async Result<Text, Error> {

        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #create, #user caller);
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {

            switch (getUser_(caller)) {
                case (?u) {
                    return #err(#userAlreadyExists (u.username));
                };
                case (null) {
                    let userId = getIdAndIncrementOne();
                    let currentTime = timeNow_();
                    let formatted = UserDomain.checkRegisterFrom(registerFrom);
                    let userProfile : UserProfile = UserDomain.newUser(userId, caller, formatted, ipAddress, caller, currentTime, "");

                    let _ = updateUser_(userProfile);
                    /// 记录用户注册数据的日志
                    ignore logInfo(UserDomain.profileToText(userProfile), caller);

                    globalCache.userCount += 1;
                    
                    return #ok(caller);                  
                };
            }
        } else {
            #err(#unauthorized)
        }
        
    };

    /// 使用指定principal进行用户注册，如果principal存在，返回存在的用户名
    public shared(msg) func registerUserByPrincipal(principal: Text, registerFrom: Text, ipAddress: Text) : async Result<Text, Error> {

        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #create, #user caller);
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {

            switch (getUser_(principal)) {
                case (?u) {
                    return #err(#userAlreadyExists (u.username));
                };
                case (null) {
                    let userId = getIdAndIncrementOne();
                    let currentTime = timeNow_();
                    let formatted = UserDomain.checkRegisterFrom(registerFrom);
                    let userProfile : UserProfile = UserDomain.newUser(userId, principal, formatted, ipAddress, caller, currentTime, "");

                    let _ = updateUser_(userProfile);
                    /// 记录用户注册数据的日志
                    ignore logInfo(UserDomain.profileToText(userProfile), caller);

                    globalCache.userCount += 1;
                    
                    return #ok(userProfile.username);                  
                };
            }
        } else {
            #err(#unauthorized)
        }
        
    };

    /// 修改用户名
    public shared(msg) func modifyUsername(name: Text) : async Result<Bool, Error> {
        // let name = Utils.toLowerCase(newName);

        if (not UserDomain.validUsername(name)) {
            return #err(#invalidUsername);
        };

        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.editUsername(u, name);
                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }

    };

    /// 修改用户头像 uri
    public shared(msg) func modifyUserAvatarUri(avatarUri: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.editAvatarUri(u, avatarUri);

                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }

    };

    /// 修改用户介绍
    public shared(msg) func modifyUserIntroduction(intro: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.editIntroduction(u, intro);

                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }

    };

    /// 修改用户联系方式
    public shared(msg) func modifyUserContactInfo(info: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.editContactInfo(u, info);

                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }

    };

    /// 增加用户项目地址
    public shared(msg) func addUserSingleProjectUri(uri: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    if (UserDomain.isProjectUriExceedMaxLimit(u)) {
                        #err(#tooLargeQuantity)
                    } else {                       
                        let newUserProfile = UserDomain.addSingleProjectUri(u, uri);
                        let _ = updateUser_(newUserProfile);
                        #ok(true)
                    }
                    
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 修改用户项目地址, idx是原来项目链接的索引
    public shared(msg) func editUserProjectUri(idx: Nat, uri: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.editSingleProjectUri(u, idx, uri);

                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 删除用户单个项目地址, idx是原来项目链接的索引
    public shared(msg) func deleteUserProjectUri(idx: Nat) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #update, #user caller);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(caller)) {
                case (?u) {
                    let newUserProfile = UserDomain.deleteSingleProjectUri(u, idx);

                    let _ = updateUser_(newUserProfile);
                    #ok(true)
                };
                case (null) {
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 删除用户
    public shared(msg) func deleteUser(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #admin, #user userPrincipal);
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let _ = deleteUser_(userPrincipal);
            globalCache.userCount -= 1;
            #ok(true)
        } else {
            #err(#unauthorized)
        }
    };

    /// 禁用用户
    public shared(msg) func disableUser(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #admin, #user userPrincipal);
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            switch (getUser_(userPrincipal)) {
                case (?u) {                   
                    let newUser = UserDomain.disableUser(u);
                    let _ = updateUser_(newUser);

                    #ok(true)
                };
                case (_) {
                    Debug.print("The user: " # userPrincipal # " is not found");
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }
        
    };

    /// 启用用户
    public shared(msg) func enableUser(userPrincipal: UserPrincipal) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        let ae = accessCheck(globalCache, caller, #admin, #user userPrincipal);
        ignore logCheckEvent(ae, caller);

        if (ae.isOk) {
            switch (getUser_(userPrincipal)) {
                case (?u) {                   
                    let newUser = UserDomain.enableUser(u);
                    let _ = updateUser_(newUser);

                    #ok(true)
                };
                case (_) {
                    Debug.print("The user: " # userPrincipal # " is not found");
                    #err(#userNotFound)
                };
            }
        } else {
            #err(#unauthorized)
        }
        
    };

    public shared(msg) func updateLastLoginTime(cmd: UserUpdateLoginTimeCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);
        
        switch (getUser_(caller)) {
            case (?u) {
                let newProfile = UserDomain.updateUserLastLoginTime(u, cmd.loginTime);
                let _ = updateUser_(newProfile);

                #ok(true)
            };
            case (null) {
                #err(#userNotFound)
            }
        }
    };

    /// ------------- EmailAddress Subscription --------------- ///
    /// ------------- Update functions ----------------- ///
    /// 保存邮箱 
    public shared(msg) func subscribe(cmd: EmailSubscribeCommand) : async Result<Text, Error> {
        let emailAddress = cmd.email;
        let lowerEmailAddress = Utils.toLowerCase(emailAddress);
        let validedEmailAddress = EmailDomain.validEmailAddress(emailAddress);

        if (not(validedEmailAddress)) {
            return #err(#emailAddressNotValid);
        };

        // let caller = Principal.toText(msg.caller);
        // Debug.print("Received request from: " # caller);

        let msgPrefix = "From canister id: " # canisterId_() ;        
        switch (EmailRepositories.findOneEmailAddress(emailAddressDB, emailAddressRepository, lowerEmailAddress)) {
            case (?_) {
                return #err(#emailAddressAlreadyExists);
            };
            case _ {
                let es = EmailDomain.newEmailSubscription(lowerEmailAddress, cmd.ipAddress, timeNow_());
                emailAddressDB := EmailRepositories.saveEmailAddress(emailAddressDB, emailAddressRepository, es);
                return #ok(msgPrefix # ": 保存成功，感谢订阅！");
            };
        }
        
    };

    /// 取消邮箱订阅
    public func unsubscribe(emailAddress: EmailAddress) : async Result<(), Error> {      
        emailAddressDB := EmailRepositories.deleteEmailAddress(emailAddressDB, emailAddressRepository, emailAddress);   
        #ok(())    
    };
 

    /// 获取最新n个的邮箱
    public shared(msg) func getNewerEmailAddress(n: Nat) : async Result<[EmailSubscription], Error> {   
        let caller = Principal.toText(msg.caller);
        
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            return #ok(EmailRepositories.getNewerEmailAddress(emailAddressDB, emailAddressRepository, n));
        } else {
            #err(#unauthorized)
        }
                         
    };

    /// 分页查询邮箱
    public shared(msg) func pageEmail(q: EmailPageQuery) : async Result<EmailPage, Error> {
        let caller = Principal.toText(msg.caller);
        
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let qEmail = q.email;
            let qStatus = q.status;
            let qStartTime = q.startTime;
            let qEndTime = if (qStartTime > 0 and q.endTime <= 0) { timeNow_() + 1000000000000 } else { q.endTime };

            let hasNoEmail = Utils.isSpaceText(qEmail);
            let hasNoStatus = Utils.isSpaceText(qStatus);
            let hasNoTime = qStartTime <= 0 and qEndTime <= 0;

            #ok(
                EmailRepositories.pageEmail(emailAddressDB, emailAddressRepository, q.pageSize, q.pageNum,
                    func (es) : Bool {
                        (hasNoEmail or EmailDomain.containsEmail(es, qEmail)) and
                            (hasNoStatus or EmailDomain.containsStatus(es, qStatus)) and
                            (hasNoTime or EmailDomain.emailBetweenCreatedTime(es, qStartTime, qEndTime))
                    }, EmailDomain.emailOrderByCreatedAtDesc
                )
            )
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取全部的邮箱
    public shared(msg) func allEmailAddress() : async Result<[EmailSubscription], Error> {     
        let caller = Principal.toText(msg.caller);
       
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        validAndProcess(ae, func (): Result<[EmailSubscription], Error> {
            return #ok(EmailRepositories.allEmails(emailAddressDB));
        })
             
    };

    /// Return the role of the message caller/user identity
    public shared(msg) func myRole() : async Result<Role, Error> {
        let caller = Principal.toText(msg.caller);

        return #ok(access.userMaxRole(globalCache, caller));
    };

    public shared(msg) func getRole(user: UserPrincipal): async Result<Role, Error> {
        let caller = Principal.toText(msg.caller);

        let ae = accessCheck(globalCache, caller, #admin, #user user);

        ignore logCheckEvent(ae, caller);
        
        validAndProcess(ae, func (): Result<Role, Error> {
            return #ok(access.userMaxRole(globalCache, user));
        })
    };

    public query func isAuthor(u: UserPrincipal) : async Bool { 
        access.userMaxRole(globalCache, u) == #admin
    };

    /// ------------------------ 首页轮播图 ---------------------------------- ///
    /// 创建轮播图
    // public shared(msg) func createBanner(picUri: Text, bannerCategory: BannerCategory, outerUri: Text) : async Result<BannerId, Error> {
    //     let caller = Principal.toText(msg.caller);

    //     let ae = accessCheck(globalCache, caller, #admin, #all);

    //     ignore logCheckEvent(ae, caller);

    //     if (ae.isOk) {
    //         let bid = getIdAndIncrementOne();
    //         let currentTime = timeNow_();

    //         let BannerProfile: BannerProfile = {
    //             id = bid;
    //             pictureUri = picUri;
    //             bannerCategory = bannerCategory;
    //             outerUri = outerUri;
    //             createdBy = caller;
    //             createdAt = currentTime;
    //         };

    //         banners := BannerRepositories.insert(banners, BannerProfile);
    //         #ok(bid)
    //     } else {
    //         #err(#unauthorized)
    //     }
        
    // };

    /// 根据指定的BannerId删除轮播图
    // public shared(msg) func deleteBanner(bid: BannerId) : async Result<Bool, Error> {
    //     let caller = Principal.toText(msg.caller);

    //     let ae = accessCheck(globalCache, caller, #admin, #all);

    //     ignore logCheckEvent(ae, caller);

    //     if (ae.isOk) {
    //         banners := BannerRepositories.delete(banners, bid);
    //         #ok(true)
    //     } else {
    //         #err(#unauthorized)
    //     }       
    // };

    /// 根据指定的BannerId获取轮播图
    // public query func getBanner(bid: BannerId): async Result<?BannerProfile, Error> {
    //     #ok(BannerRepositories.findOne(banners, bid))
    // };

    /// 获取指定数量的最新轮播图，BannerId越大表示越新, 每次获取的数量不能大于10
    // public query func getNewerBanner(num: Nat, category: Text): async Result<[BannerIdWithData], Error> {
    //     if (num > 10) {
    //         return #err(#tooLargeQuantity);
    //     };

    //     #ok(BannerRepositories.getNewer(banners, num, category))
    // };

    /// -------------------------- Grant interfaces ------------------------------ ///
    /// 打赏project
    public shared(msg) func grantProject(request:  GrantCreateRequest) : async Result<GrantId, Error> {
        let caller = Principal.toText(msg.caller);     
        let grantId = getIdAndIncrementOne();
        let ae = accessCheck(globalCache, caller, #create, #grant grantId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            let currentTime = timeNow_();
            let grantProfile = GrantDomain.createRequestToProfile(request, grantId, Constants.CATEGORY_PROJECT, caller, currentTime) ;

            GrantRepositories.saveGrant(globalCache.grantCache, grantRepository, grantProfile);
            ignore logInfo(GrantDomain.grantToText(grantProfile), caller);
            
            #ok(grantId)
        } else {
            #err(#unauthorized)
        }
    };

    /// 预打赏黑客松活动(Activity)
    public shared(msg) func prepareGrantActivity(request:  GrantCreateRequest) : async Result<GrantId, Error> {
        let caller = Principal.toText(msg.caller);     
        let grantId = getIdAndIncrementOne();
        let ae = accessCheck(globalCache, caller, #create, #grant grantId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            let currentTime = timeNow_();
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, request.targetId)) {
                case (?a) {
                    // 判断活动是否过期
                    if (a.endTime >= currentTime) {
                        let grantProfile = GrantDomain.createRequestToProfile(request, grantId, Constants.CATEGORY_ACTIVITY, caller, currentTime) ;

                        GrantRepositories.saveGrant(globalCache.grantCache, grantRepository, grantProfile);
                        ignore logInfo(GrantDomain.grantToText(grantProfile), caller);
                        
                        #ok(grantId)
                    } else {
                        #err(#activityExpired)
                    }
                };
                case (null) { #err(#notFound)};
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 回写打赏后数据
    public shared(msg) func updateGrantBlockHeight(request: GrantUpdateBlockHeightRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let grantId = request.grantId;
        let ae = accessCheck(globalCache, caller, #update, #grant grantId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (GrantRepositories.getGrant(globalCache.grantCache, grantRepository, grantId)) {
                case (?g) {
                    if (request.memo == g.memo and request.amount == g.amount) {
                        let updatedHeight = GrantDomain.updateGrantBlockHeightAndStatus(g, request.blockHeight, Constants.STATUS_ENABLE);
                        GrantRepositories.saveGrant(globalCache.grantCache, grantRepository, updatedHeight);
                        #ok(true)
                    } else {
                        #err(#unauthorized)
                    }
                    
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };
    
    /// 打赏给平台 TODO


    /// 通过外部的Ledger Service(外部个人开发者提供)验证打赏转账是否已经上链,可能存在不确定性.
    /// 打赏后计算积分
    /// Args:
    ///     |grantId| 打赏id
    public shared(msg) func validGrant(grantId: GrantId) : async Result<Bool, Error> { 
        let grantOpt = GrantRepositories.getGrant(globalCache.grantCache, grantRepository, grantId);

        switch(grantOpt) {
            case (?dr) { 
                // 如果已经验证通过,直接返回
                if (dr.isFinalized) { return #ok(true); };

                let blockHeight = dr.blockHeight;
                let memo = dr.memo;
                let rewardAmount = dr.amount;
                let grantFrom = dr.owner;

                let tx = await getOrCreateLedgerActor().block(blockHeight);
        
                switch (tx) {
                    case (#Ok(#Ok(block))) {
                        let transaction = block.transaction;
                        let transactionMemo = transaction.memo;
                        switch (transaction.transfer) {
                            case (#Send send) {
                                let transferAmount = send.amount.e8s;
                                if (transferAmount == rewardAmount and memo == transactionMemo) {
                                    let finalizedGrant = GrantDomain.finalizeGrant(dr);

                                    GrantRepositories.saveGrant(globalCache.grantCache, grantRepository, finalizedGrant);
                    
                                    let rewardAmount2 = Nat64.toNat(rewardAmount);
                                    globalCache.grantCount += rewardAmount2;
                                    let pointAmount = PointDomain.calcPointFromICP(rewardAmount2);
                                      
                                    updateUserBehaviourSummary_(grantFrom, rewardAmount2, UserDomain.addBehaviourGrantSum); // 计算捐赠金额
                                    updateUserBehaviourSummary_(grantFrom, pointAmount, UserDomain.addBehaviourPointSum);   // 计算捐赠获得的积分

                                    // 计算投票权与个人关联 
                                    // let targetId = dr.grantTarget.targetId;
                                    // switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, targetId)) {
                                    //     case (?a) {          
                                    //         // 检查捐助者+当前活动的投票权是否存在,如果不存在计算历史积分的投票权
                                    //         let uvr = calcUserVotingRight(grantFrom, targetId, a.strategy.historyRatio);

                                    //         // 判断打赏类型并应用对应计算算法,然后再加上当前捐助活动的投票权
                                    //         let newVR = if (GrantDomain.isGrantActivity(dr)) {
                                    //             pointAmount / a.strategy.periodRatio
                                    //         } else {
                                    //             pointAmount / a.strategy.historyRatio
                                    //         };

                                    //         let newUVR = PointDomain.addVoteTotalSum(uvr, newVR);
                                    //         // PointRepositories.addVotingRight(globalCache.votingRightCache, votingRightRepository, targetId, grantFrom, newUVR);
                                    //     };
                                    //     case (null) {};
                                    // };

                                    return #ok(true);
                                } else {
                                    return #ok(false);
                                }
                            };
                            case _ { return #ok(false); };
                        }
                        
                    };
                    case _ { return #ok(false); };
                }
            };
            case (nul) { return #ok(false); };
        }
        
    };   

    /// 获取指定的Grant
    public query func getGrant(grantId: GrantId) : async Result<?GrantProfile, Error> {
        #ok(GrantRepositories.getGrant(globalCache.grantCache, grantRepository, grantId))
    };

    /// 分页查询项目,状态是可用,按id倒序(最大(时间最新)在前)
    public query func pageGrant(pageSize: Nat, pageNum: Nat) : async Result<GrantPage, Error> {
        #ok(GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.status == STATUS_ENABLE
        }, GrantDomain.compareById))
    };

    /// 获取指定黑客松活动的Grant列表
    public query func pageGrantByActivity(activityId: ActivityId, pageSize: Nat, pageNum: Nat) : async Result<GrantPage, Error> {
        #ok(GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
            GrantDomain.isGrantActivity(profile) and profile.grantTarget.targetId == activityId and profile.status == STATUS_ENABLE
        }, GrantDomain.compareById))
    };

    /// 查询所有的Grant
    public query func allGrants() : async Result<GrantDB, Error> {
        #ok(GrantRepositories.grantCacheToDB(globalCache.grantCache))
    };

    /// ------------------------- Hackathon interfaces --------------------------- ///
    /// 创建黑客松活动
    public shared(msg) func createActivity(request: ActivityCreateRequest) : async Result<ActivityId, Error> {
        let caller = Principal.toText(msg.caller);     
        let activityId = getIdAndIncrementOne();
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            let currentTime = timeNow_();
            let activityProfile = HackathonDomain.createRequestToProfile(request, activityId, caller, currentTime);
            if (HackathonDomain.isValidTag(activityProfile, allTags_())) {
                HackathonRepositories.saveActivity(globalCache.activityCache, activityRepository, activityProfile);
                #ok(activityId)
            } else {
                #err(#badRequest)
            }        
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑黑客松活动
    public shared(msg) func editActivity(newActivity: ActivityProfile) : async Result<Bool, Error> {

        let caller = Principal.toText(msg.caller);     
        let activityId = newActivity.id;
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            // 校验黑客松活动各属性是否合规
            if (not(HackathonDomain.isValidTag(newActivity, allTags_()))) {
                return #err(#badRequest);
            };

            // 判断是否有项目加入活动,如果有项目加入活动, 只能修改那些文本内容,不能修改投票策略相关的数值
            if (Utils.arraySize(HackathonRepositories.getActivityProjectProfileVotedByAcivityId(globalCache.activityRelCache, activityRelRepository, 
                globalCache.projectCache, projectRepository, activityId)) <= 0) {
                
                HackathonRepositories.saveActivity(globalCache.activityCache, activityRepository, newActivity);
                #ok(true)
                 
            } else {
                switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                    case (?a) {
                        // 如果投票策略相关的数值没变化,可以修改
                        if (HackathonDomain.isStrategyOfVoteSame(a.strategy, newActivity.strategy)) {                          
                            HackathonRepositories.saveActivity(globalCache.activityCache, activityRepository, newActivity);
                            #ok(true)                           
                        } else {
                            return #err(#projectJoinedActivity);
                        }
                    };
                    case (null) #err(#notFound);
                }
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 修改指定黑客松活动状态
    public shared(msg) func modifyActivityStatus(activityId: ActivityId, status: StatusEnum) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {
                    let newActivity = HackathonDomain.modifyActivityStatus(a, status);
                    HackathonRepositories.saveActivity(globalCache.activityCache, activityRepository, newActivity);
                    #ok(true)
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };  

    /// 删除Activity, 有项目加入黑客松活动后不能删除黑客松活动
    public shared(msg) func deleteActivity(activityId: ActivityId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            if (HackathonRepositories.getRelByActivityId(globalCache.activityRelCache, activityRelRepository, activityId).size() > 0) {
                #err(#unauthorized)
            } else {
                let _ = HackathonRepositories.deleteActivity(globalCache.activityCache, activityRepository, activityId);
                #ok(true)
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定的黑客松活动
    public query func getActivity(activityId: ActivityId) : async Result<?ActivityProfile, Error> {
        #ok(HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId))
    };

    /// 获取黑客松活动投票数,参与项目,参与用户累计,捐赠金额累计
    public query func getActivitySummary(activityId: ActivityId) : async Result<ActivitySummary, Error> {
        #ok(HackathonRepositories.getActivitySummaryById(
            globalCache.activityRelCache, activityRelRepository, globalCache.recordingCache, recordingRepository, 
            globalCache.grantCache, grantRepository, activityId
        ))
    };

    /// 分页查询已上架(发布)黑客松活动,按id倒序(最大(时间最新)在前)
    public query func pagePublishedActivity(pageSize: Nat, pageNum: Nat) : async Result<ActivityPage, Error> {
        let currentTime = timeNow_();
        #ok(HackathonRepositories.pageActivity(globalCache.activityCache, activityRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.publishTime <= currentTime and profile.status == Constants.STATUS_ENABLE
        }, HackathonDomain.compareActivityById))
    };

    /// 分页查询黑客松活动,按id倒序(最大(时间最新)在前),后台管理专用
    public query(msg) func pageActivity(pageSize: Nat, pageNum: Nat) : async Result<ActivityPage, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let currentTime = timeNow_();
            #ok(HackathonRepositories.pageActivity(globalCache.activityCache, activityRepository, pageSize, pageNum, func (id, profile) : Bool { 
                profile.id >= 0
            }, HackathonDomain.compareActivityById))
        } else {
            #err(#unauthorized)
        }
    };

    /// 查询黑客松活动所有,后台管理专用
    public query(msg) func allActivities() : async Result<ActivityDB, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let currentTime = timeNow_();
            #ok(HackathonRepositories.activityCacheToDB(globalCache.activityCache))
        } else {
            #err(#unauthorized)
        }
    };

    /// 为黑客松活动添加项目
    public shared(msg) func addActivityProject(activityId: ActivityId, projectId: ProjectId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #update, #project projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {
                    switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                        case (?p) {
                            // 只有审核通过的项目才能参加黑客松活动
                            if (not(ProjectDomain.isEnableProject(p))) {
                                return #err(#projectNotEnable);
                            };

                            // 判断用户已参加的黑客松活动是否包含当前活动id
                            switch (ProjectRepositories.findActivityIdsByOwner(globalCache.projectActivityRelCache, 
                                caller).get(activityId)) {
                                case (?_) {
                                    #err(#alreadyExisted);
                                };
                                case (null) { 
                                    // 关联activity and project,初始值投票为0 
                                    let currentTime = timeNow_();
                                    let projectVoted = #project (HackathonDomain.newActivityProjectVoted(activityId, projectId, 0, a.startTime, a.endTime, currentTime,
                                        a.strategy.historyRatio, a.strategy.periodRatio, a.strategy.minPerProject, a.strategy.maxPerProject, a.strategy.maxPerActivity));
                                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                                        activityId, projectId, projectVoted);

                                    let projectActivityAwardsPrizeVoted = ProjectDomain.newProjectActivityAwardsPrizeVoted(
                                        projectId, activityId, a.title, [], [], 0, a.strategy.historyRatio, a.strategy.periodRatio, a.strategy.minPerProject, 
                                        a.strategy.maxPerProject, a.strategy.maxPerActivity, p.owner, currentTime
                                    );

                                    ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(globalCache.projectActivityRelCache, projectActivityRelRepository, 
                                        projectId, activityId, projectActivityAwardsPrizeVoted);

                                    #ok(true)
                                ;}
                            }
    
                        };
                        case (null) #err(#notFound);
                    }
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定的黑客松活动项目及投票列表
    public query func getActivityProject(activityId: ActivityId) : async Result<[ActivityProjectProfileVoted], Error> {
        #ok(
            HackathonRepositories.getActivityProjectProfileVotedByAcivityId(globalCache.activityRelCache, activityRelRepository,
                globalCache.projectCache, projectRepository, activityId)
        )
    };

    /// 删除黑客松活动与项目的关联关系
    public shared(msg) func deleteActivityProject(activityId: ActivityId, projectId: ProjectId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, projectId)) {
                case (?_) {
                    
                    HackathonRepositories.removeRelByActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, projectId);

                    #ok(true)
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 为黑客松活动添加赞助商
    public shared(msg) func addActivitySponsor(request: ActivitySponsorQuotaCreateRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let activityId = request.activityId;
        let sponsorId = request.sponsorId;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {
                    switch (SponsorRepositories.getSponsor(globalCache.sponsorCache, sponsorRepository, sponsorId)) {
                        case (?p) {
                            // 关联activity and sponsor
                            let currentTime = timeNow_();
                            let quotaConfig = HackathonDomain.createActivitySponsorQuota(request, currentTime);
                            let rel = #sponsor quotaConfig ;
                            HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                                activityId, sponsorId, rel);

                            #ok(true)
                        };
                        case (null) #err(#notFound);
                    }
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑黑客松活动赞助商
    public shared(msg) func editActivitySponsor(quotaConfig: ActivitySponsorQuota) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let  activityId = quotaConfig.activityId;
        let sponsorId = quotaConfig.sponsorId;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, sponsorId)) {
                case (?_) {
                    let rel = #sponsor quotaConfig ;
                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, sponsorId, rel);

                    #ok(true)
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定黑客松活动的赞助商
    public query func getActivitySponsor(activityId: ActivityId) : async Result<[ActivitySponsorProfile], Error> {
        #ok(
            HackathonRepositories.getActivitySponsorByActivityId(globalCache.activityRelCache, activityRelRepository, 
                globalCache.sponsorCache, sponsorRepository, activityId)
        )
    };

    /// 删除黑客松活动赞助商
    public shared(msg) func deleteActivitySponsor(activityId: ActivityId, sponsorId: SponsorId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, sponsorId)) {
                case (?_) {
                    HackathonRepositories.removeRelByActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, sponsorId);

                    #ok(true)
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 创建黑客松活动奖励
    public shared(msg) func createActivityAwards(request: AwardsCreateRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let  activityId = request.activityId;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {                  
                    // 关联activity and awards
                    let awardsId = getIdAndIncrementOne();
                    let awards = HackathonDomain.createRequestToAwards(request, awardsId);
                    let rel = #awards awards ;
                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, awardsId, rel);

                    #ok(true)
                        
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑黑客松活动奖励
    public shared(msg) func editActivityAwards(awards: ActivityAwards) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let activityId = awards.activityId;
        let awardsId = awards.id;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, awardsId)) {
                case (?_) {
                    let rel = #awards awards ;
                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, awardsId, rel);

                    #ok(true)
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    // 设置黑客松活动奖励的获胜者
    public shared(msg) func setAwardsWinners(request: ActivityAwardsWinnerUpdateRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let activityId = request.activityId;
            let awardsId = request.awardsId;
            let winners = request.winners;
            switch (HackathonRepositories.getActivityAwardsByActivityAndAwardsId(globalCache.activityRelCache, activityRelRepository, activityId, awardsId)) {
                case (?aa) {
                    // 删除原有奖励获奖项目的获奖信息 
                    for (projectId in aa.winners.vals()) {
                        switch (ProjectRepositories.getProjectActivityAwardsPrizeVoted(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId, activityId)) {
                            case (?p) {
                                let oldPAAPV = ProjectDomain.removeAwardsOfProjectActivityAwardsPrizeVoted(p, awardsId);
                                ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(globalCache.projectActivityRelCache, projectActivityRelRepository, 
                                                    projectId, activityId, oldPAAPV); 
                            };
                            case (null) {};
                        }
                    };
                    
                    switch (HackathonDomain.updateActivityAwardsWinner(aa, winners)) {
                        case (#ok(aaw)) {
                            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                                case (?a) {   
                                    let ar = #awards aaw;
                                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, activityId, awardsId, ar);              
                                
                                    // 项目活动获取信息添加获奖信息
                                    for (projectId in winners.vals()) {
                                        let newPAAPV = switch (ProjectRepositories.getProjectActivityAwardsPrizeVoted(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId, activityId)) {
                                            case (?p) {
                                                ProjectDomain.addAwardsOfProjectActivityAwardsPrizeVoted(p, awardsId)                                  
                                            };
                                            case (null) {
                                                switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                                                    case (?p) {
                                                        let currentTime = timeNow_();
                                                        ProjectDomain.newProjectActivityAwardsPrizeVoted(projectId, activityId, a.title, [awardsId], [], 0, a.strategy.historyRatio, 
                                                            a.strategy.periodRatio, a.strategy.minPerProject, a.strategy.maxPerProject, a.strategy.maxPerActivity, p.owner, currentTime)
                                                    };
                                                    case (null) { return #err(#notFound) };
                                                }
                                                
                                            };
                                        };

                                        ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(globalCache.projectActivityRelCache, projectActivityRelRepository, 
                                                    projectId, activityId, newPAAPV); 
                                    }; 
                                    #ok(true)
                                };
                                case (null) { #err(#notFound) };
                            }
                            
                        };
                        case (#err(e)) #err(e);
                    }
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定黑客松活动的奖励
    public query func getActivityAwards(activityId: ActivityId) : async Result<[ActivityAwards], Error> {
        #ok(HackathonRepositories.getActivityAwardsByActivityId(globalCache.activityRelCache, activityRelRepository, activityId))
    };

    /// 删除黑客松活动奖励
    public shared(msg) func deleteActivityAwards(activityId: ActivityId, awardsId: Types.Id) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, awardsId)) {
                case (?ar) {
                    switch (ar) {
                        case (#awards ad) { 
                            // 判断奖励是否有获得者,有获得者则不能删除
                            if (Utils.arraySize(ad.winners) > 0) {
                                #err(#unauthorized);
                            } else {
                                HackathonRepositories.removeRelByActivity(globalCache.activityRelCache, activityRelRepository, 
                                    activityId, awardsId);

                                #ok(true)
                            }
                        };
                        case (_) #err(#notFound);
                    }
                    
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 创建黑客松活动奖项
    public shared(msg) func createActivityPrize(request: PrizeCreateRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let  activityId = request.activityId;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {                  
                    // 关联activity and prize
                    let prizeId = getIdAndIncrementOne();
                    let prize = HackathonDomain.createRequestToPrize(request, prizeId);
                    let rel = #prize prize ;
                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, prizeId, rel);

                    #ok(true)
                        
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑黑客松活动奖项
    public shared(msg) func editActivityPrize(prize: ActivityPrize) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);
        let activityId = prize.activityId;
        let prizeId = prize.id;
        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, prizeId)) {
                case (?_) {
                    let rel = #prize prize ;
                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, 
                        activityId, prizeId, rel);

                    #ok(true)
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    // 设置黑客松活动奖项的获胜者
    public shared(msg) func setPrizesWinners(request: ActivityPrizeWinnerUpdateRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let activityId = request.activityId;
            let prizeId = request.prizeId;
            let winners = request.winners;

            switch (HackathonRepositories.getActivityPrizeByActivityAndPrizeId(globalCache.activityRelCache, activityRelRepository, activityId, prizeId)) {
                case (?aa) {

                    // 删除原有奖励获奖项目的获奖信息 
                    for (projectId in aa.winners.vals()) {
                        switch (ProjectRepositories.getProjectActivityAwardsPrizeVoted(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId, activityId)) {
                            case (?p) {
                                let oldPAAPV = ProjectDomain.removePrizeOfProjectActivityAwardsPrizeVoted(p, prizeId);
                                ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(globalCache.projectActivityRelCache, projectActivityRelRepository, 
                                                    projectId, activityId, oldPAAPV); 
                            };
                            case (null) {};
                        }
                    };

                    switch (HackathonDomain.updateActivityPrizeWinner(aa, winners)) {
                        case (#ok(p)) {
                            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                                case (?a) {
                                    let ar = #prize p;
                                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, activityId, prizeId, ar);
                                    
                                    // 奖项获胜者的项目活动获取信息
                                    for (projectId in winners.vals()) {
                                        let newPAAPV = switch (ProjectRepositories.getProjectActivityAwardsPrizeVoted(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId, activityId)) {
                                            case (?p) {
                                                ProjectDomain.addPrizeOfProjectActivityAwardsPrizeVoted(p, prizeId)
                                                                              
                                            };
                                            case (null) {
                                                let currentTime = timeNow_();
                                                switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                                                    case (?p) {
                                                        ProjectDomain.newProjectActivityAwardsPrizeVoted(projectId, activityId, a.title, [], [prizeId], 0, a.strategy.historyRatio, 
                                                            a.strategy.periodRatio, a.strategy.minPerProject, a.strategy.maxPerProject, a.strategy.maxPerActivity, p.owner, currentTime)
                                                    };
                                                    case (null) { return #err(#notFound) };
                                                }
                                                
                                            };
                                        };

                                        ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(globalCache.projectActivityRelCache, projectActivityRelRepository, 
                                                    projectId, activityId, newPAAPV); 
                                    };
                                    
                                    #ok(true)
                                };
                                case (null) { #err(#notFound) };
                            }
                            
                        };
                        case (#err(e)) #err(e);
                    }
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定黑客松活动的奖项
    public query func getActivityPrize(activityId: ActivityId) : async Result<[ActivityPrize], Error> {
        #ok(HackathonRepositories.getActivityPrizeByActivityId(globalCache.activityRelCache, activityRelRepository, activityId))
    };

    /// 删除黑客松活动奖项
    public shared(msg) func deleteActivityPrize(activityId: ActivityId, prizeId: Types.Id) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (HackathonRepositories.getActivityRelationship(globalCache.activityRelCache, activityRelRepository, activityId, prizeId)) {
                case (?ar) {
                    switch (ar) {
                        case (#prize p) { 
                            // 判断奖项是否有获得者,有获得者则不能删除
                            if (Utils.arraySize(p.winners) > 0) {
                                #err(#unauthorized);
                            } else {
                                HackathonRepositories.removeRelByActivity(globalCache.activityRelCache, activityRelRepository, 
                                    activityId, prizeId);

                                #ok(true)
                            }
                        };
                        case (_) #err(#notFound);
                    }
                };
                case (null) #err(#notFound);
            }
            
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定黑客松活动的投票权
    public query(msg) func getUserVotingRightOrConvertFromUserPoint(activityId: ActivityId) : async Result<UserVotingRight, Error> {
        let caller = Principal.toText(msg.caller);
        switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
            case (?a) {
                #ok(calcUserVotingRight(caller, activityId, a.strategy.historyRatio))
            };
            case (null) #err(#notFound);
        }
    };

    /// 给黑客松活动中的project投票,需要考虑活动设置的最大投票数和最小投票数,个人某个活动最大投票数限制
    public shared(msg) func voteActivityProject(request: ActivityProjectVotingCreateRequest) : async Result<RecordingId, Error> {
        let caller = Principal.toText(msg.caller);     
        let projectId = request.projectId;
        let activityId = request.activityId;
        let ae = accessCheck(globalCache, caller, #create, #pubView);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) {
                    let currentTime = timeNow_();
                    if (a.endTime >= currentTime) {
                        let uvr = calcUserVotingRight(caller, activityId, a.strategy.historyRatio);
                        let availableVotingNum = PointDomain.availableVotingNum(uvr);
                        let votingAmount = request.amount;
                        // 当前活动+项目的投票数
                        let currentAV = HackathonRepositories.countActivityVotedSum(globalCache.activityRelCache, activityRelRepository, activityId);
                        if (availableVotingNum < a.strategy.minPerProject) {    // 可投票数比活动每个项目要求最少投票数少
                            #err(#votingRightTooFew)
                        } else if (votingAmount < a.strategy.minPerProject) {   // 投票数比活动每个项目要求最少投票数少
                            #err(#votingAmountTooFew)
                        } else if (votingAmount > a.strategy.maxPerProject)  {  // 投票数比活动每个项目要求最大投票数多
                            #err(#votingAmountTooLarge)
                        } else if (votingAmount + currentAV > a.strategy.maxPerActivity) {    // 投票数+已投票数比每个活动限制投票数最大值多
                            #err(#votingAmountTooLarge)
                        } else {
                            switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                                case (?p) {
                                    let votingId = getIdAndIncrementOne();
                                    
                                    let voting = RecordingDomain.createActivityProjectVotingToRecording(request, votingId, caller, currentTime);
                                    RecordingRepositories.saveRecording(globalCache.recordingCache, recordingRepository, voting);
                                    ProjectRepositories.addProjectRecordingRel(globalCache.projectRecordingRelCache, projectRecordingRelRepository, 
                                        globalCache.recordingCache, recordingRepository, projectId, votingId);
                                    
                                    updateUserBehaviourSummary_(caller, 1, UserDomain.addBehaviourVoting);

                                    // count and save UserVotingRight
                                    let newUVR = PointDomain.addVotedTotalSum(uvr, votingAmount);
                                    PointRepositories.addVotingRight(globalCache.votingRightCache, votingRightRepository, activityId, caller, newUVR);

                                    // count and save ActivityProjectVoted
                                    let newAPV = switch (HackathonRepositories.getActivityProjectVotedByActivityAndProjectId(
                                        globalCache.activityRelCache, activityRelRepository, activityId, projectId)) {
                                            case (?apv) {
                                                HackathonDomain.addActivityProjectVotedSum(apv, votingAmount);
                                            };
                                            case (null) {
                                                HackathonDomain.newActivityProjectVoted(activityId, projectId, votingAmount, a.startTime, a.endTime, currentTime,
                                                    a.strategy.historyRatio, a.strategy.periodRatio, a.strategy.minPerProject, a.strategy.maxPerProject, a.strategy.maxPerActivity)
                                            };
                                        };
                                    
                                    let newAR = #project newAPV;
                                    HackathonRepositories.addRelToActivity(globalCache.activityRelCache, activityRelRepository, activityId, projectId, newAR);

                                    // count and save ProjectActivityRel votedSum
                                    let paapv = switch (ProjectRepositories.getProjectActivityAwardsPrizeVoted(globalCache.projectActivityRelCache, projectActivityRelRepository,
                                        projectId, activityId)) {
                                        case (?p) {
                                            ProjectDomain.addVotedSumOfProjectActivityAwardsPrizeVoted(p, votingAmount)    
                                        };
                                        case (null) { 
                                            ProjectDomain.newProjectActivityAwardsPrizeVoted(projectId, activityId, a.title, [], [], votingAmount, a.strategy.historyRatio, 
                                                a.strategy.periodRatio, a.strategy.minPerProject, a.strategy.maxPerProject, a.strategy.maxPerActivity, p.owner, currentTime)
                                        };
                                    };

                                    ProjectRepositories.addProjectActivityAwardsPrizeVotedToProjectActivityRel(
                                        globalCache.projectActivityRelCache, projectActivityRelRepository, projectId, activityId, paapv
                                    );

                                    #ok(votingId)
                                };
                                case (null)  #err(#notFound);
                            }
                        };

                        
                    } else { #err(#activityExpired) }
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// -------------------------- Point interface ------------------------------- ///
    /// 创建空投积分计划
    public shared(msg) func createAirdropPointPlan() : async Result<AirdropPointPlanCreateResponse, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        let planId = getIdAndIncrementOne();
        let currentTime = timeNow_();
        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    #err(#alreadyExisted);
                };
                case (null) {
                    let profile = PointDomain.createEmptyAirdropPointPlan(planId, caller, currentTime);
                    let response = PointDomain.createEmptyAirdropPointPlanResponse(planId, currentTime);
                    PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, profile);
                    #ok(response)
                };
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 创建空投积分计划后,保存空投积分计划
    //  保存空投积分计划时,需要执行如下检查
    //     1) 空投积分计划的title不能为空
    //     2) 空投积分计划如何执行成功(包含全部成功和部分成功),都不能编辑再保存
    public shared(msg) func saveAirdropPointPlan(request: AirdropPointPlanSaveRequest) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        let planId = request.id;
        let currentTime = timeNow_();
        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) { 
                    let profile = PointDomain.updateAirdropPointPlanProfileWithSaveRequest(app, request);
                    if (PointDomain.isSuccessExecuted(profile)) {
                        return #err(#alreadySuccessExecuted);
                    } else if (PointDomain.isEmptyTitle(profile)) {
                        return #err(#airdropPointPlanTitleEmpty);
                    } else if (PointDomain.isEmptyDescription(profile)) {
                        return #err(#airdropPointPlanDescriptionEmpty);
                    } else {
                        PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, profile);
                        #ok(true);
                    }
                };
                case (null) #err(#notFound);
            }
        } else #err(#unauthorized)
    };

    /// 获取单个空投积分计划
    public query(msg) func getAirdropPointPlan(planId: AirdropPointPlanId) : async Result<?AirdropPointPlanProfile, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            #ok(PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId))
        } else #err(#unauthorized)
    };

    /// 分页查询空投积分计划
    public query(msg) func pageAirdropPointPlan(pageSize: Nat, pageNum: Nat) : async Result<AirdropPointPlanPage, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            #ok(PointRepositories.pageAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, pageSize, pageNum, 
            func (id, profile) : Bool { true }, PointDomain.compareAirdropPointPlanByIdDesc))
        } else { #err(#unauthorized)}
    };

    /// 按条件分页查询空投积分计划
    public query(msg) func pageAirdropPointPlanByPrincipalAndExecutedTime(userStr: Text, startTime: Timestamp, endTime: Timestamp, pageSize: Nat, pageNum: Nat) : async Result<AirdropPointPlanPage, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            #ok(PointRepositories.pageAirdropPointPlanByPrincipalAndExecutedTime(globalCache.airdropPointPlanCache, airdropPointPlanRepository, pageSize, pageNum, 
            PointDomain.compareAirdropPointPlanByIdDesc, userStr, startTime, endTime))
        } else { #err(#unauthorized)}
    };

    /// 按条件查询空投积分计划
    public query(msg) func findAirdropPointPlanByPrincipalAndExecutedTime(userStr: Text, startTime: Timestamp, endTime: Timestamp) : async Result<AirdropPointPlanDB, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            #ok(PointRepositories.airdropPointPlanCacheToDB(
                PointRepositories.fitlerAirdropPointPlanByUserAndExecutedTime(globalCache.airdropPointPlanCache, userStr, startTime, endTime))
            )
        } else #err(#unauthorized)
    };

    /// For test
    // public query func testAirdropPointPlanSaveRequest() : async AirdropPointPlanSaveRequest { 
    //     let id = 10007;
    //     let title = "airdop title";
    //     let description = "airdrop description";
    //     let data = [
    //         { 
    //             recipient = "v4r3s-nn353-xms6p-37w4r-okcn5-xxp6v-cnod7-4xqfl-sw5to-gcgue-bqe";
    //             amount = 20;
    //         }
    //     ];
           
    //     let request = {
    //                 id = id;
    //                 title = title;
    //                 description = description;
    //                 data = data;
    //             };
    //     request
    // };

    /// 执行空投积分计划,并累计执行成功接收者的积分
    //  执行空投积分计划时,需要执行如下检查
    //     1) 空投积分计划的title不能为空
    //     2) 空投积分计划的description不能为空
    //     3) 空投积分计划中积分记录的UserPrincipal重复的话,只有第一条生效,其他的重复记录标记失败,对应的UserPrincipal不获得对应的积分
    //     4) 空投积分计划如何执行成功(包含全部成功和部分成功),都不能重复执行
    //     5) 空投积分分计划的记录为空的话,不执行
    public shared(msg) func executeAirdropPointPlan(planId: AirdropPointPlanId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    if (PointDomain.isSuccessExecuted(app)) {
                        return #err(#alreadySuccessExecuted);
                    } else if (PointDomain.isEmptyTitle(app)) {
                        return #err(#airdropPointPlanTitleEmpty);
                    } else if (PointDomain.isEmptyDescription(app)) {
                        return #err(#airdropPointPlanDescriptionEmpty);
                    } else if (PointDomain.isAirdropPointPlainDataEmpty(app)) { 
                        return #err(#airdropPointPlanDataEmpty);
                    } else {
                        let currentTime = timeNow_();
                        let validatedProfile = PointDomain.validateAirdropPointPlan(app, caller, currentTime, globalCache.userCache);
                        PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, validatedProfile);
                        // 计算验证成功记录的接收者的积分, 并累计进用户的积分总数
                        for (rr in validatedProfile.data.vals()) {
                            if (PointDomain.isSuccessPointResultRecord(rr)) {
                                let user = rr.recipient;
                                let ubs = switch (UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, user)) {
                                    case (?u) { u };
                                    case (null) UserDomain.newUserBehaviourSummary(user);
                                };
                                let newUBS = UserDomain.addBehaviourPointSum(ubs, rr.amount);
                                UserRepositories.saveUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, newUBS);
                            };
                        };

                        return #ok(true);
                    }
                };
                case (null) { #err(#notFound) }
            }
        } else #err(#unauthorized)
    };

    /// 修改空投积分计划标题
    public shared(msg) func modifyAirdropPointPlanTitle(planId: AirdropPointPlanId, title: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    if (PointDomain.isAirdropPointPlanAlreadyExecuted(app)) {
                        #err(#airdropPointPlanAlreadyExecuted)
                    } else {
                        let profile = PointDomain.modifyAirdropPointPlanTitle(app, title);
                        PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, profile);
                        #ok(true)
                    }
                };
                case (null) #err(#notFound)
            }
            
        } else #err(#unauthorized)
    };

    /// 修改空投积分计划描述
    public shared(msg) func modifyAirdropPointPlanDescription(planId: AirdropPointPlanId, description: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    if (PointDomain.isAirdropPointPlanAlreadyExecuted(app)) {
                        #err(#airdropPointPlanAlreadyExecuted)
                    } else {
                        let profile = PointDomain.modifyAirdropPointPlanDescription(app, description);
                        PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, profile);
                        #ok(true)
                    }
                };
                case (null) #err(#notFound)
            }
            
        } else #err(#unauthorized)
    };

    /// 修改空投积分计划标题和描述
    public shared(msg) func modifyAirdropPointPlanTitleAndDescription(planId: AirdropPointPlanId, title: Text, description: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    if (PointDomain.isAirdropPointPlanAlreadyExecuted(app)) {
                        #err(#airdropPointPlanAlreadyExecuted)
                    } else {
                        let profile = PointDomain.modifyAirdropPointPlanTitleAndDesc(app, title, description);
                        PointRepositories.saveAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, profile);
                        #ok(true)
                    }
                };
                case (null) #err(#notFound)
            }
            
        } else #err(#unauthorized)
    };

    /// 删除执行计划,执行过的空投积分记录禁止删除,无论是执行成功或失败.
    public shared(msg) func deleteAirdropPointPlan(planId: AirdropPointPlanId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            switch (PointRepositories.getAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId)) {
                case (?app) {
                    if (PointDomain.isAirdropPointPlanAlreadyExecuted(app)) {
                        #err(#airdropPointPlanAlreadyExecuted)
                    } else {
                        let _ = PointRepositories.deleteAirdropPointPlan(globalCache.airdropPointPlanCache, airdropPointPlanRepository, planId);
                        #ok(true)
                    }
                };
                case (null) #err(#notFound)
            }
            
        } else #err(#unauthorized)
    };

    /// 给指定人增加积分,测试用
    public shared(msg) func airdropPointToUser(user: UserPrincipal, amount: Nat) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            updateUserBehaviourSummary_(user, amount, UserDomain.addBehaviourPointSum);   // 计算捐赠获得的积分
            // let ubs = switch (UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, user)) {
            //     case (?u) { u };
            //     case (null) UserDomain.newUserBehaviourSummary(user);
            // };
            
            // let newUBS = UserDomain.addBehaviourPointSum(ubs, amount);
            // UserRepositories.saveUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, newUBS);
            #ok(true)
        } else #err(#unauthorized)
    };

    /// -------------------------- Project interface ----------------------------- ///
    /// 创建tag
    public shared(msg) func createTag(category: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let t = Utils.trim(category);
            if (isExistedTag(t)) { 
                #err(#alreadyExisted)
            } else {
                tagDB := TagRepositories.saveTag(tagDB, tagRepository, t);
                #ok(true)
            }     
        } else {
            #err(#unauthorized)
        }      
    };

    /// 删除tag
    public shared(msg) func deleteTag(category: Text) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let t = Utils.trim(category);
            tagDB := TagRepositories.deleteTag(tagDB, tagRepository, t).0;
            #ok(true)
        } else {
            #err(#unauthorized)
        }
    };

    /// 所有的标签类型
    public query func allTags() : async Result<[TagCategory], Error> {
        #ok(allTags_())
    };

    /// 所有的标签类型数量
    public query func countTagTotal() : async Result<Nat, Error> {
        #ok(TagRepositories.countTagTotal(tagDB))
    };
    
    /// 新建Project
    public shared(msg) func createProject(request: ProjectCreateRequest) : async Result<ProjectId, Error> {
        let caller = Principal.toText(msg.caller);     
        let projectId = getIdAndIncrementOne();
        let ae = accessCheck(globalCache, caller, #create, #project projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            let currentTime = timeNow_();
            let profile = ProjectDomain.createRequestToProfile(request, projectId, caller, currentTime) ;

            if (not(ProjectDomain.isValidProjectName(profile.name))) {
                return #err(#projectNameInValid);
            };

            if (not(ProjectDomain.isValidProjectIntro(profile.information.content))) {
                return #err(#projectContentInvalid);
            };

            if (not(ProjectDomain.isValidWalletAddress(profile.wallet))) {
                return #err(#projectWalletAddressInvalid);
            };

            if (not(ProjectDomain.isValidCurrency(profile.wallet.currency))) {
                return #err(#projectWalletCurrencyInvalid);
            };

            if (not(ProjectDomain.isValidChainName(profile.wallet.chain))) {
                return #err(#projectWalletChainInvalid);
            };

            if (not(ProjectDomain.isValidUserName(profile.creator))) {
                return #err(#projectCreatorInvalid);
            };

            if (not(ProjectDomain.isValidUserIntro(profile.creatorInfo))) {
                return #err(#projectCreatorInfoInvalid);
            }; 

            if (not(ProjectDomain.isValidTag(allTags_(), profile.tags))) {
                return #err(#projectTagsInvalid);
            };

            if (not(ProjectDomain.isValidContactInfo(profile.contactInfo))) {
                return #err(#projectContactInfoInvalid);
            };

            if (not(ProjectDomain.isValidLinks(profile.links))) {
                return #err(#projectLinksInvalid)
            };

            ProjectRepositories.saveProject(globalCache.projectCache, projectRepository, profile);
            globalCache.projectCount += 1;

            updateUserBehaviourSummary_(caller, 1, UserDomain.addBehaviourProject);

            #ok(projectId)
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑Project,参加黑客松活动后不能修改
    public shared(msg) func editProject(newProject: ProjectProfile) : async Result<Bool, Error> {
        if (not(ProjectDomain.isValidProjectField(newProject, allTags_()))) {
            return #err(#badRequest)
        };

        let caller = Principal.toText(msg.caller);     
        let projectId = newProject.id;
        let ae = accessCheck(globalCache, caller, #update, #project projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            /// 如果项目参加了任何黑客松活动,不能修改项目信息,并返回项目已加入黑客松活动错误提示
            if (ProjectRepositories.findActivityIdsByProjectId(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId).size() > 0) {
                return #err(#projectJoinedActivity);
            };

            
            switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                case (?_) {
                    let profile = ProjectDomain.modifyProjectStatus(newProject, Constants.STATUS_PENDING);
                    
                    if (not(ProjectDomain.isValidProjectName(profile.name))) {
                        return #err(#projectNameInValid);
                    };

                    if (not(ProjectDomain.isValidProjectIntro(profile.information.content))) {
                        return #err(#projectContentInvalid);
                    };

                    if (not(ProjectDomain.isValidWalletAddress(profile.wallet))) {
                        return #err(#projectWalletAddressInvalid);
                    };

                    if (not(ProjectDomain.isValidCurrency(profile.wallet.currency))) {
                        return #err(#projectWalletCurrencyInvalid);
                    };

                    if (not(ProjectDomain.isValidChainName(profile.wallet.chain))) {
                        return #err(#projectWalletChainInvalid);
                    };

                    if (not(ProjectDomain.isValidUserName(profile.creator))) {
                        return #err(#projectCreatorInvalid);
                    };

                    if (not(ProjectDomain.isValidUserIntro(profile.creatorInfo))) {
                        return #err(#projectCreatorInfoInvalid);
                    }; 

                    if (not(ProjectDomain.isValidTag(allTags_(), profile.tags))) {
                        return #err(#projectTagsInvalid);
                    };

                    if (not(ProjectDomain.isValidContactInfo(profile.contactInfo))) {
                        return #err(#projectContactInfoInvalid);
                    };

                    if (not(ProjectDomain.isValidLinks(profile.links))) {
                        return #err(#projectLinksInvalid)
                    };

                    ProjectRepositories.saveProject(globalCache.projectCache, projectRepository, profile);
                    #ok(true)
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑Project的项目进度
    public shared(msg) func modifyProjectProgress(projectId: ProjectId, progress: ProgressStage) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #update, #project projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                case (?p) {
                    let newProject = ProjectDomain.modifyProjectProgress(p, progress);
                    ProjectRepositories.saveProject(globalCache.projectCache, projectRepository, newProject);
                    #ok(true)
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 修改指定项目状态
    public shared(msg) func modifyProjectStatus(projectId: ProjectId, status: ProjectStatus) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                case (?p) {
                    let newProject = ProjectDomain.modifyProjectStatus(p, status);
                    ProjectRepositories.saveProject(globalCache.projectCache, projectRepository, newProject);
                    #ok(true)
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 删除Project,项目加入黑客松活动后不能删除
    public shared(msg) func deleteProject(projectId: ProjectId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #update, #project projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            if (ProjectRepositories.findActivityIdsByProjectId(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId).size() > 0) {
                #err(#unauthorized)
            } else {
                let _ = ProjectRepositories.deleteProject(globalCache.projectCache, projectRepository, projectId);
                globalCache.projectCount -= 1;
                #ok(true)
            }          
        } else {
            #err(#unauthorized)
        }
    };

    /// 获取指定的Project
    public query func getProject(projectId: ProjectId) : async Result<?ProjectProfile, Error> {
        #ok(ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId))
    };

    /// 查询当前用户对指定project及黑客松活动投票权及活动已投票数
    public query(msg) func getProjectActivityVotingRightAndVotedSum(projectId: ProjectId, activityId: ActivityId) : async Result<?ActivityProjectUserVote, Error> {
        let caller = Principal.toText(msg.caller); 

        let activity = switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
            case (?a) { a };
            case (null) { return #err(#notFound); };
        };

        let historyRatio = activity.strategy.historyRatio;

        // 获取项目+活动的投票情况
        switch (HackathonRepositories.getActivityProjectVotedByActivityAndProjectId(globalCache.activityRelCache, activityRelRepository, activityId, projectId)) {
            case (?apv) {
                // 获取用户投票权信息
                let uvr = calcUserVotingRight(caller, activityId, historyRatio);
                
                // 获取活动投票数
                let as = HackathonRepositories.getActivitySummaryById(globalCache.activityRelCache, activityRelRepository, 
                    globalCache.recordingCache, recordingRepository, globalCache.grantCache, grantRepository, activityId);

                let apuv = HackathonDomain.newActivityProjectUserVote(activity, apv, uvr, as.votedSum);

                #ok(?apuv)
            };
            case (null) { #ok(null) };
        }
        
    };

    /// 查询指定用户对指定project及黑客松活动投票权及活动已投票数
    public query(msg) func getUserProjectActivityVotingRightAndVotedSum(user: UserPrincipal, projectId: ProjectId, activityId: ActivityId) : async Result<?ActivityProjectUserVote, Error> {
        let caller = user; 

        let activity = switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
            case (?a) { a };
            case (null) { return #err(#notFound) };
        };

        let historyRatio = activity.strategy.historyRatio;
        // 获取项目+活动的投票情况
        switch (HackathonRepositories.getActivityProjectVotedByActivityAndProjectId(globalCache.activityRelCache, activityRelRepository, activityId, projectId)) {
            case (?apv) {
                // 获取用户投票权信息
                let uvr = calcUserVotingRight(caller, activityId, historyRatio);
                
                // 获取活动投票数
                let as = HackathonRepositories.getActivitySummaryById(globalCache.activityRelCache, activityRelRepository, 
                    globalCache.recordingCache, recordingRepository, globalCache.grantCache, grantRepository, activityId);

                let apuv = HackathonDomain.newActivityProjectUserVote(activity, apv, uvr, as.votedSum);

                #ok(?apuv)
            };
            case (null) { #ok(null) };
        }
        
    };

    /// 查询当前用户对指定project关联的进行中的黑客松活动投票权及活动已投票数
    public query(msg) func findProjectActivityVotingRightAndVotedSum(projectId: ProjectId) : async Result<[ActivityProjectUserVote], Error> {
        let caller = Principal.toText(msg.caller); 
        let activityIds = ProjectRepositories.findActivityIdsByProjectId(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId);

        let currentTime = timeNow_();
        var apuvs = Buffer.Buffer<ActivityProjectUserVote>(0);

        for ((activityId, _) in activityIds.entries()) {
            let activity = switch (HackathonRepositories.getActivity(globalCache.activityCache, activityRepository, activityId)) {
                case (?a) { a };
                case (null) { return #err(#notFound) };
            };

            let historyRatio = activity.strategy.historyRatio;
            switch (HackathonRepositories.getActivityProjectVotedByActivityAndProjectId(globalCache.activityRelCache, activityRelRepository, activityId, projectId)) {
                case (?apv) {
                    if (currentTime >= apv.startTime and currentTime <= apv.endTime) {
                        // 获取用户投票权信息
                        let uvr = calcUserVotingRight(caller, activityId, historyRatio);
                        
                        // 获取活动投票数
                        let as = HackathonRepositories.getActivitySummaryById(globalCache.activityRelCache, activityRelRepository, 
                            globalCache.recordingCache, recordingRepository, globalCache.grantCache, grantRepository, activityId);

                        apuvs.add(HackathonDomain.newActivityProjectUserVote(activity, apv, uvr, as.votedSum));

                    };
                };
                case (null) {};
            }
        };

        #ok(apuvs.toArray())
    };

    /// 分页查询项目,状态是可用,按id倒序(最大(时间最新)在前)
    public query func pageProject(pageSize: Nat, pageNum: Nat) : async Result<ProjectPage, Error> {
        #ok(ProjectRepositories.pageProject(globalCache.projectCache, projectRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.status == STATUS_ENABLE
        }, ProjectDomain.compareById))
    };

    /// 分页查询项目,忽略状态,按id倒序(最大(时间最新)在前)
    public query func pageProjectIgnoreStatus(pageSize: Nat, pageNum: Nat) : async Result<ProjectPage, Error> {
        #ok(ProjectRepositories.pageProject(globalCache.projectCache, projectRepository, pageSize, pageNum, func (id, profile) : Bool { 
            true
        }, ProjectDomain.compareById))
    };

    /// 获取所有的项目,不分页
    public query func allProjects() : async Result<ProjectDB, Error> {
        #ok(ProjectRepositories.projectCacheToDB(globalCache.projectCache))
    };

    public query func testCreateProject() : async ProjectCreateRequest {
        {
            name = "name";
            information = { format = "text"; content = "information" };
            logoUri = "";
            creator = "creator";
            creatorInfo = "creatorInfo";
            wallet = { 
                walletAddress = "address";
                currency = "currency";
                chain = "cahin"
            };
            contactInfo = "contactInfo";
            startTime = 100000000;
            links = ["link1", "link2"];
            tags = ["NFT", "DeFi"];
            progress = Constants.PROGRESS_IN_PROGRESS;

        }
    };

    public query func testCreateActivity() : async ActivityCreateRequest { 
        {
            title = "title";
            tags = ["NFT"];
            coverPhotoUri = "";
            mainPhotoUri = "";
            publishTime = 1641809965888699258;
            startTime = 1641809965888699258;
            endTime =   1642000000000000000;
            introduction = { format = "text"; content = "introdction" };
            strategy = { historyRatio = 5; periodRatio = 10; minPerProject = 10; maxPerProject = 300; maxPerActivity = 30000;};
            bonus = ["2000 ICP", "3000 USTD"];
            bonusPool = "10000 ICP";
        }
    };

    /// 给project增加评论,只有捐赠者和项目owner才能评论
    public shared(msg) func addProjectComment(request: ProjectCommentCreateRequest) : async Result<RecordingId, Error> {
        let caller = Principal.toText(msg.caller);     
        let projectId = request.projectId;
        let ae = accessCheck(globalCache, caller, #update, #commentProject projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            switch (ProjectRepositories.getProject(globalCache.projectCache, projectRepository, projectId)) {
                case (?p) {
                    let commentId = getIdAndIncrementOne();
                    let currentTime = timeNow_();
                    let comment = RecordingDomain.createProjectCommentToRecording(request, commentId, caller, currentTime);
                    RecordingRepositories.saveRecording(globalCache.recordingCache, recordingRepository, comment);
                    ProjectRepositories.addProjectRecordingRel(globalCache.projectRecordingRelCache, projectRecordingRelRepository, 
                        globalCache.recordingCache, recordingRepository, projectId, commentId);

                    updateUserBehaviourSummary_(caller, 1, UserDomain.addBehaviourComment);

                    #ok(commentId)
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };

    /// 按指定项目分页查询评论
    public query func pageProjectComment(projectId: ProjectId, pageSize: Nat, pageNum: Nat) : async Result<RecordingPage, Error> {

        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageCommentByProjectId(globalCache.recordingCache, recordingRepository, projectId, pageSize, pageNum, sortWith))
    };

    /// 获取指定的评论
    public query func getProjectComment(commentId: RecordingId) : async Result<?RecordingProfile, Error> {
        #ok(RecordingRepositories.getRecording(globalCache.recordingCache, recordingRepository, commentId))
    };

    /// 查询所有的记录(包含留言, 投票, 申请)
    public query func allRecordings() : async Result<RecordingDB, Error> {
        #ok(RecordingRepositories.recordingCacheToDB(globalCache.recordingCache))
    };

    /// 删除指定的评论
    public shared(msg) func deleteProjectComment(projectId: ProjectId, commentId: RecordingId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller); 
        let ae = accessCheck(globalCache, caller, #update, #commentProject projectId);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            switch (RecordingRepositories.getRecording(globalCache.recordingCache, recordingRepository, commentId)) {
                case (?r) { 
                    let now = timeNow_();
                    let deletingRecordingProfile = RecordingDomain.deletingRecordingProfile(r, caller, now);
                    RecordingRepositories.saveRecording(globalCache.recordingCache, recordingRepository, deletingRecordingProfile);
                    #ok(true)
                };
                case (_) #err(#notFound)
            }
        } else #err(#unauthorized)
    };

    /// 已删除评论列表分页
    public query func pageDeleteProjectComment(pageSize: Nat, pageNum: Nat, startTime: Timestamp, endTime: Timestamp) : async Result<RecordingPage, Error> {
        let sortWith =  RecordingDomain.compareByUpdateTimeDesc;
        #ok(RecordingRepositories.pageDeletedProjectComment(globalCache.recordingCache, recordingRepository, pageSize, pageNum, sortWith, startTime, endTime))
    };

    /// 按指定项目分页查询捐助Grant
    public query func pageProjectGrant(projectId: ProjectId, pageSize: Nat, pageNum: Nat) : async Result<GrantPage, Error> {
        #ok(GrantRepositories.pageProjectGrant(globalCache.grantCache, grantRepository, projectId, pageSize, pageNum, func (id, profile) : Bool { 
            profile.status == STATUS_ENABLE and profile.grantTarget.targetId == projectId
        }, GrantDomain.compareById))
    };

    /// 获取指定项目参加的所有黑客松活动列表
    public query func allActivitiesByProjectId(projectId: ProjectId) : async Result<[ActivityId], Error> {
        #ok(ProjectRepositories.findActivityIdsDBByProjectId(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId))
    };

    /// 获取指定项目参与的黑客松活动信息列表
    public query func allActivitiesDBByProjectId(projectId: ProjectId) : async Result<[ProjectActivityAwardsPrizeVoted], Error> {
        #ok(ProjectRepositories.getActivityAwardsPrizeVotedDBByProjectId(globalCache.projectActivityRelCache, projectActivityRelRepository, projectId))
    };

    /// 获取指定用户的项目参与的黑客松活动信息列表
    public query func allActivitiesByOwner(user: UserPrincipal) : async Result<[ProjectActivityAwardsPrizeVoted], Error> {
        #ok(ProjectRepositories.findProjectActivityRelDBByOwner(globalCache.projectActivityRelCache, user))
    };

    /// 获取指定项目参与的黑客松活动获奖信息
    public query func allProjectActivityAwards(projectId: ProjectId) : async Result<[ProjectActivityAwardsView], Error> {
        #ok(HackathonRepositories.getProjectActivityAwardsViewByProjectId(
            globalCache.projectActivityRelCache, projectActivityRelRepository,
            globalCache.activityRelCache, activityRelRepository,projectId
        ))
    };

    /// 获取所有的项目及其参与的活动信息列表
    public query func allProjectActivities() : async Result<ProjectActivityRelDB, Error> {
        #ok(ProjectRepositories.projectActivityRelCacheToDB(globalCache.projectActivityRelCache))
    };

    /// 按指定项目分页查询投票
    public query func pageProjectVoting(projectId: ProjectId, pageSize: Nat, pageNum: Nat) : async Result<RecordingPage, Error> {

        let sortWith =  RecordingDomain.compareByCreateTimeDesc;
        #ok(RecordingRepositories.pageVotingByProjectId(globalCache.recordingCache, recordingRepository, projectId, pageSize, pageNum, sortWith))
    };

    /// 获取指定的投票
    public query func getProjectVoting(votingId: RecordingId) : async Result<?RecordingProfile, Error> {
        #ok(RecordingRepositories.getRecording(globalCache.recordingCache, recordingRepository, votingId))
    };

    /// ------------------------ Sponsor functions -------------------------- ///
    /// 新建赞助商
    public shared(msg) func createSponsor(request: SponsorCreateRequest) : async Result<SponsorId, Error> {
        let caller = Principal.toText(msg.caller);     
        let sponsorId = getIdAndIncrementOne();
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            let currentTime = timeNow_();
            let sponsorProfile = SponsorDomain.createRequestToProfile(request, sponsorId, caller, currentTime);         
            SponsorRepositories.saveSponsor(globalCache.sponsorCache, sponsorRepository, sponsorProfile);
            #ok(sponsorId)
                 
        } else {
            #err(#unauthorized)
        }
    };

    /// 编辑赞助商
    public shared(msg) func editSponsor(newSponsor: SponsorProfile) : async Result<Bool, Error> {

        let caller = Principal.toText(msg.caller);     
        let sponsorId = newSponsor.id;
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) { 
            switch (SponsorRepositories.getSponsor(globalCache.sponsorCache, sponsorRepository, sponsorId)) {
                case (?_) {
                    SponsorRepositories.saveSponsor(globalCache.sponsorCache, sponsorRepository, newSponsor);
                    #ok(true)                   
                };
                case (null) #err(#notFound);
            }
        } else {
            #err(#unauthorized)
        }
    };


    /// 获取指定的赞助商
    public query func getSponsor(sponsorId: SponsorId) : async Result<?SponsorProfile, Error> {
        #ok(SponsorRepositories.getSponsor(globalCache.sponsorCache, sponsorRepository, sponsorId))
    };

    /// 分页查询可用赞助商,按id倒序(最大(时间最新)在前)
    public query func pageEnableSponsor(pageSize: Nat, pageNum: Nat) : async Result<SponsorPage, Error> {
        let currentTime = timeNow_();
        #ok(SponsorRepositories.pageSponsor(globalCache.sponsorCache, sponsorRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.status == Constants.STATUS_ENABLE
        }, SponsorDomain.compareSponsorById))
    };

    /// 分页查询赞助商,按id倒序(最大(时间最新)在前),后台管理专用
    public query(msg) func pageSponsor(pageSize: Nat, pageNum: Nat) : async Result<SponsorPage, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let currentTime = timeNow_();
            #ok(SponsorRepositories.pageSponsor(globalCache.sponsorCache, sponsorRepository, pageSize, pageNum, func (id, profile) : Bool { 
                profile.id >= 0
            }, SponsorDomain.compareSponsorById))
        } else {
            #err(#unauthorized)
        }
    };

    /// 查询所有赞助商,后台管理专用
    public query(msg) func allSponsors(pageSize: Nat, pageNum: Nat) : async Result<SponsorDB, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        if (ae.isOk) {
            let currentTime = timeNow_();
            #ok(SponsorRepositories.sponsorCacheToDB(globalCache.sponsorCache))
        } else {
            #err(#unauthorized)
        }
    };

    /// 删除赞助商
    public shared(msg) func deleteSponsor(sponsorId: SponsorId) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let ae = accessCheck(globalCache, caller, #admin, #all);

        ignore logCheckEvent(ae, caller);
        
        if (ae.isOk) {
            let _ = SponsorRepositories.deleteSponsor(globalCache.sponsorCache, sponsorRepository, sponsorId);
            #ok(true)
        } else {
            #err(#unauthorized)
        }
    };

    /// ------------------------ private functions -------------------------- ///

    /// 获取当前的id，并对id+1,这是有size effects的操作
    func getIdAndIncrementOne() : Nat {
        let id = idGenerator;
        idGenerator += 1;
        id
    };


    /// --------------- User helper functions --------------------- /// 
    /// 私有辅助方法，获取用户信息
    func getUser_(userPrincipal: UserPrincipal) : ?UserProfile {
        UserRepositories.getUser(globalCache.userCache, userRepository, userPrincipal)
    };

    /// 私有辅助方法，保存用户信息到数据库中
    /// Args:
    ///     |db| 保存用户信息的数据库
    ///     |userProfile| 需要被保存的用户信息
    /// Returns:
    ///     返回保存新DappProfile后的数据库
    func updateUser_(userProfile: UserProfile) : ?UserProfile {
        UserRepositories.updateUser(globalCache.userCache, userRepository, userProfile)
    };

    /// 物理删除指定用户
    func deleteUser_(userPrincipal: UserPrincipal) : ?UserProfile {
        UserRepositories.deleteUser(globalCache.userCache, userRepository, userPrincipal)
    };

    /// 用户行为数据更新
    private func updateUserBehaviourSummary_(user: UserPrincipal, amount: Nat, calc: (UserBehaviourSummary, Nat) -> UserBehaviourSummary) {    
        let currentUBS = switch (UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, user)) {
            case (?ubm) ubm;
            case (null) UserDomain.newUserBehaviourSummary(user);
        };
        let userBehaviourSummary = calc(currentUBS, amount);
        UserRepositories.saveUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, userBehaviourSummary);
    };

    /// 记录访问日志，异步操作
    func logCheckEvent(ae: AccessEvent, caller: UserPrincipal ) : async () {
        ignore logInfo(Access.accessEventToText(ae), caller);
    };

    /// 记录日志
    func logInfo(msg: Text, caller: UserPrincipal) : async () {
        ignore Logger.info(msg, getCanisterId(), caller);
    };

    /// 检查权限返回访问事件，包含是否能操作
    func accessCheck(globalCache: GlobalCache, caller : UserPrincipal, action : RoleDomain.UserAction, target : RoleDomain.ActionTarget) : AccessEvent {
        access.check(globalCache, timeNow_(), caller, action, target)       
    };

    /// 辅助方法，判断权限是否允许，然后逻辑处理并返回
    func validAndProcess<T>(ae: AccessEvent, f: () -> Result<T, Error>) : Result<T, Error> {
        if (ae.isOk) {
            f()
        } else {
            #err(#unauthorized)
        }
    };
    
    /// 辅助方法，获取当前时间
    func timeNow_() : Int {
        Time.now()
    };

    /// 查询所有的tag
    func allTags_() : [Text] {
        TagRepositories.allTags(tagDB)
    };

    /// 辅助方法,判断tag是否存在
    func isExistedTag(category: Text) : Bool {
        TagRepositories.isExistedTag(tagDB, tagRepository, category)
    };

    // 检查捐助者+当前活动的投票权是否存在,如果不存在计算历史积分的投票权 过时了
    // 从用户行为汇总中获取总积分,结合活动的历史积分与投票权比例计算
    private func calcUserVotingRight(grantFrom: UserPrincipal, activityId: Nat, historyRatio: Nat) : UserVotingRight {      
        // 计算用户历史积分对应的投票权
        let  newTotalSumFromPoint = switch (UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, grantFrom)) {
            case (?ubs) { Utils.intToNatElseZero(ubs.pointSum / historyRatio) };
            case (null) { 0 }
        };

        let currentUVR = switch (PointRepositories.getVotingRightByTargetIdAndUser(globalCache.votingRightCache, votingRightRepository, activityId, grantFrom)) {
            case (?v) {
                v
            };
            case (null) { 
                PointDomain.newUserVotingRight(grantFrom, 0, newTotalSumFromPoint)
            };
        };

        PointDomain.replaceUserVotingRightTotalSum(currentUVR, newTotalSumFromPoint)

        // 计算用户历史积分对应的投票权


        // let  vr: Nat = switch (UserRepositories.getUserBehaviourSummary(globalCache.userBehaviourSummaryCache, userBehaviourSummaryRepository, grantFrom)) {
        //     case (?ubs) { 
        //         Utils.intToNatElseZero(ubs.pointSum / historyRatio)
        //     };
        //     case (null) { 0 }
        // };
        // let uvr = switch (PointRepositories.getVoint)
        // PointDomain.newUserVotingRight(grantFrom, vr)
    };

    /// 获取指定用户的积分列表,包含捐赠和空投获得的积分
    private func pageUserPointRecord(user: UserPrincipal, pageSize: Nat, pageNum: Nat) : Page<UserPointView> {
        let pageGrant = GrantRepositories.pageGrant(globalCache.grantCache, grantRepository, pageSize, pageNum, func (id, profile) : Bool { 
            profile.owner == user and profile.status == STATUS_ENABLE
        }, GrantDomain.compareById);
        let dataBuffer = Buffer.Buffer<UserPointView>(0);

        // 捐赠获得的积分记录
        for (g in pageGrant.data.vals()) {
            dataBuffer.add(GrantDomain.grantProfileToUserPointView(g))
        };
        // 空投获得的积分记录
        for ((_, app) in globalCache.airdropPointPlanCache.entries()) {
            for (rr in app.data.vals()) {
                if (PointDomain.isSuccessPointResultRecord(rr) and rr.recipient == user) {
                    dataBuffer.add(PointDomain.airdropPointResultRecordToUserPointView(rr, app.executedTime))
                };
            }
        };

        {
            data = dataBuffer.toArray();
            pageSize = pageGrant.pageSize;
            pageNum = pageGrant.pageNum;
            totalCount = pageGrant.totalCount;
        }
    };
};
