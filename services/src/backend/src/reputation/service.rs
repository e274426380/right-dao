

use std::collections::BTreeMap;

use candid::Principal;

use super::{
    domain::{ReputationSummary, ReputationEvent},
};


#[derive(Debug, Default)]
pub struct ReputationService {
    pub summaries: BTreeMap<Principal, ReputationSummary>,
    pub events: BTreeMap<u64, ReputationEvent>,
}

impl ReputationService {
    pub fn get_reputation(&self, user: &Principal) -> Option<ReputationSummary> {
        self.summaries.get(user).cloned()
    }
}

