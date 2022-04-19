
import Nat "mo:base/Nat";
import Order "mo:base/Order";

import Constants "../constant/Constants";
import Types "../base/Types";

module {

    public type SponsorId = Types.Id;
    public type StatusEnum = Types.StatusEnum;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;

    public type SponsorProfile = {
        id: SponsorId;
        name: Text;
        description: Text;
        link: Text;
        logoUri: Text;
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    public type SponsorCreateRequest = {
        name: Text;
        description: Text;
        link: Text;
        logoUri: Text;
    };

    public let sponsorEq = Types.idEq;
    public let sponsorHash = Types.idHash;

    public func createRequestToProfile(req: SponsorCreateRequest, sponsorId: SponsorId, createdBy: UserPrincipal, createdAt: Timestamp) : SponsorProfile {
        {
            id = sponsorId;
            name = req.name;
            description = req.description;
            link = req.link;
            logoUri = req.logoUri;
            status = Constants.STATUS_ENABLE;
            createdBy = createdBy;
            createdAt = createdAt;
        }
    };

    /// 按Id倒序，id越大表示越新，排在前面
    public func compareSponsorById(profile1: SponsorProfile, profile2: SponsorProfile) : Order.Order {
        Nat.compare(profile2.id, profile1.id)
    };


}