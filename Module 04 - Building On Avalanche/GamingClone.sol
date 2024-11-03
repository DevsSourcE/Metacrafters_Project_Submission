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
