//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20,Ownable{
    
    constructor() 
    ERC20("FTK","FTK Token")
    Ownable(msg.sender)
    {}

    function mint(address to, uint256 amount) onlyOwner public {
        _mint(to,amount*1e18);
    }
}



