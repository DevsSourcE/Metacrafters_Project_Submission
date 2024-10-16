# Metacrafters Submission (Eth+Avax Intermediate): SupplyChain Smart Contract

<img src="https://camo.githubusercontent.com/f5cb29008fbb73c9a12ea53e81b0577bf30153e3b24322a0aa9f9fba8e8aa587/68747470733a2f2f63646e2e70726f642e776562736974652d66696c65732e636f6d2f3632343138323130656465376537663134383639646533352f3632343563396232633338383130316462336439353066355f6d65746163726166746572736c6f676f2d676f6c642e77656270">


## Project Objective 

The objective of this project is to develop a smart contract that effectively demonstrates the use of **require(), assert(), and revert() statements.** The smart contract will implement scenarios where each of these control flow mechanisms is used appropriately to ensure proper validation, error handling, and contract logic integrity. This includes:

1. **require():** To validate inputs, ensure conditions are met, and prevent invalid function calls.</br>
2. **assert():** To check for invariants and critical conditions that should never fail, ensuring the internal consistency of the contract.</br>
3. **revert():** To provide custom error messages and rollback transactions when specific conditions are not met, allowing for better user feedback.

## Introduction 

This Solidity smart contract implements a basic supply chain management system, allowing manufacturers to add products, transfer ownership, track product history, and mark products as delivered.

## Prerequisites

- Solidity version: `0.8.26`
- License: `MIT`

## Contract Introduction

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SupplyChain {
    struct Product {
        uint256 id;
        string name;
        string origin;
        address manufacturer;
        address currentOwner;
        string[] trackingHistory;
        bool isDelivered;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCounter;

    event ProductAdded(uint256 productId, string name, string origin, address manufacturer);
    event ProductTransferred(uint256 productId, address from, address to);

    function addProduct(string memory _name, string memory _origin) public {
        productCounter++;
        products[productCounter] = Product({
            id: productCounter,
            name: _name,
            origin: _origin,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            trackingHistory: new string[](0) ,
            isDelivered: false
        });
        emit ProductAdded(productCounter, _name, _origin, msg.sender);
    }

    function transferProduct(uint256 _productId, address _to, string memory _location) public {
        require(_productId > 0, "Invalid Product ID");
        
        assert(_productId <= productCounter);
        
        if (products[_productId].currentOwner != msg.sender) {
            revert("You are not the current owner of the product.");
        }
        
        if (products[_productId].isDelivered) {
            revert("Product has already been delivered.");
        }

        products[_productId].trackingHistory.push(_location);
        products[_productId].currentOwner = _to;

        emit ProductTransferred(_productId, msg.sender, _to);
    }

    function markDelivered(uint256 _productId) public {
        require(_productId > 0, "Invalid Product ID");
        assert(_productId <= productCounter);
        
        if (products[_productId].currentOwner != msg.sender) {
            revert("Only the current owner can mark the product as delivered.");
        }
        
        products[_productId].isDelivered = true;
    }

    function getProduct(uint256 _productId) public view returns (Product memory) {
        assert(_productId > 0 && _productId <= productCounter);
        return products[_productId];
    }

    function getTrackingHistory(uint256 _productId) public view returns (string[] memory) {
        assert(_productId > 0 && _productId <= productCounter);
        return products[_productId].trackingHistory;
    }
}
```

The `SupplyChain` contract allows users to:

- **Add Products**: Manufacturers can add new products to the supply chain.
- **Transfer Ownership**: The current owner of a product can transfer it to a new owner while updating the tracking history.
- **Mark as Delivered**: The owner can mark a product as delivered.
- **View Product Details**: Anyone can view the details of a product.
- **View Tracking History**: Anyone can view the tracking history of a product.

## Structs

### `Product`

A `Product` represents a single item in the supply chain with the following properties:

- `id`: The unique identifier for the product.
- `name`: The name of the product.
- `origin`: The origin or source of the product.
- `manufacturer`: The address of the manufacturer who added the product.
- `currentOwner`: The current owner's address.
- `trackingHistory`: An array storing the tracking locations of the product.
- `isDelivered`: A boolean indicating whether the product has been delivered.

## State Variables

- `products`: A mapping of `Product` structs, using the product's `id` as the key.
- `productCounter`: A counter to keep track of the total number of products.

## Events

- `ProductAdded(uint256 productId, string name, string origin, address manufacturer)`: Emitted when a new product is added to the supply chain.
- `ProductTransferred(uint256 productId, address from, address to)`: Emitted when a product is transferred from one owner to another.

## Functions

### `addProduct(string memory _name, string memory _origin)`

- Adds a new product to the supply chain.
- Increments the `productCounter` and assigns the new product to the `products` mapping.
- The product is initialized with the manufacturer and the current owner set as the address of the user who calls this function.
- Emits a `ProductAdded` event.

### `transferProduct(uint256 _productId, address _to, string memory _location)`

- Transfers ownership of a product to a new owner.
- Adds the new location to the product's tracking history.
- Updates the `currentOwner` of the product.
- Emits a `ProductTransferred` event.
- Requirements:
  - The `_productId` must be valid.
  - The caller must be the current owner of the product.
  - The product must not be marked as delivered.

### `markDelivered(uint256 _productId)`

- Marks a product as delivered.
- Only the current owner can mark a product as delivered.
- Requirements:
  - The `_productId` must be valid.
  - The caller must be the current owner of the product.

### `getProduct(uint256 _productId)`

- Returns the details of a product as a `Product` struct.
- The `_productId` must be valid.

### `getTrackingHistory(uint256 _productId)`

- Returns the tracking history of a product as an array of strings.
- The `_productId` must be valid.

## Usage

1. **Deploy the contract** on a compatible Ethereum network.
2. **Add a new product** using `addProduct` and provide the product's name and origin.
3. **Transfer the product** using `transferProduct`, specifying the product ID, new owner's address, and the current location.
4. **Mark a product as delivered** using `markDelivered` when the product reaches its final destination.
5. **View product details** using `getProduct` to retrieve information such as the name, origin, current owner, and delivery status.
6. **Check tracking history** using `getTrackingHistory` to see the locations the product has been through.
