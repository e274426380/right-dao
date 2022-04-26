
use ic_cdk_macros::{update, query};
use crate::{CONTEXT, post::domain::PostStatus};
use crate::common::guard::has_user_guard;

use super::{domain::{PostCreateCommand, PostEditCommand, PostIdCommand, PostProfile, PostPageQuery, PostPage}, error::PostError};

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

#[update]
fn edit_post(cmd: PostEditCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        
        ctx.post_service.edit_post(cmd, caller).ok_or(PostError::PostNotFound)
    })
}

#[update]
fn terminate_post(cmd: PostIdCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        match ctx.post_service.get_post(cmd.clone()) {
            Some(p) => {
                assert!(p.author == caller);
                if p.status == PostStatus::Completed {
                    return Err(PostError::PostAlreadyCompleted);
                }
                ctx.post_service.terminate_post(cmd).ok_or(PostError::PostNotFound)
            },
            None => Err(PostError::PostNotFound),
        }
    })
}

#[update]
fn complete_post(cmd: PostIdCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        match ctx.post_service.get_post(cmd.clone()) {
            Some(p) => {
                assert!(p.author == caller);
                ctx.post_service.complete_post(cmd).ok_or(PostError::PostNotFound)
            },
            None => Err(PostError::PostNotFound),
        }
    })
}

#[update]
fn delete_post(cmd: PostIdCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        match ctx.post_service.get_post(cmd.clone()) {
            Some(p) => {
                assert!(p.author == caller);
                if p.status == PostStatus::Completed {
                    return Err(PostError::PostAlreadyCompleted);
                }
                ctx.post_service.delete_post(cmd).ok_or(PostError::PostNotFound)
            },
            None => Err(PostError::PostNotFound),
        }
    })
}

#[query]
fn get_post(cmd: PostIdCommand) -> Result<PostProfile, PostError> {
    CONTEXT.with(|c| {
        c.borrow().post_service.get_post(cmd).ok_or(PostError::PostNotFound)
    })
}

#[query]
fn page_posts(query: PostPageQuery) -> Result<PostPage, PostError> {
    CONTEXT.with(|c| {
        Ok(c.borrow().post_service.page_posts(query))
    })
}