
use candid::{CandidType, Deserialize, Principal};
use std::collections::BTreeMap;
use std::iter::FromIterator;

use crate::env::{Environment, CanisterEnvironment, EmptyEnvironment};

use crate::user::UserService;
use crate::user::domain::UserProfile;

#[derive(Debug, Clone, CandidType, Deserialize)]
pub struct DaoDataStarage {
    pub id: u64,
    pub users: Vec<UserProfile>
}

impl From<DaoContext> for DaoDataStarage {
    fn from(state: DaoContext) -> Self {
        let id = state.id;
        let users = Vec::from_iter(state.user_service.users
            .iter()
            .map(|(_k, v)| (v.clone())));

        Self {
            id,
            users,
        }
    }
}

pub struct DaoContext {
    pub env: Box<dyn Environment>,
    pub id: u64,
    pub user_service: UserService,
}

impl Default for DaoContext {
    fn default() -> Self {
        Self {
            env: Box::new(EmptyEnvironment {}),
            id: 10001,
            user_service: UserService::default(),
        }
    }
}

impl From<DaoDataStarage> for DaoContext {
    fn from(payload: DaoDataStarage) -> Self {
        let users: BTreeMap<Principal, UserProfile> = payload
            .users
            .into_iter()
            .map(|u| (u.owner, u))
            .collect();

        Self {
            env: Box::new(CanisterEnvironment {}),
            id: payload.id,
            user_service: UserService { users },
        }
    }
}

#[cfg(test)]
mod tests {
    
}
