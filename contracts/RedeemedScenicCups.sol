// SPDX-License-Identifier: MIT 
pragma solidity 0.8.14; 

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RedeemedScenicCups is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _baseTokenURI;

    constructor (string memory baseTokenURI) ERC721("Redeemed Scenic Cups", "rSCENICCUPS") {
        _tokenIdCounter.increment();
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function contractURI() public pure returns (string memory) {
        return "ipfs://bafybeifrgmdmi6nc5bdlnr7ukaytxgm4nqjpdo6zyy5owaabaclc4u2hkm/RedeemedScenicCupsContract.json";
    }

    function safeMint(address to, uint _tokenId) public onlyOwner {
        require(_tokenIdCounter.current() <= 100, "Maximum number of NFTs already minted.");
        _tokenIdCounter.increment();
        _safeMint(to, _tokenId);
        _setTokenURI(_tokenId, tokenURI(_tokenId));
    }

    function withdrawAllFunds(address payable _to) public onlyOwner {
        _to.transfer(address(this).balance);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
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

}