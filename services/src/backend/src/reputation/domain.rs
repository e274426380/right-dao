
use candid::{CandidType, Deserialize, Principal};

/// 用户声望值，每个用户拥有声望累计总额，在平台进行各种 action 事件会产生声望值
/// 发贴时，用户会获取 2 点 声望；回帖时，回帖人和帖子的 owner 各获取 1 声望
#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct ReputationSummary {
    pub user: Principal,
    pub amount: u64,

}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum ReputationCommand {
    RegisterUserCommand,
    PublishPostCommand,
    ReplyPostCommand,
    ReplyCommentCommand,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct ReputationEvent {
    pub id: u64,
    pub operator: Principal,
    pub action: Action,
    pub amount: u64,
    pub created_at: u64,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum Action {
    RegisterUser,
    PublishPost,
    ReplyPost,
    ReplyComment,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct ReputationGetQuery {
    pub user: String,
}