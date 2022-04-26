
use ic_cdk_macros::update;
use crate::CONTEXT;

use super::{domain::PostCreateCommand, error::PostError};
use crate::guard::has_user_guard;

#[update(guard = "has_user_guard")] 
fn create_post(cmd: PostCreateCommand) -> Result<u64, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let id = ctx.id;
        let caller = ctx.env.caller();
        let now = ctx.env.now();
        match ctx.post_service.create_post(cmd, id, caller, now) {
            Some(_) => {
                ctx.id += 1;    // id addOne
                Ok(id)
            },
            None => Err(PostError::PostAlreadyExists),
        }
    })
}