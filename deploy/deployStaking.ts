const hre = require("hardhat");

async function main_() {
    const lpTokenAddress = "0x474D558AB0573032E6CD1C391199eCC58f97f767";
    const rewardTokenAddress = "0xdF261b337F137646d010ae933Ab729fdfFb9f4e4";


    const Staking = await hre.ethers.getContractFactory("Staking");
    const staking = await Staking.deploy(lpTokenAddress, rewardTokenAddress);
    await staking.waitForDeployment();

    console.log("Staking contract deployed.");
}

main_().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}); 