// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint public candidatesCount;
    address public owner;
    bool public votingOpen;

    event CandidateAdded(uint indexed id, string name);
    event VoteCast(address indexed voter, uint indexed candidateId);
    event VotingEnded();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
        votingOpen = true;
    }

    // Add a candidate
    function addCandidate(string memory _name) public onlyOwner {
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        candidatesCount++;
        emit CandidateAdded(candidatesCount - 1, _name);
    }

    // Vote for a candidate
    function vote(uint _candidateId) public {
        require(votingOpen, "Voting is closed");
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < candidatesCount, "Invalid candidate");

        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, _candidateId);
    }

    // End voting
    function endVoting() public onlyOwner {
        votingOpen = false;
        emit VotingEnded();
    }

    // Get the winner candidate
    function getWinner() public view returns (string memory winnerName, uint winnerVoteCount) {
        require(!votingOpen, "Voting is still open");

        uint winningVoteCount = 0;
        string memory winningCandidateName;

        for (uint i = 0; i < candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateName = candidates[i].name;
            }
        }

        return (winningCandidateName, winningVoteCount);
    }
}
