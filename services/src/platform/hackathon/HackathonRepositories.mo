
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Order "mo:base/Order";

import GrantDomain "../grant/GrantDomain";
import GrantRepositories "../grant/GrantRepositories";
import HackathonDomain "HackathonDomain";
import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import PointRepositories "../point/PointRepositories";
import ProjectDomain "../project/ProjectDomain";
import ProjectRepositories "../project/ProjectRepositories";
import RecordingRepositories "../recording/RecordingRepositories";
import SponsorDomain "../sponsor/SponsorDomain";
import SponsorRepositories "../sponsor/SponsorRepositories";
import Types "../base/Types";

module {

    public type ActivityProfile = HackathonDomain.ActivityProfile;
    public type ActivityRelationship = HackathonDomain.ActivityRelationship;
    public type ActivityProjectVoted = HackathonDomain.ActivityProjectVoted;
    public type ActivityProjectProfileVoted = HackathonDomain.ActivityProjectProfileVoted;
    public type ActivitySummary = HackathonDomain.ActivitySummary;
    public type ActivityId = HackathonDomain.ActivityId;

    public type ProjectId = ProjectDomain.ProjectId;
    public type ProjectProfile = ProjectDomain.ProjectProfile;
    public type ProjectActivityAwardsPrizeVoted = ProjectDomain.ProjectActivityAwardsPrizeVoted;
    public type ProjectActivityAwardsView = ProjectDomain.ProjectActivityAwardsView;
    public type RelId = Types.Id;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;

    public type ActivitySponsorProfile = HackathonDomain.ActivitySponsorProfile;
    public type ActivitySponsorQuota = HackathonDomain.ActivitySponsorQuota;
    public type SponsorProfile = SponsorDomain.SponsorProfile;

    public type RecordingCache = RecordingRepositories.RecordingCache;
    public type RecordingRepository = RecordingRepositories.RecordingRepository;
 
    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;

    public type ActivityAwards = HackathonDomain.ActivityAwards;
    public type ActivityPrize = HackathonDomain.ActivityPrize;
    public type ActivityPage = PageHelper.Page<ActivityProfile>;

    public type ActivityDB = DB<ActivityId, ActivityProfile>;
    public type ActivityCache = Cache<ActivityId, ActivityProfile>;
    public type ActivityRepository = HashMapRepositories.HashMapRepository<ActivityId, ActivityProfile>;

    public type ActivityRelDB = DB<ActivityId, DB<RelId, ActivityRelationship>>;   //[(ActivityId, [(RelId,  ActivityRelationship)])]
    public type ActivityRelCache = Cache<ActivityId, Cache<RelId, ActivityRelationship>>;
    public type ActivityRelRepository = HashMapRepositories.HashMapRepository<ActivityId, Cache<RelId, ActivityRelationship>>;

    public type GrantDB = GrantRepositories.GrantDB;
    public type GrantCache = GrantRepositories.GrantCache;
    public type GrantRepository = GrantRepositories.GrantRepository;

    public type ProjectDB = ProjectRepositories.ProjectDB;
    public type ProjectCache = ProjectRepositories.ProjectCache;
    public type ProjectRepository = ProjectRepositories.ProjectRepository;
    public type ProjectActivityRelDB = ProjectRepositories.ProjectActivityRelDB;
    public type ProjectActivityRelCache = ProjectRepositories.ProjectActivityRelCache;
    public type ProjectActivityRelRepository = ProjectRepositories.ProjectActivityRelRepository;

    public type SponsorCache = SponsorRepositories.SponsorCache;
    public type SponsorRepository= SponsorRepositories.SponsorRepository;

    public let activityEq = HackathonDomain.activityEq;  
    public let activityHash = HackathonDomain.activityHash;
    public let projectEq = ProjectDomain.projectEq;
    public let projectHash = ProjectDomain.projectHash;

    public let relEq = Types.idEq;
    public let relHash = Types.idHash;
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;

    public func newActivityDB() :  ActivityDB {
        []
    };

    public func newActivityCache() : ActivityCache {
        HashMap.HashMap<ActivityId, ActivityProfile>(0, activityEq, activityHash)
    };

    public func newActivityRepository() : ActivityRepository {
        HashMapRepositories.HashMapRepository<ActivityId, ActivityProfile>()
    };

    /// Activity CRUD
    public func saveActivity(cache: ActivityCache, repository: ActivityRepository, activityProfile: ActivityProfile) {
        let _ = updateActivity(cache, repository, activityProfile);
        ()
    };

    public func updateActivity(cache: ActivityCache, repository: ActivityRepository, activityProfile: ActivityProfile) : ?ActivityProfile {
        repository.update(cache, activityProfile.id, activityProfile)
    };

    public func deleteActivity(cache: ActivityCache, repository: ActivityRepository, activityId: ActivityId) : ?ActivityProfile {
        repository.delete(cache, activityId)
    };

    public func getActivity(cache: ActivityCache, repository: ActivityRepository, activityId: ActivityId) : ?ActivityProfile {
        repository.get(cache, activityId)
    };

    /// 按过滤条件查询活动
    public func findActivityBy(cache: ActivityCache, repository: ActivityRepository, filter: (ActivityId, ActivityProfile) -> ?ActivityProfile) : ActivityCache {
        repository.findBy(cache, activityEq, activityHash, filter)
    };

    public func pageActivity(cache: ActivityCache, repository: ActivityRepository, pageSize: Nat, pageNum: Nat,
        filter: (ActivityId, ActivityProfile) -> Bool, sortWith: (ActivityProfile, ActivityProfile) -> Order.Order) : ActivityPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 按活动创建时间段分页查询活动
    public func pageActivityByCreateTime(cache: ActivityCache, repository: ActivityRepository, pageSize: Nat, pageNum: Nat,
        sortWith: (ActivityProfile, ActivityProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : ActivityPage {
        func isIncludeTime(activityId: ActivityId, activityProfile: ActivityProfile) : Bool {
            activityProfile.createdAt >= startTime and activityProfile.createdAt <= endTime
        };

        pageActivity(cache, repository, pageSize, pageNum, isIncludeTime, sortWith)
    };

    public func activityDBToCache(db: ActivityDB) : ActivityCache {
        HashMapRepositories.dbToCache(db, activityEq, activityHash)
    };

    public func activityCacheToDB(cache: ActivityCache) : ActivityDB {
        HashMapRepositories.cacheToDB(cache)
    };

    /// Activity Relationship
    public func newActivityRelDB() : ActivityRelDB {
        []
    };

    public func newActivityRelCache() : ActivityRelCache {
        HashMapRepositories.newHashMapCache(activityEq, activityHash)
    };
    
    public func newActivityRelRepository() : ActivityRelRepository {
        HashMapRepositories.HashMapRepository<ActivityId, Cache<RelId, ActivityRelationship>>()
    };

    public func saveActivityRel(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, activityRels: Cache<RelId, ActivityRelationship>) {
        let _ = updateActivityRel_(cache, repository, activityId, activityRels);
        ()
    };

    func updateActivityRel_(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, activityRels: Cache<RelId, ActivityRelationship>) : ?Cache<RelId, ActivityRelationship> {
        repository.update(cache, activityId, activityRels)
    };

    public func getRelByActivityId(cache: ActivityRelCache, repository: ActivityRelRepository, activityId: ActivityId) : Cache<RelId, ActivityRelationship> {
        switch (repository.get(cache, activityId)) {
            case (?bs) { bs };
            case (null) { HashMapRepositories.newHashMapCache<RelId, ActivityRelationship>(relEq, relHash) };
        }
    };

    public func getActivityRelationship(cache: ActivityRelCache, repository: ActivityRelRepository, activityId: ActivityId, relId: RelId) : ?ActivityRelationship {
        getRelByActivityId(cache, repository, activityId).get(relId)
    };

    public func addRelToActivity(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, relId: RelId, activityRel: ActivityRelationship) {
        
        let existedRels = getRelByActivityId(cache, repository, activityId);
        existedRels.put(relId, activityRel);
        
        saveActivityRel(cache, repository, activityId, existedRels)
    };

    public func removeRelByActivity(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, relId: RelId) {

        let currentRels = getRelByActivityId(cache, repository, activityId);
        
        currentRels.delete(relId);
       
    };

    public func activityRelCacheToDB(cache: ActivityRelCache) : ActivityRelDB {
        HashMapRepositories.nestedMapToArray<ActivityId, RelId, ActivityRelationship>(cache)
    };

    public func activityRelDBToCache(db: ActivityRelDB): ActivityRelCache {
        HashMapRepositories.nestedArrayToMap<ActivityId, RelId, ActivityRelationship>(db, activityEq, activityHash, relEq, relHash)
    };
    
    /// 获取指定黑客松活动的赞助商列表
    public func getActivitySponsorByActivityId(cache: ActivityRelCache, repository: ActivityRelRepository,
        sponsorCache: SponsorCache, sponsorRepository: SponsorRepository, activityId: ActivityId) : ValueDB<ActivitySponsorProfile> {
        var sps = Buffer.Buffer<ActivitySponsorProfile>(0);
        for ((relId, ar) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (ar) {
                case (#sponsor sq) { 
                    switch (SponsorRepositories.getSponsor(sponsorCache, sponsorRepository, relId)) {
                        case (?s) { sps.add(assemblyActivitySponsor(sq, s)); };
                        case (_) {};
                    }
                };
                case (_) {};
            }
            
        };

        sps.toArray()
    };

    /// 获取指定黑客松活动的奖项列表
    public func getActivityPrizeByActivityId(cache: ActivityRelCache, repository: ActivityRelRepository, activityId: ActivityId) : ValueDB<ActivityPrize> {
        var aps =  Buffer.Buffer<ActivityPrize>(0);
        for ((relId, ar) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (ar) {
                case (#prize p) { aps.add (p); };
                case (_) {};
            }
        };

        aps.toArray()
    };

    /// 获取指定黑客松活动的奖励列表
    public func getActivityAwardsByActivityId(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId) : ValueDB<ActivityAwards> {
        var aas =  Buffer.Buffer<ActivityAwards>(0);
        for ((relId, ar) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (ar) {
                case (#awards a) { aas.add (a); };
                case (_) {};
            }
        };

        aas.toArray()
    };

    /// 获取指定黑客松活动的奖励
    public func getActivityAwardsByActivityAndAwardsId(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, awardsId: Types.Id) : ?ActivityAwards {
        HashMap.mapFilter<RelId, ActivityRelationship, ActivityAwards>(getRelByActivityId(cache, repository, activityId), relEq, relHash, func (relId, rel) : ?ActivityAwards {
            switch (rel) {
                case (#awards a) ?a;
                case (_) null;
            }
        })
        .get(awardsId)
    };

    /// 获取指定黑客松活动的奖项
    public func getActivityPrizeByActivityAndPrizeId(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, prizeId: Types.Id) : ?ActivityPrize {
        HashMap.mapFilter<RelId, ActivityRelationship, ActivityPrize>(getRelByActivityId(cache, repository, activityId), relEq, relHash, func (relId, rel) : ?ActivityPrize {
            switch (rel) {
                case (#prize p) ?p;
                case (_) null;
            }
        }).get(prizeId)
    };

    /// 获取指定黑客松活动的项目投票情况
    public func getActivityProjectVotedByActivityAndProjectId(cache: ActivityRelCache, repository: ActivityRelRepository, 
        activityId: ActivityId, projectId: Types.Id) : ?ActivityProjectVoted {
        HashMap.mapFilter<RelId, ActivityRelationship, ActivityProjectVoted>(getRelByActivityId(cache, repository, activityId), relEq, relHash, func (relId, rel) : ?ActivityProjectVoted {
            switch (rel) {
                case (#project p) ?p;
                case (_) null;
            }
        }).get(projectId)
    };

    /// 获取指定黑客松活动的项目信息及投票列表
    public func getActivityProjectProfileVotedByAcivityId(cache: ActivityRelCache, repository: ActivityRelRepository, 
        projectCache: ProjectCache, projectRepository: ProjectRepository,
        activityId: ActivityId) : ValueDB<ActivityProjectProfileVoted> {
        var appv = Buffer.Buffer<ActivityProjectProfileVoted>(0);
        for ((relId, ar) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (ar) {
                case (#project pv) { 
                    switch (ProjectRepositories.getProject(projectCache, projectRepository, relId)) {
                        case (?p) { appv.add(assemblyActivityProjectProfileVoted(pv, p)); };
                        case (_) {};
                    }
                };
                case (_) {};
            }
            
        };

        appv.toArray()
    };

    /// 查询指定项目参与的黑客松活动列表
    public func getActivityRelByProjectId(cache: ActivityRelCache, repository: ActivityRelRepository, projectId: Types.Id) : ValueDB<ActivityProjectVoted> {
        var aps =  Buffer.Buffer<ActivityProjectVoted>(0);
        for ((activityId, ars) in cache.entries()) {
            switch (ars.get(projectId)) {
                case (?#project pv) {
                    aps.add(pv)
                };
                case (_) {};
            }
        };

        aps.toArray()
    };

    /// 获取指定项目获得的奖项奖励信息列表
    public func getProjectActivityAwardsViewByProjectId(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        activityRelCache: ActivityRelCache, activityRelRepository: ActivityRelRepository, projectId: ProjectId) : ValueDB<ProjectActivityAwardsView> {
        
        var paavs = Buffer.Buffer<ProjectActivityAwardsView>(0);
        for ((activityId, paapv) in ProjectRepositories.getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId).entries()) {
            for (aid in paapv.awards.vals()) {
                switch (getActivityAwardsByActivityAndAwardsId(activityRelCache, activityRelRepository, activityId, aid)) {
                    case (?aa) {
                        let paav = ProjectDomain.createProjectActivityAwardsView(paapv, aid, aa.name, aa.bonus, aa.ranking);
                        paavs.add(paav);
                    };
                    case (_) {};
                }
            };

            for (pid in paapv.prize.vals()) {
                switch (getActivityPrizeByActivityAndPrizeId(activityRelCache, activityRelRepository, activityId, pid)) {
                    case (?ap) {
                        let paav = ProjectDomain.createProjectActivityAwardsView(paapv, pid, ap.name, ap.bonus, ap.ranking);
                        paavs.add(paav);
                    };
                    case (_) {};
                }
            }
        };

        paavs.toArray()
    };

    /// 获取指定黑客松活动的投票总数
    public func countActivityVotedSum(cache: ActivityRelCache, repository: ActivityRelRepository, activityId: ActivityId) : Nat {
        var votedSum = 0;
        for ((_, rel) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (rel) {
                case (#project v) { 
                    votedSum += v.votedSum;
                };
                case (_) {};
            }
        };

        votedSum
    };

    /// 组装赞助商及活动赞助额度
    public func assemblyActivitySponsor(asq: ActivitySponsorQuota, sp: SponsorProfile) : ActivitySponsorProfile {
        assert( asq.sponsorId == sp.id);
        {
            activityId = asq.activityId;
            sponsorId = asq.sponsorId;
            name = sp.name;
            description = sp.description;
            link = sp.link;
            logoUri = sp.logoUri;
            bonus = asq.bonus;
            status = sp.status;
            createdBy = sp.createdBy;
            createdAt = sp.createdAt;
            updateTime = asq.updateTime;
        }
    };

    /// 组装项目及投票数
    public func assemblyActivityProjectProfileVoted(apv: ActivityProjectVoted, pp: ProjectProfile) : ActivityProjectProfileVoted {
        assert(apv.projectId == pp.id);
        {
            activityId = apv.activityId;
            projectId = apv.projectId;
            name = pp.name;
            information = pp.information;
            logoUri = pp.logoUri;
            creator = pp.creator;
            creatorInfo = pp.creatorInfo;
            wallet = pp.wallet;
            contactInfo = pp.contactInfo;
            startTime = pp.startTime;
            links = pp.links;
            owner = pp.createdBy;
            tags = pp.tags;
            progress = pp.progress;
            votedSum = apv.votedSum;
            participatingTime = apv.participatingTime;
            historyRatio = apv.historyRatio;
            periodRatio = apv.periodRatio;
            minPerProject = apv.minPerProject;
            maxPerProject = apv.maxPerProject;
            maxPerActivity = apv.maxPerActivity;
            status = pp.status;
            createdBy = pp.createdBy;
            createdAt = pp.createdAt;
        }
    };

    /// 黑客松活动投票数,参与项目,参与用户累计,捐赠总额
    public func getActivitySummaryById(cache: ActivityRelCache, repository: ActivityRelRepository,
        recordingCache: RecordingCache, recordingRepository: RecordingRepository, 
        grantCache: GrantCache, grantRepository: GrantRepository, activityId: ActivityId) : ActivitySummary {
        
        var votedSum = 0;
        var projectSum = 0;
        var grantSum = 0;

        for ((relId, ar) in getRelByActivityId(cache, repository, activityId).entries()) {
            switch (ar) {
                case (#project pv) { 
                    votedSum += pv.votedSum;
                    projectSum += 1;
                };
                case (_) {};
            };
            
        };

        var userJoinActivitySet = HashMapRepositories.newHashSet<UserPrincipal>(userEq, userHash);

        for ((_, recording) in recordingCache.entries()) {
            switch (recording.payload) {
                case (#voting v) {
                    if (v.targetId == activityId) {
                        userJoinActivitySet.put(recording.creator, ());
                    };
                };
                case (_) {};
            }
        };      

        var userSum = userJoinActivitySet.size();

        grantSum += GrantRepositories.grantTotalSumByFilter(grantCache, func (gp) : Bool { 
            GrantDomain.isGrantActivity(gp) and gp.grantTarget.targetId == activityId
        });
        
        {
            activityId = activityId;
            votedSum = votedSum;
            projectSum = projectSum;
            userSum = userSum;
            grantSum = grantSum;
        }
    };

};