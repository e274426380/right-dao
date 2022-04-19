
import Types "../base/Types";

module {
    public type BannerId = Types.Id;
    public type UserPrincipal = Types.UserPrincipal;

    public type Timestamp = Int;
    public type BannerCategory = Text;
    public type BannerProfile = {
        id: BannerId;
        pictureUri: Text;
        bannerCategory: BannerCategory;
        outerUri: Text;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };
    
}