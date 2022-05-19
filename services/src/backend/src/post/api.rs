
use std::collections::VecDeque;

use ic_cdk_macros::{update, query};
use crate::domain::{PostComment, PostEvent, PostInfo};
use crate::{CONTEXT, post::domain::PostStatus};
use crate::common::guard::has_user_guard;

use super::domain::{PostCommentCommand, PostEventCommand, CommentCommentCommand, PostChangeStatusCommand};
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
        let post_id = cmd.id;
        match ctx.post_service.get_post(post_id) {
            Some(p) => {
                if p.author != caller {
                    return Err(PostError::PostUnAuthorizedOperation);
                }
                if p.status == PostStatus::Completed {
                    return Err(PostError::PostAlreadyCompleted);
                }
                ctx.post_service.edit_post(cmd).ok_or(PostError::PostNotFound)
            },
            None => Err(PostError::PostNotFound),
        }
        
    })
}

#[update]
fn change_post_status(cmd: PostChangeStatusCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        let post_id = cmd.id;
        let now = ctx.env.now();
        match ctx.post_service.get_post(post_id) {
            Some(p) => {
                if p.author != caller {
                    return Err(PostError::PostUnAuthorizedOperation);
                }
                
                ctx.post_service.change_post_status(cmd, caller, now)
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
        let post_id = cmd.id;
        match ctx.post_service.get_post(post_id) {
            Some(p) => {               
                if p.author != caller {
                    return Err(PostError::PostUnAuthorizedOperation);
                }
                if p.status == PostStatus::Completed {
                    return Err(PostError::PostAlreadyCompleted);
                }
                ctx.post_service.delete_post(post_id).ok_or(PostError::PostNotFound)
            },
            None => Err(PostError::PostNotFound),
        }
    })
}

#[update]
fn add_post_comment(cmd: PostCommentCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let comment_id = ctx.id;
        let caller = ctx.env.caller();
        let now = ctx.env.now();
        
        match ctx.post_service.add_post_comment(cmd, comment_id, caller, now) {
            Ok(_) => {
                ctx.id += 1;    // id addOne
                Ok(true)
            },
            e => e,
        }
    })
}

#[update]
fn add_comment_comment(cmd: CommentCommentCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let comment_id = ctx.id;
        let caller = ctx.env.caller();
        let now = ctx.env.now();
        
        match ctx.post_service.add_comment_comment(cmd, comment_id, caller, now) {
            Ok(_) => {
                ctx.id += 1;    // id addOne
                Ok(true)
            },
            e => e,
        }
    })
}

#[update]
fn add_post_event(cmd: PostEventCommand) -> Result<bool, PostError> {
    CONTEXT.with(|c| {
        let mut ctx = c.borrow_mut();
        let caller = ctx.env.caller();
        let now = ctx.env.now();
        ctx.post_service.add_post_event(cmd, caller, now)
    })
}

#[query]
fn get_post(cmd: PostIdCommand) -> Result<PostProfile, PostError> {
    CONTEXT.with(|c| {
        c.borrow().post_service.get_post(cmd.id).ok_or(PostError::PostNotFound)
    })
}

#[query]
fn get_post_info(cmd: PostIdCommand) -> Result<PostInfo, PostError> {
    CONTEXT.with(|c| {
        c.borrow().post_service.get_post(cmd.id).map(|p| p.into()).ok_or(PostError::PostNotFound)
    })
}

#[query]
fn get_post_comments(cmd: PostIdCommand) -> Result<Vec<PostComment>, PostError> {
    CONTEXT.with(|c| {
        c.borrow().post_service.get_post(cmd.id).map(|p| p.comments).ok_or(PostError::PostNotFound)
    })
}

#[query]
fn get_post_events(cmd: PostIdCommand) -> Result<VecDeque<PostEvent>, PostError> {
    CONTEXT.with(|c| {
        c.borrow().post_service.get_post(cmd.id).map(|p| p.events).ok_or(PostError::PostNotFound)
    })
}

#[query]
fn page_posts(query: PostPageQuery) -> Result<PostPage, PostError> {
    CONTEXT.with(|c| {
        Ok(c.borrow().post_service.page_posts(&query))
    })
}

#[query]
fn my_posts(query: PostPageQuery) -> Result<PostPage, PostError> {
    CONTEXT.with(|c| {
        let ctx = c.borrow();
        let caller = ctx.env.caller();
        Ok(ctx.post_service.my_posts(caller, &query))
    })
}
