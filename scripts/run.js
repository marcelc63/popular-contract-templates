const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("ZorbNFT");

  const contract = await ContractFactory.deploy(
    "0xCa21d4228cDCc68D4e23807E5e370C07577Dd152"
  );
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

  let txn = await contract.mint();
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
