# Solidity Contract Template based on AltNouns by [@onChainCo](https://twitter.com/onChainCo) [https://occ.xyz](https://occ.xyz)

Source: [https://etherscan.io/address/0x971a6ff4f5792f3e0288f093340fb36a826aae96](https://etherscan.io/address/0x971a6ff4f5792f3e0288f093340fb36a826aae96)

[@onChainCo](https://twitter.com/onChainCo) drop this marvel of a contract. AltNouns is a derivative of NounsDAO. As a new Noun gets minted, a new AltNouns will be created. This makes AltNouns an infinite derivative that will create new derivative forever.

AltNouns achieve this through two main mechanism: calling Nouns' smart contract and clever SVG manipulation. In this template we'll see how AltNouns is able to be an infinite derivative and how to alters the original Noun SVG.

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

**NOTE: Testing might not work for this template since it tries to call Noun's smart contract but that only exists in Mainnet. You might need to run your own instance of Nouns' smart contract.**

# Commands to use

```
// To test

npx hardhat run scripts/run.js
npx hardhat test

// To deploy to Rinkeby testnet

npx hardhart run scripts/deploy.js --network rinkeby
```
