
import List "mo:base/List";
import Option "mo:base/Option";

import BannerDomain "BannerDomain";

/// Banner数据存储及访问
/// 由于Banner数据最常用的是获取最新的几条数据，所以采用List结构存储数据最高效
module {
    public type BannerId = BannerDomain.BannerId;
    public type BannerProfile = BannerDomain.BannerProfile;
    public type BannerCategory = BannerDomain.BannerCategory;
    public type BannerIdWithData = (BannerId, BannerProfile);
    public type BannerDB = List.List<BannerIdWithData>;

    public func bannerIdEq(b1: BannerId, b2: BannerId) : Bool {
        b1 == b2
    };

    public func insert(bannerdb: BannerDB, bm: BannerProfile) : BannerDB {
        List.push<BannerIdWithData>((bm.id, bm), bannerdb)
    };

    public func delete(bannerdb: BannerDB, bid: BannerId) : BannerDB {
        List.filter<BannerIdWithData>(bannerdb, func (idWithData: BannerIdWithData) : Bool { idWithData.0 != bid })
    };

    public func findOne(bannerdb: BannerDB, bid: BannerId) : ?BannerProfile {    
        Option.map<BannerIdWithData, BannerProfile>(
            List.find<BannerIdWithData>(bannerdb, func (idWithData: BannerIdWithData) : Bool { idWithData.0 == bid }),
            func (idWithData: BannerIdWithData) : BannerProfile { idWithData.1 }
        )
    };

    public func getNewer(bannerdb: BannerDB, num: Nat, category: BannerCategory) : [BannerIdWithData] {
        let filtered = List.filter<BannerIdWithData>(bannerdb, func (id, data) : Bool { data.bannerCategory == category });
        let newers = List.take<BannerIdWithData>(filtered, num);
        List.toArray<BannerIdWithData>(newers)
    };
}