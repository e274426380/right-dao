
import Hash "mo:base/Hash";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Order "mo:base/Order";

import Types "../base/Types";
import Constants "../constant/Constants";

/// 记录,用于留言,荣誉,徽章等,可以做为nft元数据
module {

    public type ApplyingMetadata = {
        targetId: Types.Id;     
        amount: Nat;
        description: Text;
        category: Text;
    };

    public type CommentMetadata = {
        targetId: Types.Id;
        content: Text;
        category: Text;
    };

    public type Payload = {
        #comment: CommentMetadata;
        #pic: Types.Picture;
        #voting: VotingMetadata;
        #applying: ApplyingMetadata;
    };

    // public type Payload = Text;
    public type RecordingId = Types.Id;
    public type RecordingProfile = {
        id: RecordingId;
        payload: Payload;
        creator: UserPrincipal;
        visibility: Visibility;
        status: StatusEnum;
        createdAt: Timestamp;
        updatedBy: UserPrincipal;
        updatedAt: Timestamp;
    };

    public type StatusEnum = Types.StatusEnum;
    public type Timestamp = Types.Timestamp;
    public type UserPrincipal = Types.UserPrincipal;
    public type Visibility = {
        #pub;
        #user : [UserPrincipal];
        #self;
    };

    public type VotingMetadata = {
        targetId: Types.Id;     // e.g. ActivityId
        relId: Types.Id;        // e.g. ProjectId
        amount: Nat;
        category: Text;
    };

    public type ProjectCommentCreateRequest = {
        projectId: Types.Id;
        content: Text
    };

    public type ActivityProjectVotingCreateRequest = {
        activityId: Types.Id;
        projectId: Types.Id;
        amount: Nat;
    };

    public func createProjectCommentToRecording(c: ProjectCommentCreateRequest, id: RecordingId, creator: UserPrincipal, createdAt: Timestamp) : RecordingProfile {
        let comment = {targetId = c.projectId; content = c.content; category = Constants.CATEGORY_PROJECT};
        {
            id = id;
            payload = #comment comment;
            creator = creator;
            visibility = #pub;
            status = Constants.STATUS_ENABLE;
            createdAt = createdAt;
            updatedBy = creator;
            updatedAt = createdAt;
        }
    };

    public func createActivityProjectVotingToRecording(c: ActivityProjectVotingCreateRequest, id: RecordingId, creator: UserPrincipal, createdAt: Timestamp) : RecordingProfile {
        let voting = {targetId = c.activityId; relId = c.projectId; amount = c.amount; category = Constants.CATEGORY_ACTIVITY};
        {
            id = id;
            payload = #voting voting;
            creator = creator;
            visibility = #pub;
            status = Constants.STATUS_ENABLE;
            createdAt = createdAt;
            updatedBy = creator;
            updatedAt = createdAt;
        }
    };

    public func deletingRecordingProfile(profile: RecordingProfile, updatedBy: UserPrincipal, updatedAt: Timestamp) : RecordingProfile {
        {
            id = profile.id;
            payload = profile.payload;
            creator = profile.creator;
            visibility = profile.visibility;
            status = Constants.STATUS_DELETED;
            createdAt = profile.createdAt;
            updatedBy = updatedBy;
            updatedAt = updatedAt;
        }
    };

    /// 辅助方法 Redording.equal
    public let recordingEq = Nat.equal;
    public let recordingHash = Hash.hash;

    /// 根据创建者,创建时间,记录类型创建过滤函数
    public func isCreatorAndIncludeTime(creator: UserPrincipal, startTime: Timestamp, endTime: Timestamp, determineRecordingType: RecordingProfile -> Bool) : (RecordingId, RecordingProfile) -> Bool {
        func isCreatorAndInclude(recordingId: RecordingId, recordingProfile: RecordingProfile) : Bool {
            determineRecordingType(recordingProfile) and recordingProfile.creator == creator and recordingProfile.createdAt >= startTime and 
                recordingProfile.createdAt <= endTime and isRecordingEnable(recordingProfile)
        };

        isCreatorAndInclude
    };

    /// 根据创建时间,评论类型创建过滤函数
    public func isDeletingProjectComment(startTime: Timestamp, endTime: Timestamp) : (RecordingId, RecordingProfile) -> Bool {
        func isDeletingAndInclude(recordingId: RecordingId, recordingProfile: RecordingProfile) : Bool {
            isComment(recordingProfile) and recordingProfile.createdAt >= startTime and 
                recordingProfile.createdAt <= endTime and isRecordingDeleted(recordingProfile)
        };

        isDeletingAndInclude
    };

    /// 判断RecordingProfile是否匹配指定的TargetId
    public func isMatchTargetId(targetId: Types.Id, determineRecordingType: RecordingProfile -> Bool) : (RecordingId, RecordingProfile) -> Bool {
        func isMatchTargetId_(recordingId: RecordingId, profile: RecordingProfile) : Bool{
            determineRecordingType(profile) and (switch (profile.payload) {
                case (#comment c) c.targetId == targetId;
                case (#voting v) v.targetId == targetId;
                case (#applying a) a.targetId == targetId;
                case (_) false;
            }) and isRecordingEnable(profile)
        };
        isMatchTargetId_
        
    };

    /// 判断RecordingProfile是否符合指定的Payload类型
    // public func isMatchProjectAndPayload(projectId: Types.Id, determineRecordingType: RecordingProfile -> Bool) : (RecordingId, RecordingProfile) -> Bool {
    //     isMatchTargetId(projectId, determineRecordingType)
    // };

    /// 判断RecordingProfile是否符合指定的Project Comment
    public func isMatchProjectComment(projectId: Types.Id) : (RecordingId, RecordingProfile) -> Bool {
        isMatchTargetId(projectId, isComment)
    };

    /// 判断RecordingProfile是否对项目的投票,包括黑客松活动中项目的投票
    public func isMatchProjectVoting(projectId: Types.Id) : (RecordingId, RecordingProfile) -> Bool {
        func isProjectVoting_(rid: RecordingId, rp: RecordingProfile) : Bool {
            switch (rp.payload) {
                case (#voting v) { 
                    if (v.category == Constants.CATEGORY_PROJECT and v.targetId == projectId) {
                        true
                    } else if (v.category == Constants.CATEGORY_ACTIVITY and v.relId == projectId) {
                        true
                    } else false
                };
                case _ { false };
            }
        };

        isProjectVoting_       
    };

    /// 按创建时间倒序
    public func compareByCreateTimeDesc(profile1: RecordingProfile, profile2: RecordingProfile) : Order.Order {
        Int.compare(profile2.createdAt, profile1.createdAt)
    };

    /// 按更新时间倒序
    public func compareByUpdateTimeDesc(profile1: RecordingProfile, profile2: RecordingProfile) : Order.Order {
        Int.compare(profile2.updatedAt, profile1.updatedAt)
    };

    /// 判断RecordingProfile是否可用
    public func isRecordingEnable(recordingProfile: RecordingProfile) : Bool {
        recordingProfile.status == Constants.STATUS_ENABLE
    };

    /// 判断RecordingProfile是否已删除
    public func isRecordingDeleted(recordingProfile: RecordingProfile) : Bool {
        recordingProfile.status == Constants.STATUS_DELETED
    };

    /// 判断RecordingProfile是否Comment
    public func isComment(profile: RecordingProfile) : Bool {
        switch (profile.payload) {
            case (#comment msg) { true };
            case _ { false };
        }
    };

    /// 判断RecordingProfile是否投票
    public func isVoting(profile: RecordingProfile) : Bool {
        switch (profile.payload) {
            case (#voting _) { true };
            case _ { false };
        }
    };

    /// 判断RecordingProfile是否申请
    public func isApplying(profile: RecordingProfile) : Bool {
        switch (profile.payload) {
            case (#applying _) { true };
            case _ { false };
        }
    };

};