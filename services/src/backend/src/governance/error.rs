
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
    ExecutingProposalUnAuthorized,
    MemberAlreadyExists,
    UserNotFound, // 提案不存在的用户成为 Governance member
}