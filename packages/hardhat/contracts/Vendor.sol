pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    // event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;
    uint256 public ETH_funds = 0;
    address owner_addr;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
        owner_addr = msg.sender;
    }

    // ToDo: create a payable buyTokens() function:
    event BuyTokens(
        address indexed buyer,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    function buyTokens() external payable{
        require(msg.value > 0, "Requires some purchase greater than 0");
        uint256 amount_transfer = msg.value * tokensPerEth;
        require(yourToken.balanceOf(address(this)) >= amount_transfer, "Vendor has insufficient tokens");
        ETH_funds += msg.value;
        yourToken.transfer(msg.sender, amount_transfer);
        emit BuyTokens(msg.sender, msg.value, amount_transfer);
    }


    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() external {
        require(msg.sender == owner(), "Only owner can withdraw ETH");
        uint256 balance = ETH_funds;
        require(balance > 0, "No balance to withdraw");

        ETH_funds = 0;
        payable(owner()).transfer(balance);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:

    function sellTokens(uint256 _amount) external{
        require(_amount > 0, "More than 0 tokens needed to sell");
        uint256 allowance = yourToken.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Not enough allowance");
        yourToken.transferFrom(msg.sender, address(this), _amount);
        uint256 ethToReturn = _amount / tokensPerEth;
        payable(msg.sender).transfer(ethToReturn);

        ETH_funds -= ethToReturn;
    }
}
