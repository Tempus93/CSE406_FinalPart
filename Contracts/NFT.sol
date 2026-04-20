// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EngineeringNFT is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    // Task 1: Custom Collection Name and Symbol
    constructor() ERC721("JustinEngineerCollection", "JEC") Ownable(msg.sender) {}

    // Task 3: Mint function that takes the IPFS JSON link
    function mintMembership(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri); 
    }
}