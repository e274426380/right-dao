
use candid::Principal;
use ic_cdk_macros::query;

use crate::CONTEXT;

use super::{error::ReputationError, domain::{ReputationSummary, ReputationGetQuery}};

#[query] 
pub fn my_reputation() -> Result<ReputationSummary, ReputationError> {
    CONTEXT.with(|c| {
        let ctx = c.borrow();
        let caller = ctx.env.caller();
        ctx.reputation_service.get_reputation(&caller).ok_or(ReputationError::ReputationNotFound)
    })
}

#[query] 
pub fn get_reputation(q: ReputationGetQuery) -> Result<ReputationSummary, ReputationError> {
    CONTEXT.with(|c| {
        let ctx = c.borrow();
        let user = q.user;
        match Principal::from_text(user) {
            Ok(u) => ctx.reputation_service.get_reputation(&u).ok_or(ReputationError::ReputationNotFound),
            _ => Err(ReputationError::ReputationNotFound)
        }
      
    })
}