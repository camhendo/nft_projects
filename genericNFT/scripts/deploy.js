let { networkConfig, getNetworkIdFromName } = require('../helper-hardhat-config')
const fs = require('fs')
const hre = require("hardhat")

async function main() {
  const [deployer] = await ethers.getSigners()
  console.log("Deploying contracts with the account:",deployer.address)
  const svgComponents = await ethers.getContractFactory('svgComponents')
  const svgLib = await svgComponents.deploy()
  console.log('library deployed')
  
  const Egg = await hre.ethers.getContractFactory("Egg", {
          libraries: {
              svgComponents: svgLib.address
          }
      })
  console.log('got contract')
  const egg = await Egg.deploy()
  console.log('deployed?')
  await egg.deployed()
  console.log("EggNFT deployed to:", egg.address)
  console.log(`Verify with:\n npx hardhat verify --network mumbai ${egg.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
