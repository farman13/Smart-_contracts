import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hardhatOp",
  chainType: "op",
});

const [deployer] = await ethers.getSigners();

const tokenFactory = await ethers.getContractFactory("Token", deployer);
const token = await tokenFactory.deploy();

await token.waitForDeployment();

const tokenAddress = await token.getAddress();

const CoinFlipFactory = await ethers.getContractFactory("CoinFlips", deployer);
const coinFlip = await CoinFlipFactory.deploy(tokenAddress);

await coinFlip.waitForDeployment();

console.log("CoinFlip Game contract Address : ", await coinFlip.getAddress());
