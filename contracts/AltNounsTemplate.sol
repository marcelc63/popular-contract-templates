// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on AltNouns by @onChainCo https://occ.xyz
 * Source: https://etherscan.io/address/0x971a6ff4f5792f3e0288f093340fb36a826aae96
 *
 * @onChainCo drop this marvel of a contract. AltNouns is a derivative of NounsDAO.
 * As a new Noun gets minted, a new AltNouns will be created. This makes AltNouns
 * an infinite derivative that will create new derivative forever.
 *
 * AltNouns achieve this through two main mechanism: calling Nouns' smart contract
 * and clever SVG manipulation. In this template we'll see how AltNouns is able to be
 * an infinite derivative and how to alters the original Noun SVG.
 *
 * Curated by @marcelc63 - marcelchristianis.com
 * The original author has done extensive commenting of the contract. Here I mainly
 * provide elaborations.
 *
 * Feel free to use and modify as you see appropriate
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./library/Base64.sol";

/// @title Interface for NounsToken

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

interface INounsToken {
  function dataURI(uint256 tokenId) external view returns (string memory);
}

/*

Behold, an infinite (derivative) work of art.

By On Chain Collective

 ______   __       ______     __   __   ______   __  __   __   __   ______             
/\  __ \ /\ \     /\__  _\   /\ "-.\ \ /\  __ \ /\ \/\ \ /\ "-.\ \ /\  ___\            
\ \  __ \\ \ \____\/_/\ \/   \ \ \-.  \\ \ \/\ \\ \ \_\ \\ \ \-.  \\ \___  \           
 \ \_\ \_\\ \_____\  \ \_\    \ \_\\"\_\\ \_____\\ \_____\\ \_\\"\_\\/\_____\          
  \/_/\/_/ \/_____/   \/_/     \/_/ \/_/ \/_____/ \/_____/ \/_/ \/_/ \/_____/          
                                                                                       
                                     ______   __  __       ______   ______   ______    
                                    /\  == \ /\ \_\ \     /\  __ \ /\  ___\ /\  ___\   
                                    \ \  __< \ \____ \    \ \ \/\ \\ \ \____\ \ \____  
                                     \ \_____\\/\_____\    \ \_____\\ \_____\\ \_____\ 
                                      \/_____/ \/_____/     \/_____/ \/_____/ \/_____/ 
                                                                                       
 */

