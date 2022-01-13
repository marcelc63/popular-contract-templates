const { ethers } = require("hardhat");

describe("LootTemplate", function () {
  it("Should mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("LootTemplate");

    const contract = await Contract.deploy();
    await contract.deployed();

    // Mint loot bag with token id 1
    let mintTxn = await contract.claim(1);
    await mintTxn.wait();

    // Check the tokenURI
    let tokenURI = await contract.tokenURI(1);
    console.log(tokenURI);
  });
});
