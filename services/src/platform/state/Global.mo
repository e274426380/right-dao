
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

import GrantDomain "../grant/GrantDomain";
import GrantRepositories "../grant/GrantRepositories";
import HackathonRepositories "../hackathon/HackathonRepositories";
import HashMapRepositories "../repositories/HashMapRepositories";
import PointRepositories "../point/PointRepositories";
import ProjectDomain "../project/ProjectDomain";
import ProjectRepositories "../project/ProjectRepositories";
import RecordingRepositories "../recording/RecordingRepositories";
import Rel "../base/Rel";
import RelObj "../base/RelObj";
import RoleDomain "../validation/RoleDomain";
import RoleRepositories "../validation/RoleRepositories";
import SponsorRepositories "../sponsor/SponsorRepositories";
import Types "../base/Types";
import UserDomain "../user/UserDomain";
import UserRepositories "../user/UserRepositories";
import Utils "../base/Utils";

module {

    public type ValueDB<V> = HashMapRepositories.ValueDB<V>;
    public type Cache<X, Y> = HashMapRepositories.HashMapCache<X, Y>;

    public type GrantId = GrantDomain.GrantId;
    public type GrantProfile = GrantDomain.GrantProfile;
    public type ProjectId = ProjectDomain.ProjectId;
    public type ProjectProfile = ProjectDomain.ProjectProfile;
    public type UserProfile = UserDomain.UserProfile;
    public type UserPrincipal = UserDomain.UserPrincipal;
    

    public type RelShared<X, Y> = Rel.RelShared<X, Y>;
    public type RelObj<X, Y> = RelObj.RelObj<X, Y>;

    public type ActivityCache = HackathonRepositories.ActivityCache;
    public type ActivityDB = HackathonRepositories.ActivityDB;
    public type ActivityRelCache = HackathonRepositories.ActivityRelCache;
    public type ActivityRelDB = HackathonRepositories.ActivityRelDB;

    public type GrantDB = GrantRepositories.GrantDB;
    public type GrantCache = GrantRepositories.GrantCache;

    public type ProjectCache = ProjectRepositories.ProjectCache;
    public type ProjectDB = ProjectRepositories.ProjectDB;
    public type ProjectRecordingRelCache = ProjectRepositories.ProjectRecordingRelCache;
    public type ProjectRecordingRelDB = ProjectRepositories.ProjectRecordingRelDB;
    public type ProjectActivityRelCache = ProjectRepositories.ProjectActivityRelCache;
    public type ProjectActivityRelDB = ProjectRepositories.ProjectActivityRelDB;

    public type RecordingCache = RecordingRepositories.RecordingCache;
    public type RecordingDB = RecordingRepositories.RecordingDB;

    public type SponsorDB = SponsorRepositories.SponsorDB;
    public type SponsorCache = SponsorRepositories.SponsorCache;

    public type UserCache = UserRepositories.UserCache;
    public type UserDB = UserRepositories.UserDB;
    public type UserBehaviourSummaryCache = UserRepositories.UserBehaviourSummaryCache;
    public type UserBehaviourSummaryDB = UserRepositories.UserBehaviourSummaryDB;

    public type VotingRightCache = PointRepositories.VotingRightCache;
    public type VotingRightDB = PointRepositories.VotingRightDB;
    public type AirdropPointPlanDB = PointRepositories.AirdropPointPlanDB;
    public type AirdropPointPlanCache = PointRepositories.AirdropPointPlanCache;

    public type Role = RoleDomain.Role;
    public type RoleProfile = RoleDomain.RoleProfile;
    public type RoleDB = RoleRepositories.RoleDB;
    public type RoleCache = Cache<UserPrincipal, RoleProfile>;
     
    /// 整个Dapp的临时状态，包含用户信息，用户
    public type GlobalCache = {
        adminCache : RoleCache;        // 权限控制
        userCache: UserCache;
        projectCache: ProjectCache;
        grantCache: GrantCache;
        userBehaviourSummaryCache: UserBehaviourSummaryCache;
        recordingCache: RecordingCache;
        activityCache: ActivityCache;
        votingRightCache: VotingRightCache;                   // 活动+用户的投票权 [(ActivityId, [(UserPrincipal, UserVotingRight)])]
        airdropPointPlanCache: AirdropPointPlanCache;
        sponsorCache: SponsorCache;
        projectRecordingRelCache: ProjectRecordingRelCache;
        projectActivityRelCache: ProjectActivityRelCache;    // 项目和活动的关联,包含投票,获奖等信息
        // grantUserTargetRelCache: GrantUserTargetRelCache;     // 项目对应的某人的Grant, UserPrincipal -> <GrantTargetId>, ()>
        activityRelCache: ActivityRelCache;                   // 活动关联的信息,例如奖励,奖项,项目投票,赞助商
        var userCount: Nat;     // 平台用户数量
        var projectCount: Nat;     // 平台项目数量
        var grantCount: Nat;   // 平台打赏数量
        // var bountyCount: Nat;     // 平台Bounty数量
    };

    public type BuildSummary = {
        userCount: Nat;
        projectCount: Nat;
        grantCount: Nat;
    };

    /// 初始化状态变量 
    public func init(
        adminDB: RoleDB, 
        userDB: UserDB,
        projectDB: ProjectDB,
        grantDB: GrantDB,
        userBehaviourSummaryDB: UserBehaviourSummaryDB,
        recordingDB: RecordingDB,
        activityDB: ActivityDB,
        votingRightDB: VotingRightDB,
        airdropPointPlanDB: AirdropPointPlanDB,
        sponsorDB: SponsorDB,
        projectRecordingRelDB: ProjectRecordingRelDB,
        projectActivityRelDB: ProjectActivityRelDB,
        activityRelDB: ActivityRelDB,
    ) : GlobalCache {
        let sm: GlobalCache = {
            adminCache = RoleRepositories.roleDBToCache(adminDB);
            userCache = UserRepositories.userDBToCache(userDB);
            projectCache = ProjectRepositories.projectDBToCache(projectDB);
            grantCache = GrantRepositories.grantDBToCache(grantDB);
            userBehaviourSummaryCache = UserRepositories.userBehaviourSummaryDBToCache(userBehaviourSummaryDB);
            recordingCache = RecordingRepositories.recordingDBToCache(recordingDB);
            activityCache = HackathonRepositories.activityDBToCache(activityDB);
            votingRightCache = PointRepositories.votingRightDBToCache(votingRightDB);
            airdropPointPlanCache = PointRepositories.airdropPointPlanDBToCache(airdropPointPlanDB);
            projectRecordingRelCache = ProjectRepositories.projectRecordingRelDBToCache(projectRecordingRelDB);
            projectActivityRelCache = ProjectRepositories.projectActivityRelDBToCache(projectActivityRelDB);
            sponsorCache = SponsorRepositories.sponsorDBToCache(sponsorDB);
            // grantUserTargetRelCache = GrantRepositories.grantDBToUserTargetRelCache(grantDB);
            activityRelCache = HackathonRepositories.activityRelDBToCache(activityRelDB);
            var userCount = Utils.arraySize<(UserPrincipal, UserProfile)>(userDB);
            var projectCount = Utils.arraySize<(ProjectId, ProjectProfile)>(projectDB);
            var grantCount = GrantRepositories.grantTotalSumFromDB(grantDB);
        };

        sm
    };

    public func stateToSummary(globalCache: GlobalCache) : BuildSummary {
        { 
            userCount = globalCache.userCount;
            projectCount = globalCache.projectCount;
            grantCount = globalCache.grantCount;
        }
    };
};

