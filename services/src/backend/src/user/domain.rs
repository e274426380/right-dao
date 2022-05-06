
use candid::{CandidType, Deserialize, Principal};

pub type UserId = u64;
pub type Timestamp = u64;

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct UserProfile {
    pub id: UserId,
    pub owner: Principal,     // 用户 Principal
    pub email: String,
    pub name: String,
    pub avatar_id: u64,
    pub avatar_uri: String,
    pub biography: String,
    pub interests: Vec<String>,
    pub memo: String,
    pub status: UserStatus,
    pub created_at: Timestamp,
}

// impl Default for UserProfile {
//     fn default() -> Self {
//         Self {
//             owner: Principal::anonymous(),
//             ..Default::default()
//         }
//     }
// }

impl UserProfile {
    pub fn new(id: UserId, owner: Principal, email: String, name: String, 
            avatar_id: u64, avatar_uri: String, biography: String, interests: Vec<String>,
            memo: String, status: UserStatus, created_at: u64) -> Self {
        Self {
            id,
            owner,
            email,
            name,
            avatar_id,
            avatar_uri,
            biography,
            interests,
            memo,
            status,
            created_at,
        }
    }

    pub fn valid_name(&self) -> bool {
        self.name.chars().count() <= 20
    }

    pub fn valid_email(&self) -> bool {
        email_address::EmailAddress::is_valid(&self.email) && (self.email.chars().count() <= 50)
    }

    pub fn valid_biography(&self) -> bool {
        self.biography.chars().count() <= 120
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum UserStatus {
    Enable,
    Disable,
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct UserRegisterCommand {
    pub email: String,
    pub name: String,
    pub memo: String,
}

impl UserRegisterCommand {
    pub fn build_profile(self, id: UserId, owner: Principal, status: UserStatus, created_at: u64) -> UserProfile {
        UserProfile::new(id, owner, self.email, self.name, 0, "".to_string(), "".to_string(),
        vec![], self.memo, status, created_at)
    }
}

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct UserEditCommand {
    pub email: String,
    pub name: String,
    pub avatar_id: u64,
    pub avatar_uri: String,
    pub biography: String,
    pub interests: Vec<String>,
    pub memo: String,
    pub status: UserStatus,
}

impl UserEditCommand {
    pub fn build_profile(self, profile: &mut UserProfile) {
        profile.email = self.email;
        profile.name = self.name;
        profile.avatar_id = self.avatar_id;
        profile.avatar_uri = self.avatar_uri;
        profile.biography = self.biography;
        profile.interests = self.interests;
        profile.memo = self.memo;
        profile.status = self.status;
    }
}

