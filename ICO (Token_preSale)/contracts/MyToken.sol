// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initSupply) ERC20("Kick&Lift","FTK"){
        _mint(msg.sender, initSupply*(10**18));
    }
}
