
use ic_cdk_macros::heartbeat;

use crate::CONTEXT;

use super::domain::{GovernanceProposal, ProposalState};

#[heartbeat]
async fn heartbeat() {
    execute_accepted_proposals().await;
}

/// Execute all claim proposal
async fn execute_accepted_proposals() {
    let accepted_proposals: Vec<GovernanceProposal> = CONTEXT.with(|c| {
        c.borrow_mut()
            .governance_service
            .get_executing_accepted_proposals()
    });

    for proposal in accepted_proposals {
        let state = match execute_claim_proposal(proposal.clone()).await {
            Ok(()) => ProposalState::Succeeded,
            Err(msg) => ProposalState::Failed(msg)
        };

        CONTEXT.with(|c| c.borrow_mut().governance_service.update_proposal_state(proposal.id, state))
    }
}

async fn execute_claim_proposal(proposal: GovernanceProposal) -> Result<(), String> {
    // 转账 ICP TODO
    todo!()
}