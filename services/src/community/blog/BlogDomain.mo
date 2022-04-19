
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Result "mo:base/Result";
import Text "mo:base/Text";

import PageHelper "../base/PageHelper";
import Types "../base/Types";
import Utils "../base/Utils";

/// 博客数据结构
module {
    // 富文本
    public type RichText = Types.RichText;

    // 时间戳,实际是整数,纳秒表示
    public type Timestamp = Types.Timestamp;
    // 用户principal的文本表示
    public type UserPrincipal = Types.UserPrincipal;

    /// --------------- Blog Author -------------------- ///
    // 作者id类型
    public type AuthorId = Types.Id;
    // 博客作者实体数据结构
    public type AuthorProfile = {
        id: AuthorId;   // 作者的唯一id
        avatarUri: Text;    // 作者头像 Uri
        name: Text;     // 作者的名字
        memo: Text;     // 对作者的备注
        createdBy: UserPrincipal;       // 创建作者时实际操作的用户principal
        createdAt: Timestamp;           // 创建时间
    };

    // 创建作者请求包含的数据值对象
    public type AuthorCreateCommand = {
        avatarUri: Text;   // 作者的头像图片 uri
        name: Text;     // 作者的名字
        memo: Text;     // 对作者的备注
    };

    // 博客作者查询
    public type AuthorPageQuery = {
        pageSize: Nat;
        pageNum: Nat;
        authorName: Text;
    };

    /// 博客按 titleKey 查询
    public type BlogTitleKeyQuery = {
        titleKey: Text;
    };

    // -------------- Domain functions --------------- ///
    public func authorCreateCommandToProfile(cmd: AuthorCreateCommand, authorId: AuthorId, 
        createdBy: UserPrincipal, createdAt: Timestamp) : AuthorProfile {
        {
            id = authorId;
            avatarUri = cmd.avatarUri;
            name = cmd.name;
            memo = cmd.memo;
            createdBy = createdBy;
            createdAt = createdAt;
        }
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func authorOrderByIdDesc(profile1: AuthorProfile, profile2: AuthorProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// ----------- Blog ------------- ///
    // 博客id
    public type BlogId = Types.Id;
    public type Category = {
        category: Text;
        categoryCn: Text;
        categoryEn: Text;
    };

    /// Blog metadata 转 json
    public func blogCategoryToJson(category: Category) : Text {
        "{" #
            "\"category\": \"" # category.category # "\", " # 
            "\"categoryCn\": \"" # category.categoryCn # "\", " # 
            "\"categoryEn\": \"" # category.categoryEn # "\"" #
        "}"
    };

    // 博客实体数据结构,实体
    public type BlogProfile = {
        id: BlogId;     // 博客ID,唯一, 不重复
        titleKey: Text; // 博客标题key, 唯一不重复,是用来前端路由跳转文章时，在网页链接上显示的是一串字符串，而不是单个数字ID，方便分享
        contentCn: BlogMetadata;    // 中文内容
        contentEn: BlogMetadata;    // 英文内容
        authorAvatarUri: Text;      // 博客作者头像Url，默认空串
        authorName: Text;           // 作者名称
        tags: [TagResponse];        // 标签
        category: Category; //      // 分类/栏目
        publishTime: Timestamp;     // 发布时间, 如果是0表示未发布
        status: BlogStatus;         // 状态
        displaySum: Nat;            // 累计展示数
        readingSum: Nat;            // 累计阅读数
        rejectInfo: Text;               // 驳回信息
        memo: Text;                     // 备注用,后备信息
        createdBy: UserPrincipal;       // 创建时实际操作的用户principal
        createdAt: Timestamp;           // 创建时间
        updatedBy: UserPrincipal;       // 最新编辑人
        updatedAt: Timestamp;           // 最新编辑时间
        
    };

    /// 博客转成Json
    public func blogToJson(profile: BlogProfile) : Text {
        var json = "{" #
            "\"id\": " # Nat.toText(profile.id)  # ", " # 
            "\"titleKey\": \"" # profile.titleKey # "\", " # 
            "\"contentCn\": " # blogMetadataToJson(profile.contentCn) # ", " # 
            "\"contentEn\": " # blogMetadataToJson(profile.contentEn) # ", " # 
            "\"authorAvatarUri\": \"" # profile.authorAvatarUri  # "\", " # 
            "\"authorName\": \"" # profile.authorName # "\", " # 
            "\"tags\": " # tagResponsesToJson(profile.tags) # ", " # 
            "\"category\": " # blogCategoryToJson(profile.category) # ", " # 
            "\"publishTime\": " # Int.toText(profile.publishTime) # ", " # 
            "\"status\": \"" # blogStatusToText(profile.status) # "\", " # 
            "\"displaySum\": " # Nat.toText(profile.displaySum) # ", " # 
            "\"readingSum\": " # Nat.toText(profile.readingSum) # ", " # 
            "\"rejectInfo\": \"" # profile.rejectInfo # "\", " # 
            "\"memo\": \"" # profile.memo # "\", " # 
            "\"createdBy\": \"" # profile.createdBy  # "\"," #
            "\"createdAt\": " # Int.toText(profile.createdAt) # ", " # 
            "\"updatedBy\": \"" # profile.updatedBy  # "\"," #
            "\"updatedAt\": " # Int.toText(profile.updatedAt);

        json #= "}";

        json
    };
    
    public func blogsToJson(blogs: [BlogProfile]) : Text {
        let size = blogs.size();
        var counter = 1;

        var json = "[";

        for (blog in blogs.vals()) {
            json #= blogToJson(blog);

            if (counter < size) { json #= ","; };     // 数组元素之间以 , 分隔
            
            counter += 1;
        };
        
        json #= "]";

        json
    };
    public type BlogPage = PageHelper.Page<BlogProfile>;

    /// BlogPage 转 json
    public func blogPageToJson(page: BlogPage) : Text {
        PageHelper.pageToJson(page, blogsToJson)
    };

    /// 博客 TitleKey 与 id 关系
    public type BlogTitleKeyRelation = {
        titleKey: Text;
        id: BlogId;
    };

    // 博客内容,值对象
    public type BlogMetadata = {
        content: RichText;  // 博客实际内容
        bannerUri: Text;   // banner图片的uri
        readingTime: Nat;   // 阅读时长
        title: Text;        // 博客标题
        description: Text;  // 简介
    };

    /// Blog metadata 转 json
    public func blogMetadataToJson(metadata: BlogMetadata) : Text {
        var json = "{" #
            "\"content\": " # Types.richTextToJson(metadata.content) # ", " # 
            "\"bannerUri\": \"" # metadata.bannerUri  # "\", " # 
            "\"readingTime\": " # Nat.toText(metadata.readingTime) # ", " # 
            "\"title\": \"" # metadata.title # "\", " # 
            "\"description\": \"" # metadata.description # "\"";

        json #= "}";

        json
    };
    
    // 博客状态,枚举值
    public type BlogStatus = {
        #draft;     // 草稿
        #toPublish; // 待审核(待发布);
        #published; // 已发布;
        #rejected;  // 已驳回
    };

    /// 博客状态 转 text
    public func blogStatusToText(status: BlogStatus) : Text {
        switch (status) {
            case (#draft) "draft";
            case (#toPublish) "toPublish";
            case (#published) "published";
            case (#rejected) "rejected";
        }
    };

    // 编辑博客命令的值对象
    public type BlogUpdateCommand = {
        id: BlogId;     // 博客ID,唯一, 不重复
        titleKey: Text; // 博客标题key, 唯一不重复,是用来前端路由跳转文章时，在网页链接上显示的是一串字符串，而不是单个数字ID，方便分享
        contentCn: BlogMetadata;    // 中文内容
        contentEn: BlogMetadata;    // 英文内容
        authorAvatarUri: Text;   // 作者头像uri
        authorName: Text;           // 作者名称
        tags: [TagResponse];        // 标签
        category: Category;
        publishTime: Timestamp;
    };

    /// 博客发布命令
    public type BlogPublishCommand = {
        id: BlogId;
        publishTime: Timestamp;
    };

    /// 博客取消发布事件
    public type BlogCancelCommand = {
        id: BlogId;
    };

    /// 博客增加事件
    public type BlogIncrementCommand = {
        id: BlogId;
    };

    /// 博客提交审核事件
    public type BlogSubmitCommand = {
        id: BlogId;
    };

    /// 博客驳回事件
    public type BlogRejectCommand = {
        id: BlogId;
        rejectInfo: Text;
    };

    /// 博客查询值对象
    public type BlogPageQuery = {
        name: Text; // 模糊查询博客标题或作者名称
        pageSize: Nat;
        pageNum: Nat;
        startTime: Timestamp;
        endTime: Timestamp;
        category: Text;
        status: Text;
    };

    /// 博客查询值对象
    public type BlogPageTagQuery = {
        pageSize: Nat;
        pageNum: Nat;
        tags: [Text];
        category: Text;
    };

    /// 博客查询值对象
    public type BlogPageSingleTagQuery = {
        pageSize: Nat;
        pageNum: Nat;
        tag: Text;
    };

    /// 创建空的博客
    public func newBlankBlog(blogId: BlogId, createdBy: UserPrincipal, createdAt: Timestamp) : BlogProfile {
        let blankContent = {
            content = { 
                content = "";
                format = "markdown"; // 默认是markdown格式
            };
            bannerUri = "";
            readingTime = 0;
            title = "";
            description = "";
        };
        {
            id = blogId;
            titleKey = "";
            contentCn = blankContent;
            contentEn = blankContent;
            authorAvatarUri = "";
            authorName = "";
            tags = [];
            category = {category = ""; categoryCn = ""; categoryEn = ""};
            publishTime = 0;
            status = #draft;
            displaySum = 0;
            readingSum = 0;
            rejectInfo = "";
            memo = "";
            createdBy = createdBy;
            createdAt = createdAt;
            updatedBy = createdBy;
            updatedAt = createdAt;
        }
    };

    /// 更新博客内容,用更新命令中的内容更新旧内容
    public func updateBlog(profile: BlogProfile, cmd: BlogUpdateCommand, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        assert(profile.id == cmd.id);

        {
            id = profile.id;
            titleKey = cmd.titleKey;
            contentCn = cmd.contentCn;
            contentEn = cmd.contentEn;
            authorAvatarUri = cmd.authorAvatarUri;
            authorName = cmd.authorName;
            tags = cmd.tags;
            category = cmd.category;
            publishTime = cmd.publishTime;
            status = profile.status;
            displaySum = profile.displaySum;
            readingSum = profile.readingSum;
            rejectInfo = profile.rejectInfo;
            memo = profile.memo;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// BlogProfile 转 BlogTitleKeyRelation
    public func blogProfileToTitleKeyRelation(profile: BlogProfile) : Result.Result<BlogTitleKeyRelation, Types.Error> {
        if (blogHasEmptyTitleKey(profile)) {
            #err(#titleKeyEmpty)
        } else {
            #ok({ 
                titleKey = profile.titleKey;
                id = profile.id;
            })
        }
        
    };

    /// 博客能否发布, 只有状态是草稿或待审核才能发布 驳回状态也可以发布，只要有权限
    public func blogCanPublish(profile: BlogProfile) : Bool {
        return (profile.status == #draft or profile.status == #toPublish or profile.status == #rejected);
    };

    /// 博客是否待审核状态
    public func blogIsToPublish(profile: BlogProfile) : Bool {
        return (profile.status == #toPublish);
    };
    
    /// 博客发布
    public func blogPublishing(profile: BlogProfile, publishTime: Timestamp, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        updateBlogStatus(profile, publishTime, #published, updatedBy, updatedAt)
    };

    /// 博客是否草稿
    public func blogIsDraft(profile: BlogProfile) : Bool {
        return (profile.status == #draft);
    };

    /// 博客是否被拒绝(驳回)
    public func blogIsRejected(profile: BlogProfile) : Bool {
        return (profile.status == #rejected);
    };

    /// 驳回博客,状态变为被拒绝(驳回)
    public func blogRejecting(profile: BlogProfile, rejectInfo: Text, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        {   
            id = profile.id;
            titleKey = profile.titleKey;
            contentCn = profile.contentCn;
            contentEn = profile.contentEn;
            authorAvatarUri = profile.authorAvatarUri;
            authorName = profile.authorName;
            tags = profile.tags;
            category = profile.category;
            publishTime = profile.publishTime;
            status = #rejected; 
            displaySum = profile.displaySum;
            readingSum = profile.readingSum;
            rejectInfo = rejectInfo;
            memo = profile.memo;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// 博客提交审核,状态变为待审核
    public func blogSubmit(profile: BlogProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        updateBlogStatus(profile, profile.publishTime, #toPublish, updatedBy, updatedAt)
    };

    /// 博客取消审核,状态变为草稿
    public func blogCancelSubmit(profile: BlogProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        updateBlogStatus(profile, profile.publishTime, #draft, updatedBy, updatedAt)
    };

    /// 取消博客发布,博客的转为 #draft
    public func blogCancelPublishing(profile: BlogProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        updateBlogStatus(profile, profile.publishTime, #draft, updatedBy, updatedAt)
    };

    /// 更新博客发布信息
    public func updateBlogStatus(profile: BlogProfile, publishTime: Timestamp, status: BlogStatus, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        {
            id = profile.id;
            titleKey = profile.titleKey;
            contentCn = profile.contentCn;
            contentEn = profile.contentEn;
            authorAvatarUri = profile.authorAvatarUri;
            authorName = profile.authorName;
            tags = profile.tags;
            category = profile.category;
            publishTime = publishTime;
            status = status ;
            displaySum = profile.displaySum;
            readingSum = profile.readingSum;
            rejectInfo = profile.rejectInfo;
            memo = profile.memo;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// 更新博客显示累计总数
    public func incrementBlogDisplay(profile: BlogProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        {
            id = profile.id;
            titleKey = profile.titleKey;
            contentCn = profile.contentCn;
            contentEn = profile.contentEn;
            authorAvatarUri = profile.authorAvatarUri;
            authorName = profile.authorName;
            tags = profile.tags;
            category = profile.category;
            publishTime = profile.publishTime;
            status = profile.status ;
            displaySum = profile.displaySum + 1;
            readingSum = profile.readingSum;
            rejectInfo = profile.rejectInfo;
            memo = profile.memo;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// 更新博客阅读累计总数
    public func incrementBlogReading(profile: BlogProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : BlogProfile {
        {
            id = profile.id;
            titleKey = profile.titleKey;
            contentCn = profile.contentCn;
            contentEn = profile.contentEn;
            authorAvatarUri = profile.authorAvatarUri;
            authorName = profile.authorName;
            tags = profile.tags;
            category = profile.category;
            publishTime = profile.publishTime;
            status = profile.status ;
            displaySum = profile.displaySum;
            readingSum = profile.readingSum + 1;
            rejectInfo = profile.rejectInfo;
            memo = profile.memo;
            createdBy = profile.createdBy;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// 博客标签转成文本
    public func blogTagToText(profile: BlogProfile) : [Text] {
        Array.map<TagResponse, Text>(profile.tags, func (tr) : Text {
            tr.tag
        })
    };

    /// 博客标签列表是否包含指定的标签
    public func blogTagContainsText(profile: BlogProfile, str: Text) : Bool {
        if (Utils.isSpaceText(str)) return true;
        switch (Array.find<TagResponse>(profile.tags, func (tr) : Bool {
            tr.tag == str
        })) {
            case (?v) { true };
            case (null) { false };
        }
    };

    /// 博客标签列表是否包含指定的标签列表
    public func blogTagContainsAllText(profile: BlogProfile, tags: [Text]) : Bool {
        Utils.arrayContainsAll<Text>(blogTagToText(profile), tags, Text.equal)
    };

    /// 博客Category是否包含指定的分类
    public func blogCategoryContains(profile: BlogProfile, str: Text) : Bool {
        profile.category.category == str
    };

    /// 博客状态是否与指定的相等
    public func blogStatusEq(profile: BlogProfile, status: Text) : Bool {
        blogStatusToText(profile.status) == status
    };

    /// 判断 BlogProfile titleKey 是否为空
    public func blogHasEmptyTitleKey(profile: BlogProfile) : Bool {
        Utils.isSpaceText(profile.titleKey)
    };

    /// 判断 BlogProfile authroName 是否为空
    public func blogHasEmptyAuthorName(profile: BlogProfile) : Bool {
        Utils.isSpaceText(profile.authorName)
    };

    /// 判断 BlogProfile contentCn 是否为空
    public func blogHasEmptyContentCn(profile: BlogProfile) : Bool {
        Utils.isSpaceText(profile.contentCn.content.content) or
            Utils.isSpaceText(profile.contentCn.content.format) or
            Utils.isSpaceText(profile.contentCn.bannerUri) or
            profile.contentCn.readingTime == 0 or
            Utils.isSpaceText(profile.contentCn.description)
    };

    /// 判断 BlogProfile 是否已经发布
    public func blogIsPublished(profile: BlogProfile) : Bool {
        profile.status == #published
    };

    /// 判断 BlogProfile 发布时间是否为空
    public func blogHasPublishTime(profile: BlogProfile) : Bool {
        profile.publishTime > 0
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func blogOrderByIdDesc(profile1: BlogProfile, profile2: BlogProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// 按发布时间倒序，发布时间越大表示越新，排在前面
    public func blogOrderByPublishTimeDesc(profile1: BlogProfile, profile2: BlogProfile) : Order.Order {
        Int.compare(profile2.publishTime, profile1.publishTime)
    };

    /// ---------------- Blog Tag ------------------- ///
    // 标签id类型
    public type TagId = Types.Id;
    // 博客标签实体数据结构
    public type TagProfile = {
        id: TagId;   // 标签的唯一id
        tag: Text;     // 标签的名字
        tagCn: Text;     // 对标签的中文表示
        tagEn: Text;     // 对标签的英文表示
        createdBy: UserPrincipal;       // 创建标签时实际操作的用户principal
        createdAt: Timestamp;           // 创建时间
    };

    // 创建标签请求包含的数据值对象
    public type TagCreateCommand = {
        tag: Text;     // 标签的名字
        tagCn: Text;     // 对标签的中文表示
        tagEn: Text;     // 对标签的英文表示
    };

    // 修改标签显示命令,包含标签响应对象
    public type TagDisplayUpdateCommand = {
        tags: [TagResponse]
    };

    // 标签响应对象
    public type TagResponse = {
        id: TagId;       // 标签的唯一id
        tag: Text;     // 标签的名字
        tagCn: Text;     // 对标签的中文表示
        tagEn: Text;     // 对标签的英文表示
    };

    /// TagResponse 转 json 格式
    public func tagResponseToJson(tr: TagResponse) : Text {
        "{" #
            "\"id\": " # Nat.toText(tr.id)  # ", " # 
            "\"tag\": \"" # tr.tag # "\", " # 
            "\"tagCn\": \"" # tr.tagCn # "\", " # 
            "\"tagEn\": \"" # tr.tagEn # "\"" #
        "}"
    };

    /// TagResponse 转 json 格式
    public func tagResponsesToJson(trs: [TagResponse]) : Text {
        let size = trs.size();
        var counter = 1;

        var json = "[";

        for (tr in trs.vals()) {
            json #= tagResponseToJson(tr);

            if (counter < size) { json #= ","; };     // 数组元素之间以 , 分隔
            
            counter += 1;
        };
        
        json #= "]";

        json
    };

    // 博客标签查询
    public type TagPageQuery = {
        pageSize: Nat;
        pageNum: Nat;
    };

    // -------------- Domain functions --------------- ///
    public func tagCreateCommandToProfile(cmd: TagCreateCommand, tagId: TagId, 
        createdBy: UserPrincipal, createdAt: Timestamp) : TagProfile {
        {
            id = tagId;
            tag = cmd.tag;
            tagCn = cmd.tagCn;
            tagEn = cmd.tagEn;
            createdBy = createdBy;
            createdAt = createdAt;
        }
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func tagOrderByIdDesc(profile1: TagProfile, profile2: TagProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };

    /// 校验标签名字长度,不超过 20 
    public func isInvalidTagLength(profile: TagProfile) : Bool {
        Text.size(profile.tag) > 20
    };

    public let authorEq = Types.idEq;
    public let authorHash = Types.idHash;
    public let blogEq = Types.idEq;
    public let blogHash = Types.idHash;
    public let titleKeyEq = Text.equal;
    public let titleKeyHash = Text.hash;
    public let tagEq = Types.idEq;
    public let tagHash = Types.idHash;
    
};