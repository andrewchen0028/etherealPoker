// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Poker {
    // STATE VARIABLES
    uint256 constant smallBlind = 1 wei;
    uint256 constant bigBlind = 2 * smallBlind;
    uint256 constant minBuyIn = 20 * bigBlind;
    uint256 constant maxBuyIn = 100 * bigBlind;

    uint256 dealerIndex; // Increments each ROUND.
    uint256 activeIndex; // Increments each TURN.

    uint256 bet; // May update each TURN.
    uint256 pot; // May update each TURN.

    bool inRound; // Flips each ROUND.

    // EVENTS

    // MODIFIERS
    modifier onlyActive() {
        require(msg.sender == players[activeIndex], "Please wait your turn");
        _;
    }
    modifier onlyPlayer() {
        bool playerExists = false;
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i] == msg.sender) {
                playerExists = true;
            }
        }
        require(playerExists, "You have not joined this game");
        _;
    }
    modifier betweenRounds() {
        require(inRound == false);
        _;
    }

    // STRUCTS, ARRAYS, ENUMS
    address payable[] players; // May change each GAME.
    Card[52] private deck; // Shuffled each GAME.
    mapping(address => bool) public ready; // Changes BETWEEN ROUNDS.
    mapping(address => uint256) public stacks; //  May update each TURN.
    mapping(address => Card[2]) private holes; //Changes each GAME.

    enum Suit {
        Clubs,
        Diamonds,
        Hearts,
        Spades
    }
    enum Rank {
        Two,
        Three,
        Four,
        Five,
        Six,
        Seven,
        Eight,
        Nine,
        Ten,
        Jack,
        Queen,
        King,
        Ace
    }

    struct Card {
        Suit suit;
        Rank rank;
    }

    // CONSTRUCTOR
    // FALLBACK & RECEIVE FUNCTION

    // EXTERNAL FUNCTIONS
    function buyIn() external payable betweenRounds {
        require(
            smallBlind <= msg.value && msg.value <= bigBlind,
            "Buy-in must be within limits"
        );
        require(
            stacks[msg.sender] == 0,
            "Buy-in reserved for entering; use top-off to add funds"
        );
        players.push(payable(msg.sender));
        stacks[msg.sender] = msg.value;
    }

    function readyUp() external betweenRounds onlyPlayer {
        ready[msg.sender] = true;
    }

    function cashOut() external betweenRounds onlyPlayer {}

    function call() external onlyActive {}

    function check() external onlyActive {}

    function raise() external onlyActive {}

    function fold() external onlyActive {}

    // PUBLIC FUNCTIONS
    // INTERNAL FUNCTIONS

    // PRIVATE FUNCTIONS
    function allPlayersReady() private view returns (bool) {
        for (uint256 i = 0; i < players.length; i++) {
            if (!ready[players[i]]) {
                return false;
            }
        }
        return true;
    }

    function postSmallBlind() private {}

    function postBigBlind() private {}

    function wager(uint256 amount, address player) private {
        require(stacks[player] >= amount, "Insufficient funds");
        stacks[player] -= amount;
        pot += amount;
    }

    function win(address player) private {
        stacks[player] += pot;
        pot = 0;
    }
}
