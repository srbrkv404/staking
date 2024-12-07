import { ethers } from 'hardhat';
const hre = require("hardhat");

async function getContract() {
    const address = "0x052C4E69e0A7c2fCe168Ee6BA0B94dcAefdb06B6";
    return await ethers.getContractAt("Staking", address);
}

module.exports = getContract;