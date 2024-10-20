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
