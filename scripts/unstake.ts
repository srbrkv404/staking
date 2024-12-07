import { ethers } from 'hardhat';
import { config } from 'dotenv';
const getContract_staking = require('./getContract.ts');

config();

async function unstake() {
    const contract = await getContract_staking();

    try {
        const [acc1, acc2] = await ethers.getSigners();

        console.log(`Unstaking...`);

        const tx = await contract.unstake();

        await tx.wait();
        console.log(`Transaction finished: ${tx.hash}`);
    } catch (error) {
        console.error(`Error sending transaction: ${error}`);
    }

}

unstake()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }); 