
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Order "mo:base/Order";

import HashMapRepositories "../repositories/HashMapRepositories";
import PageHelper "../base/PageHelper";
import ProjectDomain "ProjectDomain";
import RecordingDomain "../recording/RecordingDomain";
import RecordingRepositories "../recording/RecordingRepositories";
import Types "../base/Types";

module {

    public type UserPrincipal = ProjectDomain.UserPrincipal;
    public type Timestamp = ProjectDomain.Timestamp;
    public type ProjectId = ProjectDomain.ProjectId;
    public type ProjectProfile = ProjectDomain.ProjectProfile;

    public type ActivityId = ProjectDomain.ActivityId;
    public type ProjectActivityAwardsPrizeVoted = ProjectDomain.ProjectActivityAwardsPrizeVoted;
    public type RecordingId = RecordingDomain.RecordingId;
    public type RecordingProfile = RecordingDomain.RecordingProfile;

    public type DB<K, V> = [(K, V)];
    public type ValueDB<K> = [K];
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;
    
    public type ProjectPage = PageHelper.Page<ProjectProfile>;

    public type ProjectDB = DB<ProjectId, ProjectProfile>;
    public type ProjectCache = Cache<ProjectId, ProjectProfile>;
    public type ProjectRepository = HashMapRepositories.HashMapRepository<ProjectId, ProjectProfile>;

    public type RecordingCache = RecordingRepositories.RecordingCache;
    public type RecordingRepository = RecordingRepositories.RecordingRepository;

    public type ProjectRecordingRelDB = DB<ProjectId, ValueDB<RecordingId>>;
    public type ProjectRecordingRelCache = Cache<ProjectId, HashSet<RecordingId>>;
    public type ProjectRecordingRelRepository = HashMapRepositories.HashMapRepository<ProjectId, HashSet<RecordingId>>;

    public type ProjectActivityRelDB = DB<ProjectId, DB<ActivityId, ProjectActivityAwardsPrizeVoted>>;
    public type ProjectActivityRelCache = Cache<ProjectId, Cache<ActivityId, ProjectActivityAwardsPrizeVoted>>;
    public type ProjectActivityRelRepository = HashMapRepositories.HashMapRepository<ProjectId, Cache<ActivityId, ProjectActivityAwardsPrizeVoted>>;

    public let projectEq = ProjectDomain.projectEq;
    public let projectHash = ProjectDomain.projectHash;

    public let commentEq = RecordingDomain.recordingEq;
    public let commentHash = RecordingDomain.recordingHash;

    public let activityEq = Types.idEq;
    public let activityHash = Types.idHash;

    /// Project CRUD
    public func newProjectDB() : ProjectDB {
        []
    };

    public func newProjectCache() : ProjectCache {
        HashMapRepositories.newHashMapCache(projectEq, projectHash)
    };

    public func newProjectRepository() : ProjectRepository{
        HashMapRepositories.HashMapRepository<ProjectId, ProjectProfile>()
    };

    public func saveProject(cache: ProjectCache, repository: ProjectRepository, projectProfile: ProjectProfile) {
        let _ = updateProject(cache, repository, projectProfile);
        ()
    };

    public func updateProject(cache: ProjectCache, repository: ProjectRepository, projectProfile: ProjectProfile) : ?ProjectProfile {
        repository.update(cache, projectProfile.id, projectProfile)
    };

    public func deleteProject(cache: ProjectCache, repository: ProjectRepository, projectId: ProjectId) : ?ProjectProfile {
        repository.delete(cache, projectId)
    };

    public func getProject(cache: ProjectCache, repository: ProjectRepository, projectId: ProjectId) : ?ProjectProfile {
        repository.get(cache, projectId)
    };

    /// 按过滤条件查询项目
    public func findProjectBy(cache: ProjectCache, repository: ProjectRepository, filter: (ProjectId, ProjectProfile) -> ?ProjectProfile) : ProjectCache {
        repository.findBy(cache, projectEq, projectHash, filter)
    };

    public func pageProject(cache: ProjectCache, repository: ProjectRepository, pageSize: Nat, pageNum: Nat,
        filter: (ProjectId, ProjectProfile) -> Bool, sortWith: (ProjectProfile, ProjectProfile) -> Order.Order) : ProjectPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 按项目所有者分页查询项目
    public func pageProjectByOwnerAndTime(cache: ProjectCache, repository: ProjectRepository, owner: UserPrincipal, pageSize: Nat, pageNum: Nat,
        sortWith: (ProjectProfile, ProjectProfile) -> Order.Order, startTime: Timestamp, endTime: Timestamp) : ProjectPage {
        func isOwnerAndIncludeTime(projectId: ProjectId, projectProfile: ProjectProfile) : Bool {
            projectProfile.owner == owner and projectProfile.createdAt >= startTime and projectProfile.createdAt <= endTime
        };

        pageProject(cache, repository, pageSize, pageNum, isOwnerAndIncludeTime, sortWith)

    };

    public func projectDBToCache(db: ProjectDB) : ProjectCache {
        HashMapRepositories.dbToCache(db, projectEq, projectHash)
    };

    public func projectCacheToDB(cache: ProjectCache) : ProjectDB {
        HashMapRepositories.cacheToDB(cache)
    };

    /// Project Recording
    public func newProjectRecordingRelDB() : ProjectRecordingRelDB {
        []
    };

    public func newProjectRecordingRelCache() : ProjectRecordingRelCache {
        HashMapRepositories.newHashMapCache(projectEq, projectHash)
    };
    
    public func newProjectRecordingRelRepository() : ProjectRecordingRelRepository {
        HashMapRepositories.HashMapRepository<ProjectId, HashSet<RecordingId>>()
    };

    public func saveProjectRecordingRel(cache: ProjectRecordingRelCache, repository: ProjectRecordingRelRepository, 
        projectId: ProjectId, commentIdSet: HashSet<RecordingId>) {
        let _ = updateProjectRecordingRel_(cache, repository, projectId, commentIdSet);
        ()
    };

    func updateProjectRecordingRel_(cache: ProjectRecordingRelCache, repository: ProjectRecordingRelRepository, 
        projectId: ProjectId, commentIdSet: HashSet<RecordingId>) : ?HashSet<RecordingId> {
        repository.update(cache, projectId, commentIdSet)
    };

    public func getRecordingByProjectId(cache: ProjectRecordingRelCache, repository: ProjectRecordingRelRepository, projectId: ProjectId) : HashSet<RecordingId> {
        switch (repository.get(cache, projectId)) {
            case (?bs) { bs };
            case (null) { HashMapRepositories.newHashSet<RecordingId>(commentEq, commentHash) };
        }
    };

    public func addProjectRecordingRel(cache: ProjectRecordingRelCache, repository: ProjectRecordingRelRepository, 
        commentCache: RecordingCache, commentRepository: RecordingRepository, 
        projectId: ProjectId, commentId: RecordingId) {
        
        let existedRecordingIds = getRecordingByProjectId(cache, repository, projectId);
        existedRecordingIds.put(commentId, ());
        
        saveProjectRecordingRel(cache, repository, projectId, existedRecordingIds)
    };

    public func removeRecordingFromProjectRel(cache: ProjectRecordingRelCache, repository: ProjectRecordingRelRepository, 
        projectId: ProjectId, commentId: RecordingId) {

        let currentRecordingIdSet = getRecordingByProjectId(cache, repository, projectId);
        if (Option.isSome(currentRecordingIdSet.get(commentId))) {
            currentRecordingIdSet.delete(commentId);
        };
    };

    public func projectRecordingRelCacheToDB(cache: ProjectRecordingRelCache) : ProjectRecordingRelDB {
        HashMapRepositories.hashSetCacheToDB<ProjectId, RecordingId>(cache)
    };

    public func projectRecordingRelDBToCache(db: ProjectRecordingRelDB): ProjectRecordingRelCache {
        HashMapRepositories.dbToHashSetCache<ProjectId, RecordingId>(db, projectEq, projectHash, commentEq, commentHash)
    };

    /// Project Activity Relationship
    public func newProjectActivityRelDB() : ProjectActivityRelDB {
        []
    };

    public func newProjectActivityRelCache() : ProjectActivityRelCache {
        HashMapRepositories.newHashMapCache(projectEq, projectHash)
    };
    
    public func newProjectActivityRelRepository() : ProjectActivityRelRepository {
        HashMapRepositories.HashMapRepository<ActivityId, Cache<ActivityId, ProjectActivityAwardsPrizeVoted>>()
    };

    public func saveProjectActivityRel(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId, projectActivityRels: Cache<ActivityId, ProjectActivityAwardsPrizeVoted>) {
        let _ = updateProjectActivityRel_(cache, repository, projectId, projectActivityRels);
        ()
    };

    func updateProjectActivityRel_(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId, projectActivityRels: Cache<ActivityId, ProjectActivityAwardsPrizeVoted>) : ?Cache<ActivityId, ProjectActivityAwardsPrizeVoted> {
        repository.update(cache, projectId, projectActivityRels)
    };

    public func getActivityAwardsPrizeVotedByProjectId(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId) : Cache<ActivityId, ProjectActivityAwardsPrizeVoted> {
        switch (repository.get(cache, projectId)) {
            case (?papvs) { papvs };
            case (null) { HashMapRepositories.newHashMapCache<ActivityId, ProjectActivityAwardsPrizeVoted>(activityEq, activityHash) };
        }
    };

    // 获取指定项目参与的黑客松活动信息
    public func getActivityAwardsPrizeVotedDBByProjectId(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId) : ValueDB<ProjectActivityAwardsPrizeVoted> {
        var paapvs = Buffer.Buffer<ProjectActivityAwardsPrizeVoted>(0);
        for ((_, paapv) in getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId).entries()) {           
            paapvs.add(paapv);           
        };

        paapvs.toArray()
    };

    public func getProjectActivityAwardsPrizeVoted(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, projectId: ProjectId, activityId: ActivityId) : ?ProjectActivityAwardsPrizeVoted {
        getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId).get(activityId)
    };

    public func findActivityIdsByProjectId(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, projectId: ProjectId) : HashSet<ActivityId> {
        var aIds = HashMapRepositories.newHashSet<ActivityId>(activityEq, activityHash);
        for ((activityId, _) in getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId).entries()) {
            aIds.put(activityId, ());
        };
        aIds      
    };

    public func findActivityIdsDBByProjectId(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, projectId: ProjectId) : ValueDB<ActivityId> {
        var aIds = Buffer.Buffer<ActivityId>(0);
        for ((activityId, _) in getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId).entries()) {
            aIds.add(activityId);
        };
        aIds.toArray()      
    };

    // 获取用户的项目参与的黑客松活动id
    public func findActivityIdsByOwner(cache: ProjectActivityRelCache, user: UserPrincipal) : HashSet<ActivityId> {
        var aIds = HashMapRepositories.newHashSet<ActivityId>(activityEq, activityHash);
        for ((projectId, apas) in cache.entries()) {
            for ((activityId, paapv) in apas.entries()) {
                if (paapv.projectOwner == user) {
                    aIds.put(activityId, ());
                };
            }
        };

       aIds
    };

    // 获取用户的项目参与的黑客松活动信息
    public func findProjectActivityRelDBByOwner(cache: ProjectActivityRelCache, user: UserPrincipal) : ValueDB<ProjectActivityAwardsPrizeVoted> {
        var paapvs = Buffer.Buffer<ProjectActivityAwardsPrizeVoted>(0);
        for ((projectId, apas) in cache.entries()) {
            for ((activityId, paapv) in apas.entries()) {
                if (paapv.projectOwner == user) {
                    paapvs.add(paapv);
                };
            }
        };

        paapvs.toArray()
    };

    public func addProjectActivityAwardsPrizeVotedToProjectActivityRel(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId, activityId: ActivityId, paapv: ProjectActivityAwardsPrizeVoted) {
        
        let existedRels = getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId);
        existedRels.put(activityId, paapv);
        
        saveProjectActivityRel(cache, repository, projectId, existedRels)
    };

    public func removeProjectActivityRelByProjectActivity(cache: ProjectActivityRelCache, repository: ProjectActivityRelRepository, 
        projectId: ProjectId, activityId: ActivityId) {

        let currentRels = getActivityAwardsPrizeVotedByProjectId(cache, repository, projectId);
        
        currentRels.delete(activityId);
       
    };

    public func projectActivityRelCacheToDB(cache: ProjectActivityRelCache) : ProjectActivityRelDB {
        HashMapRepositories.nestedMapToArray<ProjectId, ActivityId, ProjectActivityAwardsPrizeVoted>(cache)
    };

    public func projectActivityRelDBToCache(db: ProjectActivityRelDB): ProjectActivityRelCache {
        HashMapRepositories.nestedArrayToMap<ProjectId, ActivityId, ProjectActivityAwardsPrizeVoted>(db, projectEq, projectHash, activityEq, activityHash)
    };
}