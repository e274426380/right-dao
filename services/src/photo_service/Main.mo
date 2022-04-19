
import AssocList "mo:base/AssocList";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import TrieMap "mo:base/TrieMap";

import PictureRepositories "./PictureRepositories";
import Domain "./Domain";
import Utils "./Utils";

actor PhotoAggregateRoot {

    type PictureId = Domain.PictureId;
    type Picture = Domain.Picture;
    type PictureProfile = Domain.PictureProfile;
    type PicturePage = Domain.PicturePage;

    type UserPrincipal = Domain.UserPrincipal;

    type Error = Domain.PicError;

    type Result<V, E> = Result.Result<V, E>;

    public type PictureDB = PictureRepositories.PictureDB;
    
    // 图片器，也是图片ID生成器
    stable var idGenerator = 10001;

    stable var stablePics: PictureDB = Trie.empty<PictureId, PictureProfile>();

    let pictureRepository : PictureRepositories.PictureRepository = PictureRepositories.PictureRepository();

    /// -------------- query ------------- ///

    /// 查询图片总数
    public query func getTotalPics() : async Result<Nat, Error> {
        #ok(Trie.size<PictureId, PictureProfile>(stablePics))
    };

    /// 获取图片() 公共的获取图片的接口
    /// Args:
    ///     |picId|  需要获取图片的id
    /// Returns:
    ///     如果对应id的图片存在，返回对应的图片信息，否则返回null
    public query func getPictureProfile(picId: PictureId): async Result<?PictureProfile, Error> {
        #ok(pictureRepository.getPictureProfile(stablePics, picId))
    };

    public query func getPicture(picId: PictureId): async Result<?Picture, Error> {
        #ok(pictureRepository.getPicture(stablePics, picId))
    };

    public query func getPictures(picIds: [PictureId]): async Result<[(PictureId, Picture)], Error> {

        #ok(pictureRepository.getPics(stablePics, picIds))
    };

    /// Retrieves the |owner|'s totalPicSize
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片的数量
    public query func getTotalPicsByOwner(owner: UserPrincipal) : async Result<Nat, Error> {
        let countPics= pictureRepository.countPicsByOwner(stablePics, owner);
        #ok(countPics)
    };


    /// Retrieves the |owner|'s 所有图片，需要分页优化 FIXME
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片列表
    public query func getPictureProfilesByOwner(owner: UserPrincipal) : async Result<[PictureProfile], Error> {
        let picsMap = pictureRepository.findPicsByOwner(stablePics, owner);
        let res = Trie.toArray<PictureId, PictureProfile, PictureProfile>(picsMap, func (id: PictureId, info: PictureProfile) : PictureProfile { info });
        
        #ok(res)
    };

    /// Retrieves the |owner|'s 图片分页查询
    /// Args:
    ///     |owner| 被查询的图片所有者 
    /// Returns:
    ///     被查询用户保存的所有图片列表
    public query func pagePicsByOwner(owner: UserPrincipal, pageSize: Nat, pageNum: Nat) : async Result<PicturePage, Error> {

        if (pageSize > 100) return #err(#tooLargeQuantity);

        let picsMap = pictureRepository.findPicsByOwner(stablePics, owner);
        let picsArr = Trie.toArray<PictureId, PictureProfile, PictureProfile>(picsMap, func (id: PictureId, info: PictureProfile) : PictureProfile {
            info
        });

        let skipCounter = pageNum * pageSize;

        let picsList = List.fromArray<PictureProfile>(picsArr);

        let remainning = List.drop<PictureProfile>(picsList, skipCounter);
        let paging = List.take<PictureProfile>(remainning, pageSize);
        let totalCount = List.size(picsList);
        #ok({
            data = List.toArray<PictureProfile>(paging);
            pageSize = pageSize;
            pageNum = pageNum;
            totalCount = totalCount;
        })
        
    };

    /// -------------- Update --------------------- ///

    /// savePic() 公共的上传图片接口 需要和前端确认数据格式,图片状态默认是enable
    /// Args:
    ///     |pic|   上传时需要保存的图片内容
    ///     |owner| 图片的所有者
    ///     |picName|   图片的名称
    ///     |description|   对图片的描述
    /// Returns:
    ///     处理成功返回#ok(图片id),,否则返回相应错误
    public shared(msg) func savePic(pic: Picture, picName: Text, description: Text, owner: UserPrincipal) : async Result<PictureId, Error> {
        let picId = getIdAndIncrementOne();

        let current_time = Time.now();
        let createdBy = Principal.toText(msg.caller);
        let picInfo: PictureProfile = {
            id = picId;
            pic = pic;
            picName = picName;
            description = description;
            owner = owner;
            status = #enable;
            createdBy = createdBy;
            createdAt = current_time;
        };

        let picOpt = pictureRepository.getPictureProfile(stablePics, picId);

        switch (picOpt) {
            case (?_) #err(#picAlreadyExisted);
            case null {
                let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);
                stablePics := newPics;

                #ok(picId)
            };
        }
        
    };

    /// editPic() 公共的编辑图片接口 需要和前端确认数据格式
    /// Args:
    ///     |picId|    需要修改的图片id
    ///     |pic|  需要修改的图片Blob
    ///     |picName|   需要修改的图片名称
    ///     |description|   需要修改的图片描述
    ///     |owner|     需要修改的图片所有者
    ///     |status|    需要修改的图片状态，enable, disable or pending
    /// Returns:
    ///     处理成功返回#ok(PictureProfile),出错返回相应错误
    // public shared(msg) func editPic(
    //     picId: PictureId,
    //     pic: Picture, 
    //     picName: Text,  
    //     description: Text, 
    //     owner: UserPrincipal,
    //     status: Text) : async Result<PictureProfile, Error> {
        
    //     let current_time = Time.now();
    //     let createdBy = Principal.toText(msg.caller);
    //     let newStatus = Utils.textToPictureStatus(status);

    //     let picInfo: PictureProfile = {
    //         picId = picId;
    //         pic = pic;
    //         picName = picName;
    //         description = description;
    //         owner = owner;
    //         status = newStatus;
    //         createdBy = createdBy;
    //         createdAt = current_time;
    //     };

    //     let (newPics, _) = pictureRepository.updatePic(stablePics, picInfo);

    //     stablePics := newPics;

    //     #ok(picInfo)
            
    // };

    /// deletePic() 公共的删除图片接口 需要和前端确认数据格式
    /// Args:
    ///     |picId|    需要修改的图片数据
    /// Returns:
    ///     删除成功返回对应图片id的图片信息的#ok(PictureProfile),出错返回相应错误
    // public shared(msg) func deletePic(picId: PictureId) : async Result<PictureProfile, Error> {
    //     let (newPics, deletedPic) = pictureRepository.deletePic(stablePics, picId);
    //     stablePics := newPics;

    //     Debug.print("pic id: " # Nat.toText(picId) # " already deleted!");

    //     switch (deletedPic) {
    //         case (?picInfo) {
                
    //             #ok(picInfo)
    //         };
    //         case _ #err(#picNotFound);
    //     }
    
    // };
  
    /// Test method 测试保存数据,并读取
    // public shared(msg) func testCreateAndGet() {
    //     let pic: Picture = {
    //         content = Text.encodeUtf8("23dsfdsdfadsdsdfd80sfsfsds");
    //         fileType = "jpg";
    //     };
    //     let owner = "James";
    //     let description = "Test pic";
    //     let picName = "James Photo";

    //     let picIdRes = await createPic(pic, picName, description, owner);
        
    //     assert(Result.isOk(picIdRes));

    //     switch (picIdRes) {
    //         case (#ok(picId)) {
    //             Debug.print("The pic id: " # Nat.toText(picId));
    //             let  picInfo = await getPictureProfile(picId);

    //             Result.assertOk(picInfo);
    //             let pp = Option.flatten(Result.toOption(picInfo));
    //             Option.assertSome(pp);

    //             switch (pp) {
    //                 case (?info) {
    //                     assert(info.owner == owner);
    //                     assert info.description == description;
    //                     assert info.picName == picName;
    //                     assert info.pic == pic;
    //                 };
    //                 case (_) {
    //                     Debug.print("Get Pic " # Nat.toText(picId) # " happen error " );
    //                     assert false;                  
    //                 };

    //             }
    //         };
    //         case (#err(_)) {
    //             Debug.print("Create Pic happen error ");
    //                     assert false; 
    //         };
    //     }
    // };

    /// 获取当前的id，并对id+1,这是有size effects的操作
    func getIdAndIncrementOne() : Nat {
        let id = idGenerator;
        idGenerator += 1;
        id
    };

    private func extractQueryString(str : Text) : Text {
        let querystring = Text.split(str, #char '?');
        ignore querystring.next(); 
        Utils.getOrEmptyText(querystring.next()) 
    };

    /// 查询图片的http接口,通过url中的querystring方式,picId的值为要指定查询的图片id,http method为GET
    /// e.g. http://localhost:8000?canisterId=qaa6y-5yaaa-aaaaa-aaafa-cai&picId=10001 或
    /// e.g. https://mld4k-aqaaa-aaaai-qakeq-cai.raw.ic0.app/?picId=10001
    /// 响应头返回图片格式:Content-Type: image/png(或上传文件时指定的图片格式)
    /// 响应头默认缓存设置: Cache-Control: max-age=86400 (1天)
    /// 响应体是图片对应的的Blob
    public query func http_request(req: HttpRequest) : async HttpResponse {
        let querystring = extractQueryString(req.url);
        Debug.print("querystring is : " # querystring);

        var picIdStr = "";
        let contents = Text.split(querystring, #char '&');
        
        for (c in contents) {
            let cc = Text.split(c, #char '=');
            if (cc.next() == ?"picId") {
                picIdStr := Utils.getOrEmptyText(cc.next());
            };
        };

        let picIdOpt = Utils.textToNat(picIdStr);

        var body: Blob = Text.encodeUtf8("");
        var statusCodeOk : Nat16 = 200; // 200表示ok
        var maxAgeSeconds = "864000"; //表示过期为一天
        var fileType = "image/png";
        switch (picIdOpt) {
            case (?id) { 
                let picOpt = pictureRepository.getPicture(stablePics, id);
                switch (picOpt) {
                    case (?pic) {
                        body := pic.content;
                        fileType := pic.fileType;
                    };
                    case (null) { 
                        statusCodeOk := 404; // 404表示没找到notFound
                        maxAgeSeconds := "60"   // 没找到缓存调协1分钟
                    };
                }
             };
            case (null) { 
                statusCodeOk := 400;     // 400表示请求有问题,badRequest
                maxAgeSeconds := "10"    // 请求有问题设置缓存10秒
            };
        };

        // 响应缓存设置
        let headers = [("Cache-Control", "max-age=" # maxAgeSeconds), ("Content-Type", fileType)];

        return {
            body = body;
            headers = headers;
            status_code = statusCodeOk;
            streaming_strategy = null;
        };
    };

    /// For http_request
    public type HttpRequest = {
        body: Blob;
        headers: [HeaderField];
        method: Text;
        url: Text;
    };

    public type StreamingCallbackToken =  {
        content_encoding: Text;
        index: Nat;
        key: Text;
        sha256: ?Blob;
    };
    public type StreamingCallbackHttpResponse = {
        body: Blob;
        token: ?StreamingCallbackToken;
    };
    public type ChunkId = Nat;

    public type Path = Text;
    public type Key = Text;

    public type HttpResponse = {
        body: Blob;
        headers: [HeaderField];
        status_code: Nat16;
        streaming_strategy: ?StreamingStrategy;
    };

    public type StreamingStrategy = {
        #Callback: {
            callback: query (StreamingCallbackToken) ->
            async (StreamingCallbackHttpResponse);
            token: StreamingCallbackToken;
        };
    };

    public type HeaderField = (Text, Text);
};
