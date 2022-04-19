
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

import BlogDomain "./blog/BlogDomain";
import BlogRepositories "./blog/BlogRepositories";
import BlogTrieMapRepositories "./blog/BlogTrieMapRepositories";
import Http "http";
import PublisherDomain "./blog/PublisherDomain";
import PublisherRepositories "./blog/PublisherRepositories";
import Types "./base/Types";
import TrieMapRepositories "./repositories/TrieMapRepositories";
import TrieRepositories "./repositories/TrieRepositories";
import Utils "./base/Utils";

/// import local canister
import Platform "canister:platform";

actor Community {

    public type Error = Types.Error;

    public type Result<X, E> = Result.Result<X, E>;

    public type UserPrincipal = Types.UserPrincipal;

    public type DeleteCommand = Types.DeleteCommand;
    public type DetailQuery = Types.DetailQuery;

    /// Author data model 
    public type AuthorId = BlogDomain.AuthorId;
    public type AuthorProfile = BlogDomain.AuthorProfile;
    public type AuthorCreateCommand = BlogDomain.AuthorCreateCommand;
    public type AuthorPageQuery = BlogDomain.AuthorPageQuery;

    public type AuthorPage = BlogTrieMapRepositories.AuthorPage;

    /// Blog data and db type import
    public type BlogId = BlogDomain.BlogId;
    public type BlogProfile = BlogDomain.BlogProfile;
    public type BlogTitleKeyRelation = BlogDomain.BlogTitleKeyRelation;
    public type BlogPageQuery = BlogDomain.BlogPageQuery;
    public type BlogPageSingleTagQuery = BlogDomain.BlogPageSingleTagQuery;
    public type BlogPageTagQuery = BlogDomain.BlogPageTagQuery;
    public type BlogTitleKeyQuery = BlogDomain.BlogTitleKeyQuery;
 
    public type BlogUpdateCommand = BlogDomain.BlogUpdateCommand;
    public type BlogPublishCommand = BlogDomain.BlogPublishCommand;
    public type BlogSubmitCommand = BlogDomain.BlogSubmitCommand;
    public type BlogRejectCommand = BlogDomain.BlogRejectCommand;
    public type BlogCancelCommand = BlogDomain.BlogCancelCommand;
    public type BlogIncrementCommand = BlogDomain.BlogIncrementCommand;
    public type BlogPage = BlogTrieMapRepositories.BlogPage;

    public type BlogStore = BlogTrieMapRepositories.BlogDB;
    public type BlogTitleKeyStore = BlogTrieMapRepositories.BlogTitleKeyDB;

    /// Publisher data model
    public type PublisherProfile = PublisherDomain.PublisherProfile;
    public type PublisherAssignCommand = PublisherDomain.PublisherAssignCommand;
    public type PublisherDB = PublisherRepositories.PublisherDB;
    public type PublisherCache = PublisherRepositories.PublisherCache;

    /// Tag data model 
    public type TagId = BlogDomain.TagId;
    public type TagProfile = BlogDomain.TagProfile;
    public type TagCreateCommand = BlogDomain.TagCreateCommand;
    public type TagDisplayUpdateCommand = BlogDomain.TagDisplayUpdateCommand;
    public type TagPageQuery = BlogDomain.TagPageQuery;
    public type TagResponse = BlogDomain.TagResponse;
    
    public type TagPage = BlogTrieMapRepositories.TagPage;

    // Author Storage
    // stable var authorDB = BlogRepositories.newAuthorDB();
    // let authorRepository = BlogRepositories.newAuthorRepository();

    stable var authorStore = BlogTrieMapRepositories.newAuthorDB();
    var authorCache = BlogTrieMapRepositories.authorDBToCache(authorStore);
    let authorTrieMapRepository = BlogTrieMapRepositories.newAuthorTrieMapRepository();

    // Blog Storage
    // stable var blogDB = BlogRepositories.newBlogDB();
    // let blogRepository = BlogRepositories.newBlogRepository();

    stable var blogStore = BlogTrieMapRepositories.newBlogDB();
    var blogCache = BlogTrieMapRepositories.blogDBToCache(blogStore);
    let blogTrieMapRepository = BlogTrieMapRepositories.newBlogTrieMapRepository();

    // stable var blogTitleKeyDB = BlogRepositories.newBlogTitleKeyDB();
    // let blogTitleKeyRepository = BlogRepositories.newBlogTitleKeyRepository();

    stable var blogTitleKeyStore = BlogTrieMapRepositories.newBlogTitleKeyDB();
    var blogTitleKeyCache = BlogTrieMapRepositories.blogTitleKeyDBToCache(blogTitleKeyStore);
    let blogTitleKeyTrieMapRepository = BlogTrieMapRepositories.newBlogTitleKeyTrieMapRepository();

    // Tag Storage
    // stable var tagDB = BlogRepositories.newTagDB();
    // let tagRepository = BlogRepositories.newTagRepository();

    stable var tagStore = BlogTrieMapRepositories.newTagDB();
    var tagCache = BlogTrieMapRepositories.tagDBToCache(tagStore);
    let tagTrieMapRepository = BlogTrieMapRepositories.newTagTrieMapRepository();

    stable var tagDisplayList : [TagResponse] = [];

    /// 获取当前的id，并对id+1,这是有size effects的操作
    func getIdAndIncrementOne() : Nat {
        let id = idGenerator;
        idGenerator += 1;
        id
    };

    /// 辅助方法，获取当前时间
    func timeNow_() : Int {
        Time.now()
    };

    /// 博客发布权限人员列表
    stable var publishers_ = ["v4r3s-nn353-xms6p-37w4r-okcn5-xxp6v-cnod7-4xqfl-sw5to-gcgue-bqe", "na327-64o7y-4esyn-pjdfu-fbzkt-st2au-ujc6h-3qmgm-7zezw-bpjsw-bqe", "diw2c-paqnk-7algi-3hmz3-i5pbl-7zrbu-zoenn-lsnd2-i4tqo-guxo7-2ae"];
    
    // Publisher DB and Repository
    stable var publisherStore = PublisherRepositories.newPublisherDB();
    // 初始化角色数据
    if (publisherStore.size() == 0) {
        publisherStore :=  Array.map<Text, (Text, PublisherProfile)>(publishers_, func (u) : (Text, PublisherProfile) { (u, PublisherDomain.newPublisher(u, timeNow_())) });
    };
    var publisherCache = PublisherRepositories.publisherDBToCache(publisherStore);
    let publisherRepository = PublisherRepositories.newPublisherRepository();

    /// ID Generator
    stable var idGenerator : Nat = 10001;

    /// -------- Query  ----------- ///
    /// Canister健康检查
    public query func healthcheck() : async Bool { true };

    /// Canister Upgrades 
    /// Canister停止前把非stable转成stable保存到内存中
    system func preupgrade() {
        Debug.print("Starting preupgrade");

        // author store
        authorStore := BlogTrieMapRepositories.authorCacheToDB(authorCache);
        // blog store
        blogStore := BlogTrieMapRepositories.blogCacheToDB(blogCache);

        blogTitleKeyStore := BlogTrieMapRepositories.blogTitleKeyCacheToDB(blogTitleKeyCache);

        /// Publisher
        publisherStore := PublisherRepositories.publisherCacheToDB(publisherCache);

        tagStore := BlogTrieMapRepositories.tagCacheToDB(tagCache);

        Debug.print("preupgrade Done!!");
    };

    system func postupgrade() {
        Debug.print("Starting postupgrade");

        authorStore := [];
        blogStore := [];
        blogTitleKeyStore := [];
        publisherStore := [];
        tagStore := [];

        Debug.print("postupgrade Done!!");
    };

    /// ---------------- 博客 -------------- ///
    /// 创建博客作者
    public shared(msg) func createAuthor(cmd: AuthorCreateCommand) : async Result<Nat, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Nat, Error> {
            let authorId = getIdAndIncrementOne();
            let currentTime = timeNow_();
            let profile = BlogDomain.authorCreateCommandToProfile(cmd, authorId, caller, currentTime);
            // authorDB := BlogRepositories.saveAuthor(authorDB, authorRepository, profile);
            BlogTrieMapRepositories.saveAuthor(authorCache, authorTrieMapRepository, profile);
            #ok(authorId)
        })     
    };

    /// 删除博客作者
    public shared(msg) func deleteAuthor(cmd: DeleteCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            // authorDB := BlogRepositories.deleteAuthor(authorDB, authorRepository, cmd.id);
            let _ = BlogTrieMapRepositories.deleteAuthor(authorCache, authorTrieMapRepository, cmd.id);
            #ok(true)
        })    
    };

    /// 分页查询作者,作者名字模型查询,不区分大小写
    public query func pageAuthor(q: AuthorPageQuery) : async Result<AuthorPage, Error> {
        #ok(
            BlogTrieMapRepositories.pageAuthor(authorCache, authorTrieMapRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                Utils.containsStr(Utils.toLowerCase(profile.name), Utils.toLowerCase(Utils.trim(q.authorName)))
            }, BlogDomain.authorOrderByIdDesc)
        )
    };

    /// 创建博客标签
    public shared(msg) func createTag(cmd: TagCreateCommand) : async Result<Nat, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Nat, Error> {
            let tagId = getIdAndIncrementOne();
            let currentTime = timeNow_();

            let profile = BlogDomain.tagCreateCommandToProfile(cmd, tagId, caller, currentTime);

            // 校验标签是否满足长度限制(小于 20 字符)
            if (BlogDomain.isInvalidTagLength(profile)) {
                return #err(#tagTooLong);
            };

            // 查询是不有同名的标签
            let filterByName = BlogTrieMapRepositories.findTagByTagName(tagCache, tagTrieMapRepository, cmd.tag);
            // 重名标签返回重名错误
            if (BlogTrieMapRepositories.countTagTotal(filterByName) > 0) {
                return #err(#tagDuplicated);
            };

            // tagDB := BlogRepositories.saveTag(tagDB, tagRepository, profile);
            BlogTrieMapRepositories.saveTag(tagCache, tagTrieMapRepository, profile);
            #ok(tagId)
        })     
    };

    /// 删除博客标签
    public shared(msg) func deleteTag(cmd: DeleteCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            // tagDB := BlogRepositories.deleteTag(tagDB, tagRepository, cmd.id);
            let _ = BlogTrieMapRepositories.deleteTag(tagCache, tagTrieMapRepository, cmd.id);
            #ok(true)
        })    
    };

    /// 分页查询标签
    public query func pageTag(q: TagPageQuery) : async Result<TagPage, Error> {
        #ok(
            BlogTrieMapRepositories.pageTag(tagCache, tagTrieMapRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                true
            }, BlogDomain.tagOrderByIdDesc)
        )
    };

    /// 编辑标签显示列表
    public shared(msg) func editDisplayTag(cmd: TagDisplayUpdateCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            tagDisplayList := cmd.tags;
            #ok(true)
        })
    };

    /// 查询标签显示列表 
    public query func getTagDisplay() : async Result<[TagResponse], Error> {
        #ok(tagDisplayList)
    };

    /// 新建空的博客
    public shared(msg) func createBlankBlog() : async Result<Nat, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Nat, Error> {
            let blogId = getIdAndIncrementOne();
            let currentTime = timeNow_();
            let profile = BlogDomain.newBlankBlog(blogId, caller, currentTime);
            
            BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, profile);
            #ok(blogId)
        })

    };

    /// 删除博客
    public shared(msg) func deleteBlog(cmd: DeleteCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            
            let _ = BlogTrieMapRepositories.deleteBlog(blogCache, blogTrieMapRepository, cmd.id);
            #ok(true)
        })    
    };

    /// 编辑博客
    /// 编辑已经发布的 Blog 时,也要使用发布 Blog 的规则检查
    public shared(msg) func editBlog(cmd: BlogUpdateCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            let blogId = cmd.id;
            let newTitleKey = cmd.titleKey;
            switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, blogId)) {
                case (?profile) { 
                    
                    // 如果 titleKey 存在, 并且 blogId 不是同一个,说明 titleKey 重复了,返回 titleKey 重复提示
                    let hasTitleKey = not(Utils.isSpaceText(newTitleKey));
                    if (hasTitleKey) {
                        switch (BlogTrieMapRepositories.getBlogTitleKeyRelation(blogTitleKeyCache, blogTitleKeyTrieMapRepository, newTitleKey)) {
                            case (?br) { 
                                if (br.id != blogId) {
                                    return #err(#blogTitleKeyDuplicated);
                                };
                            };
                            case (null) {}
                        }
                    };
                    
                    let currentTime = timeNow_();
                    let newBlog = BlogDomain.updateBlog(profile, cmd, caller, currentTime);

                    if (BlogDomain.blogIsPublished(newBlog)) {
                        if (newBlog.publishTime <= 0) {
                            return #err(#blogPublishTimeEmpty);
                        };

                        if (BlogDomain.blogHasEmptyAuthorName(newBlog)) {
                            return #err(#blogAuthorNameEmpty);
                        };

                        if (BlogDomain.blogHasEmptyContentCn(newBlog)) {
                            return #err(#blogContentCnEmpty);
                        };

                        if (not(guardPublisher(caller))) {
                            return #err(#blogNotPublishAuth);
                        };
                    };         
                    
                    BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);

                    switch (BlogDomain.blogProfileToTitleKeyRelation(newBlog)) {
                        case (#ok(r)) { 
                            BlogTrieMapRepositories.saveBlogTitleKey(blogTitleKeyCache, blogTitleKeyTrieMapRepository, r);
                        };
                        case _ { };                       
                    };
                    
                    #ok(true);
                };
                case (null) #err(#notFound);
            }
        })
    };
    
    /// 提交博客审核
    public shared(msg) func submitBlog(cmd: BlogSubmitCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            let blogId = cmd.id;
            switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, blogId)) {
                case (?profile) { 
                    let currentTime = timeNow_();
                    if (BlogDomain.blogIsDraft(profile) or BlogDomain.blogIsRejected(profile)) {
                        let newBlog = BlogDomain.blogSubmit(profile, caller, currentTime);
                        BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);
                        #ok(true);
                    }  else {
                        #err(#blogIsNotDraft)
                    }
                    
                };
                case (null) #err(#notFound);
            }
        })
    };

    /// 重新提交博客审核
    public shared(msg) func reSubmitBlog(cmd: BlogSubmitCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            let blogId = cmd.id;
            switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, blogId)) {
                case (?profile) { 
                    let currentTime = timeNow_();
                    if (BlogDomain.blogIsRejected(profile)) {
                        let newBlog = BlogDomain.blogSubmit(profile, caller, currentTime);
                        BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);
                        #ok(true);
                    }  else {
                        #err(#blogIsNotRejected)
                    }
                    
                };
                case (null) #err(#notFound);
            }
        })
    };

    /// 取消审核博客
    public shared(msg) func cancelSubmitBlog(cmd: BlogCancelCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            let blogId = cmd.id;
            switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, blogId)) {
                case (?profile) { 
                    if (BlogDomain.blogIsToPublish(profile)) {
                        let currentTime = timeNow_();
                        let newBlog = BlogDomain.blogCancelSubmit(profile, caller, currentTime);
                        BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);
                        #ok(true);
                    } else {
                        #err(#blogIsNotToPublish)
                    }
                    
                };
                case (null) #err(#notFound);
            }
        })
    };

    /// 发布博客
    // 1. 发布时间必须设置 *
    // 2. 标签 可以不选 标签列表可以为空
    // 3. 作者必须设置 *
    // 4. 内容 中文是必须填一份的（内容、标题、标题Key、简介、banner 图片 *）（英文可选 内容、标题、标题 Key、简介）
    // 5. 内容中的文章标题 Key，必须唯一，不允许重复(保存博客时保障不重复)
    public shared(msg) func publishBlog(cmd: BlogPublishCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        let publishTime = cmd.publishTime;
        if (publishTime <= 0) {
            return #err(#blogPublishTimeEmpty);
        };

        guard(isAdmin_, func() : Result<Bool, Error> {
            if (guardPublisher(caller)) {
                switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, cmd.id)) {
                    case (?profile) {
                        let currentTime = timeNow_();
                        if (not(BlogDomain.blogCanPublish(profile))) {
                            return #err(#blogCannotPublish);
                        };

                        let newBlog = BlogDomain.blogPublishing(profile, publishTime, caller, currentTime);

                        if (BlogDomain.blogHasEmptyAuthorName(newBlog)) {
                            return #err(#blogAuthorNameEmpty);
                        };

                        if (BlogDomain.blogHasEmptyContentCn(newBlog)) {
                            return #err(#blogContentCnEmpty);
                        };

                        BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);
                        #ok(true)
                    };
                    case (null) #err(#notFound)
                }
            } else {
                #err(#blogNotPublishAuth)
            }                     
        })
    };

    /// 驳回博客发布,管 理员和发布人才可以驳回博客发布
    public shared(msg) func rejectBlog(cmd: BlogRejectCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            if (guardPublisher(caller)) {
                switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, cmd.id)) {
                    case (?profile) {
                        let currentTime = timeNow_();
                        if (not(BlogDomain.blogIsToPublish(profile))) {
                            return #err(#blogIsNotPublished);
                        };

                        let newBlog = BlogDomain.blogRejecting(profile, cmd.rejectInfo, caller, currentTime);
                        BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);
                        #ok(true)
                    };
                    case (null) #err(#notFound)
                }
            } else {
                #err(#blogNotPublishAuth)
            }                     
        })
    };

    /// 取消博客发布,仅把博客状态设置为待发布
    public shared(msg) func cancelBlogPublish(cmd: BlogCancelCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller);     
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<Bool, Error> {
            switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, cmd.id)) {
                case (?profile) {
                    let currentTime = timeNow_();
                    let newBlog = BlogDomain.blogCancelPublishing(profile, caller, currentTime);

                    BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);

                    #ok(true)
                };
                case (null) #err(#notFound)
            }
            
        })
    };

    /// 增加博客展示次数
    public shared(msg) func incrementBlogDisplay(cmd: BlogIncrementCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller); 
        switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, cmd.id)) {
            case (?profile) {
                let currentTime = timeNow_();
                let newBlog = BlogDomain.incrementBlogDisplay(profile, caller, currentTime);

                BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);

                #ok(true)
            };
            case (null) #err(#notFound)
        }
    };

    /// 增加博客阅读次数
    public shared(msg) func incrementBlogReading(cmd: BlogIncrementCommand) : async Result<Bool, Error> {
        let caller = Principal.toText(msg.caller); 
        switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, cmd.id)) {
            case (?profile) {
                let currentTime = timeNow_();
                let newBlog = BlogDomain.incrementBlogReading(profile, caller, currentTime);

                BlogTrieMapRepositories.saveBlog(blogCache, blogTrieMapRepository, newBlog);

                #ok(true)
            };
            case (null) #err(#notFound)
        }
    };

    /// 获取博客详细
    public query func getBlog(q: DetailQuery) : async Result<?BlogProfile, Error> {
        #ok(BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, q.id))
    };

    /// 获取博客的标签
    public query func getBlogTags(blogId: BlogId) : async [Text] {
        switch (BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, blogId)) {
            case (?blog) {
                BlogDomain.blogTagToText(blog)
            };
            case None [];
        }
    };

    public query func getBlogFromCache(q: DetailQuery) : async Result<?BlogProfile, Error> {
        #ok(BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, q.id))
    };

    /// 查询博客详情，根据文章标题key查询
    public query func getBlogByTitleKey(q: BlogTitleKeyQuery) : async Result<?BlogProfile, Error> {
        #ok(BlogTrieMapRepositories.getBlogByTitleKey(blogCache, blogTrieMapRepository, blogTitleKeyCache, blogTitleKeyTrieMapRepository, q.titleKey))
    };

    /// 
    /// 分页查询博客,博客模型查询
    // 分页查询博客列表（按id倒序排序）
    // 可以通过模糊查询博客标题或作者名称（如果为空，说明不查询）
    // 可以通过模糊查询博客分类查询（如果为空，说明不查询）
    // 可以通过开始时间和结束时间查询博客（如果为0，说明不查询）
    public query func pageBlog(q: BlogPageQuery) : async Result<BlogPage, Error> {
        let qName = Utils.trim(q.name);
        let hasNoTime = q.endTime <= 0;
        let hasNoName = Utils.isSpaceText(qName);
        let hasNoCategory = Utils.isSpaceText(q.category);
        let hasNoStatus = Utils.isSpaceText(q.status);

        #ok(
            BlogTrieMapRepositories.pageBlog(blogCache, blogTrieMapRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                (hasNoName or (Utils.containsStr(profile.contentCn.title, qName) or 
                    Utils.containsStr(profile.contentEn.title, qName) or
                    Utils.containsStr(profile.authorName, qName))) and 
                    (hasNoCategory or BlogDomain.blogCategoryContains(profile, q.category)) and
                    (hasNoStatus or BlogDomain.blogStatusEq(profile, q.status)) and
                    (
                        hasNoTime or (profile.publishTime >= q.startTime and profile.publishTime <= q.endTime)
                    )
            }, BlogDomain.blogOrderByIdDesc)
        )
    };

    public query func pageBlogFromCache(q: BlogPageQuery) : async Result<BlogPage, Error> {
        let qName = Utils.trim(q.name);
        let hasNoTime = q.endTime <= 0;
        let hasNoName = Utils.isSpaceText(qName);
        let hasNoCategory = Utils.isSpaceText(q.category);

        #ok(
            BlogTrieMapRepositories.pageBlog(blogCache, blogTrieMapRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                (hasNoName or (Utils.containsStr(profile.contentCn.title, qName) or 
                    Utils.containsStr(profile.contentEn.title, qName) or
                    Utils.containsStr(profile.authorName, qName))) and 
                    (hasNoCategory or BlogDomain.blogCategoryContains(profile, q.category)) and
                    (
                        hasNoTime or (profile.publishTime >= q.startTime and profile.publishTime <= q.endTime)
                    )
            }, BlogDomain.blogOrderByIdDesc)
        )
    };

    /// 查询所有 博客 
    public query func allBlogs() : async Result<[(BlogId, BlogProfile)], Error> {
        #ok(BlogTrieMapRepositories.blogCacheToDB(blogCache))
    };

    public func allBlogsFromCache() : async Result<[(BlogId, BlogProfile)], Error> {
        #ok(
            BlogTrieMapRepositories.blogCacheToDB(blogCache)
        )
    };

    /// 获取博客总数量
    public query func countBlogTotal() : async Result<Nat, Error> {
        #ok(BlogTrieMapRepositories.countBlogTotal(blogCache))
    };

    /// 根据标签，分页查询博客列表,博客要已经发布（按id倒序排序）
    public query func pageBlogByTag(q: BlogPageTagQuery) : async Result<BlogPage, Error> {        
        #ok(pageBlogByTag_(q))
    };

    public query func pageBlogByTagFromCache(q: BlogPageTagQuery) : async Result<BlogPage, Error> {
        #ok(pageBlogByTag_(q))
    };

    /// 根据标签查询所有博客列表,不分页
    public query func findBlogByTag(tag: Text) : async Result<[(BlogId, BlogProfile)], Error> {
        #ok(
            BlogTrieMapRepositories.findBlogDBBy(blogCache, blogTrieMapRepository, func (id, profile): ?BlogProfile {
                if (BlogDomain.blogTagContainsText(profile, tag)) ?profile else null;
            })
        )
    };

    /// 根据标签查询所有博客列表,不分页
    public query func findBlogByTagFromCache(tag: Text) : async Result<[(BlogId, BlogProfile)], Error> {
        #ok(
            BlogTrieMapRepositories.findBlogDBBy(blogCache, blogTrieMapRepository, func (id, profile): ?BlogProfile {
                if (BlogDomain.blogTagContainsText(profile, tag)) ?profile else null;
            })
        )
    };

    public query func findBlogByTags(tags: [Text]) : async Result<[(BlogId, BlogProfile)], Error> {
        #ok(
            BlogTrieMapRepositories.findBlogDBBy(blogCache, blogTrieMapRepository, func (id, profile): ?BlogProfile {
                if (BlogDomain.blogTagContainsAllText(profile, tags)) ?profile else null;
            })
        )
    };

    public shared(msg) func isAuthor() : async Bool { 
        let caller = Principal.toText(msg.caller); 
        await Platform.isAuthor(caller);
    };

    // 博客HTTP接口,暂提供按id查询博客详情和前台分页查询功能
    public query func http_request(req: Http.HttpRequest) : async Http.HttpResponse {

        let querystring = extractQueryString(req.url);
        // Debug.print("querystring is : " # querystring);

        var blogIdStr = "";
        var blogTitleKey = "";
        let contents = Text.split(querystring, #char '&');

        var pageSize = 10;
        var pageNum = 0;
        var tags : [Text] = [];
        
        for (c in contents) {
            let cc = Text.split(c, #char '=');
            let key = cc.next();
            if (key == ?"blogId") {
                blogIdStr := Utils.getOrEmptyText(cc.next());
            } else if (key == ?"titleKey") {
                blogTitleKey := Utils.getOrEmptyText(cc.next());
            } else if (key == ?"pageSize") {
                switch (Utils.textToNat(Utils.getOrEmptyText(cc.next()))) {
                    case (?v) {
                        pageSize := v;
                    };
                    case (null) {};
                };             
            } else if (key == ?"pageNum") {
                switch (Utils.textToNat(Utils.getOrEmptyText(cc.next()))) {
                    case (?v) {
                        pageNum := v;
                    };
                    case (null) {};
                };             
            } else if (key == ?"tag") {
                let value = cc.next();
                let tag = Utils.getOrEmptyText(value);
                if (not (Utils.isSpaceText(tag))) {
                    tags := [tag]
                };
            };
        };

        let blogIdOpt = Utils.textToNat(blogIdStr);

        var body: Blob = Text.encodeUtf8("");
        var statusCodeOk : Nat16 = 200; // 200表示ok
        var maxAgeSeconds = "864000"; //表示过期为一天
        var contentType = "application/json";
        switch (blogIdOpt) {
            case (?id) { 
                // Debug.print("The blog is " # Nat.toText(id));
                let blogOpt = BlogTrieMapRepositories.getBlog(blogCache, blogTrieMapRepository, id);
                switch (blogOpt) {
                    case (?blog) {
                        body := Text.encodeUtf8(BlogDomain.blogToJson(blog));
                    };
                    case (null) { 
                        statusCodeOk := 404; // 404表示没找到notFound
                        maxAgeSeconds := "60"   // 没找到缓存调协1分钟
                    };
                }
             };
            case (null) { 
                if (Utils.isSpaceText(blogTitleKey)) {
                    if (pageSize > 0) {
                        let blogPage = BlogTrieMapRepositories.pageBlog(
                            blogCache, blogTrieMapRepository, pageSize, pageNum, func (id, profile) : Bool {  
                                // BlogDomain.blogIsPublished(profile) 
                                true  
                            }, BlogDomain.blogOrderByIdDesc
                        );
                        body := Text.encodeUtf8(BlogDomain.blogPageToJson(blogPage));

                    } else {
                        statusCodeOk := 400;     // 400表示请求有问题,badRequest
                        maxAgeSeconds := "10"    // 请求有问题设置缓存10秒
                    }   
                } else {
                    let blogOpt = BlogTrieMapRepositories.getBlogByTitleKey(blogCache, blogTrieMapRepository,  blogTitleKeyCache, blogTitleKeyTrieMapRepository, blogTitleKey);
                    switch (blogOpt) {
                        case (?blog) {
                            body := Text.encodeUtf8(BlogDomain.blogToJson(blog));
                        };
                        case (null) { 
                            statusCodeOk := 404; // 404表示没找到notFound
                            maxAgeSeconds := "60"   // 没找到缓存调协1分钟
                        };
                    }
                };       
            };
        };

        // 响应缓存设置
        let headers = [("Cache-Control", "max-age=" # maxAgeSeconds), ("Content-Type", contentType)];

        return {
            body = body;
            headers = headers;
            status_code = statusCodeOk;
            streaming_strategy = null;
        };
    };

    /// 查询所有博客发布权限人员列表
    public shared(msg) func publishers() : async Result<[PublisherProfile], Error> {
        let caller = Principal.toText(msg.caller);
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<[PublisherProfile], Error> {
            #ok(PublisherRepositories.getAllPublishersOrderByAuthorizationTime(publisherCache, PublisherDomain.publisherOrderByAuthorizationTime))
        })
    };

    /// Assign a new publisher to a principal
    public shared(msg) func assignPublisher(cmd: PublisherAssignCommand) : async Result<(), Error> {

        let caller = Principal.toText(msg.caller);
        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<(), Error> {
            // switch (PublisherRepositories.getPublisher(publisherCache, publisherRepository, caller)) {
            //     case (?_) {
            if (guardPublisher(caller)) {
                let user = cmd.user;

                if (user == caller) {
                    return #ok(());
                };

                switch (PublisherRepositories.getPublisher(publisherCache, publisherRepository, user)) {
                    case (?u) { 
                        #ok(())                       
                    };
                    case null { 
                        let newPublisher = PublisherDomain.newPublisher(user, timeNow_());
                        PublisherRepositories.savePublisher(publisherCache, publisherRepository, newPublisher);
                        #ok(())
                     };
                }
            } else {
                #err(#unauthorized)
            }
            // case (null) {
            //     #err(#unauthorized)
            //     };
                
            
            // }         
        })
        
    };

    /// Remove the publisher
    public shared(msg) func removePublisher(user: UserPrincipal) : async Result<(), Error> {
        let caller = Principal.toText(msg.caller);

        if (user == caller) {
            return #err(#unauthorized);
        };

        let isAdmin_ = await isAdmin(caller);

        guard(isAdmin_, func() : Result<(), Error> {   
            if (guardPublisher(caller)) {
                let _ = PublisherRepositories.deletePublisher(publisherCache, publisherRepository, user);
                #ok(())
            } else {
                #err(#unauthorized)
            }
            // switch (PublisherRepositories.getPublisher(publisherCache, publisherReposiotry, caller)) {
            //     case (?_) {
            //         PublisherRepositories.deletePublisher(publisherCache, publisherRepository, user);
            //         #ok(())
            //     };
            //     case (null) {
            //         #err(#unauthorized)
            //     };
            // }
        })
    };

    /// ------------------------ private functions -------------------------- ///

    /// 调用 Platform 中的角色权限功能检查用户是否管理员
    private func isAdmin(user: UserPrincipal) : async Bool { 
        await Platform.isAuthor(user);
    };

    /// 辅助方法，判断权限是否允许，然后逻辑处理并返回
    func guard<T>(isAdmin_ : Bool, f: () -> Result<T, Error>) : Result<T, Error> {
        if (isAdmin_) {
            f()
        } else {
            #err(#unauthorized)
        }
    };

    /// 辅助方法，判断权限是否允许，然后逻辑处理并返回
    func guardPublisher<T>(user: UserPrincipal) : Bool {
        switch (PublisherRepositories.getPublisher(publisherCache, publisherRepository, user)) {
            case (?_) {
                true
            };
            case (null) {
                false
            };
        }
    };

    // 根据标签，分页查询博客列表,博客要已经发布（按id倒序排序）
    private func pageBlogByTag_(q: BlogPageTagQuery) : BlogPage {
        let tags = q.tags;
        let hasNoTag = tags.size() == 0;
        let hasNoCategory = Utils.isSpaceText(q.category);
        let now = Time.now();

        BlogTrieMapRepositories.pageBlog(
            blogCache, blogTrieMapRepository, q.pageSize, q.pageNum, func (id, profile) : Bool {
                 
                (hasNoTag or BlogDomain.blogTagContainsAllText(profile, tags))  and
                (hasNoCategory or BlogDomain.blogCategoryContains(profile, q.category)) and
                    BlogDomain.blogIsPublished(profile) and profile.publishTime <= now
            }, BlogDomain.blogOrderByPublishTimeDesc
        )
    };

    // URL提供查询参数功能
    private func extractQueryString(str : Text) : Text {
        let querystring = Text.split(str, #char '?');
        ignore querystring.next(); 
        Utils.getOrEmptyText(querystring.next()) 
    };

    
};
