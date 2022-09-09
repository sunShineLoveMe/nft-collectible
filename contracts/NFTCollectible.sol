// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollectible is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    // 已经mint的tokenID
    Counters.Counter private _tokenIds;

    // 本合约供应最大数量
    uint public constant MAX_SUPPLY = 100;
    // 购买一个nft需要的以太币数量
    uint public constant PRICE = 0.01 ether;
    // 一次铸造nft的数量上限
    uint public constant MAX_PER_MINT = 5;
    // 包含json元数据的文件夹
    string public baseTokenURI;

    // 构造函数
    constructor(string memory baseURI) ERC721("NFTCollectible", "NFTC") {
        setBaseURI(baseURI);
    }

    // 团队预留
    function reserveNFTs() public onlyOwner() {
        // 检查目前为止铸造的NFT的总数
        uint totalMinted = _tokenIds.current();
        // 检查是否有足够的的NFT供mint
        require(totalMinted.add(10) < MAX_SUPPLY, "Not enough NFTs");
        // 循环mint
        for(uint i = 0; i < 10; i++) {
           _mintSingleNFT();     
        }
    }

    function _baseURI() internal view virtual override returns(string memory) {
        return baseTokenURI;
    }

    // 设置基本baseurl路径，供构造器调用
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function mintNFTs(uint _count) public payable {
        uint totalMinted = _tokenIds.current();
        // 检查已经铸造的Nfts的数量是否超过合约规定的最大NFts
        require(
            totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFTs"
        );

        // 检查每次mint的数量，要大于0小于每次mint的最大数量
        require(_count > 0 && _count <= MAX_PER_MINT, "Cannot mint specified number of NFTs");

        // 检查每次Mint所需要的金额是否大于等于应该需要的金额
        require(msg.value >= PRICE.mul(_count), "Not enough ether to purchse NFTs");

        for(uint i = 0; i < _count; i++) {
            _mintSingleNFT();
        }
    }

    // 单次mint
    function _mintSingleNFT() private {
        // 得到当前还没有mint的tokenID
        uint newTokenID = _tokenIds.current();
        // 使用safemint函数，将该NFTID分配给该函数的账户
        _safeMint(msg.sender, newTokenID);
        // 递增加1
        _tokenIds.increment();
    }

    /**
        返回owner持有的tokenId的数组
     */
    function tokensOfOwner(address _owner) external view returns(uint[] memory) {
        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);
        for (uint i = 0; i < tokenCount; i++) {
          tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    function withDraw() public payable onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ether left to withDraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer is failed.");
    }

}
