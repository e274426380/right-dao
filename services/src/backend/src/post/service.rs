use std::collections::BTreeMap;

use candid::Principal;

use super::domain::{PostProfile, PostId, PostCreateCommand, Timestamp, PostStatus, };


#[derive(Debug, Default)]
pub struct PostService {
    pub posts: BTreeMap<PostId, PostProfile>,
}

impl PostService {
    pub fn create_post(&mut self, cmd: PostCreateCommand, id: u64, caller: Principal, now: Timestamp) -> Option<u64> {
        match self.posts.get(&id.into()) {
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

    
}