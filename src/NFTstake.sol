// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTstake is IERC721Receiver {
    ERC20 skyToken;
    ERC721 skyNFT;
    //ERC721 NFT2;
    //ERC721 NFT3;
    address owner;

    struct Staker{
        address staker;
        uint24 tokenId;
        uint40 timeOfStaking;
        uint24 currentRewards;
        uint40 lastTimeClaimed;
        bool claimedFirstReward;

    }

    uint8 rewardperWeek;
    uint8 minStakingperiod;
    mapping (address => Staker) stakerDetails;

    constructor (ERC721 _skyNFT, ERC20 _skyToken
    //ERC721 _nft2, ERC721 _nft3
    ){
        owner = msg.sender;
        skyNFT = _skyNFT;
        skyToken = _skyToken;
        //NFT2 = _nft2;
        //NFT3 = _nft3;
    }

    function stake(skyNFT _tokenId) external {
            Staker storage s = stakerDetails[msg.sender];
            safeTransferFrom(msg.sender, address(this), _tokenId);
            s.stake = msg.sender;
            s.tokenId = _tokenId;
            s.timeOfStaking = block.timestamp;
    }

    function claimRewards() external{
        Staker storage s = stakerDetails[msg.sender];
        if (s.claimedFirstReward == false) {
            
        uint40 checkStakePeriod = block.timestamp / s.timeOfStaking;
        require(checkStakePeriod >= minStakingperiod, "Your staking period is not up to the set minimum staking period.");
        uint rewards = rewardperWeek * checkStakePeriod;
        s.claimedFirstReward = true;
        s.lastTimeClaimed = block.timestamp;
        skyToken.mint(msg.sender, rewards);

        } else {    
        uint40 checkStakePeriod = block.timestamp / s.lastTimeClaimed;
        require(checkStakePeriod >= minStakingperiod, "Your staking period is not up to the set minimum staking period.");
        uint rewards = rewardperWeek * checkStakePeriod;
        s.lastTimeClaimed = block.timestamp;
        skyToken.mint(msg.sender, rewards);
        }
         
    }

    function claimRewardsAndNFT() external {
        Staker storage s = stakerDetails[msg.sender];
        if (s.claimedFirstReward == false) {
            
        uint40 checkStakePeriod = block.timestamp / s.timeOfStaking;
        require(checkStakePeriod >= minStakingperiod, "Your staking period is not up to the set minimum staking period.");
        uint rewards = rewardperWeek * checkStakePeriod;
        s.claimedFirstReward = true;
        s.lastTimeClaimed = block.timestamp;
        skyNFT.transferFrom(address(this), msg.sender, s.tokenId);
        skyToken.mint(msg.sender, rewards);
        delete stakerDetails[msg.sender];

        } else {    
        uint40 checkStakePeriod = block.timestamp / s.lastTimeClaimed;
        require(checkStakePeriod >= minStakingperiod, "Your staking period is not up to the set minimum staking period.");
        uint rewards = rewardperWeek * checkStakePeriod;
        s.lastTimeClaimed = block.timestamp;
        skyNFT.transferFrom(address(this), msg.sender, s.tokenId);
        skyToken.mint(msg.sender, rewards);
        delete stakerDetails[msg.sender];
        }
    }

    function checkTotalRewards() external returns (uint256){
        Staker storage s = stakerDetails[msg.sender];
        if (s.claimedFirstReward == false) {
            uint40 stakePeriod = block.timestamp / s.timeOfStaking;
            uint rewards = stakePeriod * rewardperWeek;
            return rewards;
        } else {
            uint40 stakePeriod = block.timestamp / s.lastTimeClaimed;
            uint rewards = stakePeriod * rewardperWeek;
            return rewards;
        }
    }

    function setRewardPerWeek(skyToken numberOfTokens) external ownerRestriction {
        rewardperWeek = numberOfTokens * 10 ** decimal()/ 1 weeks;
    }

    function setMinStakingPeriod (uint8 _minStakePeriod) external ownerRestriction{
        minStakingperiod = _minStakePeriod;
    }
    
    modifier ownerRestriction(){
        require(msg.sender == owner, "Function access restricted to contract owner");

        _;
    }
}
//nft development advanced tutorials