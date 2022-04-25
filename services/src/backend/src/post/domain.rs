use candid::{CandidType, Deserialize, Principal};



#[derive(Debug, Clone, CandidType, Deserialize, PartialEq, Eq)]
pub struct PostId(u64);

pub type Timestamp = u64;

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub struct PostProfile {
    id: PostId,
    owner: Principal,
    title: String,
    content: String,
    category: Category,
    participants: Vec<String>,
    end_time: Option<Timestamp>,
    created_at: Timestamp,
    updated_at: Timestamp,
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum  Category {
    // r技术
    Tech,
    Law,

}