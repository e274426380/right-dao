

use std::collections::BTreeMap;

use candid::Principal;

use crate::domain::{CommentSummaryPage, CommentSummary};

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

    pub fn page_posts(&self, q: &PostPageQuery) -> PostPage {

        let page_size= q.page_size;
        let page_num = q.page_num;
        let filter = |p: &&PostProfile| q.querystring.is_empty() || 
            (p.title.contains(&q.querystring) || p.content.content.contains(&q.querystring));
        let ps = &self.posts;

        paging(ps, page_size, page_num, filter)
    }

    pub fn my_posts(&self, caller: Principal, q: &PostPageQuery) -> PostPage {
        
        let page_size= q.page_size;
        let page_num = q.page_num;
        let filter = |p: &&PostProfile| p.author == caller && 
            (q.querystring.is_empty() || (p.title.contains(&q.querystring) || p.content.content.contains(&q.querystring)));
        let ps = &self.posts;

        paging(ps, page_size, page_num, filter)
    }

    pub fn my_post_comments(&self, caller: Principal, q: &PostPageQuery)-> PostPage {

        let page_size= q.page_size;
        let page_num = q.page_num;
        let filter = |p: && PostProfile| p.comments.iter().any(|c| c.author == caller) && 
            (q.querystring.is_empty() || (p.title.contains(&q.querystring) || p.content.content.contains(&q.querystring)));
        let ps = &self.posts;
        paging(ps, page_size, page_num, filter)
 
    }

    pub fn my_comments(&self, caller: Principal, q: &PostPageQuery) -> CommentSummaryPage {
        let mut data = Vec::new();
        let mut total_count = 0;
        
        for (_, p) in self.posts.iter() {
            for c in &p.comments {
                if c.author == caller {
                    data.push( CommentSummary {
                        id: c.id,
                        post_id: p.id,
                        post_title: p.title.clone(),
                        comment_id: c.comment_id,
                        quote_id: c.quote_id,
                        content: c.content.clone(),
                        author: c.author,
                        created_at: c.created_at,
                        updated_at: c.updated_at,
                        status: c.status.clone(),
                    });

                    total_count += 1;
                }
            }
        }
        
        data.sort_by(|c1, c2| c2.id.cmp(&c1.id));

        let filter = |c: && CommentSummary| c.author == caller && 
            (q.querystring.is_empty() || (c.post_title.contains(&q.querystring) || c.content.content.contains(&q.querystring)));

        let page_size= q.page_size;
        let page_num = q.page_num;

        let data = data
            .iter()
            .filter(filter)
            .skip(page_num * page_size)
            .take(page_size)
            .cloned()
            .collect();

        CommentSummaryPage { 
            data, 
            page_size, 
            page_num, 
            total_count 
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

fn paging(ps: &BTreeMap<u64, PostProfile>, page_size: usize, page_num: usize,
              ff: impl Fn(&&PostProfile) -> bool)
              -> PostPage {
    let mut ps: Vec<PostProfile> = ps
        .values()
        .cloned()
        .collect();

    ps.sort_by(|p1, p2| p2.id.cmp(&p1.id));

    let total_count = ps.len();
    let data = ps.iter().filter(ff).skip(page_num * page_size).take(page_size).cloned().collect();
    PostPage { page_num, page_size, total_count, data }
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
            quote_id: None,
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