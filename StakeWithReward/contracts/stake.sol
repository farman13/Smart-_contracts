// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol'; 

contract stake {

   event stake__withdraw(address indexed userAddress,uint256 indexed amount); 
   event stake__staked(address indexed userAddress,uint256 indexed amount);
   event stake__unstaked(address indexed userAddress,uint256 indexed amount);

   error stake__MoreThanZero();
   error stake__TransactionFail();
   error stake__NotEnoughUnclaimedTokens();
   
   struct userStakes{
    uint stakeAmount;
    uint stakeTimestamp;
   }

   modifier MoreThanZero(){
    if(msg.value == 0){
        revert stake__MoreThanZero();
    }
   _;
   }

   constructor(address _tokenAddress){
    rewardToken = IERC20(_tokenAddress);
   }
    
    IERC20 public rewardToken;

    mapping(address user => userStakes userInfo) public userStakesInfo;
    mapping(address user => uint256 rewardtoken) public unClaimedRewardToken;

    function stakeEth() public payable MoreThanZero {
         
         if(userStakesInfo[msg.sender].stakeAmount > 0 ){

            calculateReward(msg.sender);
            userStakesInfo[msg.sender].stakeAmount += msg.value;
            userStakesInfo[msg.sender].stakeTimestamp = block.timestamp;
         }
         else{
            userStakesInfo[msg.sender] = userStakes(msg.value,block.timestamp);
         }

        emit stake__staked(msg.sender,msg.value);
    }

    function withDrawReward() public {
        
        if(unClaimedRewardToken[msg.sender] == 0 && userStakesInfo[msg.sender].stakeAmount == 0){
            revert stake__NotEnoughUnclaimedTokens();
        }
        calculateReward(msg.sender);
        userStakesInfo[msg.sender].stakeTimestamp = block.timestamp;

        uint totalReward = unClaimedRewardToken[msg.sender];
        unClaimedRewardToken[msg.sender] = 0;
        rewardToken.transfer(msg.sender, totalReward);

        emit stake__withdraw(msg.sender,totalReward);
    }

    function unstake(uint _amount) public {
        
        calculateReward(msg.sender);

        userStakesInfo[msg.sender].stakeAmount -= _amount;
        userStakesInfo[msg.sender].stakeTimestamp = block.timestamp;
        
        (bool success,) = payable(msg.sender).call{value:_amount}("");
         
        if(!success){
          revert stake__TransactionFail();
        }

        emit stake__unstaked(msg.sender,_amount);
    }

    function calculateReward(address user) internal {
       
        uint rewardTimeperiod = block.timestamp - userStakesInfo[user].stakeTimestamp;
        uint stakedAmount = userStakesInfo[user].stakeAmount;
        uint reward = stakedAmount * rewardTimeperiod;
        unClaimedRewardToken[msg.sender] += reward;
    }

}