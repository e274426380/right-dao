use std::collections::BTreeMap;

use candid::Principal;

use super::{domain::{PostProfile, PostId, PostCreateCommand, Timestamp, PostStatus, PostEditCommand, PostIdCommand, PostPage, PostPageQuery, PostCommentCommand, PostComment, PostEventCommand, CommentCommentCommand, PostChangeStatusCommand, PostEvent, }, error::PostError};


#[derive(Debug, Default)]
pub struct PostService {
    pub posts: BTreeMap<PostId, PostProfile>,
}

impl PostService {
    pub fn create_post(&mut self, cmd: PostCreateCommand, id: u64, caller: Principal, now: Timestamp) -> Option<u64> {
        match self.posts.get(&id) {
            Some(_) => None,
            None => {
                self.posts.insert(
                    id.into(),
                    cmd.build_profile(
                        id,
                        caller,
                        PostStatus::Enable,
                        now
                    )
                );                
                Some(id)
            }
        }   
    }  

    pub fn edit_post(&mut self, cmd: PostEditCommand) -> Option<bool> {
        self.posts.get_mut(&cmd.id).map(|profile| {
            cmd.merge_profile(profile);
        }).map(|_| true)
    }

    pub fn change_post_status(&mut self, cmd: PostChangeStatusCommand, caller: Principal, now: Timestamp) -> Result<bool, PostError> {
        if let Some(profile) = self.posts.get_mut(&cmd.id) {
            if !profile.is_active() {
                return Err(PostError::PostAlreadyCompleted);
            }

            let new_status = cmd.status.parse::<PostStatus>().unwrap();
            let event = PostEvent::new(cmd.id, now, cmd.description, caller, now);
            
            profile.status = new_status;
            profile.events.push_front(event);

            Ok(true)
        } else {
            Err(PostError::PostNotFound)
        }
    }

    pub fn delete_post(&mut self, id: PostId) -> Option<bool> {
        self.posts.remove(&id).map(|_| true)
    }
    
    pub fn get_post(&self, id: PostId) -> Option<PostProfile> {
        self.posts.get(&id).cloned()
    }

    pub fn page_posts(&self, query_args: &PostPageQuery) -> PostPage {
        let data: Vec<PostProfile> = self.posts
            .iter()
            .filter(|(_, q)| query_args.querystring.is_empty() || (q.title.contains(&query_args.querystring) || q.content.content.contains(&query_args.querystring)))
            .skip(query_args.page_num * query_args.page_size)
            .take(query_args.page_size)
            .map(|(_, q)| q.clone())
            .collect();

        let total_count = self.posts.len();
        
        PostPage {
            data,
            page_size: query_args.page_size,
            page_num: query_args.page_num,
            total_count,
        }
    }

    /// add comment to post
    pub fn add_post_comment(&mut self, cmd: PostCommentCommand, comment_id: u64, author: Principal, now: Timestamp) -> Result<bool, PostError> {
        match self.posts.get_mut(&cmd.post_id) {
            Some(p) if p.is_active() => {
                p.comments.push(
                    cmd.build_comment(comment_id, author, now)
                );
                Ok(true)
            }
            Some(_) => Err(PostError::PostAlreadyCompleted),
            _ => Err(PostError::PostNotFound)
        }
    }

    /// add comment to post's comment
    pub fn add_comment_comment(&mut self, cmd: CommentCommentCommand, comment_id: u64, author: Principal, now: Timestamp) -> Result<bool, PostError> {
        match self.posts.get_mut(&cmd.post_id) {
            Some(p) if p.is_active() => {
                let mut comment = p.comments.iter().find(|c| c.id == cmd.comment_id).cloned();
                match &mut comment {
                    Some(c) => {
                        c.comments.push(cmd.build_comment(comment_id, author, now));
                        Ok(true)
                    }
                    None => Err(PostError::PostCommentNotFound)
                }              
            }
            Some(_) => Err(PostError::PostAlreadyCompleted),
            _ => Err(PostError::PostNotFound)
        }
    }

    pub fn add_post_event(&mut self, cmd: PostEventCommand, author: Principal, now: Timestamp) -> Result<bool, PostError> {
        match self.posts.get_mut(&cmd.post_id) {
            Some(p) if p.is_active() => {
                p.events.push_front(
                    cmd.build_event(author, now)
                );
                Ok(true)
            }
            Some(_) => Err(PostError::PostAlreadyCompleted),
            _ => Err(PostError::PostNotFound)
        }
    }
}