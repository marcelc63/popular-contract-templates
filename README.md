# Solidity Contract Template based on Corruption(s\*) by [@dhof](https://twitter.com/dhof)

Source: [https://etherscan.io/address/0x5bdf397bb2912859dbd8011f320a222f79a28d2e](https://etherscan.io/address/0x5bdf397bb2912859dbd8011f320a222f79a28d2e)

@dhof stealthily dropped a new NFT called corruption(s\*). Took the NFT world by a storm again
as 4,196 available NFT sold out in 15 minutes and traded for 0.7 eth floor at its peak.
Breaking down @dhof's contracts never get boring!

Corruption(s\*) combines the use of ASCII art and interaction with the blockchain's block number.
It uses the block number to calculate insight that increases if the NFT is left alone, and decreases
if moved. Then we get this super funky ASCII art! Let's see how it works.

Curated by [@marcelc63](https://twitter.com/marcelc63) - [marcelchristianis.com](https://marcelchristianis.com)
Each functions have been annotated based on my own research.

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

# Commands to use

```
// To test

npx hardhat run scripts/run.js
npx hardhat test

// To deploy to Rinkeby testnet

npx hardhart run scripts/deploy.js --network rinkeby
```
