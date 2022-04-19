
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";

import Types "../base/Types";

module {

    public type Picture = Types.Picture;
    public type StatusEnum = Types.StatusEnum;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;

    public type BountyId = Types.Id;

    /// 赏金
    public type BountyProfile = {
        id: BountyId;
        sortId: Nat;
        name: Text;
        bonus: [Bonus];
        logo: Picture;
        description: Text;
        disclaimer: Text;
        owner: UserPrincipal;
        status: StatusEnum;
        createdBy: UserPrincipal;
        createdAt: Timestamp;
    };

    public type BonusType = Text;
    public type Bonus = {
        bonusType: BonusType;
        amount: Nat;
    };

    public let bountyEq = Nat.equal;
    public let bountyHash = Hash.hash;

}