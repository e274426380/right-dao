
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

import BlogDomain "./BlogDomain";
import PageHelper "../base/PageHelper";

import TrieRepositories "../repositories/TrieRepositories";

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

    public type AuthorDB = TrieRepositories.TrieDB<AuthorId, AuthorProfile>;
    public type AuthorRepository = TrieRepositories.TrieRepository<AuthorId, AuthorProfile>;

    public type BlogDB = TrieRepositories.TrieDB<BlogId, BlogProfile>;
    public type BlogRepository = TrieRepositories.TrieRepository<BlogId, BlogProfile>;

    public type BlogTitleKeyDB = TrieRepositories.TrieDB<Text, BlogTitleKeyRelation>;
    public type BlogTitleKeyRepository = TrieRepositories.TrieRepository<Text, BlogTitleKeyRelation>;

    public type TagDB = TrieRepositories.TrieDB<TagId, TagProfile>;
    public type TagRepository = TrieRepositories.TrieRepository<TagId, TagProfile>;

    public type DBKey = TrieRepositories.TrieDBKey<Nat>;
    public type DBTextKey = TrieRepositories.TrieDBKey<Text>;

    public let authorEq = BlogDomain.authorEq;
    public let blogEq = BlogDomain.blogEq;
    public let blogTitleKeyEq = Text.equal;
    public let tagEq = BlogDomain.tagEq;

    /// 辅助方法，Nat 为 Key 的 Trie.Key 实例
    public func dbKey(k: Nat): DBKey {
        { key = k; hash = Hash.hash(k) }
    };

    /// 辅助方法，Text 为 Key 的 Trie.Key 实例
    public func dbTextKey(k: Text): DBTextKey {
        { key = k; hash = Text.hash(k) }
    };

    /// 新建博客作者数据存储
    public func newAuthorDB() : AuthorDB {
        Trie.empty<AuthorId, AuthorProfile>()
    };

    /// 新建博客作者数据访问对象
    public func newAuthorRepository() : AuthorRepository {
        TrieRepositories.TrieRepository<AuthorId, AuthorProfile>()
    };

    /// 保存Author
    public func saveAuthor(db: AuthorDB, repository: AuthorRepository, profile: AuthorProfile) : AuthorDB {
        let newDB = repository.update(db, profile, dbKey(profile.id), authorEq).0;
        newDB
    };

    /// 删除指定的Author
    /// Args:
    ///     |db|    作者数据源
    ///     |authorId| 被删除的作者主键
    /// Returns:
    ///     删除指定作者后的数据存储
    public func deleteAuthor(db: AuthorDB, repository: AuthorRepository, authorId: AuthorId) : AuthorDB {
        repository.delete(db, dbKey(authorId), authorEq)
    };

    /// 分页查询Author
    public func pageAuthor(db: AuthorDB, repository: AuthorRepository, 
        pageSize: Nat, pageNum: Nat, 
        filter: (AuthorId, AuthorProfile) -> Bool, 
        sortWith: (AuthorProfile, AuthorProfile) -> Order.Order) : AuthorPage {
        repository.page(db, pageSize, pageNum, filter, sortWith)
    };

    /// 总作者数
    public func countAuthorTotal(db : AuthorDB) :  Nat {
        Trie.size<AuthorId, AuthorProfile>(db)
    };

    /// ---------------------- tag ---------------------- ///
    /// 新建博客标签数据存储
    public func newTagDB() : TagDB {
        Trie.empty<TagId, TagProfile>()
    };

    /// 新建博客标签数据访问对象
    public func newTagRepository() : TagRepository {
        TrieRepositories.TrieRepository<TagId, TagProfile>()
    };

    /// 保存Tag
    public func saveTag(db: TagDB, repository: TagRepository, profile: TagProfile) : TagDB {
        let newDB = repository.update(db, profile, dbKey(profile.id), tagEq).0;
        newDB
    };

    /// 删除指定的Tag
    /// Args:
    ///     |db|    标签数据源
    ///     |tagId| 被删除的标签主键
    /// Returns:
    ///     删除指定标签后的数据存储
    public func deleteTag(db: TagDB, repository: TagRepository, tagId: TagId) : TagDB {
        repository.delete(db, dbKey(tagId), tagEq)
    };

    /// 查询精确匹配标签名字的标签
    public func findByTag(db: TagDB, repository: TagRepository, tagName: Text) : TagDB {
        repository.findBy(db, func (id, profile) : Bool {
            profile.tag == tagName
        })
    };

    /// 分页查询Tag
    public func pageTag(db: TagDB, repository: TagRepository, 
        pageSize: Nat, pageNum: Nat, 
        filter: (TagId, TagProfile) -> Bool, 
        sortWith: (TagProfile, TagProfile) -> Order.Order) : TagPage {
        repository.page(db, pageSize, pageNum, filter, sortWith)
    };

    /// 总标签数
    public func countTagTotal(db : TagDB) :  Nat {
        Trie.size<TagId, TagProfile>(db)
    };

    /// ------------------------ Blog ------------------------ ///
    public func newBlogDB() : BlogDB {
        Trie.empty<BlogId, BlogProfile>()
    };

    public func newBlogRepository() : BlogRepository {
        TrieRepositories.TrieRepository<BlogId, BlogProfile>()
    };

    /// 保存Blog
    public func saveBlog(db: BlogDB, repository: BlogRepository, profile: BlogProfile) : BlogDB {
        let newDB = repository.update(db, profile, dbKey(profile.id), blogEq).0;
        newDB
    };

    /// 删除指定的Blog
    /// Args:
    ///     |db|    博客数据存储
    ///     |blogId| 被删除的博客主键
    /// Returns:
    ///     删除指定博客后的数据存储
    public func deleteBlog(db: BlogDB, repository: BlogRepository, blogId: BlogId) : BlogDB {
        repository.delete(db, dbKey(blogId), blogEq)
    };

    /// 获取指定的Blog
    public func getBlog(db: BlogDB, repository: BlogRepository, blogId: BlogId) : ?BlogProfile {
        repository.get(db, dbKey(blogId), blogEq)
    };

    /// 分页查询Blog
    public func pageBlog(db: BlogDB, repository: BlogRepository, 
        pageSize: Nat, pageNum: Nat, 
        filter: (BlogId, BlogProfile) -> Bool, 
        sortWith: (BlogProfile, BlogProfile) -> Order.Order) : BlogPage {
        repository.page(db, pageSize, pageNum, filter, sortWith)
    };

    /// 根据标签查询所有博客列表,不分页
    public func findBlogByTag(db: BlogDB, repository: BlogRepository, tag: Text) : [(BlogId, BlogProfile)] {
        repository.vals(
            repository.findBy(db, func (k, v) : Bool { BlogDomain.blogTagContainsText(v, tag)})
        )
    };

    /// 总博客数
    public func countBlogTotal(db : BlogDB) :  Nat {
        Trie.size<BlogId, BlogProfile>(db)
    };

    /// 查询所有 Blog
    public func allBlogs(db : BlogDB, repository: BlogRepository) :[(BlogId, BlogProfile)] {
        repository.vals(db)
    };

    /// BlogTitleKeyDB
    public func newBlogTitleKeyDB() : BlogTitleKeyDB {
        Trie.empty<Text, BlogTitleKeyRelation>()
    };

    public func newBlogTitleKeyRepository() : BlogTitleKeyRepository {
        TrieRepositories.TrieRepository<Text, BlogTitleKeyRelation>()
    };

    /// 保存BlogTitleKeyDB
    public func saveTitleKeyBlog(db: BlogTitleKeyDB, repository: BlogTitleKeyRepository, profile: BlogTitleKeyRelation) : BlogTitleKeyDB {
        let newDB = repository.update(db, profile, dbTextKey(profile.titleKey), blogTitleKeyEq).0;
        newDB
    };

    /// 删除指定TitleKey的Blog
    /// Args:
    ///     |db|    博客数据存储
    ///     |titleKey| 被删除的博客TitleKey
    /// Returns:
    ///     删除指定博客后的数据存储
    public func deleteTitleKeyBlog(db: BlogTitleKeyDB, repository: BlogTitleKeyRepository, titleKey: Text) : BlogTitleKeyDB {
        repository.delete(db, dbTextKey(titleKey), blogTitleKeyEq)
    };

    /// 获取指定的Blog Relation
    public func getBlogTitleKeyRelation(db: BlogTitleKeyDB, repository: BlogTitleKeyRepository, titleKey: Text) : ?BlogTitleKeyRelation {
        repository.get(db, dbTextKey(titleKey), blogTitleKeyEq)
    };

    /// 获取指定TitleKey的Blog
    public func getBlogByTitleKey(db: BlogDB, repository: BlogRepository, reldb: BlogTitleKeyDB, relRepository: BlogTitleKeyRepository, titleKey: Text) : ?BlogProfile {
        // switch (getBlogTitleKeyRelation(reldb, relRepository, titleKey)) {
        //     case (?r) { 
        //         getBlog(db, repository, r.id)
        //     };
        //     case (null) null
        // }

        Option.chain<BlogTitleKeyRelation, BlogProfile>(
            getBlogTitleKeyRelation(reldb, relRepository, titleKey), 
            func (r) : ?BlogProfile { getBlog(db, repository, r.id) }
        )
    };

};