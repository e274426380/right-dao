
use candid::{CandidType, Deserialize, Principal};
use std::collections::BTreeMap;
use std::iter::FromIterator;

use crate::env::{Environment, CanisterEnvironment, EmptyEnvironment};

use crate::post::domain::PostId;
use crate::user::UserService;
use crate::user::domain::UserProfile;

use crate::post::{
    PostService,
    domain::PostProfile,
};

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct DaoDataStorage {
    pub id: u64,
    pub users: Vec<UserProfile>,
    pub posts: Vec<PostProfile>,
}

impl From<DaoContext> for DaoDataStorage {
    fn from(state: DaoContext) -> Self {
        let id = state.id;
        let users = Vec::from_iter(state.user_service.users
            .iter()
            .map(|(_k, v)| (v.clone())));
        let posts = Vec::from_iter(state.post_service.posts
            .iter()
            .map(|(_k, v)| (v.clone())));   

        Self {
            id,
            users,
            posts,
        }
    }
}

pub struct DaoContext {
    pub env: Box<dyn Environment>,
    pub id: u64,
    pub user_service: UserService,
    pub post_service: PostService,
}

impl Default for DaoContext {
    fn default() -> Self {
        Self {
            env: Box::new(EmptyEnvironment {}),
            id: 10001,
            user_service: UserService::default(),
            post_service: PostService::default(),
        }
    }
}

impl From<DaoDataStorage> for DaoContext {
    fn from(payload: DaoDataStorage) -> Self {
        let users: BTreeMap<Principal, UserProfile> = payload
            .users
            .into_iter()
            .map(|u| (u.owner, u))
            .collect();
        let posts: BTreeMap<PostId, PostProfile> = payload
            .posts
            .into_iter()
            .map(|p| (p.id, p))
            .collect();

        Self {
            env: Box::new(CanisterEnvironment {}),
            id: payload.id,
            user_service: UserService { users },
            post_service: PostService { posts },
        }
    }
}

#[cfg(test)]
mod tests {
    
}
