
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import TrieMap "mo:base/TrieMap";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Order "mo:base/Order";


import BlogDomain "BlogDomain";
import TrieMapRepositories "../repositories/TrieMapRepositories";
import PageHelper "../base/PageHelper";

module {

    public type AuthorId = BlogDomain.AuthorId;
    public type AuthorProfile = BlogDomain.AuthorProfile;
    public type AuthorPage = PageHelper.Page<AuthorProfile>;

    public type TagId = BlogDomain.TagId;
    public type TagProfile = BlogDomain.TagProfile;
    public type TagPage = PageHelper.Page<TagProfile>;

    public type BlogId = BlogDomain.BlogId;
    public type BlogProfile = BlogDomain.BlogProfile;
    public type BlogTitleKeyRelation = BlogDomain.BlogTitleKeyRelation;
    public type BlogPage = PageHelper.Page<BlogProfile>;

    public type UserPrincipal = BlogDomain.UserPrincipal;

    public type DB<K, V> = [(K, V)];
    public type Cache<K, V> = TrieMapRepositories.TrieMapCache<K, V>;
    public type Set<K> = TrieMapRepositories.Set<K>;

    public type AuthorDB = DB<AuthorId, AuthorProfile>;
    public type AuthorCache = Cache<BlogId, AuthorProfile>;
    public type AuthorTrieMapRepository = TrieMapRepositories.TrieMapRepository<AuthorId, AuthorProfile>;

    public type BlogDB = DB<BlogId, BlogProfile>;
    public type BlogCache = Cache<BlogId, BlogProfile>;
    public type BlogTrieMapRepository = TrieMapRepositories.TrieMapRepository<BlogId, BlogProfile>;

    public type BlogTitleKeyDB = DB<Text, BlogTitleKeyRelation>;
    public type BlogTitleKeyCache = Cache<Text, BlogTitleKeyRelation>;
    public type BlogTitleKeyTrieMapRepository = TrieMapRepositories.TrieMapRepository<Text, BlogTitleKeyRelation>;

    public type TagDB = DB<TagId, TagProfile>;
    public type TagCache = Cache<TagId, TagProfile>;
    public type TagTrieMapRepository = TrieMapRepositories.TrieMapRepository<TagId, TagProfile>;

    // public type AuthorDB = TrieRepositories.TrieDB<AuthorId, AuthorProfile>;
    // public type AuthorRepository = TrieRepositories.TrieRepository<AuthorId, AuthorProfile>;

    // public type BlogTitleKeyDB = TrieRepositories.TrieDB<Text, BlogTitleKeyRelation>;
    // public type BlogTitleKeyRepository = TrieRepositories.TrieRepository<Text, BlogTitleKeyRelation>;

    // public type TagDB = TrieRepositories.TrieDB<TagId, TagProfile>;
    // public type TagRepository = TrieRepositories.TrieRepository<TagId, TagProfile>;

    // public type DBKey = TrieRepositories.TrieDBKey<Nat>;
    // public type DBTextKey = TrieRepositories.TrieDBKey<Text>;

    public let authorEq = BlogDomain.authorEq;
    public let authorHash = BlogDomain.blogHash;
    public let blogEq = BlogDomain.blogEq;
    public let blogHash = BlogDomain.blogHash;
    public let blogTitleKeyEq = Text.equal;
    public let blogTitleKeyHash = Text.hash;
    public let tagEq = BlogDomain.tagEq;
    public let tagHash = BlogDomain.tagHash;

    // Author
    public func newAuthorDB() : AuthorDB {
        []
    };
    
    public func newAuthorCache() : AuthorCache {
        TrieMapRepositories.newTrieMapCache(authorEq, authorHash)
    };

    public func newAuthorTrieMapRepository() : AuthorTrieMapRepository{
        TrieMapRepositories.TrieMapRepository<AuthorId, AuthorProfile>()
    };

    public func saveAuthor(cache: AuthorCache, repository: AuthorTrieMapRepository, authorProfile: AuthorProfile) {
        let _ = updateAuthor(cache, repository, authorProfile);
        ()
    };

    public func updateAuthor(cache: AuthorCache, repository: AuthorTrieMapRepository, authorProfile: AuthorProfile) : ?AuthorProfile {
        repository.update(cache, authorProfile.id, authorProfile)
    };

    public func deleteAuthor(cache: AuthorCache, repository: AuthorTrieMapRepository, authorId: AuthorId) : ?AuthorProfile {
        repository.delete(cache, authorId)
    };

    public func getAuthor(cache: AuthorCache, repository: AuthorTrieMapRepository, authorId: AuthorId) : ?AuthorProfile {
        repository.get(cache, authorId)
    };

    /// 按过滤条件查询博客
    public func findAuthorBy(cache: AuthorCache, repository: AuthorTrieMapRepository, filter: (AuthorId, AuthorProfile) -> ?AuthorProfile) : AuthorCache {
        repository.findBy(cache, authorEq, authorHash, filter)
    };

    /// 按过滤条件查询博客,返回[]
    public func findAuthorDBBy(cache: AuthorCache, repository: AuthorTrieMapRepository, filter: (AuthorId, AuthorProfile) -> ?AuthorProfile) : AuthorDB {
        authorCacheToDB(repository.findBy(cache, authorEq, authorHash, filter))
    };

    public func pageAuthor(cache: AuthorCache, repository: AuthorTrieMapRepository, pageSize: Nat, pageNum: Nat,
        filter: (AuthorId, AuthorProfile) -> Bool, sortWith: (AuthorProfile, AuthorProfile) -> Order.Order) : AuthorPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func authorDBToCache(db: AuthorDB) : AuthorCache {
        TrieMapRepositories.dbToCache(db, authorEq, authorHash)
    };

    public func authorCacheToDB(cache: AuthorCache) : AuthorDB {
        TrieMapRepositories.cacheToDB(cache)
    };

    // Blog 
    public func newBlogDB() : BlogDB {
        []
    };
    
    public func newBlogCache() : BlogCache {
        TrieMapRepositories.newTrieMapCache(blogEq, blogHash)
    };

    public func newBlogTrieMapRepository() : BlogTrieMapRepository{
        TrieMapRepositories.TrieMapRepository<BlogId, BlogProfile>()
    };

    public func saveBlog(cache: BlogCache, repository: BlogTrieMapRepository, blogProfile: BlogProfile) {
        let _ = updateBlog(cache, repository, blogProfile);
        ()
    };

    public func updateBlog(cache: BlogCache, repository: BlogTrieMapRepository, blogProfile: BlogProfile) : ?BlogProfile {
        repository.update(cache, blogProfile.id, blogProfile)
    };

    public func deleteBlog(cache: BlogCache, repository: BlogTrieMapRepository, blogId: BlogId) : ?BlogProfile {
        repository.delete(cache, blogId)
    };

    public func getBlog(cache: BlogCache, repository: BlogTrieMapRepository, blogId: BlogId) : ?BlogProfile {
        repository.get(cache, blogId)
    };

    /// 按过滤条件查询博客
    public func findBlogBy(cache: BlogCache, repository: BlogTrieMapRepository, filter: (BlogId, BlogProfile) -> ?BlogProfile) : BlogCache {
        repository.findBy(cache, blogEq, blogHash, filter)
    };

    /// 按过滤条件查询博客,返回[]
    public func findBlogDBBy(cache: BlogCache, repository: BlogTrieMapRepository, filter: (BlogId, BlogProfile) -> ?BlogProfile) : BlogDB {
        blogCacheToDB(repository.findBy(cache, blogEq, blogHash, filter))
    };

    public func pageBlog(cache: BlogCache, repository: BlogTrieMapRepository, pageSize: Nat, pageNum: Nat,
        filter: (BlogId, BlogProfile) -> Bool, sortWith: (BlogProfile, BlogProfile) -> Order.Order) : BlogPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func findBlogByIds(cache: BlogCache, repository: BlogTrieMapRepository, 
        blogIdSet: Set<BlogId>) : [BlogProfile] {
        let size = blogIdSet.size();
        var tempBuffer = Buffer.Buffer<BlogProfile>(size);

        for ((blogId, _) in blogIdSet.entries()) {
            switch (getBlog(cache, repository, blogId)) {
                case (?b) { tempBuffer.add(b); };
                case (null) { }
            }
        };

        tempBuffer.toArray() 
    };

    /// 总博客数
    public func countBlogTotal(cache : BlogCache) :  Nat {
        cache.size()
    };

    public func blogDBToCache(db: BlogDB) : BlogCache {
        TrieMapRepositories.dbToCache(db, blogEq, blogHash)
    };

    public func blogCacheToDB(cache: BlogCache) : BlogDB {
        TrieMapRepositories.cacheToDB(cache)
    };

    /// BlogTitleKeyDB
    public func newBlogTitleKeyDB() : BlogTitleKeyDB {
        []
    };

    public func newBlogTitleKeyCache() : BlogTitleKeyCache {
        TrieMapRepositories.newTrieMapCache(blogTitleKeyEq, blogTitleKeyHash)
    };

    public func newBlogTitleKeyTrieMapRepository() : BlogTitleKeyTrieMapRepository{
        TrieMapRepositories.TrieMapRepository<Text, BlogTitleKeyRelation>()
    };

    public func updateBlogTitleKey(cache: BlogTitleKeyCache, repository: BlogTitleKeyTrieMapRepository, profile: BlogTitleKeyRelation) : ?BlogTitleKeyRelation {
        repository.update(cache, profile.titleKey, profile)
    };

    public func saveBlogTitleKey(cache: BlogTitleKeyCache, repository: BlogTitleKeyTrieMapRepository, profile: BlogTitleKeyRelation) {
        let _ = updateBlogTitleKey(cache, repository, profile);
        ()
    };

    /// 删除指定TitleKey的Blog
    /// Args:
    ///     |db|    博客数据存储
    ///     |titleKey| 被删除的博客TitleKey
    /// Returns:
    ///     删除指定博客后的数据存储
    public func deleteBlogTitleKeyRelation(cache: BlogTitleKeyCache, repository: BlogTitleKeyTrieMapRepository, titleKey: Text) : ?BlogTitleKeyRelation {
        repository.delete(cache, titleKey);
    };

    /// 获取指定的Blog Relation
    public func getBlogTitleKeyRelation(cache: BlogTitleKeyCache, repository: BlogTitleKeyTrieMapRepository, titleKey: Text) : ?BlogTitleKeyRelation {
        repository.get(cache, titleKey)
    };

    /// 获取指定TitleKey的Blog
    public func getBlogByTitleKey(cache: BlogCache, repository: BlogTrieMapRepository, relCache: BlogTitleKeyCache, 
        relRepository: BlogTitleKeyTrieMapRepository, titleKey: Text) : ?BlogProfile {
        Option.chain<BlogTitleKeyRelation, BlogProfile>(
            getBlogTitleKeyRelation(relCache, relRepository, titleKey), 
            func (r) : ?BlogProfile { getBlog(cache, repository, r.id) }
        )
    };

    public func blogTitleKeyDBToCache(db: BlogTitleKeyDB) : BlogTitleKeyCache {
        TrieMapRepositories.dbToCache<Text, BlogTitleKeyRelation>(db, blogTitleKeyEq, blogTitleKeyHash)
    };

    public func blogTitleKeyCacheToDB(cache: BlogTitleKeyCache) : BlogTitleKeyDB {
        TrieMapRepositories.cacheToDB(cache)
    };

    // Tag
    public func newTagDB() : TagDB {
        []
    };
    
    public func newTagCache() : TagCache {
        TrieMapRepositories.newTrieMapCache(tagEq, tagHash)
    };

    public func newTagTrieMapRepository() : TagTrieMapRepository{
        TrieMapRepositories.TrieMapRepository<TagId, TagProfile>()
    };

    public func saveTag(cache: TagCache, repository: TagTrieMapRepository, tagProfile: TagProfile) {
        let _ = updateTag(cache, repository, tagProfile);
        ()
    };

    public func updateTag(cache: TagCache, repository: TagTrieMapRepository, tagProfile: TagProfile) : ?TagProfile {
        repository.update(cache, tagProfile.id, tagProfile)
    };

    public func deleteTag(cache: TagCache, repository: TagTrieMapRepository, tagId: TagId) : ?TagProfile {
        repository.delete(cache, tagId)
    };

    public func getTag(cache: TagCache, repository: TagTrieMapRepository, tagId: TagId) : ?TagProfile {
        repository.get(cache, tagId)
    };

    /// 按过滤条件查询博客标签
    public func findTagBy(cache: TagCache, repository: TagTrieMapRepository, filter: (TagId, TagProfile) -> ?TagProfile) : TagCache {
        repository.findBy(cache, tagEq, tagHash, filter)
    };

    /// 查询精确匹配标签名字的标签
    public func findTagByTagName(cache: TagCache, repository: TagTrieMapRepository, tagName: Text) : TagCache {
        findTagBy(cache, repository, func (id, profile) : ?TagProfile {
            if (profile.tag == tagName) ? profile else null
        })
    };

    /// 按过滤条件查询博客,返回[]
    public func findTagDBBy(cache: TagCache, repository: TagTrieMapRepository, filter: (TagId, TagProfile) -> ?TagProfile) : TagDB {
        tagCacheToDB(repository.findBy(cache, tagEq, tagHash, filter))
    };

    public func pageTag(cache: TagCache, repository: TagTrieMapRepository, pageSize: Nat, pageNum: Nat,
        filter: (TagId, TagProfile) -> Bool, sortWith: (TagProfile, TagProfile) -> Order.Order) : TagPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    /// 总标签数
    public func countTagTotal(cache : TagCache) :  Nat {
        // TrieMap.size<TagId, TagProfile>(cache)
        cache.size()
    };

    public func tagDBToCache(db: TagDB) : TagCache {
        TrieMapRepositories.dbToCache(db, tagEq, tagHash)
    };

    public func tagCacheToDB(cache: TagCache) : TagDB {
        TrieMapRepositories.cacheToDB(cache)
    };
}