contract AltNouns is ERC721Enumerable, ReentrancyGuard, Ownable {
  // TODO: Change Price and other settings
  uint256 private price = 0.25 ether;
  uint256 public priceIncrement = 0.75 ether;
  uint256 public numTokensMinted;
  uint256 public maxPerAddress = 2;

  bool public allSalesPaused = true;
  bool public priceChangesLocked = false;
  bool public dynamicPriceEnabled = true;
  bool public reservedMintsLocked = false;

  mapping(address => uint256) private _mintPerAddress;
  mapping(uint256 => uint256) private _altForId;

  // This calls the Nouns Smart Contract. This might not work in local and test network.
  // You will need the live network for this address to be valid.
  address public nounsTokenContract =
    0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03;
  uint256 public nounsTokenIndexOffset;

  /*
     ______  ______   ______   __  __   _____    ______       ______   ______   __   __   _____    ______   __    __   __   __   ______   ______   ______    
    /\  == \/\  ___\ /\  ___\ /\ \/\ \ /\  __-. /\  __ \     /\  == \ /\  __ \ /\ "-.\ \ /\  __-. /\  __ \ /\ "-./  \ /\ "-.\ \ /\  ___\ /\  ___\ /\  ___\   
    \ \  _-/\ \___  \\ \  __\ \ \ \_\ \\ \ \/\ \\ \ \/\ \    \ \  __< \ \  __ \\ \ \-.  \\ \ \/\ \\ \ \/\ \\ \ \-./\ \\ \ \-.  \\ \  __\ \ \___  \\ \___  \  
     \ \_\   \/\_____\\ \_____\\ \_____\\ \____- \ \_____\    \ \_\ \_\\ \_\ \_\\ \_\\"\_\\ \____- \ \_____\\ \_\ \ \_\\ \_\\"\_\\ \_____\\/\_____\\/\_____\ 
      \/_/    \/_____/ \/_____/ \/_____/ \/____/  \/_____/     \/_/ /_/ \/_/\/_/ \/_/ \/_/ \/____/  \/_____/ \/_/  \/_/ \/_/ \/_/ \/_____/ \/_____/ \/_____/ 

     */

  // The almighty pseudo random number generator
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  // Uses blockhash, tokenId, etc. as inputs for random(), and returns a random number between minNum & maxNum
  function pluckNum(
    uint256 tokenId,
    string memory keyPrefix,
    uint256 minNum,
    uint256 maxNum
  ) internal view returns (uint256) {
    uint256 rand = random(
      string(
        abi.encodePacked(
          blockhash(block.number - 1),
          keyPrefix,
          toString(tokenId),
          minNum,
          maxNum,
          _msgSender()
        )
      )
    );
    uint256 num = (rand % (maxNum - minNum + 1)) + minNum;
    return num;
  }

  // Uses blockhash and tokenId as inputs for random() for new Alt Nouns, or returns stored Alt Type for existing Alt Nouns
  function getAltType(uint256 tokenId) private view returns (uint256) {
    if (_altForId[tokenId] == 0) {
      uint256 rand = random(
        string(abi.encodePacked(blockhash(block.number - 1), toString(tokenId)))
      );
      uint256 altType = rand % 19;

      return altType;
    } else {
      return _altForId[tokenId] - 1;
    }
  }

  /*
     ______   __       ______     ______  ______   ______   __   ______  ______    
    /\  __ \ /\ \     /\__  _\   /\__  _\/\  == \ /\  __ \ /\ \ /\__  _\/\  ___\   
    \ \  __ \\ \ \____\/_/\ \/   \/_/\ \/\ \  __< \ \  __ \\ \ \\/_/\ \/\ \___  \  
     \ \_\ \_\\ \_____\  \ \_\      \ \_\ \ \_\ \_\\ \_\ \_\\ \_\  \ \_\ \/\_____\ 
      \/_/\/_/ \/_____/   \/_/       \/_/  \/_/ /_/ \/_/\/_/ \/_/   \/_/  \/_____/ 

     */

  // NOTE: Type of alterations available
  string[19] altNames = [
    "Jittery",
    "Wavy",
    "Uhhhhh",
    "Glitching",
    "Static",
    "Immobilized",
    "Snapped",
    "?????",
    "Anti-noun",
    "Wall",
    "Warped",
    "Totem",
    "Outta Focus",
    "Spirit",
    "Collapsing",
    "Exploding",
    "Nether-noun",
    "Distorted",
    "Fractionalize"
  ];

  // NOTE: The traits is used to describe the type of alteration.
  function getTraits(uint256 tokenId) private view returns (string memory) {
    uint256 altType = getAltType(tokenId);
    string[3] memory parts;

    parts[0] = ', "attributes": [{"trait_type": "Alteration","value": "';
    parts[1] = altNames[altType];
    parts[2] = '"}], ';

    string memory result = string(
      abi.encodePacked(parts[0], parts[1], parts[2])
    );

    return result;
  }

  /*
     ______   __   __ ______       __    __   ______   __   __   __   ______  __  __   __       ______   ______  __   ______   __   __    
    /\  ___\ /\ \ / //\  ___\     /\ "-./  \ /\  __ \ /\ "-.\ \ /\ \ /\  == \/\ \/\ \ /\ \     /\  __ \ /\__  _\/\ \ /\  __ \ /\ "-.\ \   
    \ \___  \\ \ \'/ \ \ \__ \    \ \ \-./\ \\ \  __ \\ \ \-.  \\ \ \\ \  _-/\ \ \_\ \\ \ \____\ \  __ \\/_/\ \/\ \ \\ \ \/\ \\ \ \-.  \  
     \/\_____\\ \__|  \ \_____\    \ \_\ \ \_\\ \_\ \_\\ \_\\"\_\\ \_\\ \_\   \ \_____\\ \_____\\ \_\ \_\  \ \_\ \ \_\\ \_____\\ \_\\"\_\ 
      \/_____/ \/_/    \/_____/     \/_/  \/_/ \/_/\/_/ \/_/ \/_/ \/_/ \/_/    \/_____/ \/_____/ \/_/\/_/   \/_/  \/_/ \/_____/ \/_/ \/_/ 

     */

  // NOTE: This is where the SVG gets manipulated
  function getAlteration(uint256 tokenId) private view returns (string memory) {
    // NOTE: Check SVG Filter Effects. That's the main principle behind the manipulation.
    string memory feTurbulence;
    string memory feDisplacementMap;
    string memory feTurbulenceAnim;
    string memory feDisplacementMapAnim;

    // NOTE: So we get the Traits to know what filters to use
    uint256 altType = getAltType(tokenId);

    if (altType == 0) {
      // Jittery
      feTurbulence = "0.035";
      feDisplacementMap = "9";
      feTurbulenceAnim = '<animate attributeName="baseFrequency" begin="0s" dur="0.15s" values="0.0812;0.0353;0.0041;0.0424;0.0010;0.0934" repeatCount="indefinite"/>';
    } else if (altType == 1) {
      // Wavy
      feTurbulence = string(
        abi.encodePacked(
          "0.0",
          toString(pluckNum(tokenId, "Way", 1, 99)),
          " ",
          "0.0",
          toString(pluckNum(tokenId, "Vee", 1, 99))
        )
      );
      feDisplacementMap = "50";
    } else if (altType == 2) {
      // Uhhhhh
      feTurbulence = string(
        abi.encodePacked("0.0", toString(pluckNum(tokenId, "Uhhhhh", 15, 20)))
      );
      feDisplacementMap = toString(pluckNum(tokenId, "Uhhhhh", 100, 300));
    } else if (altType == 3) {
      // Glitching
      return
        '<feDisplacementMap in="SourceGraphic" scale="0"><animate attributeName="scale" begin="0s" dur="10s" values="18.51;16.14;-7.81;4.40;-5.97;5.83;-4.63;8.88;-6.38;11.70;9.35;-14.77;-18.40;8.72;-12.61;14.69;6.56;11.47;-5.59;13.16;19.81;3.56;-1.47;3.95;-16.19;-8.11;-3.04;-10.54;-2.04;-14.23;2.00;-12.81;16.28;-0.54;7.18;-1.52;-10.86;-9.92;-7.48;-0.47;-15.37;17.88;19.83;-10.57;5.75;5.67;-1.84;10.87;1.80;8.13;15.44;-11.35;7.77;-15.39;-18.19;14.66;-7.26;-14.34;-14.41;-3.52;-13.27;-7.34;-19.83;17.63;-14.66;-13.68;-18.70;10.14;0.93;-17.23;15.29;2.20;-0.94;-16.04;-0.55;15.80;-7.77;-12.51;-1.13;-11.18;-15.50;5.72;-13.99;-7.17;-2.19;10.36;-11.09;5.68;-15.20;3.09;-6.79;13.58;-12.04;-10.05;17.14;1.32;-15.67;-14.96;-1.01;-3.94;-11.90;-13.77;-2.27;14.63;12.37;-19.31;-3.99;-13.19;14.06;-15.91;-5.03;-6.54;19.74;-5.67;15.57;-6.80;14.24;2.03;-19.11;-14.10;0.35;-19.23;-13.11;12.04;9.69;13.88;5.13;11.94" repeatCount="indefinite"/></feDisplacementMap>';
    } else if (altType == 4) {
      // Static
      return
        '<feTurbulence numOctaves="3" seed="2" baseFrequency="0.02 0.05" type="fractalNoise"><animate attributeName="baseFrequency" begin="0s" dur="60s" values="0.002 0.06;0.004 0.08;0.002 0.06" repeatCount="indefinite"/></feTurbulence><feDisplacementMap scale="20" in="SourceGraphic"></feDisplacementMap>';
    } else if (altType == 5) {
      // Immobilized
      feTurbulence = "0.5";
      feDisplacementMap = "0";
      feDisplacementMapAnim = '<animate attributeName="scale" begin="0s" dur="0.5s" values="36.72;58.84;36.90;14.99;13.26;47.30;58.24;21.58;46.51;40.17;35.83;36.08;42.74;32.16;46.57;33.67;17.31;52.09;30.80;40.37;43.99;36.21;16.18;20.04;15.72;50.92;41.35;26.12;31.38;30.41;59.51;10.51;45.48;19.59;58.88;33.92;26.88;13.50;31.85;43.88;33.05;22.82;56.26;27.90;51.95;26.47;27.13;32.41;18.12;52.98;50.04;17.62;27.43;52.81;21.61;15.11;25.89;27.39;39.35;51.29" repeatCount="indefinite"/>';
    } else if (altType == 6) {
      // Snapped
      feTurbulence = string(
        abi.encodePacked("0.", toString(pluckNum(tokenId, "Snapped", 100, 500)))
      );
      feDisplacementMap = toString(pluckNum(tokenId, "Snapped", 100, 500));
    } else if (altType == 7) {
      // ?????
      feTurbulence = string(
        abi.encodePacked(
          "0.0",
          toString(pluckNum(tokenId, "?????", 100, 500)),
          '" numOctaves="10'
        )
      );
      feDisplacementMap = toString(pluckNum(tokenId, "?????", 200, 300));
    } else if (altType == 8) {
      // Anti-noun
      return
        '<feColorMatrix in="SourceGraphic" type="matrix" values="-1 0 0 0 1 0 -1 0 0 1 0 0 -1 0 1 0 0 0 1 0"/>';
    } else if (altType == 9) {
      // Wall
      return
        '<feTile in="SourceGraphic" x="90" y="100" width="140" height="100" /><feTile/>';
    } else if (altType == 10) {
      // Warped
      return
        '<feTile in="SourceGraphic" x="0" y="140" width="320" height="20" /><feTile/>';
    } else if (altType == 11) {
      // Totem
      return
        '<feTile in="SourceGraphic" x="0" y="100" width="320" height="80" /><feTile/>';
    } else if (altType == 12) {
      // Outta Focus
      return
        '<feGaussianBlur in="SourceGraphic" stdDeviation="3"><animate attributeName="stdDeviation" begin="0s" dur="4s" values="0;4;3;5;3;2;5;7;8;10;15;0;0;0;0;0;0;0;0" repeatCount="indefinite"/></feGaussianBlur>';
    } else if (altType == 13) {
      // Spirit
      return
        '<feColorMatrix type="matrix" values=".33 .33 .33 0 0 .33 .33 .33 0 0 .33 .33 .33 0 0  0 0 0 0.2 0"></feColorMatrix>';
    } else if (altType == 14) {
      // Collapsing
      return
        '<feTurbulence baseFrequency="0.05" type="fractalNoise" numOctaves="9"></feTurbulence><feDisplacementMap in="SourceGraphic" scale="200"><animate attributeName="scale" begin="0s" dur="16s" values="40;550;1;40" fill="freeze" repeatCount="indefinite"/></feDisplacementMap><feMorphology operator="erode" radius="25"><animate attributeName="radius" begin="0s" dur="16s" values="1;25;1;1" fill="freeze" repeatCount="indefinite"/></feMorphology>';
    } else if (altType == 15) {
      // Exploding
      return
        string(
          abi.encodePacked(
            '<feMorphology operator="dilate" radius="',
            toString(pluckNum(tokenId, "Explode", 5, 40)),
            '"></feMorphology>'
          )
        );
    } else if (altType == 16) {
      // Nether-noun
      return
        '<feTile in="SourceGraphic" x="90" y="100" width="140" height="100" /><feTile x="0" y="0" width="320" height="320"/><feBlend in2="SourceGraphic" mode="color-burn"/><feTile x="0" y="0" width="320" height="320"/><feBlend in2="SourceGraphic" mode="color-burn"/><feTile x="0" y="0" width="320" height="320"/><feBlend in2="SourceGraphic" mode="color-burn"/>';
    } else if (altType == 17) {
      // Distorted
      return
        '<feTile id="eye" in="SourceGraphic" x="142.5" y="110" width="45" height="50" /><feTile/><feTile in2="strip" x="0" y="0" width="320" height="320"/><feBlend in2="SourceGraphic" mode="exclusion"/>';
    } else if (altType == 18) {
      // Fractionalize
      return
        '<feTurbulence baseFrequency="0.01 0.01" type="fractalNoise" numOctaves="5" seed="12453"><animate attributeName="seed" begin="0s" dur="16s" values="1;20;160" repeatCount="indefinite" /></feTurbulence><feDisplacementMap in="SourceGraphic" scale="300"><animate attributeName="scale" begin="0s" dur="16s" values="1;200;1000;1;1" repeatCount="indefinite" /></feDisplacementMap>';
    }

    // NOTE: This bit is to save computation. For some filters that have similar pattern, just pass in the values.
    // For others, it's a shortcircuit as noted by the return
    string memory result = string(
      abi.encodePacked(
        '<feTurbulence baseFrequency="',
        feTurbulence,
        '" type="fractalNoise">',
        feTurbulenceAnim,
        '</feTurbulence><feDisplacementMap in="SourceGraphic" scale="',
        feDisplacementMap,
        '">',
        feDisplacementMapAnim,
        "</feDisplacementMap>"
      )
    );

    return result;
  }

  // Note: Here is where we construct the altered Noun
  function altNoun(string memory noun, uint256 tokenId)
    private
    view
    returns (string memory)
  {
    // Decoding the noun tokenURI
    // NOTE: The Strings.length is to strip away "data:application/json;base64," bit from base64 encoded strings.
    string memory decodedNoun = string(
      Base64.decode(
        Strings._substring(noun, int256(Strings.length(noun) - 29), 29)
      )
    );

    // Finds the index of ';' in decoded tokenURI & adds 8 to it (for 'base64,') to set the starting index for the encoded SVG
    // NOTE: The first thing we decode is the metadata, so we need to find the stuff after "image"
    uint256 index = uint256(Strings.indexOf(decodedNoun, ";"));
    index = index + 8;

    // Substring subtracts 2 from (length - index) to skip the last two characters, i.e. '"}'
    string memory nounSVG = Strings._substring(
      decodedNoun,
      int256(Strings.length(decodedNoun) - index - 2),
      int256(index)
    );

    // Decoding the noun encoded SVG
    // NOTE: Remember that the SVG is also base64 encoded. So we need to decode it again.
    bytes memory SVG = Base64.decode(nounSVG);

    // Opening SVG tag
    string
      memory openingTag = '<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">';

    // Grabbing the Noun inside the SVG tag
    // NOTE: We need to do this since the original svg will also have its opening and closing <svg> tag
    // We just want whats inside
    string memory innerSVG = getInnerSVG(SVG);

    // Opening <g> tag for filters
    string memory openingGTag = '<g filter="url(#alteration)">';

    // Closing <g> tag and alteration filter
    string memory alterationAndClosingTag = string(
      abi.encodePacked(
        '</g><defs><filter id="alteration" x="-50%" y="-50%" width="200%" height="200%">',
        getAlteration(tokenId),
        "</filter></defs></svg>"
      )
    );

    // Concatenating everything to get the final Alt Noun SVG
    return
      string(
        abi.encodePacked(
          openingTag,
          openingGTag,
          innerSVG,
          alterationAndClosingTag
        )
      );
  }

  // NOTE: The function that grabs only SVG inside the <svg> tag
  function getInnerSVG(bytes memory svgBytes)
    internal
    pure
    returns (string memory)
  {
    // NOTE: It's done by trimming the last 122 characters and first 116 characters
    bytes memory result = new bytes(svgBytes.length - 122);
    for (uint256 i = 0; i < result.length; i++) {
      result[i] = svgBytes[i + 116];
    }
    return string(result);
  }

  // NOTE: We construct the metadata and SVG here. This is a read function so its free, doesn't cost gas to call
  function tokenURI(uint256 tokenId)
    public
    view
    override
    returns (string memory)
  {
    require(_exists(tokenId), "URI query for nonexistent token");
    // NOTE: First thing to do is call Nouns' smart contract for the base64 data
    // Amazing how we can do this inside a read function. So this call is also free
    string memory noun = INounsToken(nounsTokenContract).dataURI(tokenId);

    // NOTE: Here we do a lot. We decode, alter, and finally encode the final result to base64 again.
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "Alt Noun ',
            toString(tokenId),
            '", "description": "Hmmm... Something is up with Alt Noun ',
            toString(tokenId),
            '"',
            getTraits(tokenId),
            '"image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(altNoun(noun, tokenId))),
            '"}'
          )
        )
      )
    );
    json = string(abi.encodePacked("data:application/json;base64,", json));
    return json;
  }

  /*
     __    __   __   __   __   ______  __   __   __   ______       ______  __  __   __   __   ______   ______  __   ______   __   __   ______    
    /\ "-./  \ /\ \ /\ "-.\ \ /\__  _\/\ \ /\ "-.\ \ /\  ___\     /\  ___\/\ \/\ \ /\ "-.\ \ /\  ___\ /\__  _\/\ \ /\  __ \ /\ "-.\ \ /\  ___\   
    \ \ \-./\ \\ \ \\ \ \-.  \\/_/\ \/\ \ \\ \ \-.  \\ \ \__ \    \ \  __\\ \ \_\ \\ \ \-.  \\ \ \____\/_/\ \/\ \ \\ \ \/\ \\ \ \-.  \\ \___  \  
     \ \_\ \ \_\\ \_\\ \_\\"\_\  \ \_\ \ \_\\ \_\\"\_\\ \_____\    \ \_\   \ \_____\\ \_\\"\_\\ \_____\  \ \_\ \ \_\\ \_____\\ \_\\"\_\\/\_____\ 
      \/_/  \/_/ \/_/ \/_/ \/_/   \/_/  \/_/ \/_/ \/_/ \/_____/     \/_/    \/_____/ \/_/ \/_/ \/_____/   \/_/  \/_/ \/_____/ \/_/ \/_/ \/_____/ 
                                                                                                                                             
    */

  // Checks if a supplied tokenId is a valid noun
  function isNounValid(uint256 tokenId) private view returns (bool) {
    // NOTE: Here we call Nouns' contract to check if a token Id exist
    bool isValid = (tokenId + nounsTokenIndexOffset ==
      IERC721Enumerable(nounsTokenContract).tokenByIndex(tokenId));
    return isValid;
  }

  // Updates nounsTokenIndexOffset. Default value is 0 (since indexOf(tokenId) check should match tokenId), but in case a Noun is burned, the offset may require a manual update to allow Alt Nouns to be minted again
  function setNounsTokenIndexOffset(uint256 newOffset) public onlyOwner {
    nounsTokenIndexOffset = newOffset;
  }

  // Mint function that saves the Alt Type (for future tokenURI reads), mints the supplied tokenId and increments counters
  function mint(address destination, uint256 tokenId) private {
    // NOTE: Check if a given Noun token id exist or not. If not, don't allow mint.
    // This is how AltNouns sync with Nouns. It only allows minting of Nouns token id that exists.
    require(
      isNounValid(tokenId),
      "This noun does not exist (yet). So its Alt Noun cannot exist either."
    );

    _altForId[tokenId] = getAltType(tokenId) + 1;
    _safeMint(destination, tokenId);
    numTokensMinted += 1;
    _mintPerAddress[msg.sender] += 1;
  }

  // Public minting for a supplied tokenId, except for every 10th Alt Noun
  function publicMint(uint256 tokenId) public payable virtual {
    require(!allSalesPaused, "Sales are currently paused");
    require(
      tokenId % 10 != 0,
      "Every 10th Alt Noun is reserved for Noun holders and Alt Nounders, in perpetuity"
    );
    require(getCurrentPrice() == msg.value, "ETH amount is incorrect");
    require(
      _mintPerAddress[msg.sender] < maxPerAddress,
      "You can't exceed the minting limit for your wallet"
    );
    mint(_msgSender(), tokenId);
  }

  // Allows Noun holders to mint any Alt Noun for a supplied tokenId, including every 10th Alt Noun
  function nounHolderMint(uint256 tokenId) public payable virtual {
    require(!allSalesPaused, "Sales are currently paused");
    require(
      IERC721Enumerable(nounsTokenContract).balanceOf(_msgSender()) > 0,
      "Every 10th Alt Noun is reserved for Noun holders and Alt Nounders, in perpetuity"
    );
    require(getCurrentPrice() == msg.value, "ETH amount is incorrect");
    require(
      _mintPerAddress[msg.sender] < maxPerAddress,
      "You can't exceed this wallet's minting limit"
    );
    mint(_msgSender(), tokenId);
  }

  // Allows owner to mint any available tokenId. To be used with discretion & lockable via lockReservedMints()
  function reservedMint(uint256 tokenId) public payable onlyOwner {
    require(!reservedMintsLocked, "Reserved mints locked. Oops lol");
    mint(_msgSender(), tokenId);
  }

  /*
     ______   ______   __       ______       __  __   ______  __   __       __   ______  __  __       ______  __  __   __   __   ______   ______  __   ______   __   __   ______    
    /\  ___\ /\  __ \ /\ \     /\  ___\     /\ \/\ \ /\__  _\/\ \ /\ \     /\ \ /\__  _\/\ \_\ \     /\  ___\/\ \/\ \ /\ "-.\ \ /\  ___\ /\__  _\/\ \ /\  __ \ /\ "-.\ \ /\  ___\   
    \ \___  \\ \  __ \\ \ \____\ \  __\     \ \ \_\ \\/_/\ \/\ \ \\ \ \____\ \ \\/_/\ \/\ \____ \    \ \  __\\ \ \_\ \\ \ \-.  \\ \ \____\/_/\ \/\ \ \\ \ \/\ \\ \ \-.  \\ \___  \  
     \/\_____\\ \_\ \_\\ \_____\\ \_____\    \ \_____\  \ \_\ \ \_\\ \_____\\ \_\  \ \_\ \/\_____\    \ \_\   \ \_____\\ \_\\"\_\\ \_____\  \ \_\ \ \_\\ \_____\\ \_\\"\_\\/\_____\ 
      \/_____/ \/_/\/_/ \/_____/ \/_____/     \/_____/   \/_/  \/_/ \/_____/ \/_/   \/_/  \/_____/     \/_/    \/_____/ \/_/ \/_/ \/_____/   \/_/  \/_/ \/_____/ \/_/ \/_/ \/_____/ 
                                                                                                                                                                                
     */

  // Returns the current price per mint
  function getCurrentPrice() public view returns (uint256 dynamicPrice) {
    // Since solidity doesn't support floats, supplyDiv will be 0 for <100, 1 for 100 to 200 etc.
    uint256 supplyDiv = totalSupply() / 100;

    // If dynamic pricing disabled or <100 minted, return price
    if (supplyDiv == 0 || !dynamicPriceEnabled) {
      return price;
    }

    // Otherwise, price = priceIncrement added to itself, once for every 100 Alt Noun mints

    dynamicPrice = 0 ether;

    // NOTE: For every 100 Alt Nouns minted, price increases!
    for (uint256 index = 0; index < supplyDiv; index++) {
      dynamicPrice = dynamicPrice + priceIncrement;
    }

    return dynamicPrice;
  }

  // Pauses all sales, except reserved mints
  function toggleAllSalesPaused() public onlyOwner {
    allSalesPaused = !allSalesPaused;
  }

  // Locks all pricing states, forever
  function lockPriceChanges() public onlyOwner {
    priceChangesLocked = true;
  }

  // Locks owners ability to use reservedMints()
  function lockReservedMints() public onlyOwner {
    reservedMintsLocked = true;
  }

  // Sets mint price
  function setPrice(uint256 newPrice) public onlyOwner {
    require(!priceChangesLocked, "Price changes are now locked");
    price = newPrice;
  }

  // Toggles dynamic pricing
  function toggleDynamicPrice() public onlyOwner {
    require(!priceChangesLocked, "Price changes are now locked");
    dynamicPriceEnabled = !dynamicPriceEnabled;
  }

  // Sets dynamic pricing increment that gets added to the price after ever 100 mints
  function setPriceIncrement(uint256 newPriceIncrement) public onlyOwner {
    require(!priceChangesLocked, "Price changes are now locked");
    priceIncrement = newPriceIncrement;
  }

  // Withdraws contract balance to contract owners account
  function withdrawAll() public payable onlyOwner {
    require(payable(_msgSender()).send(address(this).balance));
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

  constructor() ERC721("AltNouns", "ALTNOUNS") Ownable() {}
}
