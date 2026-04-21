const hre = require("hardhat");

async function main() {
  // 1. Define your addresses from Part 1 and Part 2
  const coinAddress = "0x94ddEf20Ee4D5635C238b88D1B745737530BFD33"; 
  const nftAddress = "0xE21b046C4e3b8fF809F84a63186C55b466928AF7";

  console.log("Deploying Vault with Coin:", coinAddress, "and NFT:", nftAddress);

  // 2. Get the Vault Contract Factory
  const Vault = await hre.ethers.getContractFactory("Vault");

  // 3. Deploy the Vault passing both addresses to the constructor
  const vault = await Vault.deploy(coinAddress, nftAddress);

  // 4. Wait for the deployment to finish
  await vault.waitForDeployment();
  
  const vaultAddress = await vault.getAddress();

  console.log("-----------------------------------------");
  console.log("SUCCESS! Vault deployed to:", vaultAddress);
  console.log("-----------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});