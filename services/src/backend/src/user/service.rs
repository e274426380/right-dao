
use std::collections::BTreeMap;

use candid::Principal;

use super::{domain::{UserProfile, UserRegisterCommand, UserStatus, Timestamp, UserEditCommand}, error::UserError};

#[derive(Debug, Default)]
pub struct UserService {
    pub users: BTreeMap<Principal, UserProfile>,
}

impl UserService {
    pub fn register_user(&mut self, cmd: UserRegisterCommand, id: u64, caller: Principal, now: Timestamp) -> Result<Principal, UserError> {
        match self.users.get(&caller) {
            Some(_) => Err(UserError::UserAlreadyExists),
            None => {
                let user = cmd.build_profile(
                    id,
                    caller,
                    UserStatus::Enable,
                    now
                );
                if !user.valid_name() {
                    return Err(UserError::UserNameTooLong);
                }

                if !user.valid_email() {
                    return Err(UserError::UserEmailInvalid);
                }

                if !user.valid_biography() {
                    return Err(UserError::UserBiographyTooLong);
                }

                self.users.insert(
                    caller,
                    user,
                );                
                Ok(caller)
            }
        }       
    }

    pub fn is_owner(&self, caller: &Principal) -> bool {
       matches!(self.users.get(caller), Some(u) if u.owner == *caller)
    }

    pub fn get_user(&self, principal: &Principal) -> Option<UserProfile> {
        self.users.get(principal).cloned()    
    }

    pub fn edit_user(&mut self, cmd: UserEditCommand, principal: &Principal) -> Option<bool> {
        self.users.get_mut(principal).map(|profile| {
            cmd.build_profile(profile);
        }).map(|_| true)
    }

    pub fn enable_user(&mut self, principal: &Principal) -> Option<bool> {
        self.users.get_mut(principal).map(|profile| {
            profile.status = UserStatus::Enable;
        }).map(|_| true)
    }

    pub fn disable_user(&mut self, principal: &Principal) -> Option<bool> {
        self.users.get_mut(principal).map(|profile| {
            profile.status = UserStatus::Disable;
        }).map(|_| true)
    }
}