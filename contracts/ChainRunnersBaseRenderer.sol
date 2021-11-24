// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Solidity Renderer Contract Template based on @chain_runners
 * Source: https://etherscan.io/address/0xfdac77881ff861ff76a83cc43a1be3c317c6a1cc
 * Bulk of the logic is here
 **/

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./core/ChainRunnersTypes.sol";

/*
               ::::                                                                                                                                                  :::#%=
               @*==+-                                                                                                                                               ++==*=.
               #+=#=++..                                                                                                                                        ..=*=*+-#:
                :=+++++++=====================================:    .===============================================. .=========================================++++++++=
                 .%-+%##+=--==================================+=..=+-=============================================-+*+======================================---+##+=#-.
                   -+++@@%++++@@@%+++++++++++++++++++++++++++%#++++++%#+++#@@@#+++++++++@@%++++++++++++++++++++@#+.=+*@*+*@@@@*+++++++++++++++++++++++%@@@#+++#@@+++=
                    -*-#%@@%%%=*%@%*++=++=+==+=++=++=+=++=++==#@%#%#+++=+=*@%*+=+==+=+++%*++==+=++=+==+=++=+=++@%%#%#++++*@%#++=++=++=++=+=++=++=+=+*%%*==*%@@@*:%=
                     :@:+@@@@@@*+++%@@*+===========+*=========#@@========+#%==========*@========##*#*+=======*@##*======#@#+=======*#*============+#%++#@@%#@@#++=.
                      .*+=%@%*%@%##++@@%#=-==-=--==*%=========*%==--=--=-====--=--=-=##=--=-=--%%%%%+=-=--=-=*%=--=--=-=#%=--=----=#%=--=-=--=-+%#+==#%@@*#%@=++.
                        +%.#@@###%@@@@@%*---------#@%########@%*---------------------##---------------------##---------%%*--------@@#---------+#@=#@@#+==@@%*++-
                        .:*+*%@#+=*%@@@*=-------=#%#=-------=%*---------=*#*--------#+=--------===--------=#%*-------=#%*-------==@%#--------=%@@%#*+=-+#%*+*:.
       ====================%*.@@%#==+##%@*=----------------+@#+---------@@*-------=*@+---------@@*--------=@+--------+@=--------*@@+-------+#@@%#==---+#@.*%====================
     :*=--==================-:=#@@%*===+*@%+=============%%%@=========*%@*========+@+=--=====+%@+==========@+========+@========*%@@+======%%%**+=---=%@#=:-====================-#-
       +++**%@@@#*****************@#*=---=##%@@@@@@@@@@@@@#**@@@@****************%@@*+++@#***********#@************************************+=------=*@#*********************@#+=+:
        .-##=*@@%*----------------+%@%=---===+%@@@@@@@*+++---%#++----------------=*@@*+++=-----------=+#=------------------------------------------+%+--------------------+#@-=@
         :%:#%#####+=-=-*@@+--=-==-=*@=--=-==-=*@@#*=-==-=-+@===-==-=-=++==-=-==--=@%===-==----+-==-==--+*+-==-==---=*@@@@@@%#===-=-=+%@%-==-=-==-#@%=-==-==--+#@@@@@@@@@@@@*+++
        =*=#@#=----==-=-=++=--=-==-=*@=--=-==-=*@@+-=-==-==+@===-=--=-*@@*=-=-==--+@=--=-==--+#@-==-==---+%-==-==---=+++#@@@#--==-=-=++++-=--=-===#%+=-==-==---=++++++++@@@%.#*
        +#:@%*===================++%#=========%@%=========#%=========+#@%+=======#%==========*@#=========*%=========+*+%@@@+========+*==========+@@%+**+================*%#*=+=
       *++#@*+=++++++*#%*+++++=+++*%%++++=++++%%*=+++++++##*=++++=++=%@@++++=++=+#%++++=++++#%@=+++++++=*#*+++++++=#%@@@@@*++=++++=#%@*+++=++=+++@#*****=+++++++=+++++*%@@+:=+=
    :=*=#%#@@@@#%@@@%#@@#++++++++++%%*+++++++++++++++++**@*+++++++++*%#++++++++=*##++++++++*%@%+++++++++##+++++++++#%%%%%%++++**#@@@@@**+++++++++++++++++=*%@@@%#@@@@#%@@@%#@++*:.
    #*:@#=-+%#+:=*@*=-+@%#++++++++#%@@#*++++++++++++++#%@#*++++++++*@@#+++++++++@#++++++++*@@#+++++++++##*+++++++++++++++++###@@@@++*@@#+++++++++++++++++++*@@#=:+#%+--+@*=-+%*.@=
    ++=#%#+%@@%=#%@%#+%%#++++++*#@@@%###**************@@@++++++++**#@##*********#*********#@@#++++++***@#******%@%#*++**#@@@%##+==+++=*#**********%%*++++++++#%#=%@@%+*%@%*+%#*=*-
     .-*+===========*@@+++++*%%%@@@++***************+.%%*++++#%%%@@%=:=******************--@@#+++*%%@#==+***--*@%*++*%@@*===+**=--   -************++@%%#++++++#@@@*==========*+-
        =*******##.#%#++++*%@@@%+==+=             *#-%@%**%%###*====**-               -@:*@@##@###*==+**-.-#=+@@#*@##*==+***=                     =+=##%@*+++++*%@@#.#%******:
               ++++%#+++*#@@@@+++==.              **-@@@%+++++++===-                 -+++#@@+++++++==:  :+++%@@+++++++==:                          .=++++@%##++++@@%++++
             :%:*%%****%@@%+==*-                .%==*====**+...                      #*.#+==***....    #+=#%+==****:.                                ..-*=*%@%#++*#%@=+%.
            -+++#%+#%@@@#++===                  .@*++===-                            #%++===           %#+++===                                          =+++%@%##**@@*.@:
          .%-=%@##@@%*==++                                                                                                                                 .*==+#@@%*%@%=*=.
         .+++#@@@@@*++==.                                                                                                                                    -==++#@@@@@@=+%
       .=*=%@@%%%#=*=.                                                                                                                                          .*+=%@@@@%+-#.
       @=-@@@%:++++.                                                                                                                                              -+++**@@#+*=:
    .-+=*#%%++*::.                                                                                                                                                  :+**=#%@#==#
    #*:@*+++=:                                                                                                                                                          =+++@*++=:
  :*-=*=++..                                                                                                                                                             .=*=#*.%=
 +#.=+++:                                                                                                                                                                   ++++:+#
*+=#-::                                                                                                                                                                      .::*+=*

*/

