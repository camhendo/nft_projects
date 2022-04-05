// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners()
  console.log("Deploying contracts with the account:",deployer.address)
  const HeartsNFT = await hre.ethers.getContractFactory("HeartsNFT")
  console.log('got contract')
  const heartsNFT = await HeartsNFT.deploy()
  console.log('deployed?')
  await heartsNFT.deployed()
  console.log("HeartsNFT deployed to:", heartsNFT.address);
  console.log(`Verify with:\n npx hardhat verify --network rinkeby ${heartsNFT.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
