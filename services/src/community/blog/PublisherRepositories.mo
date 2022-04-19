
import Buffer "mo:base/Buffer";
import TrieMap "mo:base/TrieMap";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";

import TrieMapRepositories "../repositories/TrieMapRepositories";
import PageHelper "../base/PageHelper";
import PublisherDomain "PublisherDomain";
import Types "../base/Types";
import Utils "../base/Utils";

module {

    public type UserPrincipal = PublisherDomain.UserPrincipal;
    public type PublisherId = UserPrincipal;
    public type PublisherProfile = PublisherDomain.PublisherProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = TrieMapRepositories.TrieMapCache<K, V>;
    
    public type PublisherPage = PageHelper.Page<PublisherProfile>;

    public type PublisherDB = DB<PublisherId, PublisherProfile>;
    public type PublisherCache = Cache<PublisherId, PublisherProfile>;
    public type PublisherRepository = TrieMapRepositories.TrieMapRepository<PublisherId, PublisherProfile>;

    public let userEq = Types.userEq;
    public let userHash = Types.userHash;
    public let publisherEq = userEq;
    public let publisherHash = userHash;

    public func newPublisherDB() : PublisherDB {
        []
    };

    public func newPublisherCache() : PublisherCache {
        TrieMapRepositories.newTrieMapCache(publisherEq, publisherHash)
    };

    public func newPublisherRepository() : PublisherRepository{
        TrieMapRepositories.TrieMapRepository<PublisherId, PublisherProfile>()
    };

    public func savePublisher(cache: PublisherCache, repository: PublisherRepository, publisherProfile: PublisherProfile) {
        let _ = updatePublisher(cache, repository, publisherProfile);
        ()
    };

    public func updatePublisher(cache: PublisherCache, repository: PublisherRepository, publisherProfile: PublisherProfile) : ?PublisherProfile {
        repository.update(cache, publisherProfile.id, publisherProfile)
    };

    public func deletePublisher(cache: PublisherCache, repository: PublisherRepository, publisherId: PublisherId) : ?PublisherProfile {
        repository.delete(cache, publisherId)
    };

    public func getPublisher(cache: PublisherCache, repository: PublisherRepository, publisherId: PublisherId) : ?PublisherProfile {
        repository.get(cache, publisherId)
    };

    public func countPublisherTotal(cache: PublisherCache, repository: PublisherRepository) : Nat {
        repository.countSize(cache)
    };

    public func pagePublisher(cache: PublisherCache, repository: PublisherRepository, pageSize: Nat, pageNum: Nat,
        filter: (PublisherId, PublisherProfile) -> Bool, sortWith: (PublisherProfile, PublisherProfile) -> Order.Order) : PublisherPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func getAllPublishersOrderByAuthorizationTime(cache: PublisherCache, sortWith: (PublisherProfile, PublisherProfile) -> Order.Order) : [PublisherProfile] {
        let buffer = Buffer.Buffer<PublisherProfile>(cache.size());
        
        for ((_, profile) in cache.entries()) {
            buffer.add(profile);
        };
 
        Utils.sort<PublisherProfile>(buffer.toArray(), sortWith)
    };

    public func publisherDBToCache(db: PublisherDB) : PublisherCache {
        TrieMapRepositories.dbToCache(db, publisherEq, publisherHash)
    };

    public func publisherCacheToDB(cache: PublisherCache) : PublisherDB {
        TrieMapRepositories.cacheToDB(cache)
    };

}