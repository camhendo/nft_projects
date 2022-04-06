# Welcome to a repo for all my NFTs 
### (that are public right now at least)
---

In this repo you'll find three main files. 


1. Inside [contracts](https://github.com/camhendo/nft_projects/tree/master/contracts) you will find the solidity contracts that I have built. They're usually named after the nft they were created for. 

2. Inside [scripts](https://github.com/camhendo/nft_projects/tree/master/scripts) you will find the corresponding scripts that were used to deploy the contracts. In most cases I deploy to polygon (gas fees for L1 ethereum are a little insane)

3. Inside [latest_nft_proj](https://github.com/camhendo/nft_projects/tree/master/latest_nft_proj) you'll find the most recent project I've been working on/worked on. I haven't included all the source files because they take up quite a bit of space and are not specifically necessary for you to understand the logic of the contracts themselves. 

---

However, my projects do make use of some wonderful templates and plugins that make smart contract development a lot easier. Here's a short list of the ones that I use the most often. 

[hardhat](https://hardhat.org/) - for project creations, testing, and deployments 

[openzeppelin](https://openzeppelin.com/) - provider of standardized contracts for ERC20, ERC721 (nft), ERC1155 (token/nft combo) and many more. A growing standard for any sort of smart contract development with solidity. 

[chainlink](https://chain.link/) - smart contract oracles (I don't use this for smaller projects, but for larger projects where randomness can't be deterministic, chainlink is what I use to recieve truly random variables)

---

## If you'd like to use parts of these NFTs for your own contracts/deployments

For contracts

    git clone https://github.com/camhendo/nft_projects/contracts.git

For deployments

    git clone https://github.com/camhendo/nft_projects/scripts.git

## If you're making your first NFT, I'm not the best resource, but here's what I used

First, I read a lot of the documentation for OpenZeppelin because it helps you understand the underlying functionalities

But this [tutourial](https://www.youtube.com/watch?v=9oERTH9Bkw0) by Patrick Collins is amazing. I think I watched this 5-6 times through the process of my first NFT. His channel is a great resources

# Where can I see the current NFTs!

## EggNFT

[Polygonscan](https://polygonscan.com/address/0x2eb0e66C9D3f38fbA4Ad883e81d48221C9740ff0) - for minting new Eggs and reading/writing to the contract

[Opensea](https://opensea.io/collection/thisisegg)

## How to Mint EggNFT

[Instructions](https://github.com/camhendo/nft_projects/tree/master/latest_nft_proj)


Contact me:
Twitter: [@_camhendo](https://twitter.com/_camhendo)