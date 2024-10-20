# Metacrafters Submission (Eth+Avax Intermediate): ERC20TokenClone

This repository contains a smart contract that implements a clone of the ERC20 token standard using Solidity and the OpenZeppelin library. The contract includes custom access control and minting functionality.

## Overview

The `ERC20TokenClone` contract is a simplified version of an ERC20 token, named "Bitcoin" with the symbol "BTC". It allows the contract owner to mint new tokens and includes basic functionality for transferring and burning tokens.

## Features

- **Minting:** The contract owner can mint new tokens to a specified account.
- **Burning:** Any token holder can burn their own tokens.
- **Access Control:** The mint function is restricted to the contract owner.
- **Custom Transfer Logic:** The `transfer` function can be overridden to include additional custom logic in future implementations.

## Contract Explanation

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20TokenClone is ERC20 {

    address owner;
    
    constructor() ERC20("Bitcoin", "BTC") {
        owner = msg.sender;
    }

    // @dev Implement Access Control 
    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner Allowed To Mint");
        _;
    }

    // @dev Mint new tokens.
    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
    
    // @dev Burn tokens.
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // @dev Override the transfer function to include a custom logic.
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, amount);
    }
}
```

The contract is built using Solidity `0.8.26` and inherits from the OpenZeppelin `ERC20` implementation. Below is a detailed explanation of the contract:

### Inheritance
- The contract extends the `ERC20` contract from the OpenZeppelin library, which means it inherits all standard ERC20 functionality like `transfer`, `approve`, and `transferFrom`.

### Constructor
- The `constructor()` function is executed once when the contract is deployed.
- It sets the token name to `"Bitcoin"` and the symbol to `"BTC"`.
- The `msg.sender` (the deployer of the contract) is assigned as the `owner`, who has exclusive rights to mint new tokens.

### Owner
- The `owner` state variable stores the address of the contract deployer.
- The `onlyOwner` modifier ensures that only the owner can execute functions with this restriction, such as `mint`.

### Modifiers
- **`onlyOwner` Modifier:**
    - Checks if the caller of a function is the `owner`.
    - If the caller is not the `owner`, it throws an error message: `"Only Owner Allowed To Mint"`.
    - This modifier is used to restrict access to the `mint` function.

### Functions

- **`mint(address account, uint256 amount)`**
    - Allows the `owner` to create new tokens and assign them to a specified `account`.
    - Uses the `_mint` function provided by the OpenZeppelin ERC20 contract.
    - This function increases the total supply of tokens and credits the specified `account` with the minted amount.

- **`burn(uint256 amount)`**
    - Allows any token holder to destroy a specified `amount` of their tokens.
    - Uses the `_burn` function from the OpenZeppelin ERC20 contract.
    - This function reduces the total supply of tokens by removing the specified amount from the caller’s balance.

- **`transfer(address recipient, uint256 amount)`**
    - Transfers tokens from the caller's account to the specified `recipient`.
    - This function overrides the `transfer` function of the inherited `ERC20` contract.
    - The current implementation uses `super.transfer` to retain the default functionality but can be customized further with additional logic.

## Prerequisites

- Solidity `0.8.26`
- OpenZeppelin Contracts library

## Setup and Deployment

1. **Clone the repository:**
    ```bash
    git clone https://github.com/your-repo/erc20-token-clone.git
    cd erc20-token-clone
    ```

2. **Install Dependencies:**
   Make sure to install the OpenZeppelin contracts library using `npm`:
    ```bash
    npm install @openzeppelin/contracts
    ```

3. **Deploy the Contract:**
   You can use tools like [Remix](https://remix.ethereum.org/) or [Hardhat](https://hardhat.org/) for deployment. Make sure you have an Ethereum wallet like MetaMask connected to a test network.

## Usage

### Mint Tokens

The contract owner can mint tokens by calling the `mint` function:
```solidity
mint(address account, uint256 amount);
```

### Burn Tokens

Any token holder can burn tokens from their balance by calling the `burn` function:
```solidity
burn(uint256 amount);
```

### Transfer Tokens

Token holders can transfer tokens to other accounts using the `transfer` function:
```solidity
transfer(address recipient, uint256 amount);
```

## Disclaimer

This contract is intended for educational and testing purposes. It is not audited, and using it in production environments or with real funds is not recommended.
