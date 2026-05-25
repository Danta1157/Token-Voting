# Token-Weighted Governance Voting dApp
## Overview
The project demonstrates a simplified governance-style voting dApp where participants cast weighted votes by committing ERC-20 tokens. The candidate with the highest accumulated token-weight wins.

## Architecture
The system consists of two primary layers:

1. **Solidity Smart Contracts:**
   - **TokenVoting.sol:** Interacts with any standard ERC-20 token interface (IERC20) to securely pull and lock tokens as vote weights.
   - **MyToken.sol:** Defines and deploys your own custom ERC-20 token

2. **Frontend UI (HTML/JavaScript):** Connects to a wallet, reads real-time blockchain state, and manages sequential user transactions.

## Voting Mechanism
To prevent users from voting with tokens they don't actually hold, the dApp uses the standard two-step ERC-20 transfer pattern:

1. **Approve:** The voter grants permission to the TokenVoting contract to spend a specified amount of their ERC-20 tokens.

2. **Vote:** The vote() function is executed. The voting contract calls transferFrom(), pulls the approved tokens into its own balance and logs their weight.
