const main = async () => {
  const ContractFactory = await hre.ethers.getContractFactory("CoolCats");

  // TODO: Change to where you will host your metadata
  const baseURI = "https://api.example.com";

  const contract = await ContractFactory.deploy({ args: [baseURI] });
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);
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
