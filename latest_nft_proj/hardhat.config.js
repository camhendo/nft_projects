require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("@nomiclabs/hardhat-ethers");
require('hardhat-contract-sizer');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
   solidity: {
     version: "0.8.6",
     settings: {
      optimizer: {
        enabled: true,
        runs: 2000,
        details: {
          yul: true,
          yulDetails: {
            stackAllocation: true,
            optimizerSteps: "dhfoDgvulfnTUtnIf"
          }
        }
      }
     }
   },
   networks: {
     mainnet: {
       url: process.env.MAINNET_URL || "",
       accounts: process.env.PRIVATE_KEY2 !== undefined ? [process.env.PRIVATE_KEY2] : [],
       gas: 3500000, // per gas used when deployed in test 
       gasPrice: 70000000000, // 70 gwei (current cost in eth station)
     },
     rinkeby: {
       url: process.env.RINKEBY_RPC_URL || "",
       accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
       // gas: 35000000, // per gas used when deployed in test 
       // gasPrice: 90000000000, // 70 gwei (current cost in eth station)
     },
     matic: {
       url: process.env.POLYGON_RPC_URL || "",
       accounts: process.env.PRIVATE_KEY2 !== undefined ? [process.env.PRIVATE_KEY2] : [],
       // gas: 35000000, // per gas used when deployed in test 
       // gasPrice: 90000000000, // 70 gwei (current cost in eth station)
     },
     mumbai: {
       url: process.env.POLYGON_MUMBAI_RPC_URL || "",
       accounts: process.env.PRIVATE_KEY2 !== undefined ? [process.env.PRIVATE_KEY2] : [],
       // gas: 35000000, // per gas used when deployed in test 
       // gasPrice: 90000000000, // 70 gwei (current cost in eth station)
     },
   },
   gasReporter: {
     enabled: process.env.REPORT_GAS !== undefined,
     currency: "USD",
   },
   etherscan: {
     apiKey: process.env.POLYGONSCAN_API_KEY,
   },
   mocha: {
     timeout: 100000
   },
   namedAccounts: {
     deployer: {
         default: 0, // here this will by default take the first account as deployer
         1: 0 // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
     },
     feeCollector: {
         default: 1
     }
    },
   contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true
   }
 };
  