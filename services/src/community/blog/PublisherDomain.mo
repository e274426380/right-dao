
import Int "mo:base/Int";
import Order "mo:base/Order";

import Types "../base/Types";

module {

    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;

    public type PublisherProfile = {
        id: UserPrincipal;
        authorizationTime: Timestamp;
    };

    /// 给用户授权发布博客权限命令
    public type PublisherAssignCommand = {
        user: UserPrincipal;
    };

    public func newPublisher(user: UserPrincipal, authorizationTime: Timestamp) : PublisherProfile {
        {
            id = user;
            authorizationTime = authorizationTime;
        }
    };

    public func publisherOrderByAuthorizationTime(profile1: PublisherProfile, profile2: PublisherProfile) : Order.Order {
        Int.compare(profile2.authorizationTime, profile1.authorizationTime)
    };

}