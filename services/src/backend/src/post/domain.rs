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
            status,
            created_at,
            updated_at: created_at,
            comments: vec![]
        }
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

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostEditCommand {
    pub id: u64,
    title: String,
    content: RichText,
    category: Category,
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
        profile.category = self.category;
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
    pub query: String,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostComment {
    pub post_id: u64,
    pub content: RichText,
    pub author: Principal,
    pub created_at: Timestamp,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct PostCommentCommand {
    pub post_id: u64,
    pub content: RichText,
}

impl PostCommentCommand {
    pub fn build_comment(self, author: Principal, now: Timestamp) -> PostComment {
        PostComment {
            post_id: self.post_id,
            content: self.content,
            author,
            created_at: now,
        }
    }
}