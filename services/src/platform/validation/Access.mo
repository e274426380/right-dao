
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

import Global "../state/Global";
import HashMapRepositories "../repositories/HashMapRepositories";
import ProjectRepositories "../project/ProjectRepositories";
import RoleDomain "../validation/RoleDomain";
import Rel "../base/Rel";
import RelObj "../base/RelObj";
import Types "../base/Types";
import UserDomain "../user/UserDomain";
import UserRepositories "../user/UserRepositories";

module {

    type Cache<X, Y> = HashMapRepositories.HashMapCache<X, Y>;

    type Id = Types.Id;
    type UserPrincipal = Types.UserPrincipal;

    type Role = RoleDomain.Role;
    type Rel<X, Y> = RelObj.RelObj<X, Y>;
    type RelShared<X, Y> = Rel.RelShared<X, Y>;

    public type GlobalCache = Global.GlobalCache;
    public type ProjectCache = ProjectRepositories.ProjectCache;
    public type RoleCache = Cache<UserPrincipal, Role>;
    public type UserCache = UserRepositories.UserCache;

    public type IdOwner = {
        id: Id;
        owner: UserPrincipal
    };

    /// Access control log stores all of the checks and their outcomes,
    // e.g., for debugging and auditing security.
    public module Log {
        public module Check {
            /// An access check consists of a caller, a username and a user action.
            public type Check = {
                caller : UserPrincipal;
                role : Role;
                userAction : RoleDomain.UserAction;
                actionTarget : RoleDomain.ActionTarget
            };
        };

        public module Event {
            /// An access event is an access control check, its calling context, and its outcome.
            public type Event = {
                time : Int; // using mo:base/Time and Time.now() : Int
                check : Check.Check;
                isOk : Bool;
            };

            public func equal(x:Event, y:Event) : Bool { x == y };
        };

    };

    public type AccessEvent = Log.Event.Event;

    public func accessEventToText(event: AccessEvent) : Text {
        Int.toText(event.time) # " -- " # checkToText(event.check) # " -- " # Bool.toText(event.isOk)
    };

    public func checkToText(c: Log.Check.Check) : Text {
         c.caller # " -- " # RoleDomain.roleToText(c.role) # " -- " # RoleDomain.userActionToText(c.userAction) # 
          " -- " # RoleDomain.actionTargetToText(c.actionTarget)
    };


    public class Access() {

        // let admins_ : HashSet<UserPrincipal> = HashMapRepositories.valueDBToHashSet(admins);

        // public func getAdmins(globalCache: GlobalCache) : [UserPrincipal] {
        //     // Iter.toArray<UserPrincipal>(
        //     //     Iter.map<(UserPrincipal, RoleProfile), UserPrincipal>(
        //     //         globalCache.adminCache.entries(), func (u) : (UserPrincipal) { u.0 }
        //     //     )
        //     // )
        //     HashMapRepositories.cacheToKeyDB<UserPrincipal, RoleProfile>(globalCache.adminCache)
        // };

        /// Get the maximal role for a user.
        public func userMaxRole(globalCache: GlobalCache, user : UserPrincipal) : Role {
            switch (globalCache.userCache.get(user)) {
                case (?u) {
                    if (UserDomain.userIsDisabled(u)) {
                        return #guest;
                    };
                    switch (globalCache.adminCache.get(user)) {
                        case (?_) #admin;
                        case (null) #user;
                    };
                };
                case (_) #guest;
            }
            // switch ((globalCache.adminCache.get(user), globalCache.userCache.get(user))) {
            //     case ((?_, _)) { #admin };
            //     case ((null, ?_)) { #user };
            //     case _ { #guest };
            // }
        };

        public func addAdminRole(globalCache: GlobalCache, user: UserPrincipal) {
            globalCache.adminCache.put(user, RoleDomain.newRoleProfile(user, #admin, Time.now()));
        };

        public func removeAdminRole(globalCache: GlobalCache, user: UserPrincipal) {
            globalCache.adminCache.delete(user);
        };

        /// Get the maximal role for a caller,
        /// considering all possible user names associated with principal.
        // public func callerMaxRole(p : Principal) : Types.Role {
        //     if (p == admin) { #admin } else {
        //         let usernames = userPrincipal.get1(p);
        //         let userRoles = Array.map<Types.UserPrincipal, Types.Role>(usernames, userMaxRole);
        //         Array.foldLeft(userRoles, #guest, Role.max)
        //     }
        // };

        /// Perform a systematic (and logged) service-access check.
        ////
        /// `check(caller, userAction, UserPrincipal)`
        /// checks that `userAction` is permitted by the caller as `UserPrincipal`,
        /// returning `?()` if so, and `null` otherwise.
        ///
        /// This function is meant to be used as a protective guard,
        /// starting each service call, before any other CanCan service logic,
        /// (before it changes or accesses any state, to guard against unauthorized access).
        ///
        /// To audit the CanCan service for security, we need to check that this call is used
        /// appropriately in each call, and that its logic (below) is correct.
        ///
        /// the logic is as follows:
        ///
        /// First, use the current state to resolve the caller Principal
        /// to all available roles, preferring the highest access according to the ordering:
        ///
        ///       (minimal access) #guest  <  #user  < #admin (maximal access)
        ///
        /// The role #guest is for new Principals that are not recognized.
        ///
        /// Then, we apply these role-based rules:
        ///
        /// a. guest，可以浏览公开的资源，不能上传和修改任何资源
        /// b. user表示注册用户，除了拥有guest的权限外，对自己创建的资源可以修改，删除，与其他user或资源交互
        /// c. admin是超级管理员，admin拥有包含user的权限，不限于某个app，拥有全部权限 
        ///
        public func check(
            globalCache: GlobalCache,
            time_ : Int,
            caller_ : UserPrincipal,
            userAction_ : RoleDomain.UserAction,
            actionTarget_ : RoleDomain.ActionTarget,
        ) : AccessEvent {
            let operationRole = userMaxRole(globalCache, caller_);

            let canOperation = switch (operationRole) {
                case (#admin) {
                    // success; full power, and full responsibility.
                    ?()
                };
                case (#guest) {
                    // guests just create users.
                    switch (actionTarget_) { 
                        case (#pubView) ?();
                        case (#user u) { 
                            if (userAction_ == #create) ?() else null
                        };
                        case (_) (null);
                    };
                    // if(userAction_ == #create or actionTarget_ == #pubView ) { ?() }
                    // else { null }
                };
                case (#user) {
                    switch userAction_ {
                        case (#view) { ?() };
                        case (#create) { ?() };
                        case (#admin) { null };
                        case (#update) {
                            switch actionTarget_ {
                                case (#pubView) { ?() };
                                case (#all) { null };
                                case (#user i) { if (i == caller_) { ?() } else { null } };
                                case (#project projectId) { 
                                    switch (globalCache.projectCache.get(projectId)) {
                                        case (?p) {
                                            if (p.owner == caller_) ?() else null
                                        };
                                        case (null) null;
                                    }
                                };
                                case (#commentProject projectId) {
                                    if ((switch (globalCache.userBehaviourSummaryCache.get(caller_)) {
                                        case (?ubs) { 
                                            UserDomain.userHasPoint(ubs)
                                        };
                                        case (null) { false };
                                    }) or (switch (globalCache.projectCache.get(projectId)) {
                                        case (?p) {
                                            if (p.owner == caller_) true else false;
                                        };
                                        case (null) false;
                                    })) ?() else null
                                };
                                case (#grant grantId) { 
                                    // isOwner(globalCache.grantCache, grantId, caller_)
                                    switch (globalCache.grantCache.get(grantId)) {
                                        case (?g) {
                                            if (g.owner == caller_) ?() else null
                                        };
                                        case (null) null;
                                    }
                                };
                            }
                        };
                    }
                };

            };

            let accessEvent : AccessEvent = {
                time = time_;
                caller = caller_;
                isOk = canOperation == ?();
                check = { 
                    caller = caller_;
                    role = operationRole;
                    userAction = userAction_;
                    actionTarget = actionTarget_ ; 
                } 
            };
            // print all access events for debugging
            Debug.print (debug_show accessEvent);
            // recall: this log will only be saved for updates, not queries; IC semantic rules.
            // log.add(accessEvent);
            accessEvent
        };

        public func isOwner(cache: Cache<Id, {id: Id; owner: UserPrincipal}>, id: Id, owner: UserPrincipal) : ?() {
            switch (cache.get(id)) {
                case (?g) {
                    if (g.owner == owner) ?() else null
                };
                case (null) null;
            }
        }
    };
}
