// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Staking is Ownable, AccessControl {
    
    IERC20 public lpToken;
    IERC20 public rewardToken;

    uint120 public rewardTime;
    uint16 public rewardPercent;
    uint120 public lockTime;

    struct Stake {
        uint256 amount;
        uint256 stakeTime;
        bool staked;
    }

    mapping (address => Stake) users;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    event Staked(address user, uint256 amount, uint256 time);
    event Claimed(address user, uint256 amount, uint256 time);
    event Unstaked(address user, uint256 amount, uint256 time);

    constructor (address lpToken_, address rewardToken_) Ownable(msg.sender) {
        _grantRole(ADMIN_ROLE, msg.sender);
        lpToken = IERC20(lpToken_);
        rewardToken = IERC20(rewardToken_);
    }


    function stake(uint256 lpAmount) external {
        require(users[msg.sender].staked == false, "You already staked");
        require(lpAmount <= lpToken.balanceOf(msg.sender), "Insufficient balance");
        require(lpToken.allowance(msg.sender, address(this)) >= lpAmount, "Insufficient allowance to transfer tokens");

        lpToken.transferFrom(msg.sender, address(this), lpAmount);

        users[msg.sender].amount = lpAmount;
        users[msg.sender].stakeTime = block.timestamp;
        users[msg.sender].staked = true;

        emit Staked(msg.sender, lpAmount, users[msg.sender].stakeTime);
    }

    function claim() external {
        require(users[msg.sender].staked == true, "You did not stake");
        require(users[msg.sender].stakeTime >= block.timestamp + rewardTime, "You can not get reward yet");
        
        uint256 reward = users[msg.sender].amount * rewardPercent / 100;

        rewardToken.transfer(msg.sender, reward);

        emit Claimed(msg.sender, reward, block.timestamp);
    }

    function unstake() external {
        require(users[msg.sender].staked == true, "You did not stake");
        require(users[msg.sender].stakeTime >= block.timestamp + lockTime, "You can not get lp tokens yet");

        lpToken.transfer(msg.sender, users[msg.sender].amount);

        users[msg.sender].amount = 0;
        users[msg.sender].staked = false;

        emit Unstaked(msg.sender, users[msg.sender].amount, block.timestamp);
    }


    function setRewardTime(uint120 time) external onlyRole(ADMIN_ROLE) {
        rewardTime = uint120(block.timestamp) + time;
    }
    function setRewardPercent(uint16 percent) external onlyRole(ADMIN_ROLE) {
        rewardPercent = percent;
    }
    function setUnstakeTime(uint120 time) external onlyRole(ADMIN_ROLE) {
        lockTime = uint120(block.timestamp) + time;
    }

    function grantAdminRole(address admin) external onlyOwner {
        _grantRole(ADMIN_ROLE, admin);
    }
}