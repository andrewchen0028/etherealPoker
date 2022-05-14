// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Poker {
    // STATE VARIABLES
    uint256 constant smallBlind = 1 wei;
    uint256 constant bigBlind = 2 * smallBlind;
    uint256 constant minBuyIn = 20 * bigBlind;
    uint256 constant maxBuyIn = 100 * bigBlind;

    uint256 dealerIndex; // Increments each HAND.
    uint256 activeIndex; // Increments each TURN.

    uint256 currentBet; // May update each TURN.
    uint256 currentPot; // May update each TURN.

    bool betweenHands; // Flips each HAND.

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
    modifier onlyBetweenHands() {
        require(betweenHands == true);
        _;
    }

    // STRUCTS, ARRAYS, ENUMS
    address payable[] players; // May change each GAME.
    Card[52] private deck; // Shuffled each GAME.
    mapping(address => bool) public ready; // Changes BETWEEN HANDS.
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
    function buyIn() external payable onlyBetweenHands {
        // require: buy-in must be within limits
        // require: buy-in reserved for entering
        // add player to players list
        // update player stack
    }

    function topOff() external payable onlyBetweenHands {
        // require: stack must be below maximum buy-in
        // require: top-off must not push stack over limit
        // update player stack
    }

    function readyUp() external onlyBetweenHands onlyPlayer {
        ready[msg.sender] = true;
        if (allPlayersReady()) {
            startHand();
        }
    }

    function cashOut() external onlyBetweenHands onlyPlayer {
        // send stack to player
        // remove player from list
    }

    function call() external onlyActive {
        wager(currentBet);
    }

    function check() external onlyActive {
        incrementActiveIndex();
    }

    function raise(uint256 _raise) external onlyActive {
        require(_raise >= currentBet);
        wager(currentBet + _raise);
        currentBet = currentBet + _raise;
        incrementActiveIndex();
    }

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

    function incrementActiveIndex() private {
        activeIndex = (activeIndex + 1) % players.length;
        while (stacks[players[activeIndex]] == 0) {
            activeIndex = (activeIndex + 1) % players.length;
        }
    }

    function startHand() private {
        betweenHands = false;
        shuffle();
        wager(smallBlind);
        wager(bigBlind);
        currentBet = bigBlind;
    }

    function shuffle() private {}

    function wager(uint256 amount) private {
        require(stacks[players[activeIndex]] >= amount, "Insufficient funds");
        stacks[players[activeIndex]] -= amount;
        currentPot += amount;
        incrementActiveIndex();
    }

    function endHand(address winner) private {
        stacks[winner] += currentPot;
        currentPot = 0;
        dealerIndex = (dealerIndex + 1) % players.length;
        activeIndex = dealerIndex;
        betweenHands = true;
    }
}
