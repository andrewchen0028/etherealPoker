// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Poker {
    // STATE VARIABLES
    uint256 constant smallBlind = 1 wei;
    uint256 constant bigBlind = 2 * smallBlind;
    uint256 constant minBuyIn = 20 * bigBlind;
    uint256 constant maxBuyIn = 100 * bigBlind;

    uint256 dealerIndex; // Increments each ROUND.
    uint256 playerIndex; // Increments each TURN.

    uint256 bet; // May update each TURN.
    uint256 pot; // May update each TURN.

    // EVENTS

    // MODIFIERS
    modifier onlyPlayer() {
        require(msg.sender == players[playerIndex], "Please wait your turn");
        _;
    }

    // STRUCTS, ARRAYS, ENUMS
    address payable[] players; // May change each GAME.
    Card[52] private deck; // Shuffled each GAME.
    mapping(address => uint256) public balances; //  May update each TURN.
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
    function buyIn() external payable {
        require(minBuyIn <= msg.value);
        require(msg.value <= maxBuyIn);
    }

    function voteStart() external {}

    function call() external onlyPlayer {}

    function check() external onlyPlayer {}

    function raise() external onlyPlayer {}

    function fold() external onlyPlayer {}

    // PUBLIC FUNCTIONS
    // INTERNAL FUNCTIONS
    // PRIVATE FUNCTIONS
    function postSmallBlind() private onlyPlayer {}

    function postBigBlind() private onlyPlayer {}
}
