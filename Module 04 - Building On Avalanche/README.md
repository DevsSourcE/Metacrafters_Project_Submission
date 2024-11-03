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

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract AvalancheGame is ERC20 {

    using Roles for Roles.Role;

    ///////////////////////// STATE VARIABLES ///////////////////////////

    address public owner;
    string public description;
    string private constant TOKEN_NAME = "Degen";
    string private constant TOKEN_SYMBOL = "DGN";

    mapping(uint256 => string) public itemNames;
    mapping(uint256 => uint256) public itemPrices;
    mapping(address => mapping(uint256 => bool)) public redeemedItems;
    mapping(address => uint256) public redeemedItemCount;

    Roles.Role private _ownerRole;

    ///////////////////////////// EVENTS ///////////////////////////////

    event ItemRedeemed(address indexed user, string itemName);

    //////////////////////////// CONSTRUCTOR ////////////////////////////

    constructor(string memory _description) ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        owner = msg.sender;
        description = _description;
    }

    //////////////////////////// FUNCTIONS /////////////////////////////

    /**
     * @dev Sets the description for the contract.
     * @param _description The new description for the contract.
     */
    function setDescription(string memory _description) public  {
        require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        description = _description;
    }

    /**
     * @dev Retrieves the contract description.
     * @return The current description of the contract.
     */
    function getDescription() public view returns (string memory) {
        return description;
    }

    /**
     * @dev Adds a new item to the game store.
     * @param itemId The ID of the item.
     * @param itemName The name of the item.
     * @param itemPrice The price of the item in tokens.
     */
    function addItemToStore(uint256 itemId, string memory itemName, uint256 itemPrice) public {
         require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        itemNames[itemId] = itemName;
        itemPrices[itemId] = itemPrice;
    }

    /**
     * @dev Mints new tokens to a specified address.
     * @param to The address to receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mintTokens(address to, uint256 amount) public  {
        require(_ownerRole.has(msg.sender), "DOES_NOT_HAVE_OWNER_ROLE");
        _mint(to, amount);
    }

    /**
     * @dev Burns a specified amount of tokens from the caller's balance.
     * @param amount The amount of tokens to burn.
     */
    function burnTokens(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Redeems an item from the store using tokens.
     * @param itemId The ID of the item to redeem.
     * @return The name of the redeemed item.
     */
    function redeemItem(uint256 itemId) public returns (string memory) {
        require(itemPrices[itemId] > 0, "Invalid item ID.");
        uint256 redemptionAmount = itemPrices[itemId];
        require(balanceOf(msg.sender) >= redemptionAmount, "Insufficient balance.");

        _burn(msg.sender, redemptionAmount);
        redeemedItems[msg.sender][itemId] = true;
        redeemedItemCount[msg.sender]++;
        emit ItemRedeemed(msg.sender, itemNames[itemId]);

        return itemNames[itemId];
    }

    /**
     * @dev Gets the total count of items redeemed by a specific user.
     * @param user The address of the user.
     * @return The total redeemed item count.
     */
    function getRedeemedItemCount(address user) public view returns (uint256) {
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
