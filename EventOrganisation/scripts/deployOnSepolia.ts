// scripts/deploy-op.ts
import { network } from "hardhat";

const { ethers } = await network.connect({
  network: "sepolia",   // must be defined in hardhat.config.ts
  chainType: "l1",        // Optimism chain type
});

console.log("Deploying contract on sepolia…");

const [deployer] = await ethers.getSigners();
console.log("Deployer:", deployer.address);

const eventFactory = await ethers.getContractFactory("Event", deployer);
const event = await eventFactory.deploy();

await event.waitForDeployment();

console.log("Event Contract deployed to:", await event.getAddress());

// npx hardhat --init
// npx hardhat compile
// npx hardhat run scripts/deploy.ts or npx hardhat run scripts/deployOnSepolia.ts --network sepolia
