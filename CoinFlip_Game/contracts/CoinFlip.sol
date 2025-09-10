//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinFlips{

   IERC20 public token;

   mapping(address user => uint256 win) public wins;
   mapping(address user => uint256 lose) public loses;
   mapping(address user => bool) public getCoins;

   constructor(address _token) {
      token = IERC20(_token);
   }
   
   function getFreeCoins() public {
      require(getCoins[msg.sender] == false, "You already claimed free tokens");
      getCoins[msg.sender] = true;
      bool success = token.transfer(msg.sender,10*1e18);
      require(success,"Token Transfer Failed");
   } 

   function FlipCoin() public {
         uint check = 5;
         uint randomNumber = getRandomNumber();

         if(randomNumber > check){
            wins[msg.sender] += 1;
            bool success = token.transfer(msg.sender, 10*1e18);
            require(success, "Winning token transfer failed");
         }
         else{
            loses[msg.sender] += 1;
            bool success = token.transferFrom(address(this),msg.sender, 10*1e18);
            require(success, "Lose token withdraw failed");
         }
   }

   function getRandomNumber() private view returns(uint){
      uint randNo = 0;
      return uint(keccak256(abi.encodePacked (msg.sender, block.timestamp,randNo)))%10;
    }

   function Balance() public view returns(uint256){
      return token.balanceOf(msg.sender);
   }

}