const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("CoolCats");

  // TODO: Change to where you will host your metadata
  const baseURI = "https://api.example.com";

  const contract = await ContractFactory.deploy({ args: [baseURI] });
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

  // Activate minting
  let activateTxn = await contract.pause(false);
  await activateTxn.wait();

  // Call the function.
  let adoptTxn = await contract.adopt(20, {
    value: hre.ethers.utils.parseEther("1.2"),
  });
  // Wait for it to be mined.
  await adoptTxn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
