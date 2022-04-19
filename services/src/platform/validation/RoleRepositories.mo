
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import RoleDomain "RoleDomain";
import Types "../base/Types";
import Utils "../base/Utils";

module {

    public type UserPrincipal = RoleDomain.UserPrincipal;
    public type RoleId = RoleDomain.RoleId;
    public type RoleProfile = RoleDomain.RoleProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;
    
    public type RolePage = PageHelper.Page<RoleProfile>;

    public type RoleDB = DB<RoleId, RoleProfile>;
    public type RoleCache = Cache<RoleId, RoleProfile>;
    public type RoleRepository = HashMapRepositories.HashMapRepository<RoleId, RoleProfile>;

    public let roleEq = RoleDomain.roleEq;
    public let roleHash = RoleDomain.roleHash;
    
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;

    public func newRoleDB() : RoleDB {
        []
    };

    public func newRoleCache() : RoleCache {
        HashMapRepositories.newHashMapCache(roleEq, roleHash)
    };

    public func newRoleRepository() : RoleRepository{
        HashMapRepositories.HashMapRepository<RoleId, RoleProfile>()
    };

    public func saveRole(cache: RoleCache, repository: RoleRepository, roleProfile: RoleProfile) {
        let _ = updateRole(cache, repository, roleProfile);
        ()
    };

    public func updateRole(cache: RoleCache, repository: RoleRepository, roleProfile: RoleProfile) : ?RoleProfile {
        repository.update(cache, roleProfile.id, roleProfile)
    };

    public func deleteRole(cache: RoleCache, repository: RoleRepository, roleId: RoleId) : ?RoleProfile {
        repository.delete(cache, roleId)
    };

    public func getRole(cache: RoleCache, repository: RoleRepository, roleId: RoleId) : ?RoleProfile {
        repository.get(cache, roleId)
    };

    public func countRoleTotal(cache: RoleCache, repository: RoleRepository) : Nat {
        repository.countSize(cache)
    };

    public func pageRole(cache: RoleCache, repository: RoleRepository, pageSize: Nat, pageNum: Nat,
        filter: (RoleId, RoleProfile) -> Bool, sortWith: (RoleProfile, RoleProfile) -> Order.Order) : RolePage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func getAllAdminAndOrderByAuthorizationTime(cache: RoleCache, sortWith: (RoleProfile, RoleProfile) -> Order.Order) : [RoleProfile] {
        let buffer = Buffer.Buffer<RoleProfile>(0);
        
        for ((_, profile) in cache.entries()) {
            if  (profile.role == #admin) {
                buffer.add(profile);
            };
        };
 
        Utils.sort<RoleProfile>(buffer.toArray(), sortWith)
    };

    public func getAllAdminPrincipal(cache: RoleCache) : [UserPrincipal] {
        HashMapRepositories.cacheToKeyDB<UserPrincipal, RoleProfile>(cache)
    };

    public func roleDBToCache(db: RoleDB) : RoleCache {
        HashMapRepositories.dbToCache(db, roleEq, roleHash)
    };

    public func roleCacheToDB(cache: RoleCache) : RoleDB {
        HashMapRepositories.cacheToDB(cache)
    };

}