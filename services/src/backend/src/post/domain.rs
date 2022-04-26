use candid::{CandidType, Deserialize, Principal};



#[derive(Debug, Clone, Copy, CandidType, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
pub struct PostId(u64);

impl From<u64> for PostId {
    fn from(id: u64) -> Self {
        Self(id)
    }
}

pub type Timestamp = u64;

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub struct PostProfile {
    pub id: PostId,
    pub owner: Principal,
    pub title: String,
    pub content: RichText,
    pub category: Category,
    pub photos: Vec<u64>,
    pub participants: Vec<String>,
    pub end_time: Option<Timestamp>,
    pub status: PostStatus,
    pub created_at: Timestamp,
    pub updated_at: Timestamp,
}

impl PostProfile {
    pub fn new(id: u64, owner: Principal, title: String, content: RichText, category: Category, photos: Vec<u64>, participants: Vec<String>, end_time: Option<Timestamp>, status: PostStatus, created_at: Timestamp) -> Self {
        Self {
            id: PostId(id),
            owner,
            title,
            content,
            category,
            photos,
            participants,
            end_time,
            status,
            created_at,
            updated_at: created_at,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub struct RichText {
    pub text: String,
    pub format: String,
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum  Category {
    Tech,
    Law,

}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum PostStatus {
    Enable,
    Completed,
    Terminated,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostCreateCommand {
    pub title: String,
    content: RichText,
    category: Category,
    photos: Vec<u64>,
    participants: Vec<String>,
    end_time: Option<Timestamp>,
}

impl PostCreateCommand {
    pub fn build_profile(self, id: u64, owner: Principal, status: PostStatus, now: Timestamp) -> PostProfile {
        PostProfile::new(id, owner, self.title, self.content, self.category, self.photos, self.participants, self.end_time, status, now)
    }

}