# Token-Weighted Voting System
## Overview
The project demonstrates a simplified governance-style voting dApp where participants cast weighted votes by committing ERC-20 tokens. The candidate with the highest accumulated token-weight wins.

## Architecture
The system consists of two primary layers:

1. **Solidity Smart Contracts:**
   - **TokenVoting.sol:** Interacts with any standard ERC-20 token interface (IERC20) to securely pull and lock tokens as vote weights.
   - **MyToken.sol:** Defines and deploys your own custom ERC-20 token

2. **Frontend UI (token-dashboard.html):** Connects to a wallet, reads real-time blockchain state, and manages sequential user transactions.

## Features
- Votes are proportional to the number of ERC-20 tokens a user chooses to spend.

- Each address can only vote once per poll but they can choose how many tokens to allocate during that vote.

- Only the contract creator can add candidates or finalize the poll.

- The contract programmatically tracks and determines the winning candidate based on the highest accumulated token weight. In case of a tie, the first registered candidate wins
  
- Every requirement rule is prefixed with "TokenVoting: ...". Inspect it to identify exactly which criteria failed.

## How It Works
1. Initialization
The contract is deployed in Remix by providing the address of an existing ERC-20 token (voteToken). The deployer automatically becomes the contract owner, and the voting session opens instantly.

2. Adding Candidates
The owner calls addCandidate() to register choices for the ballot. This can only be done while the voting window is active.

3. Casting Votes
Users interact with the contract using the vote() function.

4. Closing the Poll
The owner terminates the election by calling closeVoting(). This freezes all voting state updates, calculates the winner, and emits an event declaring the final results.

## Voting Mechanism
To prevent users from voting with tokens they don't actually hold, the dApp uses the standard two-step ERC-20 transfer pattern:

1. **Approve:** The voter grants permission to the TokenVoting contract to spend a specified amount of their ERC-20 tokens.

2. **Vote:** The vote() function is executed. The voting contract calls transferFrom(), pulls the approved tokens into its own balance and logs their weight.

## About the Code
### State Variables
- **IERC20 voteToken** - The ERC-20 token interface used for voting weight.
- **owner** - Stores the owners address
- **votingStatus** - Stores the current status of voting (open/closed)
- Candidate details like name, description and vote count are stored in a struct
- A list of these structs maintains the details of all candidates. The index is the candidates ID
- The mapping checks the voting status of a user to ensure no one votes twice
### Constructor
Stores the owners address at the time of deployment
### Modifiers
To implement checks on functions which can only be accessed by the owner or if the voting is open
### Events
Events are emitted in case a new candidate is added, a vote is cast or voting is closed
### Functions
- **addCandidate** - Accessible by the admin only and only if voting is open. Adds new candidates and emits an event
- **closeVoting** - Accessible by the admin only and only if voting is open. Closes voting and emits the winners details
- **getCandidateCount** - Public function. Returns the total count of candidates
- **getCandidate** - Public function. Returns the details of a particular candidate
- **getWinnerId** - Returns the winners ID. This is complemented by an internal helper function so that the same code doesnt run more than once, saving gas
- **votingOpen** - Returns the status of voting
- **hasVoted** - Checks the voting status of a particular user

## Deployment & Setup Guide
### Prerequisites
- Remix IDE (or Hardhat/Foundry)
- MetaMask Extension with some testnet ETH on the Sepolia Network.
- Address of TokenVoting and MyToken after deploying, verifying and publishing in Etherscan.

### Configure the Frontend
Open voting-dapp.html in a code editor.

Replace with your deployed addresses and save the file
- const VOTING_ADDRESS = "0xYOUR_VOTING_CONTRACT_ADDRESS";
- const TOKEN_ADDRESS  = "0xYOUR_ERC20_TOKEN_ADDRESS";

### Run the Application
Access admin functions and few others through Remix or Etherscan

Open voting-dapp.html in a web browser.

Connect MetaMask to display available tokens, voting status and list of candidate.

In the Cast Vote section select a candidate, input the desired token amount and click Approve & Vote.

Approve the two consecutive MetaMask prompts (First for token spend permission, second for the actual vote).

Once completed, the dashboard updates automatically, you see a prompt saying "You have voted successfully" for a short while and the option to vote disappears
