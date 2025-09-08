import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hardhatOp",
  chainType: "op",
});

const [deployer] = await ethers.getSigners();

const TokenFactory = await ethers.getContractFactory("MyToken", deployer);
const token = await TokenFactory.deploy(1000);
await token.waitForDeployment();
const tokenAddress = await token.getAddress();
console.log("Token deployed to:", await token.getAddress());
console.log("Token Total Supply:", await token.totalSupply());

const TokenPreSaleFactory = await ethers.getContractFactory("TokenPreSale", deployer);
const tokenPreSale = await TokenPreSaleFactory.deploy(tokenAddress, 123456789988765645464n);

await tokenPreSale.waitForDeployment();

console.log("TokenPreSale deployed to:", await tokenPreSale.getAddress());
console.log("Transaction sent successfully");
