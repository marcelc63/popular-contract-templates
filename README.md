# Solidity Contract Template based on [@chain_runners](https://twitter.com/chain_runners)

Source: [https://etherscan.io/address/0x97597002980134bea46250aa0510c9b90d87a587](https://etherscan.io/address/0x97597002980134bea46250aa0510c9b90d87a587)

Chain Runners is a collection of 10,000 renegades 100% stored and generated on chain.
They recently caught the attention of the NFT community and their floor price has surged
through the weekend. Their on chain pixel generation is one to look out for.

To do their on chain pixel generation, they use many advanced techniques. For example,
all layers information is stored as bytecode. To construct the final image, they parsed
them as rgba values to plot each pixel on to the canvas. We'll see how its done here.

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
