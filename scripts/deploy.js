
const hre = require("hardhat");

async function main() {

    const [deployer] = await hre.ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Balance:", (await deployer.provider.getBalance(deployer.address)));

    const auction = await hre.ethers.deployContract("Auction");

    console.log("Bank deployed to:", await auction.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
