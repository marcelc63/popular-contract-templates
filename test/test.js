const { ethers } = require("hardhat");

describe("CoolCats", function () {
  it("Should return mint 20 NFTs", async function () {
    const Contract = await ethers.getContractFactory("CoolCats");

    // TODO: Change to where you will host your metadata
    const baseURI = "https://api.example.com";

    const contract = await Contract.deploy({ args: [baseURI] });
    await contract.deployed();

    // Activate minting
    let setActivateTx = await contract.pause(false);
    await setActivateTx.wait();

    // Test adopting 20 cats
    const setAdoptTx = await contract.adopt(20, {
      value: hre.ethers.utils.parseEther("1.2"),
    });

    // wait until the transaction is mined
    await setAdoptTx.wait();
  });
});
