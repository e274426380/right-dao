

use std::collections::BTreeMap;

use candid::Principal;

use super::{
    domain::{ReputationSummary, ReputationEvent}
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

    pub fn handle_reputation_event(&mut self, event: ReputationEvent) -> bool {
        self.events.insert(event.id, event.clone());
        let user = event.operator;
        *self.summaries.entry(user).or_insert_with(|| ReputationSummary::new(user)) += event.amount;
        
        true
    }
}

