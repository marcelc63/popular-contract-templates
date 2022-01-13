// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on SuperSea https://nonfungible.tools
 * Source: https://etherscan.io/address/0x24E047001f0Ac15f72689D3F5cD0B0f52b1abdF9
 *
 * SuperSea contract showcases how you can use NFT for memberships and contract for subscription. 
 * Access to member-only features are protected behind a paywall that is unlocked through this contract.
 * The subscription logic allows you to collect payment and give access to users.
 * The NFT membership allows you to grant lifetime access to NFT holders.
 *
 * This contract represents a very real use case where you can now provide authentication, 
 * memberships, and subscriptions through the blockchain.
 * I see this as a common practice as web3 obtain even wider adoption.
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * Each functions have been annotated based on my own research.
 *
 * Feel free to use and modify as you see appropriate
 */

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/Pausable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract SuperSea is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    // TODO: Change this with your own base URL
    string _baseTokenURI = 'https://api.example.com/';
    // TODO: NFT price. Adjust this with your own price
    uint256 private _price = 0.75 ether;

    // TODO: Decide the amount of reserved token and total supply
    uint256 RESERVED_FOUNDING_MEMBERS = 10;
    uint256 FOUNDING_MEMBERS_SUPPLY = 100;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _subscriptionCounter;

    // The structure for plans is to store the price and duration of the plan
    struct SubscriptionPlan {
        uint256 price;
        uint256 duration;
    }

    // Then we store available plans in a map
    mapping (uint => SubscriptionPlan) subscriptionPlans;

    // Address -> Date in time
    mapping (address => uint256) subscriptionExpiration;

    event Mint(address indexed _address, uint256 tokenId);
    event Subscription(address _address, SubscriptionPlan plan, uint256 timestamp, uint256 expiresAt, uint256 subscriptionCounter);

    // TODO: Change "Non Fungible Tools Membership" and "NFTOOLS" to your own token name
    constructor() ERC721("Non Fungible Tools Membership", "NFTOOLS") {
	// TODO: Adjust this to create your own plans
	// The unit days is a special unit supported within the ethereum virtual machine denoting time
        subscriptionPlans[0] = SubscriptionPlan(0.1 ether, 30 days);
        subscriptionPlans[1] = SubscriptionPlan(0.5 ether, 365 days); 

	// TODO: Decide if you want to mint reserved NFTs or not
        for (uint i = 0; i < RESERVED_FOUNDING_MEMBERS; i++) {
            _safeMint(msg.sender);
        }
    }

    // If you're the owner, you can edit the subscription plan. This function also allows you to create new plans.
    function updateSubscriptionPlan(uint index, SubscriptionPlan memory plan) public onlyOwner {
        subscriptionPlans[index] = plan;
    }

    // Note: Functions prefixed with _ means internal functions. It's only called within the contract
    function _getSubscriptionPlan(uint index) private view returns (SubscriptionPlan memory) {
        SubscriptionPlan memory plan = subscriptionPlans[index];

        require(plan.duration > 0, "Subscription plan does not exist");

        return plan;
    }

    // Note: Here we call the internal function but we now expose the function for external call
    function getSubscriptionPlan(uint index) external view returns (SubscriptionPlan memory) {
        return _getSubscriptionPlan(index);
    }

    // Note: I modified this function to use msg.sender instead of address _to argument. Feel free to undo.
    // Original: function subscribe(address _to, uint planIndex)
    function subscribe(uint planIndex) whenNotPaused public payable {
	// Get the plan based on its index
        SubscriptionPlan memory plan = _getSubscriptionPlan(planIndex);

	// Here we make sure the plan actually exist and user is paying the correct price
        require(plan.price == msg.value, "Wrong amount sent");
        require(plan.duration > 0, "Subscription plan does not exist");

	// Get the current time
        uint256 startingDate = block.timestamp;

        // We check if the address has an active plan
        if(_hasActiveSubscription(msg.sender)) {
	    // If they do, we override the starting date with the active plan's expiry date
            startingDate = subscriptionExpiration[msg.sender];
        }   

	// Create expiry date by adding the starting date and the duration of the plan
	// If the user has an active plan, starting date refers to the plan's expiry date
        uint256 expiresAt = startingDate + plan.duration;

	// Assign the expiry date to the address
        subscriptionExpiration[msg.sender] = expiresAt;
        _subscriptionCounter.increment();

        emit Subscription(msg.sender, plan, block.timestamp, expiresAt, _subscriptionCounter.current());
    }

    function _hasActiveSubscription(address _address) private view returns (bool) {
	// Get the expiry date from the map. If it's greater than the current time, then subscription is active.
        // subscriptionExpiration[_address] will be 0 if that address never had a subscription.  
        return subscriptionExpiration[_address] > block.timestamp;    
    }

    function hasActiveSubscription(address _address) external view returns (bool) {
        return _hasActiveSubscription(_address);
    }

    function getSubscription(address _address) external view returns (uint256) {
        return subscriptionExpiration[_address];
    }

    // Creating the membership NFT is a simply minting function
    // Note: I modified this function to use msg.sender instead of address _to argument. Feel free to undo.
    // Original: function mint(address _to)
    function mint() whenNotPaused public payable  {
        require(msg.value == _price, "Wrong amount sent");
        require(_tokenIdCounter.current() < FOUNDING_MEMBERS_SUPPLY, "Can't mint over supply limit");

	// TODO: Decide the amount of NFT a wallet can hold
        require(balanceOf(msg.sender) == 0, "Can only mint one founding membership");

        _tokenIdCounter.increment();
    
        _safeMint(msg.sender, _tokenIdCounter.current());
        emit Mint(msg.sender, _tokenIdCounter.current());
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function getPrice() external view returns (uint256) {
        return _price;
    }

    function setPrice(uint256 price) public onlyOwner {
        _price = price;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function _baseURI() internal override view returns (string memory) {
        return _baseTokenURI;
    }

    function pause() public onlyOwner whenNotPaused {
        _pause();
    }

    function unpause()  public onlyOwner whenPaused {
        _unpause();
    }

    function _safeMint(address to) public onlyOwner {
        _tokenIdCounter.increment();

        _safeMint(to, _tokenIdCounter.current());
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function hasFoundingMemberToken(address wallet) public view returns (bool) {
	// To know if a user holds an NFT, we simply check the balance of the wallet 
	// to count how many tokens the wallet has.
       return balanceOf(wallet) > 0;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
