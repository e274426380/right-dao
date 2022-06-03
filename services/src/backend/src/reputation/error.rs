
use candid::{CandidType, Deserialize, Principal};


#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum ReputationError {
    ReputationNotFound,
}