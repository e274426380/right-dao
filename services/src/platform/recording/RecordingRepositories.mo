
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Order "mo:base/Order";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import RecordingDomain "RecordingDomain";
import Types "../base/Types";

module {

    public type UserPrincipal = RecordingDomain.UserPrincipal;
    public type Timestamp = RecordingDomain.Timestamp;

    public type RecordingId = RecordingDomain.RecordingId;
    public type RecordingProfile = RecordingDomain.RecordingProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;

    public type RecordingPage = PageHelper.Page<RecordingProfile>;
    
    public type RecordingDB = DB<RecordingId, RecordingProfile>;
    public type RecordingCache = Cache<RecordingId, RecordingProfile>;
    public type RecordingRepository = HashMapRepositories.HashMapRepository<RecordingId, RecordingProfile>;

    public let recordingEq = RecordingDomain.recordingEq;
    public let recordingHash = RecordingDomain.recordingHash;

    public func newRecordingDB() : RecordingDB {
        []
    };

    public func newRecordingCache() : RecordingCache {
        HashMapRepositories.newHashMapCache(recordingEq, recordingHash)
    };

    public func newRecordingRepository() : RecordingRepository{
        HashMapRepositories.HashMapRepository<RecordingId, RecordingProfile>()
    };

    public func saveRecording(cache: RecordingCache, repository: RecordingRepository, recordingProfile: RecordingProfile) {
        let _ = updateRecording(cache, repository, recordingProfile);
        ()
    };

    public func updateRecording(cache: RecordingCache, repository: RecordingRepository, recordingProfile: RecordingProfile) : ?RecordingProfile {
        repository.update(cache, recordingProfile.id, recordingProfile)
    };

    public func deleteRecording(cache: RecordingCache, repository: RecordingRepository, recordingId: RecordingId) : ?RecordingProfile {
        repository.delete(cache, recordingId)
    };

    public func getRecording(cache: RecordingCache, repository: RecordingRepository, recordingId: RecordingId) : ?RecordingProfile {
        repository.get(cache, recordingId)
    };

    /// 按过滤条件查询记录
    public func findRecordingBy(cache: RecordingCache, repository: RecordingRepository, filter: (RecordingId, RecordingProfile) -> ?RecordingProfile) : RecordingCache {
        repository.findBy(cache, recordingEq, recordingHash, filter)
    };

    /// 对Recording分页查询
    public func pageRecording(cache: RecordingCache, repository: RecordingRepository, pageSize: Nat, pageNum: Nat,
        filter: (RecordingId, RecordingProfile) -> Bool, sortWith: (RecordingProfile, RecordingProfile) -> Order.Order) : RecordingPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 按记录Creator分页查询
    public func pageRecordingByOwnerAndTime(cache: RecordingCache, repository: RecordingRepository, creator: UserPrincipal, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp,  determineRecordingType: RecordingProfile -> Bool) : RecordingPage {
        pageRecording(cache, repository, pageSize, pageNum, RecordingDomain.isCreatorAndIncludeTime(creator, startTime, endTime, determineRecordingType), sortWith)
    };

    /// 按记录Creator分页查询Comment
    public func pageCommentByOwnerAndTime(cache: RecordingCache, repository: RecordingRepository, creator: UserPrincipal, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : RecordingPage {
        pageRecordingByOwnerAndTime(cache, repository, creator, pageSize, pageNum, sortWith, startTime, endTime, RecordingDomain.isComment)
    };

    /// 按记录Creator分页查询投票
    public func pageVotingByOwnerAndTime(cache: RecordingCache, repository: RecordingRepository, creator: UserPrincipal, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : RecordingPage {
        pageRecordingByOwnerAndTime(cache, repository, creator, pageSize, pageNum, sortWith, startTime, endTime, RecordingDomain.isVoting)
    };

    /// 按记录Creator分页查询申请
    public func pageApplyingByOwnerAndTime(cache: RecordingCache, repository: RecordingRepository, creator: UserPrincipal, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : RecordingPage {
        pageRecordingByOwnerAndTime(cache, repository, creator, pageSize, pageNum, sortWith, startTime, endTime, RecordingDomain.isApplying)
    };

    /// 按项目分页查询评论
    public func pageCommentByProjectId(cache: RecordingCache, repository: RecordingRepository, projectId: Types.Id, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order) : RecordingPage {
        pageRecording(cache, repository, pageSize, pageNum, RecordingDomain.isMatchProjectComment(projectId), sortWith)
    };

    /// 分页查询已删除的项目评论
    public func pageDeletedProjectComment(cache: RecordingCache, repository: RecordingRepository, pageSize: Nat, pageNum: Nat, 
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : RecordingPage {
        pageRecording(cache, repository, pageSize, pageNum, RecordingDomain.isDeletingProjectComment(startTime, endTime), sortWith)
    };
    
    /// 按项目分页查询投票
    public func pageVotingByProjectId(cache: RecordingCache, repository: RecordingRepository, projectId: Types.Id, pageSize: Nat, pageNum: Nat,
        sortWith: (RecordingProfile, RecordingProfile) -> Order.Order) : RecordingPage {
        pageRecording(cache, repository, pageSize, pageNum, RecordingDomain.isMatchProjectVoting(projectId), sortWith)
    };
    
    public func findRecordingByIds(cache: RecordingCache, repository: RecordingRepository, 
        recordingIdSet: HashSet<RecordingId>) : [RecordingProfile] {
        let size = recordingIdSet.size();
        var tempBuffer = Buffer.Buffer<RecordingProfile>(size);

        for ((recordingId, _) in recordingIdSet.entries()) {
            switch (getRecording(cache, repository, recordingId)) {
                case (?r) { tempBuffer.add(r); };
                case (null) { }
            }
        };

        tempBuffer.toArray() 
    };

    public func recordingDBToCache(db: RecordingDB) : RecordingCache {
        HashMapRepositories.dbToCache(db, recordingEq, recordingHash)
    };

    public func recordingCacheToDB(cache: RecordingCache) : RecordingDB {
        HashMapRepositories.cacheToDB(cache)
    };
}