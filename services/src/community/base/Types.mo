
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

module {

    // 删除请求值对象
    public type DeleteCommand = {
        id: Id;
    };

    // 获取请求值对象 
    public type DetailQuery = {
        id: Id;
    };

    // 分页查询值对象
    public type PageQuery = {
        pageSize: Nat;
        pageNum: Nat;
    };

    public type Id = Nat;

    public type RichText = {
        format: Text;   /// 文本内容格式,例如text,html,markdown
        content: Text;
    };

    public func richTextToJson(rt: RichText) : Text {
         "{\"content\": \"" # rt.content # "\", \"format\": \"" # rt.format # "\"}"
    };

    public type Timestamp = Int;
    
    public type UserPrincipal = Text;

    public let idEq = Nat.equal;
    public let idHash = Hash.hash;

    public let userEq = Text.equal;
    public let userHash = Text.hash;

    public type IdOwner = {
        id: Id;
        owner: UserPrincipal;
    };
    
    /// 错误类型定义
    public type Error = {
        #idDuplicated;  // id重复
        #notFound;      
        #alreadyExisted;
        #badCommand;    // 请求体错误
        #unauthorized;  // 没有授权
        #unknownError;

        // blog relationship
        #tagDuplicated; // 标签重复
        #tagTooLong;    // 标签太长

        #blogTitleKeyDuplicated; // TitleKey重复
        #titleKeyEmpty; //TitleKeyp为空
        #blogPublishTimeEmpty;  
        #blogAuthorNameEmpty;
        #blogContentCnEmpty;
        #blogNotPublishAuth;
        #blogCannotPublish;
        #blogIsNotDraft;
        #blogIsNotPublished;
        #blogIsNotToPublish;
        #blogIsNotRejected;
    };
}