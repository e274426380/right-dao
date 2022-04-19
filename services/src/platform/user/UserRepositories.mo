

import Order "mo:base/Order";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import UserDomain "./UserDomain";
import Utils "../base/Utils";

module {

    public type UserPrincipal = UserDomain.UserPrincipal;
    public type UserProfile = UserDomain.UserProfile;
    public type UserBehaviourSummary = UserDomain.UserBehaviourSummary;

    public type DB<K, V> = HashMapRepositories.DB<K, V>;
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    
    public type UserPage = PageHelper.Page<UserProfile>;
    public type UserDB = DB<UserPrincipal, UserProfile>;
    public type UserCache = Cache<UserPrincipal, UserProfile>;
    public type UserRepository = HashMapRepositories.HashMapRepository<UserPrincipal, UserProfile>;

    public type UserBehaviourSummaryDB = DB<UserPrincipal, UserBehaviourSummary>;
    public type UserBehaviourSummaryCache = Cache<UserPrincipal, UserBehaviourSummary>;
    public type UserBehaviourSummaryRepository = HashMapRepositories.HashMapRepository<UserPrincipal, UserBehaviourSummary>;

    let userEq = UserDomain.userEq;
    let userHash = UserDomain.userHash;

    public func newUserDB() : UserDB {
        HashMapRepositories.newDB<UserPrincipal, UserProfile>()
    };

    public func newUserCache() : UserCache {
        HashMapRepositories.newHashMapCache(userEq, userHash)
    };

    public func newUserRepository() : UserRepository{
        HashMapRepositories.HashMapRepository<UserPrincipal, UserProfile>()
    };

    public func newUserBehaviourSummaryDB() : UserBehaviourSummaryDB {
        HashMapRepositories.newDB<UserPrincipal, UserBehaviourSummary>()
    };

    public func newUserBehaviourSummaryCache() : UserBehaviourSummaryCache {
        HashMapRepositories.newHashMapCache(userEq, userHash)
    };

    public func newUserBehaviourSummaryRepository() : UserBehaviourSummaryRepository{
        HashMapRepositories.HashMapRepository<UserPrincipal, UserBehaviourSummary>()
    };

    /// 删除指定的用户
    /// Args:
    ///     |userDB|    用户数据源
    ///     |keyOfUser| 被删除的用户主键
    /// Returns:
    ///     删除指定用户的用户数据源与删除的用户数据组成的元组,如果指定的用户不存在数据源中存,该值为null
    public func deleteUser(cache: UserCache, repository: UserRepository, keyOfUser: UserPrincipal) : ?UserProfile {
        repository.delete(cache, keyOfUser)
    };

    /// 查询指定用户名的用户信息
    public func findOneUserByName(cache: UserCache, repository: UserRepository, username: Text) : ?(UserPrincipal, UserProfile) {
        let users = repository.findBy<UserProfile>(cache, userEq, userHash, func (uid: UserPrincipal, up : UserProfile): ?UserProfile { 
            if (up.username == username) { ?up } else { null }
        });
        users.entries().next()        
    };

    /// 获取的指定用户的信息
    public func getUser(cache : UserCache, repository: UserRepository, owner: UserPrincipal) : ?UserProfile {
        repository.get(cache, owner)
    };

    public func pageUser(cache: UserCache, repository: UserRepository, pageSize: Nat, pageNum: Nat,
        filter: (UserPrincipal, UserProfile) -> Bool, sortWith: (UserProfile, UserProfile) -> Order.Order) : UserPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 更新指定用户的信息
    public func updateUser(cache: UserCache, repository: UserRepository, userProfile: UserProfile): ?UserProfile {
        repository.update(cache, userProfile.owner, userProfile)
    };

    /// 总用户数
    public func countUserTotal(cache : UserCache, repository: UserRepository) :  Nat {
        repository.countSize(cache)
    };

    /// 用户缓存转换为用户持久数据
    public func userCacheToDB(userCache: UserCache) : [(UserPrincipal, UserProfile)] {
        HashMapRepositories.cacheToDB<UserPrincipal, UserProfile>(userCache)
    };

    /// 获取所有用户的UserPrincipal
    // public func allUserPrincipals(userDB: UserDB) : [UserPrincipal] {
    //     Trie.toArray<UserPrincipal, UserProfile, UserPrincipal>(userDB, func (k: UserPrincipal, _) : UserPrincipal { k })
    // };

    public func userDBToCache(userDB: UserDB) : UserCache {
        var cache = HashMapRepositories.newHashMapCache<UserPrincipal, UserProfile>(userEq, userHash);
        for ((k, v) in userDB.vals()) {
            cache.put(k, v);
        };
        cache
    };

    /// UserBehaviourSummary 
    /// 删除指定的用户行为数据汇总
    public func deleteUserBehaviourSummary(cache: UserBehaviourSummaryCache, repository: UserBehaviourSummaryRepository, keyOfUser: UserPrincipal) : ?UserBehaviourSummary {
        repository.delete(cache, keyOfUser)
    };

    /// 获取的指定用户行为数据汇总
    public func getUserBehaviourSummary(cache : UserBehaviourSummaryCache, repository: UserBehaviourSummaryRepository, owner: UserPrincipal) : ?UserBehaviourSummary {
        repository.get(cache, owner)
    };

    /// 更新指定用户行为数据汇总
    public func updateUserBehaviourSummary(cache: UserBehaviourSummaryCache, repository: UserBehaviourSummaryRepository, userBehaviourSummary: UserBehaviourSummary): ?UserBehaviourSummary {
        repository.update(cache, userBehaviourSummary.owner, userBehaviourSummary)
    };

    /// 保存指定用户行为数据汇总
    public func saveUserBehaviourSummary(cache: UserBehaviourSummaryCache, repository: UserBehaviourSummaryRepository, userBehaviourSummary: UserBehaviourSummary) {
        let _ = repository.update(cache, userBehaviourSummary.owner, userBehaviourSummary);
        ()
    };

    public func userBehaviourSummaryCacheToDB(cache: UserBehaviourSummaryCache) : [(UserPrincipal, UserBehaviourSummary)] {
        HashMapRepositories.cacheToDB<UserPrincipal, UserBehaviourSummary>(cache)
    };

    public func userBehaviourSummaryDBToCache(db: UserBehaviourSummaryDB) : UserBehaviourSummaryCache {
        var cache = HashMapRepositories.newHashMapCache<UserPrincipal, UserBehaviourSummary>(userEq, userHash);
        for ((k, v) in db.vals()) {
            cache.put(k, v);
        };
        cache
    };
}