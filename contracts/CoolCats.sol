// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Solidity Contract Template based on CoolCatsNFT @coolcatnft
 * Source: https://etherscan.io/address/0x1a92f7381b9f03921564a437210bb9396471050c#contracts
 *
 * The CoolCatsNFT contract is very well written and very gas efficient. 
 * Consider using this approach if you're creating NFTs off-chain.
 * Can cost as low as $100 at 14 October 2021 ETH Price of $3,527. 
 * CoolCatsNFT team deployed this contract for $55.59 at $1,983 ETH Price from 27 June 2021.
 *
 * The trick is to just use _safeMint without using _setTokenURI at all. Hence no ERC721Metadata.sol imported.
 * tokenURI function will just concatenate the baseURI with the token id when calling the function.
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * Each functions have been annotated based on my own research and findings from https://medium.com/coinmonks/what-i-learned-from-building-cool-cats-nft-4057f279d400
 *
 * Feel free to use and modify as you see appropriate
 */

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

// TODO: Make sure to change the CoolCats contract name to your own
contract CoolCatsTemplate is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string _baseTokenURI;
    // TODO: The amount of tokens you want to reserve
    uint256 private _reserved = 100;
    // TODO: Price for each NFT
    uint256 private _price = 0.06 ether;
    // Minting is paused by default. Call function to set to true when you're ready for people to mint.
    bool public _paused = true;

    // TODO: Withdraw addresses, it's my wallet address lol. Change this to your and add/remove address as needed.
    address t1 = 0x5e226ae843aDf2F0d7E8596fc1effc58eB0e2af8;
    address t2 = 0x5e226ae843aDf2F0d7E8596fc1effc58eB0e2af8;
    address t3 = 0x5e226ae843aDf2F0d7E8596fc1effc58eB0e2af8;
    address t4 = 0x5e226ae843aDf2F0d7E8596fc1effc58eB0e2af8;

    // Constructor to set the baseURI and give 4 first NFT to the designated address
    // TODO: Change "Cool Cats" and "COOL" to your own token name
    constructor(string memory baseURI) ERC721("Cool Cats", "COOL")  {
        setBaseURI(baseURI);

        // TODO: team gets the first 4 NFT. add/remove as needed.
        _safeMint( t1, 0);
        _safeMint( t2, 1);
        _safeMint( t3, 2);
        _safeMint( t4, 3);
    }

    // Minting function
    function adopt(uint256 num) public payable {
        // Assigning totalSupply to uint256 safe gas since you check for require later in line 53
        uint256 supply = totalSupply();
        // Check if minting is paused or active
        require( !_paused,                              "Sale paused" );
        // Only doing < safe gas instead of doing <= since we safe compuation to do equal comparison
        // Hard coding the number 21 also safe gas since this comparison will just happen in the stack
        // Change 21 to any max amount of minting you will allow in a single call
        require( num < 21,                              "You can adopt a maximum of 20 NFT" );
        require( supply + num < 10000 - _reserved,      "Exceeds maximum NFT supply" );
        // Make minting price to be price multiplied by number of NFT minted
        require( msg.value >= _price * num,             "Ether sent is not correct" );

        // Loop through the amount of num to mint as much as what num has
        for(uint256 i; i < num; i++){
            _safeMint( msg.sender, supply + i );
        }
    }

    function walletOfOwner(address _owner) public view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for(uint256 i; i < tokenCount; i++){
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    // Ability to change price if ETH gets too expensive
    function setPrice(uint256 _newPrice) public onlyOwner() {
        _price = _newPrice;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // Ability to change baseURI if you change your server/host
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getPrice() public view returns (uint256){
        return _price;
    }

    // Ability to giveAway NFT based on how many are reserved
    function giveAway(address _to, uint256 _amount) external onlyOwner() {
        require( _amount <= _reserved, "Exceeds reserved NFT supply" );

        uint256 supply = totalSupply();
        for(uint256 i; i < _amount; i++){
            _safeMint( _to, supply + i );
        }

        _reserved -= _amount;
    }

    // Call this function when you want to activate minting
    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdrawAll() public payable onlyOwner {
        // TODO: Everyone gets 25%. Change depending on how many wallets you will payout to
        uint256 _each = address(this).balance / 4;

        // TODO: Modify to the amount of payout addresses you'll have
        require(payable(t1).send(_each));
        require(payable(t2).send(_each));
        require(payable(t3).send(_each));
        require(payable(t4).send(_each));
    }
}