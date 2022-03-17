// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlockgamesERC20 is ERC20, Ownable {
    address payable ownerWallet;
    uint256 initialToken = 1000000;

    event TokenBought(address buyer, address receiver, uint256 tokenAmount);

    constructor(address payable _wallet) ERC20("BlockgamesERC20", "BTK") {
        ownerWallet = _wallet;
        _mint(msg.sender, initialToken);
    }

    // receive() external payable {}

    function buyToken(address receiver) public payable {
        // 1eth -> 1000 token
        // 1 * 10**18 wei-> 1000 token
        // 1 token -> 10**18 / 10**3 -> 10**15 wei
        require(msg.value >= 10**18, "You need to send more ether");
        ownerWallet.transfer(msg.value); // take before you give
        uint256 amountOfTokenToBuy = msg.value / 10**15;
        _mint(receiver, amountOfTokenToBuy);
        emit TokenBought(msg.sender, receiver, amountOfTokenToBuy);
    }

    function getOwnerEthBalance() public view onlyOwner returns(uint256){
        return address(ownerWallet).balance;
    }

    // function getOwnerEthBalance() public view onlyOwner returns(string memory){
    //     return string(abi.encodePacked(address(ownerWallet).balance));
    // }
}