// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVoting {

    // State Variables

    IERC20 public voteToken;
    address public owner;
    bool public votingStatus;

    struct Candidate {
        string name;
        string description;
        uint256 votes;
    }

    Candidate[] public candidates;
    mapping (address => bool) public voted;

    // Constructor

    constructor (address tokenAddress) {
        voteToken = IERC20(tokenAddress);
        owner = msg.sender;
        votingStatus = true;
    }

    // Modifiers

    modifier onlyOwner() {
        require(msg.sender  == owner, "TokenVoting: Only owner can access this function");
        _;
    }

    modifier isVotingOpen() {
        require(votingStatus == true, "TokenVoting: Voting is closed");
        _;
    }

    // Events

    event CandidateAdded (uint256 indexed candidateId, string name, string description);
    event VoteCast (address indexed voter, uint256 indexed candidateId, uint256 amount);
    event VotingClosed (uint256 winnerId, string winnerName, uint256 winnerVotes);

    // Allows owner to add candidates while voting is open

    function addCandidate(string calldata name, string calldata description) public onlyOwner isVotingOpen {
        candidates.push(Candidate({
            name: name,
            description: description,
            votes: 0
        }));

        uint256 newCandidateId = candidates.length - 1;
        emit CandidateAdded(newCandidateId, name, description);        
    }

    // Allows any user to vote for their candidate by giving ERC20 tokens

    function vote(uint256 candidateId, uint256 amount) public isVotingOpen {
        require(!voted[msg.sender], "TokenVoting: User has already voted");
        require(candidateId < candidates.length, "TokenVoting: Invalid candidate ID");
        require(amount > 0, "TokenVoting: Amount must be greater than zero");

        voted[msg.sender] = true;
        candidates[candidateId].votes += amount;

        bool success = voteToken.transferFrom(msg.sender, address(this), amount);
        require(success, "TokenVoting: Token transfer failed");

        emit VoteCast(msg.sender, candidateId, amount);
    }

    // Allows owner to close voting and announce the winner

    function closeVoting() public onlyOwner isVotingOpen {
        votingStatus = false;

        uint256 winnerId = _getWinnerId();
        string memory winnerName = "No candidates registered";
        uint256 winnerVotes = 0;

        if (candidates.length > 0) {
            Candidate memory winner = candidates[winnerId];
            winnerName = winner.name;
            winnerVotes = winner.votes;
        }

        emit VotingClosed(winnerId, winnerName, winnerVotes);
    }

    // Fetches the total number of candidates

    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    // Gives the votes corresponding to a candidate

    function getCandidate(uint256 id) public view returns (string memory name, string memory description, uint256 totalVotes) {
        require(id < candidates.length, "TokenVoting: Invalid candidate ID");
        Candidate memory candidate = candidates[id];
        return (candidate.name, candidate.description, candidate.votes);
    }

    // Finds the winning candidates ID 

    function getWinnerId() public view returns (uint256) {
        require(candidates.length > 0, "TokenVoting: No candidates registered");

        return _getWinnerId();
    }

    // Internal function to find the winners details

    function _getWinnerId() internal view returns (uint256) {
        uint256 maxVotes = 0;
        uint256 winnerId = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].votes > maxVotes) {
                maxVotes = candidates[i].votes;
                winnerId = i;
            }
        }

        return winnerId;
    }

    // To check is voting is currently open or not

    function votingOpen() public view returns (bool) {
        return votingStatus;
    }

    // To check if a particular user has voted
    
    function hasVoted(address voter) public view returns (bool) {
        return voted[voter];
    }
}