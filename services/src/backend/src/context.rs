
use candid::{CandidType, Deserialize, Principal};
use std::collections::BTreeMap;
use std::iter::FromIterator;

use crate::env::{Environment, CanisterEnvironment, EmptyEnvironment};

use crate::post::domain::PostId;
use crate::reputation::ReputationService;
use crate::reputation::domain::{ReputationSummary, ReputationEvent};
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
    pub reputation_summaries: Vec<ReputationSummary>,
    pub reputation_events: Vec<ReputationEvent>,
}

impl From<DaoContext> for DaoDataStorage {
    fn from(context: DaoContext) -> Self {
        let id = context.id;
        let users = Vec::from_iter(context.user_service.users
            .iter()
            .map(|(_k, v)| v.clone()));
        let posts = Vec::from_iter(context.post_service.posts
            .iter()
            .map(|(_k, v)| v.clone()));   
        let reputation_summaries = Vec::from_iter(context.reputation_service.summaries
            .iter()
            .map(|(_, summary)| summary.clone())
        );
        let reputation_events = Vec::from_iter(context.reputation_service.events
            .iter()
            .map(|(_, event)| event.clone())
        );
        Self {
            id,
            users,
            posts,
            reputation_summaries,
            reputation_events
        }
    }
}

pub struct DaoContext {
    pub env: Box<dyn Environment>,
    pub id: u64,
    pub user_service: UserService,
    pub post_service: PostService,
    pub reputation_service: ReputationService,
}

impl Default for DaoContext {
    fn default() -> Self {
        Self {
            env: Box::new(EmptyEnvironment {}),
            id: 10001,
            user_service: UserService::default(),
            post_service: PostService::default(),
            reputation_service: ReputationService::default(),
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

        let reputation_summaries: BTreeMap<Principal, ReputationSummary> = payload
            .reputation_summaries
            .into_iter()
            .map(|summary| (summary.user, summary))
            .collect();

        let reputation_events: BTreeMap<u64, ReputationEvent> = payload
            .reputation_events
            .into_iter()
            .map(|event| (event.id, event))
            .collect();

        Self {
            env: Box::new(CanisterEnvironment {}),
            id: payload.id,
            user_service: UserService { users },
            post_service: PostService { posts },
            reputation_service: ReputationService { summaries: reputation_summaries, events: reputation_events },
        }
    }
}

#[cfg(test)]
mod tests {
    
}
