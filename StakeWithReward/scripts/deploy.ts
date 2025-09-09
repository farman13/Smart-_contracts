import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hardhatOp",
  chainType: "op",
});

const [deployer] = await ethers.getSigners();

const TokenFactory = await ethers.getContractFactory("rewardToken", deployer);
const rewardToken = await TokenFactory.deploy();
await rewardToken.waitForDeployment();
const rewardTokenAddress = await rewardToken.getAddress();
console.log("Reward Token deployed to:", await rewardToken.getAddress());

const stakeFactory = await ethers.getContractFactory("stake", deployer);
const stake = await stakeFactory.deploy(rewardTokenAddress);

await stake.waitForDeployment();

console.log("Stake contract deployed to:", await stake.getAddress());

