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