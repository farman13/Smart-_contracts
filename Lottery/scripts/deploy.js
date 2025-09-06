async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

    const LotteryFactory = await ethers.getContractFactory("Lottery");
    const lottery = await LotteryFactory.deploy();

    await lottery.waitForDeployment();

    console.log("Lottery deployed to:", await lottery.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });