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

const TokenFactory = await ethers.getContractFactory("Token", deployer);
const token = await TokenFactory.deploy(1000);
await token.waitForDeployment();
const tokenAddress = await token.getAddress();
console.log("Token deployed to:", await token.getAddress());
console.log("Token Total Supply:", await token.totalSupply());


const DonateWithTokenFactory = await ethers.getContractFactory("DonateWithToken", deployer);
const donateWithToken = await DonateWithTokenFactory.deploy(tokenAddress);

await donateWithToken.waitForDeployment();

console.log("Donate deployed to:", await donateWithToken.getAddress());


// npx hardhat compile
// npx hardhat run scripts/deploy.ts