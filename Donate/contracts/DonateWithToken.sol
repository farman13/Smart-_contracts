// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

struct Donaters{
     address Donater;
     uint amount; 
}
contract DonateWithToken{
    address public owner;
    IERC20 public FTK_token;

    Donaters[] DonaterList;
    Donaters[3] topDonors;
    mapping(address => bool) ExistingDonars;
    mapping(address =>bool)  allowance;

    event DonateWithToken__AmountDonated(address indexed user, uint256 indexed amount);
    event DonateWithToken__AmountWithdraw(address indexed user, uint256 indexed amount);
    
    constructor(address token) {
        owner = msg.sender;
        FTK_token = IERC20(token);
    }

    modifier  OnlyOwner{
        require(msg.sender==owner);
        _;
    }

    function Donater(uint amount) payable public {
        require(amount>0,"Appreciating! I think u want to Donate, please try again");
        if(ExistingDonars[msg.sender]){
        for(uint i=0;i<DonaterList.length;i++){
            if(DonaterList[i].Donater == msg.sender){
                DonaterList[i].amount += amount;
              bool success=  FTK_token.transferFrom(msg.sender,address(this),amount);  //Update
              require(success,"Fail Bhaiya ...Transaction ");  
                updateTopDonors(Donaters(msg.sender,DonaterList[i].amount));
                break;
            }
        }
        }
        else{
            DonaterList.push(Donaters(msg.sender,amount));
          bool success = FTK_token.transferFrom(msg.sender,address(this),amount);  // update
            require(success,"Fail Bhaiya ...Transaction ");
            ExistingDonars[msg.sender] = true;
            updateTopDonors(Donaters(msg.sender,amount));
        }

        emit DonateWithToken__AmountDonated(msg.sender, amount);

    }

    function Allow(address _user) public OnlyOwner {
        allowance[_user] = true;
    }

    function withdraw(uint256 amount) public{
        require(msg.sender==owner || allowance[msg.sender]==true);
       bool success =  FTK_token.transfer(msg.sender,amount);   //update
       require(success,"Token withdrawl Failed");

       emit DonateWithToken__AmountWithdraw(msg.sender,amount);
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

    function AllDonaters() public view returns( Donaters[] memory){
         return DonaterList;
    }

  }

  /*
  ********* Changes ********
  1. Now instead of using msg.value , we are passing the amount agrument in the Donate() so that this 
     amount is passed into the transferFrom() of token contract. 
     And the tokens from the donar is sent to Donate contract address.
  2. In the withdraw() , we are calling the tranfer() of token contract and passing the address of withdrawl 
     and all the donate contract collected tokens. so that these tokens gets pass to the withdrawl account. 

*/
  