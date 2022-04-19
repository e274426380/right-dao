
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";

import HashMapRepositories "../repositories/HashMapRepositories";

import BountyDomain "BountyDomain"

module {

    public type UserPrincipal = BountyDomain.UserPrincipal;
    public type BountyId = BountyDomain.BountyId;
    public type BountyProfile = BountyDomain.BountyProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;

    public type BountyDB = DB<BountyId, BountyProfile>;
    public type BountyCache = Cache<BountyId, BountyProfile>;
    public type BountyRepository = HashMapRepositories.HashMapRepository<BountyId, BountyProfile>;

    public let bountyEq = BountyDomain.bountyEq;
    public let bountyHash = BountyDomain.bountyHash;

    public func newBountyDB() : BountyDB {
        []
    };

    public func newBountyCache() : BountyCache {
        HashMapRepositories.newHashMapCache(bountyEq, bountyHash)
    };

    public func newBountyRepository() : BountyRepository{
        HashMapRepositories.HashMapRepository<BountyId, BountyProfile>()
    };

    public func saveBounty(cache: BountyCache, repository: BountyRepository, bountyProfile: BountyProfile) {
        let _ = updateBounty(cache, repository, bountyProfile);
        ()
    };

    public func updateBounty(cache: BountyCache, repository: BountyRepository, bountyProfile: BountyProfile) : ?BountyProfile {
        repository.update(cache, bountyProfile.id, bountyProfile)
    };

    public func deleteBounty(cache: BountyCache, repository: BountyRepository, bountyId: BountyId) : ?BountyProfile {
        repository.delete(cache, bountyId)
    };

    public func getBounty(cache: BountyCache, repository: BountyRepository, bountyId: BountyId) : ?BountyProfile {
        repository.get(cache, bountyId)
    };

    public func findBountyByIds(cache: BountyCache, repository: BountyRepository, 
        bountyIdSet: HashSet<BountyId>) : [BountyProfile] {
        let size = bountyIdSet.size();
        var tempBuffer = Buffer.Buffer<BountyProfile>(size);

        for ((bountyId, _) in bountyIdSet.entries()) {
            switch (getBounty(cache, repository, bountyId)) {
                case (?b) { tempBuffer.add(b); };
                case (null) { }
            }
        };

        tempBuffer.toArray() 
    };

    public func bountyWithOwners(bountyDB: BountyDB) : Cache<BountyId, UserPrincipal> {
        var res = HashMapRepositories.newHashMapCache<BountyId, UserPrincipal>(bountyEq, bountyHash);
        for ((k, v) in bountyDB.vals()) {
            res.put(k, v.owner);
        };
        res
    };

    public func bountyCacheFromDB(db: BountyDB) : BountyCache {
        HashMapRepositories.dbToCache(db, bountyEq, bountyHash)
    };
}