contract ChainRunnersBaseRenderer is Ownable, ReentrancyGuard {
  struct SVGCursor {
    uint8 x;
    uint8 y;
    string color1;
    string color2;
    string color3;
    string color4;
  }

  struct Buffer {
    string one;
    string two;
    string three;
    string four;
    string five;
    string six;
    string seven;
    string eight;
  }

  struct Color {
    string hexString;
    uint256 alpha;
    uint256 red;
    uint256 green;
    uint256 blue;
  }

  struct Layer {
    string name;
    bytes hexString;
  }

  struct LayerInput {
    string name;
    bytes hexString;
    uint8 layerIndex;
    uint8 itemIndex;
  }

  uint256 public constant NUM_LAYERS = 13;
  uint256 public constant NUM_COLORS = 8;

  mapping(uint256 => Layer)[NUM_LAYERS] layers;

  /*
    This indexes into a race, then a layer index, then an array capturing the frequency each layer should be selected.
    Shout out to Anonymice for the rarity impl inspiration.
    */
  uint16[][NUM_LAYERS][3] WEIGHTS;

  constructor() {
    // Default
    // NOTE: The array of frequency determines two things:
    // 1. The frequency of appearance of the layer
    // 2. The index of the frequency will become the layer index
    WEIGHTS[0][0] = [
      36,
      225,
      225,
      225,
      360,
      135,
      27,
      360,
      315,
      315,
      315,
      315,
      225,
      180,
      225,
      180,
      360,
      180,
      45,
      360,
      360,
      360,
      27,
      36,
      360,
      45,
      180,
      360,
      225,
      360,
      225,
      225,
      360,
      180,
      45,
      360,
      18,
      225,
      225,
      225,
      225,
      180,
      225,
      361
    ];
    WEIGHTS[0][1] = [
      875,
      1269,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      17,
      8,
      41
    ];
    WEIGHTS[0][2] = [
      303,
      303,
      303,
      303,
      151,
      30,
      0,
      0,
      151,
      151,
      151,
      151,
      30,
      303,
      151,
      30,
      303,
      303,
      303,
      303,
      303,
      303,
      30,
      151,
      303,
      303,
      303,
      303,
      303,
      303,
      303,
      303,
      3066
    ];
    WEIGHTS[0][3] = [
      645,
      0,
      1290,
      322,
      645,
      645,
      645,
      967,
      322,
      967,
      645,
      967,
      967,
      973
    ];
    WEIGHTS[0][4] = [0, 0, 0, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250];
    WEIGHTS[0][5] = [
      121,
      121,
      121,
      121,
      121,
      121,
      243,
      0,
      0,
      0,
      0,
      121,
      121,
      243,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      121,
      121,
      243,
      121,
      121,
      243,
      0,
      0,
      0,
      121,
      121,
      243,
      121,
      121,
      306
    ];
    WEIGHTS[0][6] = [925, 555, 185, 555, 925, 925, 185, 1296, 1296, 1296, 1857];
    WEIGHTS[0][7] = [88, 88, 88, 88, 88, 265, 442, 8853];
    WEIGHTS[0][8] = [189, 189, 47, 18, 9, 28, 37, 9483];
    WEIGHTS[0][9] = [
      340,
      340,
      340,
      340,
      340,
      340,
      34,
      340,
      340,
      340,
      340,
      170,
      170,
      170,
      102,
      238,
      238,
      238,
      272,
      340,
      340,
      340,
      272,
      238,
      238,
      238,
      238,
      170,
      34,
      340,
      340,
      136,
      340,
      340,
      340,
      340,
      344
    ];
    WEIGHTS[0][10] = [
      159,
      212,
      106,
      53,
      26,
      159,
      53,
      265,
      53,
      212,
      159,
      265,
      53,
      265,
      265,
      212,
      53,
      159,
      239,
      53,
      106,
      5,
      106,
      53,
      212,
      212,
      106,
      159,
      212,
      265,
      212,
      265,
      5066
    ];
    WEIGHTS[0][11] = [
      139,
      278,
      278,
      250,
      250,
      194,
      222,
      278,
      278,
      194,
      222,
      83,
      222,
      278,
      139,
      139,
      27,
      278,
      278,
      278,
      278,
      27,
      278,
      139,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      27,
      139,
      139,
      139,
      139,
      0,
      278,
      194,
      83,
      83,
      278,
      83,
      27,
      306
    ];
    WEIGHTS[0][12] = [981, 2945, 654, 16, 981, 327, 654, 163, 3279];

    // Skull
    WEIGHTS[1][0] = [
      36,
      225,
      225,
      225,
      360,
      135,
      27,
      360,
      315,
      315,
      315,
      315,
      225,
      180,
      225,
      180,
      360,
      180,
      45,
      360,
      360,
      360,
      27,
      36,
      360,
      45,
      180,
      360,
      225,
      360,
      225,
      225,
      360,
      180,
      45,
      360,
      18,
      225,
      225,
      225,
      225,
      180,
      225,
      361
    ];
    WEIGHTS[1][1] = [
      875,
      1269,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      17,
      8,
      41
    ];
    WEIGHTS[1][2] = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      10000
    ];
    WEIGHTS[1][3] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    WEIGHTS[1][4] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    WEIGHTS[1][5] = [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      384,
      7692,
      1923,
      0,
      0,
      0,
      0,
      0,
      1
    ];
    WEIGHTS[1][6] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10000];
    WEIGHTS[1][7] = [0, 0, 0, 0, 0, 909, 0, 9091];
    WEIGHTS[1][8] = [0, 0, 0, 0, 0, 0, 0, 10000];
    WEIGHTS[1][9] = [
      526,
      526,
      526,
      0,
      0,
      0,
      0,
      0,
      526,
      0,
      0,
      0,
      526,
      0,
      526,
      0,
      0,
      0,
      526,
      526,
      526,
      526,
      526,
      526,
      526,
      526,
      526,
      526,
      526,
      0,
      0,
      526,
      0,
      0,
      0,
      0,
      532
    ];
    WEIGHTS[1][10] = [
      80,
      0,
      400,
      240,
      80,
      0,
      240,
      0,
      0,
      80,
      80,
      80,
      0,
      0,
      0,
      0,
      80,
      80,
      0,
      0,
      80,
      80,
      0,
      80,
      80,
      80,
      80,
      80,
      0,
      0,
      0,
      0,
      8000
    ];
    WEIGHTS[1][11] = [
      289,
      0,
      0,
      0,
      0,
      404,
      462,
      578,
      578,
      0,
      462,
      173,
      462,
      578,
      0,
      0,
      57,
      0,
      57,
      0,
      57,
      57,
      578,
      289,
      578,
      57,
      0,
      57,
      57,
      57,
      578,
      578,
      0,
      0,
      0,
      0,
      0,
      0,
      57,
      289,
      578,
      0,
      0,
      0,
      231,
      57,
      0,
      0,
      1745
    ];
    WEIGHTS[1][12] = [714, 714, 714, 0, 714, 0, 0, 0, 7144];

    // Bot
    WEIGHTS[2][0] = [
      36,
      225,
      225,
      225,
      360,
      135,
      27,
      360,
      315,
      315,
      315,
      315,
      225,
      180,
      225,
      180,
      360,
      180,
      45,
      360,
      360,
      360,
      27,
      36,
      360,
      45,
      180,
      360,
      225,
      360,
      225,
      225,
      360,
      180,
      45,
      360,
      18,
      225,
      225,
      225,
      225,
      180,
      225,
      361
    ];
    WEIGHTS[2][1] = [
      875,
      1269,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      779,
      17,
      8,
      41
    ];
    WEIGHTS[2][2] = [
      303,
      303,
      303,
      303,
      151,
      30,
      0,
      0,
      151,
      151,
      151,
      151,
      30,
      303,
      151,
      30,
      303,
      303,
      303,
      303,
      303,
      303,
      30,
      151,
      303,
      303,
      303,
      303,
      303,
      303,
      303,
      303,
      3066
    ];
    WEIGHTS[2][3] = [
      645,
      0,
      1290,
      322,
      645,
      645,
      645,
      967,
      322,
      967,
      645,
      967,
      967,
      973
    ];
    WEIGHTS[2][4] = [2500, 2500, 2500, 0, 0, 0, 0, 0, 0, 2500, 0];
    WEIGHTS[2][5] = [
      0,
      0,
      0,
      0,
      0,
      0,
      588,
      588,
      588,
      588,
      588,
      0,
      0,
      588,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      588,
      588,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      588,
      0,
      0,
      4
    ];
    WEIGHTS[2][6] = [925, 555, 185, 555, 925, 925, 185, 1296, 1296, 1296, 1857];
    WEIGHTS[2][7] = [88, 88, 88, 88, 88, 265, 442, 8853];
    WEIGHTS[2][8] = [183, 274, 274, 18, 18, 27, 36, 9170];
    WEIGHTS[2][9] = [
      340,
      340,
      340,
      340,
      340,
      340,
      34,
      340,
      340,
      340,
      340,
      170,
      170,
      170,
      102,
      238,
      238,
      238,
      272,
      340,
      340,
      340,
      272,
      238,
      238,
      238,
      238,
      170,
      34,
      340,
      340,
      136,
      340,
      340,
      340,
      340,
      344
    ];
    WEIGHTS[2][10] = [
      217,
      362,
      217,
      144,
      72,
      289,
      144,
      362,
      72,
      289,
      217,
      362,
      72,
      362,
      362,
      289,
      0,
      217,
      0,
      72,
      144,
      7,
      217,
      72,
      217,
      217,
      289,
      217,
      289,
      362,
      217,
      362,
      3269
    ];
    WEIGHTS[2][11] = [
      139,
      278,
      278,
      250,
      250,
      194,
      222,
      278,
      278,
      194,
      222,
      83,
      222,
      278,
      139,
      139,
      27,
      278,
      278,
      278,
      278,
      27,
      278,
      139,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      278,
      27,
      139,
      139,
      139,
      139,
      0,
      278,
      194,
      83,
      83,
      278,
      83,
      27,
      306
    ];
    WEIGHTS[2][12] = [981, 2945, 654, 16, 981, 327, 654, 163, 3279];
  }

  // NOTE: All layers are kept as bytecode. We need to call this function to load up all the layers bytecode upon contract deployment.
  // This is expensive! The chain runners team spent 10eth to do this?
  function setLayers(LayerInput[] calldata toSet) external onlyOwner {
    for (uint16 i = 0; i < toSet.length; i++) {
      layers[toSet[i].layerIndex][toSet[i].itemIndex] = Layer(
        toSet[i].name,
        toSet[i].hexString
      );
    }
  }

  function getLayer(uint8 layerIndex, uint8 itemIndex)
    public
    view
    returns (Layer memory)
  {
    return layers[layerIndex][itemIndex];
  }

  /*
    Get race index.  Race index represents the "type" of base character:

    0 - Default, representing human and alien characters
    1 - Skull
    2 - Bot

    This allows skull/bot characters to have distinct trait distributions.
    */
  function getRaceIndex(uint16 _dna) public view returns (uint8) {
    // NOTE: lowerBound starts with value 0, percentage also 0
    uint16 lowerBound;
    uint16 percentage;
    // NOTE: loop through the length of the frequency array
    for (uint8 i; i < WEIGHTS[0][1].length; i++) {
      percentage = WEIGHTS[0][1][i];
      // NOTE: If DNA is more than lower bound and less then lowerBound + percentage, check the iteration and return index representing the race
      // the DNA itself is a split version and holds 4 digit.
      if (_dna >= lowerBound && _dna < lowerBound + percentage) {
        if (i == 1) {
          // Bot
          return 2;
        } else if (i > 11) {
          // Skull
          return 1;
        } else {
          // Default
          return 0;
        }
      }
      // NOTE: If none match, set accumulate lowerBound with the percentage and move on to the next index.
      lowerBound += percentage;
    }
    revert();
  }

  function getLayerIndex(
    uint16 _dna,
    uint8 _index,
    uint16 _raceIndex
  ) public view returns (uint256) {
    // NOTE: Same as above, lowerBound starts with value 0, percentage also 0
    uint16 lowerBound;
    uint16 percentage;
    // NOTE: loop through the length of the frequency array
    for (uint8 i; i < WEIGHTS[_raceIndex][_index].length; i++) {
      percentage = WEIGHTS[_raceIndex][_index][i];
      // NOTE: Same as above, if DNA is more than lower bound and less then lowerBound + percentage, check the iteration and return index representing the race
      // the DNA itself is a split version and holds 4 digit.
      if (_dna >= lowerBound && _dna < lowerBound + percentage) {
        return i;
      }
      lowerBound += percentage;
    }
    // NOTE: This time if none match, we ignore the layer
    // If not found, return index higher than available layers.  Will get filtered out.
    return WEIGHTS[_raceIndex][_index].length;
  }

  /*
    Generate base64 encoded tokenURI.

    All string constants are pre-base64 encoded to save gas.
    Input strings are padded with spacing/etc to ensure their length is a multiple of 3.
    This way the resulting base64 encoded string is a multiple of 4 and will not include any '=' padding characters,
    which allows these base64 string snippets to be concatenated with other snippets.
    */
  function tokenURI(
    uint256 tokenId,
    ChainRunnersTypes.ChainRunner memory runnerData
  ) public view returns (string memory) {
    // NOTE: getTokenData as what its called, get us the traits and layers of the runner
    (
      Layer[NUM_LAYERS] memory tokenLayers,
      Color[NUM_COLORS][NUM_LAYERS] memory tokenPalettes,
      uint8 numTokenLayers,
      string[NUM_LAYERS] memory traitTypes
    ) = getTokenData(runnerData.dna);
    string memory attributes;
    // NOTE: Everything is already partially encoded with base64
    for (uint8 i = 0; i < numTokenLayers; i++) {
      attributes = string(
        abi.encodePacked(
          attributes,
          bytes(attributes).length == 0 ? "eyAg" : "LCB7",
          "InRyYWl0X3R5cGUiOiAi",
          traitTypes[i],
          "IiwidmFsdWUiOiAi",
          tokenLayers[i].name,
          "IiB9"
        )
      );
    }
    // NOTE: tokenSVGBuffer will construct the SVG
    string[4] memory svgBuffers = tokenSVGBuffer(
      tokenLayers,
      tokenPalettes,
      numTokenLayers
    );
    // NOTE: Return base64 encoded uri as usual
    return
      string(
        abi.encodePacked(
          "data:application/json;base64,eyAgImltYWdlX2RhdGEiOiAiPHN2ZyB2ZXJzaW9uPScxLjEnIHZpZXdCb3g9JzAgMCAzMjAgMzIwJyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHNoYXBlLXJlbmRlcmluZz0nY3Jpc3BFZGdlcyc+",
          svgBuffers[0],
          svgBuffers[1],
          svgBuffers[2],
          svgBuffers[3],
          "PHN0eWxlPnJlY3R7d2lkdGg6MTBweDtoZWlnaHQ6MTBweDt9PC9zdHlsZT48L3N2Zz4gIiwgImF0dHJpYnV0ZXMiOiBb",
          attributes,
          "XSwgICAibmFtZSI6IlJ1bm5lciAj",
          Base64.encode(uintToByteString(tokenId, 6)),
          "IiwgImRlc2NyaXB0aW9uIjogIkNoYWluIFJ1bm5lcnMgYXJlIE1lZ2EgQ2l0eSByZW5lZ2FkZXMgMTAwJSBnZW5lcmF0ZWQgb24gY2hhaW4uIn0g"
        )
      );
  }

  // NOTE: Similar to tokenURI but just gives you the SVG base64
  function tokenSVG(uint256 _dna) public view returns (string memory) {
    (
      Layer[NUM_LAYERS] memory tokenLayers,
      Color[NUM_COLORS][NUM_LAYERS] memory tokenPalettes,
      uint8 numTokenLayers,
      string[NUM_LAYERS] memory traitTypes
    ) = getTokenData(_dna);
    string[4] memory buffer256 = tokenSVGBuffer(
      tokenLayers,
      tokenPalettes,
      numTokenLayers
    );
    return
      string(
        abi.encodePacked(
          "PHN2ZyB2ZXJzaW9uPScxLjEnIHZpZXdCb3g9JzAgMCAzMiAzMicgeG1sbnM9J2h0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnJyBzaGFwZS1yZW5kZXJpbmc9J2NyaXNwRWRnZXMnIGhlaWdodD0nMTAwJScgd2lkdGg9JzEwMCUnICA+",
          buffer256[0],
          buffer256[1],
          buffer256[2],
          buffer256[3],
          "PHN0eWxlPnJlY3R7d2lkdGg6MXB4O2hlaWdodDoxcHg7fTwvc3R5bGU+PC9zdmc+"
        )
      );
  }

  // NOTE: Get the traits of the NFT!
  function getTokenData(uint256 _dna)
    public
    view
    returns (
      Layer[NUM_LAYERS] memory tokenLayers,
      Color[NUM_COLORS][NUM_LAYERS] memory tokenPalettes,
      uint8 numTokenLayers,
      string[NUM_LAYERS] memory traitTypes
    )
  {
    // NOTE: Split the dna here, becomes an array with 13 entries of 4 digits integer
    uint16[NUM_LAYERS] memory dna = splitNumber(_dna);
    // NOTE: Get race index using lowerBound looping thing
    uint16 raceIndex = getRaceIndex(dna[1]);

    // NOTE: Check for face, mask, and head traits by comparing the frequency
    bool hasFaceAcc = dna[7] < (10000 - WEIGHTS[raceIndex][7][7]);
    bool hasMask = dna[8] < (10000 - WEIGHTS[raceIndex][8][7]);
    bool hasHeadBelow = dna[9] < (10000 - WEIGHTS[raceIndex][9][36]);
    bool hasHeadAbove = dna[11] < (10000 - WEIGHTS[raceIndex][11][48]);
    bool useHeadAbove = (dna[0] % 2) > 0;
    for (uint8 i = 0; i < NUM_LAYERS; i++) {
      // NOTE: Get the token layer. We get base64 string for the label and bytecode for the pixel
      Layer memory layer = layers[i][getLayerIndex(dna[i], i, raceIndex)];
      if (layer.hexString.length > 0) {
        /*
                These conditions help make sure layer selection meshes well visually.
                1. If mask, no face/eye acc/mouth acc
                2. If face acc, no mask/mouth acc/face
                3. If both head above & head below, randomly choose one
                */
        if (
          ((i == 2 || i == 12) && !hasMask && !hasFaceAcc) ||
          (i == 7 && !hasMask) ||
          (i == 10 && !hasMask) ||
          (i < 2 || (i > 2 && i < 7) || i == 8 || i == 9 || i == 11)
        ) {
          if (
            (hasHeadBelow && hasHeadAbove && (i == 9 && useHeadAbove)) ||
            (i == 11 && !useHeadAbove)
          ) continue;
          tokenLayers[numTokenLayers] = layer;
          // NOTE: Get the palette from the tokenLayer
          tokenPalettes[numTokenLayers] = palette(
            tokenLayers[numTokenLayers].hexString
          );
          traitTypes[numTokenLayers] = [
            "QmFja2dyb3VuZCAg",
            "UmFjZSAg",
            "RmFjZSAg",
            "TW91dGgg",
            "Tm9zZSAg",
            "RXllcyAg",
            "RWFyIEFjY2Vzc29yeSAg",
            "RmFjZSBBY2Nlc3Nvcnkg",
            "TWFzayAg",
            "SGVhZCBCZWxvdyAg",
            "RXllIEFjY2Vzc29yeSAg",
            "SGVhZCBBYm92ZSAg",
            "TW91dGggQWNjZXNzb3J5"
          ][i];
          numTokenLayers++;
        }
      }
    }
    return (tokenLayers, tokenPalettes, numTokenLayers, traitTypes);
  }

  /*
    Generate svg rects, leaving un-concatenated to save a redundant concatenation in calling functions to reduce gas.
    Shout out to Blitmap for a lot of the inspiration for efficient rendering here.
    */
  function tokenSVGBuffer(
    Layer[NUM_LAYERS] memory tokenLayers,
    Color[NUM_COLORS][NUM_LAYERS] memory tokenPalettes,
    uint8 numTokenLayers
  ) public pure returns (string[4] memory) {
    // Base64 encoded lookups into x/y position strings from 010 to 310.
    // NOTE: These are all base64, if you decode you get the value 010 up to 310
    string[32] memory lookup = [
      "MDAw",
      "MDEw",
      "MDIw",
      "MDMw",
      "MDQw",
      "MDUw",
      "MDYw",
      "MDcw",
      "MDgw",
      "MDkw",
      "MTAw",
      "MTEw",
      "MTIw",
      "MTMw",
      "MTQw",
      "MTUw",
      "MTYw",
      "MTcw",
      "MTgw",
      "MTkw",
      "MjAw",
      "MjEw",
      "MjIw",
      "MjMw",
      "MjQw",
      "MjUw",
      "MjYw",
      "Mjcw",
      "Mjgw",
      "Mjkw",
      "MzAw",
      "MzEw"
    ];
    SVGCursor memory cursor;

    /*
        Rather than concatenating the result string with itself over and over (e.g. result = abi.encodePacked(result, newString)),
        we fill up multiple levels of buffers.  This reduces redundant intermediate concatenations, performing O(log(n)) concats
        instead of O(n) concats.  Buffers beyond a length of about 12 start hitting stack too deep issues, so using a length of 8
        because the pixel math is convenient.
        */
    Buffer memory buffer4;
    // 4 pixels per slot, 32 total.  Struct is ever so slightly better for gas, so using when convenient.
    string[8] memory buffer32;
    // 32 pixels per slot, 256 total
    string[4] memory buffer256;
    // 256 pixels per slot, 1024 total
    uint8 buffer32count;
    uint8 buffer256count;
    // NOTE: We iterate to scan from top left to bottom right
    for (uint256 k = 32; k < 416; ) {
      // NOTE: We interpret the pixels here. We do for all 8 layers and 4 pixels per scan at once to save gas
      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        0,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        1,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        2,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        3,
        tokenPalettes,
        numTokenLayers
      );
      // NOTE: Plot 4 pixel at once to save gas
      buffer4.one = pixel4(lookup, cursor);
      cursor.x += 4;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        4,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        5,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        6,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        7,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.two = pixel4(lookup, cursor);
      cursor.x += 4;

      // NOTE: Move our scan to the next coordinate of our canvas
      k += 3;

      // NOTE: Do this again 3 more times, again to save gas
      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        0,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        1,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        2,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        3,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.three = pixel4(lookup, cursor);
      cursor.x += 4;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        4,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        5,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        6,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        7,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.four = pixel4(lookup, cursor);
      cursor.x += 4;

      k += 3;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        0,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        1,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        2,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        3,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.five = pixel4(lookup, cursor);
      cursor.x += 4;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        4,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        5,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        6,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        7,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.six = pixel4(lookup, cursor);
      cursor.x += 4;

      k += 3;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        0,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        1,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        2,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        3,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.seven = pixel4(lookup, cursor);
      cursor.x += 4;

      cursor.color1 = colorForIndex(
        tokenLayers,
        k,
        4,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color2 = colorForIndex(
        tokenLayers,
        k,
        5,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color3 = colorForIndex(
        tokenLayers,
        k,
        6,
        tokenPalettes,
        numTokenLayers
      );
      cursor.color4 = colorForIndex(
        tokenLayers,
        k,
        7,
        tokenPalettes,
        numTokenLayers
      );
      buffer4.eight = pixel4(lookup, cursor);
      cursor.x += 4;

      k += 3;

      // NOTE: Combine and collect the results as a buffer
      buffer32[buffer32count++] = string(
        abi.encodePacked(
          buffer4.one,
          buffer4.two,
          buffer4.three,
          buffer4.four,
          buffer4.five,
          buffer4.six,
          buffer4.seven,
          buffer4.eight
        )
      );
      cursor.x = 0;
      cursor.y += 1;
      if (buffer32count >= 8) {
        buffer256[buffer256count++] = string(
          abi.encodePacked(
            buffer32[0],
            buffer32[1],
            buffer32[2],
            buffer32[3],
            buffer32[4],
            buffer32[5],
            buffer32[6],
            buffer32[7]
          )
        );
        buffer32count = 0;
      }
    }
    // At this point, buffer256 contains 4 strings or 256*4=1024=32x32 pixels
    return buffer256;
  }

  // NOTE: We interpret the bytecode and get RGBA Values and hexString for the pixel
  function palette(bytes memory data)
    internal
    pure
    returns (Color[NUM_COLORS] memory)
  {
    Color[NUM_COLORS] memory colors;
    for (uint16 i = 0; i < NUM_COLORS; i++) {
      // Even though this can be computed later from the RGBA values below, it saves gas to pre-compute it once upfront.
      colors[i].hexString = Base64.encode(
        bytes(
          abi.encodePacked(
            byteToHexString(data[i * 4]),
            byteToHexString(data[i * 4 + 1]),
            byteToHexString(data[i * 4 + 2])
          )
        )
      );
      colors[i].red = byteToUint(data[i * 4]);
      colors[i].green = byteToUint(data[i * 4 + 1]);
      colors[i].blue = byteToUint(data[i * 4 + 2]);
      colors[i].alpha = byteToUint(data[i * 4 + 3]);
    }
    return colors;
  }

  // NOTE: We determine what pixel and color to plot on a given coordinate of the canvas
  function colorForIndex(
    Layer[NUM_LAYERS] memory tokenLayers,
    uint256 k,
    uint256 index,
    Color[NUM_COLORS][NUM_LAYERS] memory palettes,
    uint256 numTokenLayers
  ) internal pure returns (string memory) {
    for (uint256 i = numTokenLayers - 1; i >= 0; i--) {
      // NOTE: We get the index of the color based on the coordinate of the canvas we're in
      Color memory fg = palettes[i][
        colorIndex(tokenLayers[i].hexString, k, index)
      ];
      // Since most layer pixels are transparent, performing this check first saves gas
      // NOTE: If nothing to plot on the coordinate, it'll be transparent
      if (fg.alpha == 0) {
        continue;
      } else if (fg.alpha == 255) {
        return fg.hexString;
      } else {
        for (uint256 j = i - 1; j >= 0; j--) {
          Color memory bg = palettes[j][
            colorIndex(tokenLayers[j].hexString, k, index)
          ];
          /* As a simplification, blend with first non-transparent layer then stop.
                    We won't generally have overlapping semi-transparent pixels.
                    */
          // NOTE: If there's something to plot, we call the blend colors function
          if (bg.alpha > 0) {
            return Base64.encode(bytes(blendColors(fg, bg)));
          }
        }
      }
    }
    return "000000";
  }

  /*
    Each color index is 3 bits (there are 8 colors, so 3 bits are needed to index into them).
    Since 3 bits doesn't divide cleanly into 8 bits (1 byte), we look up colors 24 bits (3 bytes) at a time.
    "k" is the starting byte index, and "index" is the color index within the 3 bytes starting at k.
    */
  // NOTE: Here we determine what color to plot at which coordinate of the canvas. K represents the coordinate of the pixel.
  function colorIndex(
    bytes memory data,
    uint256 k,
    uint256 index
  ) internal pure returns (uint8) {
    if (index == 0) {
      return uint8(data[k]) >> 5;
    } else if (index == 1) {
      return (uint8(data[k]) >> 2) % 8;
    } else if (index == 2) {
      return ((uint8(data[k]) % 4) * 2) + (uint8(data[k + 1]) >> 7);
    } else if (index == 3) {
      return (uint8(data[k + 1]) >> 4) % 8;
    } else if (index == 4) {
      return (uint8(data[k + 1]) >> 1) % 8;
    } else if (index == 5) {
      return ((uint8(data[k + 1]) % 2) * 4) + (uint8(data[k + 2]) >> 6);
    } else if (index == 6) {
      return (uint8(data[k + 2]) >> 3) % 8;
    } else {
      return uint8(data[k + 2]) % 8;
    }
  }

  /*
    Create 4 svg rects, pre-base64 encoding the svg constants to save gas.
    */
  // NOTE: Plot 4 svg pixels at once as base64 to save gas
  function pixel4(string[32] memory lookup, SVGCursor memory cursor)
    internal
    pure
    returns (string memory result)
  {
    return
      string(
        abi.encodePacked(
          "PHJlY3QgICBmaWxsPScj",
          cursor.color1,
          "JyAgeD0n",
          lookup[cursor.x],
          "JyAgeT0n",
          lookup[cursor.y],
          "JyAvPjxyZWN0ICBmaWxsPScj",
          cursor.color2,
          "JyAgeD0n",
          lookup[cursor.x + 1],
          "JyAgeT0n",
          lookup[cursor.y],
          "JyAvPjxyZWN0ICBmaWxsPScj",
          cursor.color3,
          "JyAgeD0n",
          lookup[cursor.x + 2],
          "JyAgeT0n",
          lookup[cursor.y],
          "JyAvPjxyZWN0ICBmaWxsPScj",
          cursor.color4,
          "JyAgeD0n",
          lookup[cursor.x + 3],
          "JyAgeT0n",
          lookup[cursor.y],
          "JyAgIC8+"
        )
      );
  }

  /*
    Blend colors, inspired by https://stackoverflow.com/a/12016968
    */
  // NOTE: Magic code to blend RGBA values as base64 color
  function blendColors(Color memory fg, Color memory bg)
    internal
    pure
    returns (string memory)
  {
    uint256 alpha = uint16(fg.alpha + 1);
    uint256 inv_alpha = uint16(256 - fg.alpha);
    return
      uintToHexString6(
        uint24((alpha * fg.blue + inv_alpha * bg.blue) >> 8) +
          (uint24((alpha * fg.green + inv_alpha * bg.green) >> 8) << 8) +
          (uint24((alpha * fg.red + inv_alpha * bg.red) >> 8) << 16)
      );
  }

  // NOTE: Split DNA into 13 pieces of 4 digits integers
  function splitNumber(uint256 _number)
    internal
    pure
    returns (uint16[NUM_LAYERS] memory numbers)
  {
    for (uint256 i = 0; i < numbers.length; i++) {
      numbers[i] = uint16(_number % 10000);
      _number >>= 14;
    }
    return numbers;
  }

  // NOTE: Below are helper functions to convert data types

  function uintToHexDigit(uint8 d) public pure returns (bytes1) {
    if (0 <= d && d <= 9) {
      return bytes1(uint8(bytes1("0")) + d);
    } else if (10 <= uint8(d) && uint8(d) <= 15) {
      return bytes1(uint8(bytes1("a")) + d - 10);
    }
    revert();
  }

  /*
    Convert uint to hex string, padding to 6 hex nibbles
    */
  function uintToHexString6(uint256 a) public pure returns (string memory) {
    string memory str = uintToHexString2(a);
    if (bytes(str).length == 2) {
      return string(abi.encodePacked("0000", str));
    } else if (bytes(str).length == 3) {
      return string(abi.encodePacked("000", str));
    } else if (bytes(str).length == 4) {
      return string(abi.encodePacked("00", str));
    } else if (bytes(str).length == 5) {
      return string(abi.encodePacked("0", str));
    }
    return str;
  }

  /*
    Convert uint to hex string, padding to 2 hex nibbles
    */
  function uintToHexString2(uint256 a) public pure returns (string memory) {
    uint256 count = 0;
    uint256 b = a;
    while (b != 0) {
      count++;
      b /= 16;
    }
    bytes memory res = new bytes(count);
    for (uint256 i = 0; i < count; ++i) {
      b = a % 16;
      res[count - i - 1] = uintToHexDigit(uint8(b));
      a /= 16;
    }

    string memory str = string(res);
    if (bytes(str).length == 0) {
      return "00";
    } else if (bytes(str).length == 1) {
      return string(abi.encodePacked("0", str));
    }
    return str;
  }

  /*
    Convert uint to byte string, padding number string with spaces at end.
    Useful to ensure result's length is a multiple of 3, and therefore base64 encoding won't
    result in '=' padding chars.
    */
  function uintToByteString(uint256 a, uint256 fixedLen)
    internal
    pure
    returns (bytes memory _uintAsString)
  {
    uint256 j = a;
    uint256 len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(fixedLen);
    j = fixedLen;
    if (a == 0) {
      bstr[0] = "0";
      len = 1;
    }
    while (j > len) {
      j = j - 1;
      bstr[j] = bytes1(" ");
    }
    uint256 k = len;
    while (a != 0) {
      k = k - 1;
      uint8 temp = (48 + uint8(a - (a / 10) * 10));
      bytes1 b1 = bytes1(temp);
      bstr[k] = b1;
      a /= 10;
    }
    return bstr;
  }

  function byteToUint(bytes1 b) public pure returns (uint256) {
    return uint256(uint8(b));
  }

  function byteToHexString(bytes1 b) public pure returns (string memory) {
    return uintToHexString2(byteToUint(b));
  }
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
  bytes internal constant TABLE =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  /// @notice Encodes some bytes to the base64 representation
  function encode(bytes memory data) internal pure returns (string memory) {
    uint256 len = data.length;
    if (len == 0) return "";

    // multiply by 4/3 rounded up
    uint256 encodedLen = 4 * ((len + 2) / 3);

    // Add some extra buffer at the end
    bytes memory result = new bytes(encodedLen + 32);

    bytes memory table = TABLE;

    assembly {
      let tablePtr := add(table, 1)
      let resultPtr := add(result, 32)

      for {
        let i := 0
      } lt(i, len) {

      } {
        i := add(i, 3)
        let input := and(mload(add(data, i)), 0xffffff)

        let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
        out := shl(8, out)
        out := add(
          out,
          and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
        )
        out := shl(8, out)
        out := add(
          out,
          and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
        )
        out := shl(8, out)
        out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
        out := shl(224, out)

        mstore(resultPtr, out)

        resultPtr := add(resultPtr, 4)
      }

      switch mod(len, 3)
      case 1 {
        mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
      }
      case 2 {
        mstore(sub(resultPtr, 1), shl(248, 0x3d))
      }

      mstore(result, encodedLen)
    }

    return string(result);
  }
}
