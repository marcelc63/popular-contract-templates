# Solidity Contract Template based on Adventure Gold

Source: [https://etherscan.io/address/0x32353a6c91143bfd6c7d363b546e62a9a2489a20](https://etherscan.io/address/0x32353a6c91143bfd6c7d363b546e62a9a2489a20)

The Adventure Gold's contract airdrops AGLD token to the holder of a loot bag.
Each loot bag owners receive 10,000 AGLD per bag. As of 9 November 2021, this will
worth $27,8000. ERC20 as a derivative is a powerful addition to an NFT ecosystem.

The airdrop of AGLD is achieved through communication between AGLD's contract and
Loot's contract. In reality, it's not really an airdrop but more like a permission to claim.
In this template, we'll see how to create ERC20 tokens that complement an NFT.

Curated by [@marcelc63](https://twitter.com/marcelc63) - [marcelchristianis.com](https://marcelchristianis.com)
The original author has done extensive commenting of the contract. Here I mainly
provide elaborations.

Feel free to use and modify as you see appropriate

# Using the Template

Please do the followings

1. Modify any code that's labeled with TODO
2. Change the baseURI in deploy.js, run.js, and test.js
3. Make sure to create your own .env and modify hardhat.config.js accordingly with your deployment URL and accounts private key.
4. Remove the comments and annotation

# Included in the Template

1. Contract that CoolCatsNFT used
2. Complete commentary on core functions
3. Deployment Script
4. Testing Script
   **NOTE: Testing might not work for this template since it tries to call Loot's smart contract but that only exists in Mainnet. You might need to run your own instance of Loot' smart contract.**

# Commands to use

```
// To test

npx hardhat run scripts/run.js
npx hardhat test

// To deploy to Rinkeby testnet

npx hardhart run scripts/deploy.js --network rinkeby
```
