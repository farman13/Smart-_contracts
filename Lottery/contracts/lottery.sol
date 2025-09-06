// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Lottery{

    
    address public manager;
    address payable[] public participants;

    event Lottery_Winner(address indexed winner, uint256 indexed amount);
    
    constructor(){
        manager = msg.sender;
    }

    receive() external payable {      
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }
    
    function checkBalance() public view returns(uint) {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function Random() private view returns(uint){
      return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }

    function SelectWinner() public {

       require(msg.sender==manager);
       require(participants.length>=3);

       uint r = Random();
       uint index = r % participants.length;
       
       address payable Winner = participants[index];
       Winner.transfer(checkBalance());
       participants = new address payable[](0);

       emit Lottery_Winner(Winner,checkBalance());
    } 
}