// scripts/deploy-op.ts
import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "hardhatOp",   // must be defined in hardhat.config.ts
  chainType: "op",        // Optimism chain type
});

console.log("Deploying Donate contract on OP…");

const [deployer] = await ethers.getSigners();
console.log("Deployer:", deployer.address);
console.log("Balance:", (await ethers.provider.getBalance(deployer.address)).toString());

const DonateFactory = await ethers.getContractFactory("Donate", deployer);
const donate = await DonateFactory.deploy();

await donate.waitForDeployment();

console.log("Donate deployed to:", await donate.getAddress());

// npx hardhat compile
// npx hardhat run scripts/deploy.ts