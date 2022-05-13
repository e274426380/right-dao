use std::{
    collections::VecDeque, 
    string::ParseError, 
    str::FromStr
};

use candid::{CandidType, Deserialize, Principal};



// #[derive(Debug, Clone, Copy, CandidType, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
// pub struct PostId(u64);

// impl From<u64> for PostId {
//     fn from(id: u64) -> Self {
//         Self(id)
//     }
// }
pub type PostId = u64;
pub type Timestamp = u64;

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostProfile {
    pub id: PostId,
    pub author: Principal,
    pub title: String,
    pub content: RichText,
    pub category: Category,
    pub photos: Vec<u64>,
    pub participants: Vec<String>,
    pub end_time: Option<Timestamp>,
    pub likes_count: u64,
    pub ask_for_money: Currency,
    pub events: VecDeque<PostEvent>,
    pub status: PostStatus,
    pub created_at: Timestamp,
    pub updated_at: Timestamp,
    pub comments: Vec<PostComment>,
}

impl PostProfile {
    pub fn new(id: u64, author: Principal, title: String, content: RichText, category: Category, photos: Vec<u64>, participants: Vec<String>, end_time: Option<Timestamp>, status: PostStatus, created_at: Timestamp) -> Self {
        Self {
            id,
            author,
            title,
            content,
            category,
            photos,
            participants,
            end_time,
            likes_count: 0,
            ask_for_money: Currency::default(),
            events: VecDeque::new(),
            status,
            created_at,
            updated_at: created_at,
            comments: vec![]
        }
    }

    pub fn is_active(&self) -> bool {
        self.status == PostStatus::Enable
    }
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub struct RichText {
    pub content: String,
    pub format: String,
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum  Category {
    Tech,
    Law,
    Other,
}   

impl FromStr for Category {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "law" => Ok(Category::Law),
            "tech" => Ok(Category::Tech),
            _ => Ok(Category::Other)
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum PostStatus {
    Enable,
    Completed,
    Closed,
}

impl FromStr for PostStatus {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "completed" => Ok(PostStatus::Completed),
            "closed" => Ok(PostStatus::Closed),
            _ => Ok(PostStatus::Enable),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub struct Currency {
    pub amount: u64,
    pub unit: CurrencyUnit,
    pub decimals: u8,
}

#[derive(Debug, Clone, PartialEq, Eq, CandidType, Deserialize)]
pub enum CurrencyUnit {
    USDT,
    ICP,
    BTC,
    ETH,
}

impl Default for Currency {
    fn default() -> Self {
        Self {
            amount: 0,
            unit: CurrencyUnit::ICP,
            decimals: 8,
        }
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostEvent {
    post_id: u64,
    event_time: Timestamp,
    description: String,
    author: Principal,
    created_at: Timestamp,
}

impl PostEvent {
    pub fn new(post_id: u64, event_time: Timestamp, description: String, author: Principal, created_at: Timestamp) -> Self {
        Self {
            post_id,
            event_time,
            description, 
            author,
            created_at
        }
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum EventStatus {
    Enable,
    Disable,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostCreateCommand {
    pub title: String,
    content: RichText,
    category: String,
    photos: Vec<u64>,
    participants: Vec<String>,
    end_time: Option<Timestamp>,
}

impl PostCreateCommand {
    pub fn build_profile(self, id: u64, owner: Principal, status: PostStatus, now: Timestamp) -> PostProfile {
        PostProfile::new(id, owner, self.title, self.content, self.category.parse::<Category>().unwrap(), self.photos, self.participants, self.end_time, status, now)
    }

}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostEditCommand {
    pub id: u64,
    title: String,
    content: RichText,
    category: String,
    photos: Vec<u64>,
    participants: Vec<String>,
    end_time: Option<Timestamp>,
    status: PostStatus,
}

impl PostEditCommand {
    pub fn merge_profile(self, profile: &mut PostProfile) {
        assert!(self.id == profile.id);

        profile.title = self.title;
        profile.content = self.content;
        profile.category = self.category.parse::<Category>().unwrap();
        profile.photos = self.photos;
        profile.participants = self.participants;
        profile.end_time = self.end_time;
        profile.status = self.status;
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostIdCommand {
    pub id: u64,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostChangeStatusCommand {
    pub id: u64,
    pub status: String,
    pub description: String,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostPage {
    pub data: Vec<PostProfile>,
    pub page_size: usize,
    pub page_num: usize,
    pub total_count: usize,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostPageQuery {
    pub page_size: usize,
    pub page_num: usize,
    pub querystring: String,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostComment {
    pub id: u64,
    pub post_id: u64,
    pub comment_id: Option<u64>,
    pub content: RichText,
    pub author: Principal,
    pub status: CommentStatus,
    pub created_at: Timestamp,
    pub updated_at: Timestamp,
    pub comments: Vec<PostComment>,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum CommentStatus {
    Enable,
    Disable,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostCommentCommand {
    pub post_id: u64,
    pub content: RichText,
}

impl PostCommentCommand {
    pub fn build_comment(self, id: u64, author: Principal, now: Timestamp) -> PostComment {
        PostComment {
            id,
            post_id: self.post_id,
            comment_id: None,
            content: self.content,
            author,
            status: CommentStatus::Enable,
            created_at: now,
            updated_at: now,
            comments: vec![],
        }
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct CommentCommentCommand {
    pub post_id: u64,
    pub comment_id: u64,
    pub content: RichText,
}

impl CommentCommentCommand {
    pub fn build_comment(self, id: u64, author: Principal, now: Timestamp) -> PostComment {
        PostComment {
            id,
            post_id: self.post_id,
            comment_id: Some(self.comment_id),
            content: self.content,
            author,
            status: CommentStatus::Enable,
            created_at: now,
            updated_at: now,
            comments: vec![]
        }
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostEventCommand {
    pub post_id: u64,
    pub event_time: Timestamp,
    pub description: String,
}

impl PostEventCommand {
    pub fn build_event(self, author: Principal, now: Timestamp) -> PostEvent {
        PostEvent { 
            post_id: self.post_id,
            event_time: self.event_time,
            description: self.description, 
            author,
            created_at: now,
        }
    }
}