
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Text "mo:base/Text";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import PointDomain "PointDomain";
import Types "../base/Types";
import Utils "../base/Utils";

module {

    public type AirdropPointPlanId = Types.Id;         // 积分记录Id
    public type AirdropPointPlanProfile = PointDomain.AirdropPointPlanProfile;
    public type AirdropPointPlanResultRecord = PointDomain.AirdropPointPlanResultRecord;
    public type TargetId = Types.Id;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;
    public type UserVotingRight = PointDomain.UserVotingRight;

    public type AirdropPointPlanPage = PageHelper.Page<AirdropPointPlanProfile>;
    public type DB<K, V> = [(K, V)];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;

    public type AirdropPointPlanDB = DB<AirdropPointPlanId, AirdropPointPlanProfile>;
    public type AirdropPointPlanCache = Cache<AirdropPointPlanId, AirdropPointPlanProfile>;
    public type AirdropPointPlanRepository = HashMapRepositories.HashMapRepository<AirdropPointPlanId, AirdropPointPlanProfile>;

    public type VotingRightDB = DB<TargetId, DB<UserPrincipal, UserVotingRight>>;   //[(ActivityId, [(UserPrincipal, UserVotingRight)])]
    public type VotingRightCache = Cache<TargetId, Cache<UserPrincipal, UserVotingRight>>;
    public type VotingRightRepository = HashMapRepositories.HashMapRepository<TargetId, Cache<UserPrincipal, UserVotingRight>>;

    public let airdropPointPlanEq = Types.idEq;
    public let airdropPointPlanHash = Types.idHash;
    public let targetEq = Types.idEq;
    public let targetHash = Types.idHash;
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;


    public func newAirdropPointPlanDB() :  AirdropPointPlanDB {
        []
    };

    public func newAirdropPointPlanCache() : AirdropPointPlanCache {
        HashMap.HashMap<AirdropPointPlanId, AirdropPointPlanProfile>(0, airdropPointPlanEq, airdropPointPlanHash)
    };

    public func newAirdropPointPlanRepository() : AirdropPointPlanRepository {
        HashMapRepositories.HashMapRepository<AirdropPointPlanId, AirdropPointPlanProfile>()
    };

    /// AirdropPointPlan CRUD
    public func saveAirdropPointPlan(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, airdropPointPlan: AirdropPointPlanProfile) {
        let _ = updateAirdropPointPlan(cache, repository, airdropPointPlan);
        ()
    };

    public func updateAirdropPointPlan(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, airdropPointPlan: AirdropPointPlanProfile) : ?AirdropPointPlanProfile {
        repository.update(cache, airdropPointPlan.id, airdropPointPlan)
    };

    public func deleteAirdropPointPlan(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, AirdropPointPlanId: AirdropPointPlanId) : ?AirdropPointPlanProfile {
        repository.delete(cache, AirdropPointPlanId)
    };

    public func getAirdropPointPlan(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, AirdropPointPlanId: AirdropPointPlanId) : ?AirdropPointPlanProfile {
        repository.get(cache, AirdropPointPlanId)
    };

    /// 按过滤条件查询活动
    public func findAirdropPointPlanBy(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, filter: (AirdropPointPlanId, AirdropPointPlanProfile) -> ?AirdropPointPlanProfile) : AirdropPointPlanCache {
        repository.findBy(cache, airdropPointPlanEq, airdropPointPlanHash, filter)
    };

    public func pageAirdropPointPlan(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, pageSize: Nat, pageNum: Nat,
        filter: (AirdropPointPlanId, AirdropPointPlanProfile) -> Bool, sortWith: (AirdropPointPlanProfile, AirdropPointPlanProfile) -> Order.Order) : AirdropPointPlanPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 按活动创建时间段分页查询活动
    public func pageAirdropPointPlanByCreateTime(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, pageSize: Nat, pageNum: Nat,
        sortWith: (AirdropPointPlanProfile, AirdropPointPlanProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : AirdropPointPlanPage {
        func isIncludeTime(AirdropPointPlanId: AirdropPointPlanId, airdropPointPlan: AirdropPointPlanProfile) : Bool {
            airdropPointPlan.createdAt >= startTime and airdropPointPlan.createdAt <= endTime
        };

        pageAirdropPointPlan(cache, repository, pageSize, pageNum, isIncludeTime, sortWith)
    };

    public func pageAirdropPointPlanByPrincipalAndExecutedTime(cache: AirdropPointPlanCache, repository: AirdropPointPlanRepository, pageSize: Nat, pageNum: Nat,
        sortWith: (AirdropPointPlanProfile, AirdropPointPlanProfile) -> Order.Order, userStr: Text, startTime: Timestamp, endTime: Timestamp) : AirdropPointPlanPage {
        let filteredCache = fitlerAirdropPointPlanByUserAndExecutedTime(cache, userStr, startTime, endTime);
        pageAirdropPointPlan(filteredCache, repository, pageSize, pageNum, func (id, profile) : Bool { true }, sortWith)
    };
        
    /// 根据principal和executedTime过滤符合条件的空投积分计划
    public func fitlerAirdropPointPlanByUserAndExecutedTime(cache: AirdropPointPlanCache, userStr: Text, 
        startTime: Timestamp, endTime: Timestamp) : AirdropPointPlanCache {
        
        let res = HashMapRepositories.newHashMapCache<AirdropPointPlanId, AirdropPointPlanProfile>(airdropPointPlanEq, airdropPointPlanHash);  

        // 查询条件是否包含principal条件
        let containsPrincipalQ = Utils.isSpaceText(userStr);
        // 查询条件是否包含时间条件
        let containsExecutedTimeQ = endTime > 0;

        for ((id, profile) in cache.entries()) {
            // 查询条件是否包含时间条件
            let executedTimeFilter = if (containsExecutedTimeQ) {
                profile.executedTime >= startTime and profile.executedTime <= endTime
            } else {
                true
            };
            // 如果查询条件满足时间条件
            if (executedTimeFilter) {
                
                if (containsPrincipalQ) {    // principal查询字段为空
                    let filteredProfile = PointDomain.updateAirdropPointPlanWithRecordData(profile, []);
                    res.put(id, filteredProfile);
                } else {     // 如果包含按principal模糊查询,需要把满足的记录保留
                    let recordBuffer = Buffer.Buffer<AirdropPointPlanResultRecord>(0);
                    var hasUser = false;
                    for (d in profile.data.vals()) {
                        if (Text.contains(d.recipient, #text userStr)) {
                            hasUser := true;
                            recordBuffer.add(d)
                        };
                    };

                    let data = recordBuffer.toArray();
                    if (hasUser) {
                        let filteredProfile = PointDomain.updateAirdropPointPlanWithRecordData(profile, data);
                        res.put(id, filteredProfile);
                    };
                };
            }; 
        };

        res

        // HashMap.mapFilter<AirdropPointPlanId, AirdropPointPlanProfile, AirdropPointPlanProfile>(cache, airdropPointPlanEq, airdropPointPlanHash, 
        // func (id, profile) : ?AirdropPointPlanProfile {
        //     let executedTimeFilter = if (endTime > 0) {
        //         profile.executedTime >= startTime and profile.executedTime <= endTime
        //     } else {
        //         true
        //     };

        //     // 如果查询条件满足时间条件
        //     if (executedTimeFilter) {
        //         // 查询条件是否包含principal条件
        //         let containsPrincipalQ = Utils.isSpaceText(userStr);
        //         let data = if (containsPrincipalQ) {    // principal查询字段为空
        //             profile.data
        //         } else {     // 如果包含按principal模糊查询,需要把满足的记录保留
        //             let recordBuffer = Buffer.Buffer<AirdropPointPlanResultRecord>(0);
        //             for (d in profile.data.vals()) {
        //                 if (Text.contains(d.recipient, #text userStr)) {
        //                     recordBuffer.add(d)
        //                 };
        //             };

        //             recordBuffer.toArray()
        //         };
                
        //         if (Utils.arraySize(data) > 0) {
        //             if 
        //             let filteredProfile = {
        //                 id = profile.id;
        //                 title = profile.title;
        //                 description = profile.description;
        //                 pointSum = profile.pointSum;
        //                 recordCount = profile.recordCount;
        //                 successCount = profile.successCount;
        //                 failedCount = profile.failedCount;
        //                 executedTime = profile.executedTime;
        //                 executor = profile.executor;
        //                 status = profile.status;
        //                 createdBy = profile.createdBy;
        //                 createdAt = profile.createdAt;
        //                 data = data;
        //             };
        //             ?filteredProfile
        //         } else {
        //             null
        //         }                
        //     } else {
        //         null
        //     }
        // })
    };

    public func airdropPointPlanDBToCache(db: AirdropPointPlanDB) : AirdropPointPlanCache {
        HashMapRepositories.dbToCache(db, airdropPointPlanEq, airdropPointPlanHash)
    };

    public func airdropPointPlanCacheToDB(cache: AirdropPointPlanCache) : AirdropPointPlanDB {
        HashMapRepositories.cacheToDB(cache)
    };

    /// VotingRight 
    public func newVotingRightDB() : VotingRightDB {
        []
    };

    public func newVotingRightCache() : VotingRightCache {
        HashMapRepositories.newHashMapCache(targetEq, targetHash)
    };
    
    public func newVotingRightRepository() : VotingRightRepository {
        HashMapRepositories.HashMapRepository<TargetId, Cache<UserPrincipal, UserVotingRight>>()
    };

    public func saveVotingRight(cache: VotingRightCache, repository: VotingRightRepository, 
        targetId: TargetId, voteRights: Cache<UserPrincipal, UserVotingRight>) {
        let _ = updateVotingRight_(cache, repository, targetId, voteRights);
        ()
    };

    func updateVotingRight_(cache: VotingRightCache, repository: VotingRightRepository, 
        targetId: TargetId, voteRights: Cache<UserPrincipal, UserVotingRight>) : ?Cache<UserPrincipal, UserVotingRight> {
        repository.update(cache, targetId, voteRights)
    };

    public func getVotingRightByTargetId(cache: VotingRightCache, repository: VotingRightRepository, targetId: TargetId) : Cache<UserPrincipal, UserVotingRight> {
        switch (repository.get(cache, targetId)) {
            case (?bs) { bs };
            case (null) { HashMapRepositories.newHashMapCache<UserPrincipal, UserVotingRight>(userEq, userHash) };
        }
    };

    public func getVotingRightByTargetIdAndUser(cache: VotingRightCache, repository: VotingRightRepository, targetId: TargetId, user: UserPrincipal) : ?UserVotingRight {
        getVotingRightByTargetId(cache, repository, targetId).get(user)
    };

    public func addVotingRight(cache: VotingRightCache, repository: VotingRightRepository, 
        targetId: TargetId, userId: UserPrincipal, votingRight: UserVotingRight) {
        
        let existedRights = getVotingRightByTargetId(cache, repository, targetId);
        existedRights.put(userId, votingRight);
        
        saveVotingRight(cache, repository, targetId, existedRights)
    };

    public func removeVotingRightByTargetAndUser(cache: VotingRightCache, repository: VotingRightRepository, 
        targetId: TargetId, userId: UserPrincipal) {

        let currentUserPrincipalSet = getVotingRightByTargetId(cache, repository, targetId);
        if (Option.isSome(currentUserPrincipalSet.get(userId))) {
            currentUserPrincipalSet.delete(userId);
        };
    };

    public func votingRightCacheToDB(cache: VotingRightCache) : VotingRightDB {
        HashMapRepositories.nestedMapToArray<TargetId, UserPrincipal, UserVotingRight>(cache)
    };

    public func votingRightDBToCache(db: VotingRightDB): VotingRightCache {
        HashMapRepositories.nestedArrayToMap<TargetId, UserPrincipal, UserVotingRight>(db, targetEq, targetHash, userEq, userHash)
    };
}