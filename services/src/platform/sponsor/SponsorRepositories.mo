
import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import SponsorDomain "SponsorDomain";
import Types "../base/Types"

module {

    public type UserPrincipal = SponsorDomain.UserPrincipal;
    public type SponsorId = SponsorDomain.SponsorId;
    public type SponsorProfile = SponsorDomain.SponsorProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;
    
    public type SponsorPage = PageHelper.Page<SponsorProfile>;

    public type SponsorDB = DB<SponsorId, SponsorProfile>;
    public type SponsorCache = Cache<SponsorId, SponsorProfile>;
    public type SponsorRepository = HashMapRepositories.HashMapRepository<SponsorId, SponsorProfile>;

    public let sponsorEq = SponsorDomain.sponsorEq;
    public let sponsorHash = SponsorDomain.sponsorHash;
    
    public let userEq = Types.userEq;
    public let userHash = Types.userHash;

    public func newSponsorDB() : SponsorDB {
        []
    };

    public func newSponsorCache() : SponsorCache {
        HashMapRepositories.newHashMapCache(sponsorEq, sponsorHash)
    };

    public func newSponsorRepository() : SponsorRepository{
        HashMapRepositories.HashMapRepository<SponsorId, SponsorProfile>()
    };

    public func saveSponsor(cache: SponsorCache, repository: SponsorRepository, sponsorProfile: SponsorProfile) {
        let _ = updateSponsor(cache, repository, sponsorProfile);
        ()
    };

    public func updateSponsor(cache: SponsorCache, repository: SponsorRepository, sponsorProfile: SponsorProfile) : ?SponsorProfile {
        repository.update(cache, sponsorProfile.id, sponsorProfile)
    };

    public func deleteSponsor(cache: SponsorCache, repository: SponsorRepository, sponsorId: SponsorId) : ?SponsorProfile {
        repository.delete(cache, sponsorId)
    };

    public func getSponsor(cache: SponsorCache, repository: SponsorRepository, sponsorId: SponsorId) : ?SponsorProfile {
        repository.get(cache, sponsorId)
    };

    public func countSponsorTotal(cache: SponsorCache, repository: SponsorRepository) : Nat {
        repository.countSize(cache)
    };

    public func pageSponsor(cache: SponsorCache, repository: SponsorRepository, pageSize: Nat, pageNum: Nat,
        filter: (SponsorId, SponsorProfile) -> Bool, sortWith: (SponsorProfile, SponsorProfile) -> Order.Order) : SponsorPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func sponsorDBToCache(db: SponsorDB) : SponsorCache {
        HashMapRepositories.dbToCache(db, sponsorEq, sponsorHash)
    };

    public func sponsorCacheToDB(cache: SponsorCache) : SponsorDB {
        HashMapRepositories.cacheToDB(cache)
    };

}