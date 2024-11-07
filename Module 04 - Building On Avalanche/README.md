# Metacrafters Eth+Avax Module 4: Building On Avalanche 

## Introduction
The `AvalancheGame` smart contract is an ERC20-based token system designed for a blockchain game. It enables users to purchase in-game items with tokens, redeem items, and track item redemptions. This contract also includes minting and burning functionality, making it a versatile tool for managing in-game assets and transactions.

## Requirements
- **Solidity Version**: `^0.8.10`
- **Dependencies**:
  - OpenZeppelin's ERC20 library for token standard implementation.
  - OpenZeppelin's Roles library for managing roles.

## Overview
- **Token Name**: Degen
- **Token Symbol**: DGN

The contract owner has the exclusive ability to:
- Set and update a description for the game.
- Add items to the game store with specified prices.
- Mint new tokens for game rewards.
- Track redeemed items per user.

## Contract Features

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// Import OpenZeppelin Libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract DegenGaming is ERC20 {
    using Roles for Roles.Role;

    // State Variables
    string private _name = "Wrapped USDC";
    string private _symbol = "BUSDC";
    uint8 private _decimals = 10;
    address public owner;

    Roles.Role private _ownerRole;

    // Mapping for Store Items
    mapping(uint256 => string) public ItemName;
    mapping(uint256 => uint256) public Itemprice;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    // Events for Redeeming Items
    event Redeem(address indexed user, string itemName);

    // Constructor to Initialize ERC20 and Sample Items in Store
    constructor() ERC20(_name, _symbol) {
        owner = msg.sender;
        _ownerRole.add(owner);
        // Initialize some sample items in the store
        addItemToStore(0, "Avalanche VIP", 1000);
        addItemToStore(1, "Avalanche Boss Card", 10000);
    }

    // Mint Tokens (Only Owner)
    function mint(address to, uint256 amount) public {
        require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        _mint(to, amount);
    }

    // Burn Tokens (Anyone Can Burn Their Own Tokens)
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Custom Transfer Function
    function transferTokens(address to, uint256 amount) external {

        require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        _transfer(msg.sender, to, amount);
    }

    // Store Function to Set Item Name and Price
    function addItemToStore(uint256 itemId, string memory _itemName, uint256 _itemPrice) public {
        require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        ItemName[itemId] = _itemName;
        Itemprice[itemId] = _itemPrice;
    }

    // Redeem Item from Store
    function Itemredeem(uint256 accId) external returns (string memory) {
        require(Itemprice[accId] > 0, "Invalid item ID.");
        uint256 redemptionAmount = Itemprice[accId];
        require(balanceOf(msg.sender) >= redemptionAmount, "Insufficient balance to redeem the item.");

        _burn(msg.sender, redemptionAmount);
        redeemedItems[msg.sender][accId] = true;
        redeemedItemCount[msg.sender]++;
        emit Redeem(msg.sender, ItemName[accId]);

        return ItemName[accId];
    }

    // Get Redeemed Item Count
    function getRedeemedItemCount(address user) external view returns (uint256) {
        return redeemedItemCount[user];
    }
}
```

- **Item Store**: Add items to the store with unique IDs, names, and prices.
- **Token Minting and Burning**: The owner can mint new tokens, and users can burn tokens to redeem in-game items.
- **Item Redemption**: Users can redeem in-game items by burning tokens.

## Important Functions

### Owner Functions
1. **`setDescription(string memory _description)`**: 
   - Sets or updates the game description.
   - Restricted to the owner role.
   
2. **`addItemToStore(uint256 itemId, string memory itemName, uint256 itemPrice)`**: 
   - Adds a new item with an ID, name, and token price.
   - Restricted to the owner role.

3. **`mintTokens(address to, uint256 amount)`**: 
   - Mints a specified amount of tokens to a user's address.
   - Restricted to the owner role.

### User Functions
1. **`burnTokens(uint256 amount)`**: 
   - Allows users to burn tokens from their balance.
   
2. **`redeemItem(uint256 itemId)`**: 
   - Redeems an in-game item by burning the required amount of tokens.
   - Emits an `ItemRedeemed` event upon successful redemption.

3. **`getRedeemedItemCount(address user)`**: 
   - Returns the count of items redeemed by a specific user.

## Events
- **`ItemRedeemed(address indexed user, string itemName)`**: Triggered when a user successfully redeems an in-game item.

## How to Use in Real-World Scenarios
1. **Game Setup**: Deploy the contract, setting the game description and initial items.
2. **Reward System**: Use the mint function to distribute tokens as rewards for game achievements.
3. **In-Game Purchases**: Players redeem tokens to unlock or buy in-game items, promoting token utility.
4. **Item Tracking**: Use the redemption records to track user engagement and items owned.

This contract provides a foundational token-based economy for blockchain games, enabling token rewards, in-game purchases, and item tracking, and offers secure access control via roles.
