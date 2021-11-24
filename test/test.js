const { ethers } = require("hardhat");

describe("LootTemplate", function () {
  it("Should mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("ChainRunners");

    const contract = await Contract.deploy();
    await contract.deployed();

    const RendererContract = await ethers.getContractFactory(
      "ChainRunnersBaseRenderer"
    );

    const rendererContract = await RendererContract.deploy();
    await rendererContract.deployed();

    // NOTE: Will update with code on setting renderer contract and bytecodes
  });
});
