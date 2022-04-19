import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import GrantDomain "GrantDomain";
import Types "../base/Types"

module {

    public type UserPrincipal = GrantDomain.UserPrincipal;
    public type GrantId = GrantDomain.GrantId;
    public type GrantTargetId = GrantDomain.TargetId;
    public type GrantProfile = GrantDomain.GrantProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;
    
    public type GrantPage = PageHelper.Page<GrantProfile>;

    public type GrantDB = DB<GrantId, GrantProfile>;
    public type GrantCache = Cache<GrantId, GrantProfile>;
    public type GrantRepository = HashMapRepositories.HashMapRepository<GrantId, GrantProfile>;

    // public type GrantTargetUserRelDB = DB<GrantTargetId, ValueDB<GrantId>>;
    // public type GrantTargetUserRelCache = Cache<GrantTargetId, HashSet<UserPrincipal>>;
    // public type GrantTargetUserRelRepository = HashMapRepositories.HashMapRepository<GrantTargetId, HashSet<UserPrincipal>>;

    // public type GrantUserTargetRelDB = DB<UserPrincipal, ValueDB<GrantId>>, 用在权限验证评论项目时,只有捐赠过的人能评论
    // public type GrantUserTargetRelCache = Cache<UserPrincipal, HashSet<GrantTargetId>>;
    // public type GrantUserTargetRelRepository = HashMapRepositories.HashMapRepository<UserPrincipal, HashSet<GrantTargetId>>;

    public let grantEq = GrantDomain.grantEq;
    public let grantHash = GrantDomain.grantHash;

    public let targetEq = GrantDomain.targetEq;
    public let targetHash = GrantDomain.targetHash;
    
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;

    public func newGrantDB() : GrantDB {
        []
    };

    public func newGrantCache() : GrantCache {
        HashMapRepositories.newHashMapCache(grantEq, grantHash)
    };

    public func newGrantRepository() : GrantRepository{
        HashMapRepositories.HashMapRepository<GrantId, GrantProfile>()
    };

    public func saveGrant(cache: GrantCache, repository: GrantRepository, grantProfile: GrantProfile) {
        let _ = updateGrant(cache, repository, grantProfile);
        ()
    };

    public func updateGrant(cache: GrantCache, repository: GrantRepository, grantProfile: GrantProfile) : ?GrantProfile {
        repository.update(cache, grantProfile.id, grantProfile)
    };

    public func deleteGrant(cache: GrantCache, repository: GrantRepository, grantId: GrantId) : ?GrantProfile {
        repository.delete(cache, grantId)
    };

    public func getGrant(cache: GrantCache, repository: GrantRepository, grantId: GrantId) : ?GrantProfile {
        repository.get(cache, grantId)
    };

    public func countGrantTotal(cache: GrantCache, repository: GrantRepository) : Nat {
        repository.countSize(cache)
    };

    public func grantTotalSum(cache: GrantCache) : Nat {
        var sum = 0;
        for ((_, g) in cache.entries()) {
            sum += Nat64.toNat(g.amount)
        };
        
        sum
    };

    public func grantTotalSumByFilter(cache: GrantCache, filter: GrantProfile -> Bool) : Nat {
        var sum = 0;
        for ((_, g) in cache.entries()) {
            if (filter(g)) {
                sum += Nat64.toNat(g.amount)
            };          
        };
        
        sum
    };

    public func grantTotalSumFromDB(grantDB: GrantDB) : Nat {
        Array.foldLeft<(GrantId, GrantProfile), Nat>(grantDB, 0, func (acc, (id, profile)) : Nat { acc + Nat64.toNat(profile.amount) })
    };

    public func pageGrant(cache: GrantCache, repository: GrantRepository, pageSize: Nat, pageNum: Nat,
        filter: (GrantId, GrantProfile) -> Bool, sortWith: (GrantProfile, GrantProfile) -> Order.Order) : GrantPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func pageProjectGrant(cache: GrantCache, repository: GrantRepository, projectId: GrantTargetId, pageSize: Nat, pageNum: Nat,
        filter: (GrantId, GrantProfile) -> Bool, sortWith: (GrantProfile, GrantProfile) -> Order.Order) : GrantPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func grantDBToCache(db: GrantDB) : GrantCache {
        HashMapRepositories.dbToCache(db, grantEq, grantHash)
    };

    public func grantCacheToDB(cache: GrantCache) : GrantDB {
        HashMapRepositories.cacheToDB(cache)
    };

    /// GrantUserTargetRel
    // public func newGrantUserTargetRelCache() : GrantUserTargetRelCache {
    //     HashMapRepositories.newHashMapCache(userEq, userHash)
    // };
    
    // public func newGrantUserTargetRelRepository() : GrantUserTargetRelRepository {
    //     HashMapRepositories.HashMapRepository<UserPrincipal, HashSet<GrantTargetId>>()
    // };

    // public func saveGrantUserTargetRel(cache: GrantUserTargetRelCache, repository: GrantUserTargetRelRepository, 
    //     user: UserPrincipal, grantTargetIdSet: HashSet<GrantTargetId>) {
    //     let _ = updateGrantUserTargetRel_(cache, repository, user, grantTargetIdSet);
    //     ()
    // };

    // func updateGrantUserTargetRel_(cache: GrantUserTargetRelCache, repository: GrantUserTargetRelRepository, 
    //     user: UserPrincipal, grantTargetIdSet: HashSet<GrantTargetId>) : ?HashSet<GrantTargetId> {
    //     repository.update(cache, user, grantTargetIdSet)
    // };

    // public func getProjectByUserPrincipal(cache: GrantUserTargetRelCache, repository: GrantUserTargetRelRepository, user: UserPrincipal) : HashSet<GrantTargetId> {
    //     switch (repository.get(cache, user)) {
    //         case (?bs) { bs };
    //         case (null) { HashMapRepositories.newHashSet<GrantTargetId>(targetEq, targetHash) };
    //     }
    // };

    // public func addGrantUserTargetRel(cache: GrantUserTargetRelCache, repository: GrantUserTargetRelRepository, 
    //     user: UserPrincipal, grantTargetId: GrantTargetId) {

    //     let existedGrantTargetIds = getProjectByUserPrincipal(cache, repository, user);
    //     existedGrantTargetIds.put(grantTargetId, ());
    //     saveGrantUserTargetRel(cache, repository, user, existedGrantTargetIds)
    // };

    // /// 把Grant数据中的记录反转为UserPrincipal -> HashSet<GrantTargetId, ()>
    // public func grantDBToUserTargetRelCache(db: GrantDB) : GrantUserTargetRelCache {
    //     let cache = newGrantUserTargetRelCache();
    //     for ((_, gp) in db.vals()) {
    //         let targetId = gp.grantTarget.targetId;
    //         let user = gp.owner;
    //         let targetIdSet = switch (cache.get(user)) {
    //             case (?ids) { ids };
    //             case (null) { HashMapRepositories.newHashSet<GrantTargetId>(targetEq, targetHash) }
    //         };
    //         targetIdSet.put(targetId, ());
    //         cache.put(user, targetIdSet);
    //     };

    //     cache
    // };
}