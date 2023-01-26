// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Counters.sol";

contract SkyNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _URI = "https://ipfs.filebase.io/ipfs/QmT7VQxnYV2hyF4pYDLpepoua4ox3YqW6Wr7ZwCKckpBiL";
    uint24 mintAmount;
    uint16 maxMintAmount;
    address owner;
    

    constructor(uint16 _maxMintAmount) ERC721("skyNFT", "skyNFT") {
        maxMintAmount = _maxMintAmount;
        owner = msg.sender;
    }

    function _baseURI() internal pure override returns (string memory) {
        return _URI;
    }

    function safeMint(address to) public payable{
        require(_tokenIdCounter.current < maxMintAmount, "Sorry, max mint reached.");
        assert(msg.value == mintAmount);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _URI);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    function setmintAmount (uint24 _Amount) onlyOwner external{
        mintAmount = _Amount;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }
 }
