// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Contract Template based on
 * Source: https://etherscan.io/address/
 *
 * Add Introduction Here
 *
 * Add Summary Here
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

interface Wagmigotchi {
  function love(address) external view returns (uint256);
}

contract PFP is ERC721Enumerable, ReentrancyGuard, Ownable {
  Wagmigotchi wagmi =
    Wagmigotchi(address(0xeCB504D39723b0be0e3a9Aa33D646642D1051EE1));
  Wagmigotchi wagmiOne =
    Wagmigotchi(address(0x57268ec83C8983D6907553A36072f737Eab67475));

  bool enabled = false;

  string constant header =
    '<svg width="400" height="400" viewBox="50 50 300 300" fill="none" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gradient-fill" x1="0" y1="0" x2="800" y2="0" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#1f005c" /><stop offset="0.14285714285714285" stop-color="#5b0060" /><stop offset="0.2857142857142857" stop-color="#870160" /><stop offset="0.42857142857142855" stop-color="#ac255e" /><stop offset="0.5714285714285714" stop-color="#ca485c" /><stop offset="0.7142857142857142" stop-color="#e16b5c" /><stop offset="0.8571428571428571" stop-color="#f39060" /><stop offset="1" stop-color="#ffb56b" /></linearGradient></defs>';

  string constant footer =
    '<g transform="translate(160 150)"><path d="M2 37C5.33333 42.3333 16.9 52.2 36.5 49C56.1 45.8 64 39.6667 65.5 37" stroke="black" stroke-width="5"/><path d="M3 12C3.73491 7.77554 6.28504 -0.0397118 10.6063 2.49496C14.9276 5.02964 16.6693 9.88777 17 12" stroke="black" stroke-width="5"/><path d="M42 12C42.7349 7.77554 45.285 -0.0397118 49.6063 2.49496C53.9276 5.02964 55.6693 9.88777 56 12" stroke="black" stroke-width="5"/></g></svg>';

  string constant halo =
    '<g transform="translate(161 76)"><path d="M36.7717 25.35C17.0173 28.6787 5.35958 18.4151 2 12.8671C2 8.78797 8.4 0.928144 34 2.12204C59.6 3.31594 66 9.78289 66 12.8671C64.4882 15.6411 56.526 22.0212 36.7717 25.35Z" stroke="black" stroke-width="10"/><path d="M36.7717 25.35C17.0173 28.6787 5.35958 18.4151 2 12.8671C2 8.78797 8.4 0.928144 34 2.12204C59.6 3.31594 66 9.78289 66 12.8671C64.4882 15.6411 56.526 22.0212 36.7717 25.35Z" stroke="#FFE600" stroke-width="5"/></g>';

  mapping(uint256 => address) internal _mints;
  mapping(address => bool) internal _claims;
  mapping(address => uint256) internal _love;

  function toggle() public onlyOwner nonReentrant {
    enabled = !enabled;
  }

  function random(bytes memory input, uint256 range)
    internal
    pure
    returns (uint256)
  {
    return uint256(keccak256(abi.encodePacked(input))) % range;
  }

  function draw(
    string memory color,
    string memory ox,
    string memory oy,
    string memory r,
    string memory scale,
    string memory opacity,
    bool stroke
  ) internal pure returns (string memory) {
    string[17] memory parts;
    if (!stroke) {
      parts[0] = '<g opacity="';
    } else {
      parts[0] = '<g stroke-width="5" stroke="black" opacity="';
    }
    parts[1] = opacity;
    parts[2] = '" fill="';
    parts[3] = color;
    parts[4] = '" transform="translate(';
    parts[5] = ox;
    parts[6] = " ";
    parts[7] = oy;
    parts[8] = ") rotate(";
    parts[9] = r;
    parts[10] = " 81.5 110) scale(";
    parts[11] = scale;
    parts[
      12
    ] = ')"><path d="M52.2262 2.0318C20.6262 9.2318 5.39287 69.0318 1.72621 98.0318C-3.77379 133.365 0.726208 206.932 62.7262 218.532C140.226 233.032 162.726 112.032 162.726 63.0318C162.726 14.0318 91.7262 -6.9682 52.2262 2.0318Z"/></g>';

    string memory output = string(
      abi.encodePacked(
        parts[0],
        parts[1],
        parts[2],
        parts[3],
        parts[4],
        parts[5],
        parts[6],
        parts[7]
      )
    );
    output = string(
      abi.encodePacked(
        output,
        parts[8],
        parts[9],
        parts[10],
        parts[11],
        parts[12]
      )
    );
    return output;
  }

  function getLove(uint256 tokenId) public view returns (uint256) {
    address creator = _mints[tokenId];
    return _love[creator];
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override
    returns (string memory)
  {
    address creator = _mints[tokenId];

    string memory output;

    string[7] memory colors = [
      "#59B9FF",
      "#51FFD5",
      "#FFD159",
      "#FFA3A3",
      "#CA59FF",
      "#597EFF",
      "#FFDBDB"
    ];

    output = header;

    output = string(
      abi.encodePacked(
        output,
        '<rect width="400" height="400" fill="',
        colors[random(abi.encodePacked("BACKGROUND", creator), colors.length)],
        '" opacity="0.2" />'
      )
    );

    uint256 love = _love[creator];
    uint256 count = random(abi.encodePacked("BASECOUNT", creator), 3) + love;

    if (count >= 5) {
      count = 5;
    }

    for (uint256 i = 0; i < count; ++i) {
      string memory color = colors[
        random(abi.encodePacked("COLOR", creator, i), colors.length)
      ];
      uint256 ox = uint256(random(abi.encodePacked("ox", creator, i), 80)) +
        119 -
        40;
      uint256 oy = uint256(random(abi.encodePacked("oy", creator, i), 80)) +
        90 -
        40;
      uint256 r = uint256(random(abi.encodePacked("r", creator, i), 360));
      string memory opacity = "0.3";
      string memory scale = string(
        abi.encodePacked(
          "0.",
          toString(79 + random(abi.encodePacked("SCALE", creator, i), 20))
        )
      );
      if (i == count - 1) {
        ox = 119;
        oy = 90;
        r = uint256(random(abi.encodePacked("r", creator, i), 14));
        scale = "1";
        opacity = "1";
        if (love < 7) color = "clear";
      }
      bool stroke = i == count - 1;
      string memory ds = draw(
        color,
        toString(ox),
        toString(oy),
        maybeNegateString(r),
        scale,
        opacity,
        stroke
      );
      output = string(abi.encodePacked(output, ds));
    }

    if (love >= 14) {
      output = string(abi.encodePacked(output, halo));
    }

    output = string(abi.encodePacked(output, footer));

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "pfp #',
            toString(tokenId),
            '", "description": "dear caretaker, thank u for a great time in ur world! miss u lots and hope to see u soon", "attributes": [{"trait_type": "LOVE", "value":',
            toString(love),
            '}], "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(output)),
            '"}'
          )
        )
      )
    );
    output = string(abi.encodePacked("data:application/json;base64,", json));

    return output;
  }

  function mint() public nonReentrant {
    require(enabled || _msgSender() == owner(), "Not allowed");
    require(wagmi.love(_msgSender()) > 0, "Not enough love");
    require(_claims[_msgSender()] == false, "Already minted from this address");
    _mints[totalSupply()] = _msgSender();
    _claims[_msgSender()] = true;
    _love[_msgSender()] = wagmi.love(_msgSender());
    _safeMint(_msgSender(), totalSupply());
  }

  function mintForWagmiOne() public nonReentrant {
    require(enabled || _msgSender() == owner(), "Not allowed");
    require(wagmiOne.love(_msgSender()) > 0, "Not enough love");
    require(_claims[_msgSender()] == false, "Already minted from this address");
    _mints[totalSupply()] = _msgSender();
    _claims[_msgSender()] = true;
    _love[_msgSender()] = wagmiOne.love(_msgSender());
    _safeMint(_msgSender(), totalSupply());
  }

  function maybeNegateString(uint256 value)
    internal
    pure
    returns (string memory)
  {
    if (value % 2 == 0) {
      return string(abi.encodePacked("-", toString(value)));
    }
    return toString(value);
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

  constructor() ERC721("postcards from paradise", "PFP") Ownable() {}
}
