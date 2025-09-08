// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

struct Donaters{
     address Donater;
     uint amount; 
}
contract Donate{

     
    address public owner;

    Donaters[] DonaterList;
    Donaters[3] topDonors;
    mapping(address => bool) ExistingDonars;
    mapping(address =>bool)  allowance;

    event Donate__AmountDonated(address indexed user, uint256 indexed amount);
    event Donate__AmountWithdraw(address indexed user, uint256 indexed amount);
    
    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner{
        require(msg.sender==owner);
        _;
    }

    function Donater() payable public {
        require(msg.value>0,"Appreciating! I think u want to Donate, please try again");
        if(ExistingDonars[msg.sender]){
        for(uint i=0;i<DonaterList.length;i++){
            if(DonaterList[i].Donater == msg.sender){
                DonaterList[i].amount += msg.value;
                updateTopDonors(Donaters(msg.sender,DonaterList[i].amount));
                break;
            }
        }
        }
        else{
            DonaterList.push(Donaters(msg.sender,msg.value));
            ExistingDonars[msg.sender] = true;
            updateTopDonors(Donaters(msg.sender,msg.value));
        }
        emit Donate__AmountDonated(msg.sender, msg.value);

    }

    function Allow(address _user) public OnlyOwner {
        allowance[_user] = true;
    }

    function withdraw() public{
        require(msg.sender==owner || allowance[msg.sender]==true);
        payable(msg.sender).transfer(address(this).balance);

        emit Donate__AmountWithdraw(msg.sender, address(this).balance);
    }
    
    function TopDonars() public view returns(Donaters[3] memory){
        return topDonors;
    }

    function updateTopDonors(Donaters memory D1) internal  {
            if (D1.amount > topDonors[0].amount) {
                topDonors[2] = topDonors[1];
                topDonors[1] = topDonors[0];
                topDonors[0] = D1;
            } else if (D1.amount > topDonors[1].amount) {
                topDonors[2] = topDonors[1];
                topDonors[1] = D1;
            } else if (D1.amount > topDonors[2].amount) {
                topDonors[2] = D1;
            }

    }

  }
