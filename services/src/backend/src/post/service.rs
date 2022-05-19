

use std::collections::BTreeMap;

use candid::Principal;

use super::{domain::{PostProfile, PostId, PostCreateCommand, Timestamp, PostStatus, PostEditCommand, PostPage, PostPageQuery, PostCommentCommand, PostEventCommand, CommentCommentCommand, PostChangeStatusCommand, PostEvent, }, error::PostError};


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
        self.posts
            .get(&id)
            .cloned()
    }

    pub fn my_posts(&self, caller: Principal, query_args: &PostPageQuery) -> PostPage {
        let total_count = self.posts.len();

        let data: Vec<PostProfile> = self.posts
            .iter()
            .filter(|(_, p)| p.author == caller && (query_args.querystring.is_empty() || (p.title.contains(&query_args.querystring) || p.content.content.contains(&query_args.querystring))))
            .skip(query_args.page_num * query_args.page_size)
            .take(query_args.page_size)
            .map(|(_, q)| q.clone())
            .collect();
        
        PostPage {
            data,
            page_size: query_args.page_size,
            page_num: query_args.page_num,
            total_count,
        }
    }

    pub fn page_posts(&self, query_args: &PostPageQuery) -> PostPage {
        let total_count = self.posts.len();

        let data: Vec<PostProfile> = self.posts
            .iter()
            .filter(|(_, q)| query_args.querystring.is_empty() || (q.title.contains(&query_args.querystring) || q.content.content.contains(&query_args.querystring)))
            .skip(query_args.page_num * query_args.page_size)
            .take(query_args.page_size)
            .map(|(_, q)| q.clone())
            .collect();

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
        // let c_id = &cmd.comment_id;
        match self.posts.get_mut(&cmd.post_id) {
            Some(p) if p.is_active() => {
                let comments = &mut p.comments;
                
                let c_id = &cmd.comment_id;
                let new_comment = cmd.clone().build_comment(comment_id, author, now);
                for comment in comments {
                    if comment.id == *c_id {
                        comment.comments.push(new_comment.clone());
                    }
                }

                Ok(true)
                            
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

#[cfg(test)]
mod tests {

    use crate::post::domain::RichText;

    use super::*;

    #[test] 
    fn add_comment_comment_should_work() {
        let mut svc = PostService::default();
        let id = 10001u64;
        let caller = Principal::anonymous();
        let now = 20220516u64;
        let create_cmd = PostCreateCommand { 
            title: "james title".to_string(),
            content: RichText {
                content: "james content".to_string(),
                format: "md".to_string(),
            },
            category: "Tech".to_string(),
            photos: vec![30, 20],
            participants: vec!["Layer".to_string()],
            end_time: None,
        };

        let res1 = svc.create_post(create_cmd, id, caller, now);

        assert_eq!(res1.unwrap(), 10001u64);

        let add_comment_cmd = PostCommentCommand {
            post_id: id,
            content: RichText { content: "coment james".to_string(), format: "md".to_string() },
        };

        let comment_id = 10002u64;
        let res2 = svc.add_post_comment(add_comment_cmd, comment_id, caller, now);
        assert!(res2.unwrap());

        let res3 = svc.get_post(id).unwrap();
        assert_eq!(res3.title, "james title".to_string());
        assert_eq!(res3.comments.len(), 1);
        assert_eq!(res3.comments.first().unwrap().content, RichText { content: "coment james".to_string(), format: "md".to_string() });

        let add_cc_cmd = CommentCommentCommand {
            post_id: id,
            comment_id,
            content: RichText { content: "coment comment".to_string(), format: "md".to_string() }
        };

        let cc_id = 10003u64;

        let res4 = svc.add_comment_comment(add_cc_cmd, cc_id, caller, now).unwrap();
        assert!(res4);

        let res5 = svc.get_post(id).unwrap();
        assert_eq!(res5.comments.len(), 1);
        assert_eq!(res5.comments.first().unwrap().comments.len(), 1);
        assert_eq!(res5.comments.first().unwrap().comments.first().unwrap().content.content, "coment comment".to_string());
    }
}