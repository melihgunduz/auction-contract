
const hre = require("hardhat");

async function main() {

    const [deployer] = await hre.ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Balance:", (await deployer.provider.getBalance(deployer.address)));

    const Auction = await hre.ethers.getContractFactory("Auction");
    const auction = await Auction.deploy(); // Use the deploy() function

    await auction.deployed(); // Wait for the deployment to be confirmed

    console.log("Auction deployed to:", auction.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
