// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTstake {
    ERC20 skyToken;
    ERC721 skyNFT;
    //ERC721 NFT2;
    //ERC721 NFT3;
    address owner;

    struct Staker{
        address staker;
        uint24[] tokenId;
        uint40 timeOfStaking;
        uint24 currentRewards;
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
            transferFrom(msg.sender, address(this), _tokenId);
            s.stake = msg.sender;
            s.tokenId = _tokenId;
            s.timeOfStaking = block.timestamp;
    }

    function claimRewards() external{
        Staker storage s = stakerDetails[msg.sender];
        uint40 checkStakePeriod = s.timeOfStaking + block.timestamp;
        require(checkStakePeriod >= minStakingperiod, "Your staking period is not up to the set minimum staking period.");
        uint rewards = rewardperWeek * checkStakePeriod;
         
    }

    function setRewardPerWeek(skyToken numberOfTokens) external ownerRestriction {
        rewardperWeek = numberOfTokens * 10*decimal()/ 1 weeks;
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