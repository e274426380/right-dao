use std::collections::BTreeMap;

use candid::Principal;

use super::domain::{PostProfile, PostId, PostCreateCommand, Timestamp, PostStatus, PostEditCommand, PostIdCommand, PostPage, PostPageQuery, PostCommentCommand, PostComment, };


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

    pub fn edit_post(&mut self, cmd: PostEditCommand, caller: Principal) -> Option<bool> {
        self.posts.get_mut(&cmd.id).map(|profile| {
            assert!(caller == profile.author);
            cmd.merge_profile(profile);
        }).map(|_| true)
    }

    pub fn terminate_post(&mut self, cmd: PostIdCommand) -> Option<bool> {
        if let Some(profile) = self.posts.get_mut(&cmd.id) {
            profile.status = PostStatus::Terminated;
            Some(true)
        } else {
            None
        }
    }

    pub fn complete_post(&mut self, cmd: PostIdCommand) -> Option<bool> {
        if let Some(profile) = self.posts.get_mut(&cmd.id) {
            profile.status = PostStatus::Completed;
            Some(true)
        } else {
            None
        }
    }

    pub fn delete_post(&mut self, cmd: PostIdCommand) -> Option<bool> {
        self.posts.remove(&cmd.id).map(|_| true)
    }
    
    pub fn get_post(&self, cmd: PostIdCommand) -> Option<PostProfile> {
        self.posts.get(&cmd.id).cloned()
    }

    pub fn page_posts(&self, query: PostPageQuery) -> PostPage {
        let data: Vec<PostProfile> = self.posts
            .iter()
            .filter(|(_, q)| q.title.contains(&query.query) || q.content.content.contains(&query.query))
            .skip(query.page_num * query.page_size)
            .take(query.page_size)
            .map(|(_, q)| q.clone())
            .collect();

        let total_count = self.posts.len();
        
        PostPage {
            data,
            page_size: query.page_size,
            page_num: query.page_num,
            total_count,
        }
    }

    pub fn comment_post(&mut self, cmd: PostCommentCommand, author: Principal, now: Timestamp) -> Option<bool> {
        self.posts.get_mut(&cmd.post_id).map(|profile| {
            profile.comments.push(
                PostComment {
                    post_id: cmd.post_id,
                    content: cmd.content,
                    author,
                    created_at: now,
                }
            );
        }).map(|_| true)
    }
}