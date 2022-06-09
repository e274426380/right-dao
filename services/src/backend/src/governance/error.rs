
use candid::{CandidType, Deserialize};

#[derive(Debug, Clone, CandidType, Deserialize)]
pub enum GovernanceError { 
    ProposalNotFound,
    ProposalAlreadyExists,
    ProposalStateNotOpen,
    ProposalUnAuthorized,
    VoterAlreadyVoted,
    VoterNotFound,
    MemberPrincipalWrongFormat,
    MemberNotFound,
}