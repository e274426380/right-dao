import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Order "mo:base/Order";

import GrantDomain "../grant/GrantDomain";
import ProjectDomain "../project/ProjectDomain";
import Types "../base/Types";

module {

    public type UserPrincipal = Types.UserPrincipal;
    public type GrantId = GrantDomain.GrantId;
    public type ProjectId = ProjectDomain.ProjectId;
    public type RoleId = UserPrincipal;
    public type Timestamp = Types.Timestamp;

    public type RoleProfile = {
        id: UserPrincipal;
        role: Role;
        authorizationTime: Timestamp;
    };

    /// Role for a caller into the service API.
    /// Common case is #user.
    public type Role = {
        // caller is the admin
        #admin;
        // caller is a user
        #user;       
        // caller is not yet a user; just a guest
        #guest
    };

    public let roleEq = Types.userEq;
    public let roleHash = Types.userHash;

    public func newAdminRoleProfile(user: UserPrincipal) : RoleProfile {
        newRoleProfile(user, #admin, 0)
    };

    public func newRoleProfile(user: UserPrincipal, role: Role, authorizationTime: Timestamp) : RoleProfile {
        {
            id = user;
            role = role;
            authorizationTime = authorizationTime;
        }
    };

    public func roleOrderByAuthorizationTime(profile1: RoleProfile, profile2: RoleProfile) : Order.Order {
        Int.compare(profile2.authorizationTime, profile1.authorizationTime)
    };

    public func roleToText(role: Role) : Text {
        switch (role) {
            case (#admin)  "admin";
            case (#user) "user";
            case (#guest) "guest";
        }
    };

    /// Action is an API call classification for access control logic.
    public type UserAction = {
        /// Create a new record.
        #create;
        /// Update an existing profile, or add to its videos, etc.
        #update;
        /// View an existing profile, or its videos, etc.
        #view;
        /// Admin action, e.g., getting a dump of logs, etc
        #admin
    };

    public func userActionToText(ua: UserAction) : Text {
        switch (ua) {
            case (#create) "create";
            case (#update) "update";
            case (#view) "view";
            case (#admin) "admin";
        }
    };

    public func textToUserAction(t: Text) : UserAction {
        if (t == "admin") {
            #admin
        } else if (t == "create") {
            #create
        } else if (t == "update") {
            #update
        } else {
            #view
        }
    };

    /// An ActionTarget identifies the target of a UserAction.
    public type ActionTarget = {
        /// User's profile or dapp are all potential targets of action.
        #user : UserPrincipal ;
        /// Exactly one app is the target of the action.
        #project : ProjectId ;
        /// 评论项目
        #commentProject: ProjectId;
        /// Hackathon
        // #hackathon : HackathonId;
        /// Grant
        #grant : GrantId;
        /// Everything is a potential target of the action.
        #all;
        /// Everything public is a potential target (of viewing only)
        #pubView
    };

    public func actionTargetToText(at: ActionTarget) : Text {
        switch (at) {
            case (#user up) "user: " # up ;
            case (#pubView) "pubView";
            case (#all) "all";
            case (#project projectId) "projectId: " # Nat.toText(projectId);
            case (#commentProject projectId) "commentProject: " # Nat.toText(projectId);
            case (#grant grantId) "grantId: " # Nat.toText(grantId);
        }
    };

    // public func roleEq(r1 : Role, r2 : Role) : Bool {
    //     r1 == r2
    // };

    public func roleMax(r1 : Role, r2 : Role) : Role {
        switch (r1, r2) {
            case (#admin, _) { #admin };
            case (_, #admin) { #admin };
            case (#user, #user) { #user };
            case (#user, #guest) { #user };
            case (#guest, #user) { #user };
            case (#guest, #guest) { #guest };
        }
    };

    // public func roleHash(r : Role) : Hash.Hash {
    //     switch r {
    //         case (#guest) 0;
    //         case (#user) 1;
    //         case (#admin) 100;
    //     };
    // };
};
