import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hardhatOp",
  chainType: "op",
});

const [deployer] = await ethers.getSigners();

const FundMeFactory = await ethers.getContractFactory("FundMe", deployer);
const fundMe = await FundMeFactory.deploy();

await fundMe.waitForDeployment();

console.log("FundMe contract deployed to:", await fundMe.getAddress());