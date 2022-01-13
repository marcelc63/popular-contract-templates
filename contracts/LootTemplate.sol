// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on Loot @lootproject https://lootproject.com
 * Source: https://etherscan.io/address/0xff9c1b15b16263c61d017ee9f65c50e4ae0113d7
 *
 * Loot is a NFT that took the NFT world by storm. It redefines what an NFT could be.
 * A characteristic of a loot NFT is all data is contained on chain. No IPFS or external hosting used.
 * They did this in a very gas efficient way for the minter as most computation is offloaded to the read function.
 * Loot has become a prime example on how to create on-chain NFTs.
 *
 * This contract showcase how you will want to structure your contract to create an on-chain NFT,
 * the key is to not construct the metadata during minting, but offload everything to a read function.
 * Although deployment might be costly, it makes minting gas efficient.
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * Each functions have been annotated based on my own research.
 *
 * Feel free to use and modify as you see appropriate
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./library/Base64.sol";

contract LootTemplate is ERC721Enumerable, ReentrancyGuard, Ownable {
  // Phrases of Weapons
  // TODO: Change phrases inside the weapons array. You can also change the arrays into anything.
  // For example, a Marvel themed loot will have array of heroes, superpowers, etc.
  string[] private weapons = [
    "Warhammer",
    "Quarterstaff",
    "Maul",
    "Mace",
    "Club",
    "Katana",
    "Falchion",
    "Scimitar",
    "Long Sword",
    "Short Sword",
    "Ghost Wand",
    "Grave Wand",
    "Bone Wand",
    "Wand",
    "Grimoire",
    "Chronicle",
    "Tome",
    "Book"
  ];

  string[] private chestArmor = [
    "Divine Robe",
    "Silk Robe",
    "Linen Robe",
    "Robe",
    "Shirt",
    "Demon Husk",
    "Dragonskin Armor",
    "Studded Leather Armor",
    "Hard Leather Armor",
    "Leather Armor",
    "Holy Chestplate",
    "Ornate Chestplate",
    "Plate Mail",
    "Chain Mail",
    "Ring Mail"
  ];

  string[] private headArmor = [
    "Ancient Helm",
    "Ornate Helm",
    "Great Helm",
    "Full Helm",
    "Helm",
    "Demon Crown",
    "Dragon's Crown",
    "War Cap",
    "Leather Cap",
    "Cap",
    "Crown",
    "Divine Hood",
    "Silk Hood",
    "Linen Hood",
    "Hood"
  ];

  string[] private waistArmor = [
    "Ornate Belt",
    "War Belt",
    "Plated Belt",
    "Mesh Belt",
    "Heavy Belt",
    "Demonhide Belt",
    "Dragonskin Belt",
    "Studded Leather Belt",
    "Hard Leather Belt",
    "Leather Belt",
    "Brightsilk Sash",
    "Silk Sash",
    "Wool Sash",
    "Linen Sash",
    "Sash"
  ];

  string[] private footArmor = [
    "Holy Greaves",
    "Ornate Greaves",
    "Greaves",
    "Chain Boots",
    "Heavy Boots",
    "Demonhide Boots",
    "Dragonskin Boots",
    "Studded Leather Boots",
    "Hard Leather Boots",
    "Leather Boots",
    "Divine Slippers",
    "Silk Slippers",
    "Wool Shoes",
    "Linen Shoes",
    "Shoes"
  ];

  string[] private handArmor = [
    "Holy Gauntlets",
    "Ornate Gauntlets",
    "Gauntlets",
    "Chain Gloves",
    "Heavy Gloves",
    "Demon's Hands",
    "Dragonskin Gloves",
    "Studded Leather Gloves",
    "Hard Leather Gloves",
    "Leather Gloves",
    "Divine Gloves",
    "Silk Gloves",
    "Wool Gloves",
    "Linen Gloves",
    "Gloves"
  ];

  string[] private necklaces = ["Necklace", "Amulet", "Pendant"];

  string[] private rings = [
    "Gold Ring",
    "Silver Ring",
    "Bronze Ring",
    "Platinum Ring",
    "Titanium Ring"
  ];

  // The suffixes will be combined with any of the phrases above. E.g., Gold Ring can become Gold Ring of Power.
  // TODO: Change the suffix
  string[] private suffixes = [
    "of Power",
    "of Giants",
    "of Titans",
    "of Skill",
    "of Perfection",
    "of Brilliance",
    "of Enlightenment",
    "of Protection",
    "of Anger",
    "of Rage",
    "of Fury",
    "of Vitriol",
    "of the Fox",
    "of Detection",
    "of Reflection",
    "of the Twins"
  ];

  // The namePrefixes works with the nameSuffixes. Combine, it will become a suffix to the item.
  // E.g., we can get "Agony Bane" Katana of Power
  // TODO: Change the namePrefixes and nameSuffixes
  string[] private namePrefixes = [
    "Agony",
    "Apocalypse",
    "Armageddon",
    "Beast",
    "Behemoth",
    "Blight",
    "Blood",
    "Bramble",
    "Brimstone",
    "Brood",
    "Carrion",
    "Cataclysm",
    "Chimeric",
    "Corpse",
    "Corruption",
    "Damnation",
    "Death",
    "Demon",
    "Dire",
    "Dragon",
    "Dread",
    "Doom",
    "Dusk",
    "Eagle",
    "Empyrean",
    "Fate",
    "Foe",
    "Gale",
    "Ghoul",
    "Gloom",
    "Glyph",
    "Golem",
    "Grim",
    "Hate",
    "Havoc",
    "Honour",
    "Horror",
    "Hypnotic",
    "Kraken",
    "Loath",
    "Maelstrom",
    "Mind",
    "Miracle",
    "Morbid",
    "Oblivion",
    "Onslaught",
    "Pain",
    "Pandemonium",
    "Phoenix",
    "Plague",
    "Rage",
    "Rapture",
    "Rune",
    "Skull",
    "Sol",
    "Soul",
    "Sorrow",
    "Spirit",
    "Storm",
    "Tempest",
    "Torment",
    "Vengeance",
    "Victory",
    "Viper",
    "Vortex",
    "Woe",
    "Wrath",
    "Light's",
    "Shimmering"
  ];

  string[] private nameSuffixes = [
    "Bane",
    "Root",
    "Bite",
    "Song",
    "Roar",
    "Grasp",
    "Instrument",
    "Glow",
    "Bender",
    "Shadow",
    "Whisper",
    "Shout",
    "Growl",
    "Tear",
    "Peak",
    "Form",
    "Sun",
    "Moon"
  ];

  // The random function calls keccak256. How it works is, we take a string, put it inside abi.encodePacked
  // then hash it with keccak256. Finally by inserting it inside uint256, we get a random number
  // Remember, keccak256 will always hash the same way as it is deterministic. If the string 1 outputs 2
  // it will always output 2 even if we run it infinite times.
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  // Each of this functions calls the pluck function below.
  // The argument tokenId and "WEAPON" is what we will pass to keccak256.
  // This ensures that getWeapon and getChest will be randomized differently.
  function getWeapon(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "WEAPON", weapons);
  }

  //NOTE: Also notice the function is public view. This means anyone can call this functions.
  // Derivatives will call this function to read individual information for each item that
  // a loot bag has
  function getChest(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "CHEST", chestArmor);
  }

  function getHead(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "HEAD", headArmor);
  }

  function getWaist(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "WAIST", waistArmor);
  }

  function getFoot(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "FOOT", footArmor);
  }

  function getHand(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "HAND", handArmor);
  }

  function getNeck(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "NECK", necklaces);
  }

  function getRing(uint256 tokenId) public view returns (string memory) {
    return pluck(tokenId, "RING", rings);
  }

  // This is where the logic on getting a random item happens
  function pluck(
    uint256 tokenId,
    string memory keyPrefix,
    string[] memory sourceArray
  ) internal view returns (string memory) {
    // First we get a random number from our random() function.
    uint256 rand = random(
      string(abi.encodePacked(keyPrefix, toString(tokenId)))
    );

    // Then we use the modulo operator to get an index of the sourced array.
    // Modulo operator ensures that the index is within range of the available number of phrases.
    // E.g. if we call the getWeapon function, sourceArray will be the weapon array.
    // There are 18 weapons, but the random number can be 240 for example.
    // If we modulo 240 % 18, we get its remainder which is 6. So we will get weapon item with index 6.
    string memory output = sourceArray[rand % sourceArray.length];

    // We also modulo the greatness to give our item some flavor.
    uint256 greatness = rand % 21;

    // If greatness is greater than 14, we give it a suffix
    if (greatness > 14) {
      output = string(
        abi.encodePacked(output, " ", suffixes[rand % suffixes.length]) // The modulo happens here
      );
    }

    // If greater or equal to 19, we give it a name
    if (greatness >= 19) {
      // This time we store it in an array of string
      // NOTE: This is a good structure to follow. By doing string[2] we say we want to create an array
      // of strings with maximum length of 2
      string[2] memory name;
      name[0] = namePrefixes[rand % namePrefixes.length];
      name[1] = nameSuffixes[rand % nameSuffixes.length];

      // Then we give it a name and if greatness is greater than 19, we give it a +1
      if (greatness == 19) {
        output = string(
          abi.encodePacked('"', name[0], " ", name[1], '" ', output)
        );
      } else {
        output = string(
          abi.encodePacked('"', name[0], " ", name[1], '" ', output, " +1")
        );
      }
    }
    return output;
  }

  // This is where the magic happen, all logic on constructing the NFT is in the tokenURI function
  // NOTE: Remember this is a read function. In the blockchain, calling this function is free and cost 0 gas.
  function tokenURI(uint256 tokenId)
    public
    view
    override
    returns (string memory)
  {
    // We create the an array of string with max length 17
    string[17] memory parts;

    // Part 1 is the opening of an SVG.
    // TODO: Edit the SVG as you wish. I recommend to play around with SVG on https://www.svgviewer.dev/ and figma first.
    // Change the background color, or font style.
    parts[
      0
    ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

    // Then we call the getWeapon function. So the randomization and getting the weapon actually happens
    // in the read function, not when the NFT is minted
    parts[1] = getWeapon(tokenId);

    parts[2] = '</text><text x="10" y="40" class="base">';

    parts[3] = getChest(tokenId);

    parts[4] = '</text><text x="10" y="60" class="base">';

    parts[5] = getHead(tokenId);

    parts[6] = '</text><text x="10" y="80" class="base">';

    parts[7] = getWaist(tokenId);

    parts[8] = '</text><text x="10" y="100" class="base">';

    parts[9] = getFoot(tokenId);

    parts[10] = '</text><text x="10" y="120" class="base">';

    parts[11] = getHand(tokenId);

    parts[12] = '</text><text x="10" y="140" class="base">';

    parts[13] = getNeck(tokenId);

    parts[14] = '</text><text x="10" y="160" class="base">';

    parts[15] = getRing(tokenId);

    parts[16] = "</text></svg>";

    // We do it for all and then we combine them.
    // The reason its split into two parts is due to abi.encodePacked has
    // a limit of how many arguments to accept. If too many, you will get
    // "stack too deep" error
    string memory output = string(
      abi.encodePacked(
        parts[0],
        parts[1],
        parts[2],
        parts[3],
        parts[4],
        parts[5],
        parts[6],
        parts[7],
        parts[8]
      )
    );
    output = string(
      abi.encodePacked(
        output,
        parts[9],
        parts[10],
        parts[11],
        parts[12],
        parts[13],
        parts[14],
        parts[15],
        parts[16]
      )
    );

    // We then create a JSON metadata and encode it in Base64. The browser and OpenSea can recognize this as
    // a url and will encode it. This is how the data is on-chain and does not rely on IPFS or external server
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "Bag #',
            toString(tokenId),
            '", "description": "Loot is randomized adventurer gear generated and stored on chain. Stats, images, and other functionality are intentionally omitted for others to interpret. Feel free to use Loot in any way you want.", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(output)),
            '"}'
          )
        )
      )
    );
    output = string(abi.encodePacked("data:application/json;base64,", json));

    return output;
  }

  // Claim is suepr simple, it just checks tokenId is within range and then it assigns the address with it
  function claim(uint256 tokenId) public nonReentrant {
    require(tokenId > 0 && tokenId < 7778, "Token ID invalid");
    _safeMint(_msgSender(), tokenId);
  }

  function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
    require(tokenId > 7777 && tokenId < 8001, "Token ID invalid");
    _safeMint(owner(), tokenId);
  }

  function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

    if (value == 0) {
      return "0";
    }
    uint256 temp = value;
    uint256 digits;
    while (temp != 0) {
      digits++;
      temp /= 10;
    }
    bytes memory buffer = new bytes(digits);
    while (value != 0) {
      digits -= 1;
      buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
      value /= 10;
    }
    return string(buffer);
  }

  constructor() ERC721("Loot", "LOOT") Ownable() {}
}
