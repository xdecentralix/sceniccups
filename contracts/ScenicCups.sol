// SPDX-License-Identifier: MIT 
pragma solidity 0.8.14; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ScenicCups is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 mintedSupplyCounter = 0;
    uint256 burnedSupplyCounter = 0;
    
    string private _baseTokenURI;

    constructor (string memory baseTokenURI) ERC721("Scenic Cups", "SC") {
        _tokenIdCounter.increment();
        _baseTokenURI = baseTokenURI;
    }

    function contractURI() public pure returns (string memory) {
        return "ipfs://bafybeicxuy3l7lfeemurztjzdmp4p6gz6gviqxeb5axlqbmwuh23ynkmhe/ScenicCupsContract.json";
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function safeMint(address to) public payable {
        require(_tokenIdCounter.current() <= 100, "Maximum number of NFTs already minted");
        require(msg.value == (0.08 ether + 0.001 ether * (_tokenIdCounter.current() - 1)) , "Incorrect ETH amount, please send the correct amount  ETH.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        mintedSupplyCounter++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function withdrawAllFunds(address payable _to) public onlyOwner {
        _to.transfer(address(this).balance);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        burnedSupplyCounter++;
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
        string memory dotJson = ".json";
        return string(abi.encodePacked(_baseTokenURI, Strings.toString(tokenId), dotJson));
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getMintedSupplyCounter() public view returns(uint256)
    {
        return mintedSupplyCounter;
    }

    function getBurnedSupplyCounter() public view returns(uint256)
    {
        return burnedSupplyCounter;
    }

}