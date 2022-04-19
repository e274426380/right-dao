
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Order "mo:base/Order";


import BlogDomain "BlogDomain";
import HashMapRepositories "../repositories/HashMapRepositories";
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
    public type Cache<K, V> = HashMapRepositories.HashMapCache<K, V>;
    public type HashSet<K> = HashMapRepositories.HashSet<K>;

    // public type BlogStore = DB<BlogId, BlogProfile>;
    public type BlogDB = DB<BlogId, BlogProfile>;
    public type BlogCache = Cache<BlogId, BlogProfile>;
    public type BlogMapRepository = HashMapRepositories.HashMapRepository<BlogId, BlogProfile>;
    // public type AuthorDB = TrieRepositories.TrieDB<AuthorId, AuthorProfile>;
    // public type AuthorRepository = TrieRepositories.TrieRepository<AuthorId, AuthorProfile>;

    // public type BlogDB = TrieRepositories.TrieDB<BlogId, BlogProfile>;
    // public type BlogMapRepository = TrieRepositories.TrieRepository<BlogId, BlogProfile>;

    // public type BlogTitleKeyDB = TrieRepositories.TrieDB<Text, BlogTitleKeyRelation>;
    // public type BlogTitleKeyRepository = TrieRepositories.TrieRepository<Text, BlogTitleKeyRelation>;

    // public type TagDB = TrieRepositories.TrieDB<TagId, TagProfile>;
    // public type TagRepository = TrieRepositories.TrieRepository<TagId, TagProfile>;

    // public type DBKey = TrieRepositories.TrieDBKey<Nat>;
    // public type DBTextKey = TrieRepositories.TrieDBKey<Text>;

    public let authorEq = BlogDomain.authorEq;
    public let blogEq = BlogDomain.blogEq;
    public let blogHash = BlogDomain.blogHash;
    public let blogTitleKeyEq = Text.equal;
    public let tagEq = BlogDomain.tagEq;

    public func newBlogDB() : BlogDB {
        []
    };
    
    public func newBlogCache() : BlogCache {
        HashMapRepositories.newHashMapCache(blogEq, blogHash)
    };

    public func newBlogMapRepository() : BlogMapRepository{
        HashMapRepositories.HashMapRepository<BlogId, BlogProfile>()
    };

    public func saveBlog(cache: BlogCache, repository: BlogMapRepository, blogProfile: BlogProfile) {
        let _ = updateBlog(cache, repository, blogProfile);
        ()
    };

    public func updateBlog(cache: BlogCache, repository: BlogMapRepository, blogProfile: BlogProfile) : ?BlogProfile {
        repository.update(cache, blogProfile.id, blogProfile)
    };

    public func deleteBlog(cache: BlogCache, repository: BlogMapRepository, blogId: BlogId) : ?BlogProfile {
        repository.delete(cache, blogId)
    };

    public func getBlog(cache: BlogCache, repository: BlogMapRepository, blogId: BlogId) : ?BlogProfile {
        repository.get(cache, blogId)
    };

    /// 按过滤条件查询博客
    public func findBlogBy(cache: BlogCache, repository: BlogMapRepository, filter: (BlogId, BlogProfile) -> ?BlogProfile) : BlogCache {
        repository.findBy(cache, blogEq, blogHash, filter)
    };

    /// 按过滤条件查询博客,返回[]
    public func findBlogDBBy(cache: BlogCache, repository: BlogMapRepository, filter: (BlogId, BlogProfile) -> ?BlogProfile) : BlogDB {
        blogCacheToDB(repository.findBy(cache, blogEq, blogHash, filter))
    };

    public func pageBlog(cache: BlogCache, repository: BlogMapRepository, pageSize: Nat, pageNum: Nat,
        filter: (BlogId, BlogProfile) -> Bool, sortWith: (BlogProfile, BlogProfile) -> Order.Order) : BlogPage {
        repository.page(cache, pageSize, pageNum, filter, sortWith)
    };

    public func findBlogByIds(cache: BlogCache, repository: BlogMapRepository, 
        blogIdSet: HashSet<BlogId>) : [BlogProfile] {
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

    public func blogDBToCache(db: BlogDB) : BlogCache {
        HashMapRepositories.dbToCache(db, blogEq, blogHash)
    };

    public func blogCacheToDB(cache: BlogCache) : BlogDB {
        HashMapRepositories.cacheToDB(cache)
    };
}