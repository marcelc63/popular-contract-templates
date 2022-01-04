// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.6;

/**
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBB#RROOOOOOOOOOOOOOORR#BBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBROOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZOORBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BB#ROOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZORB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B#ROOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZORB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@BBRRROOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZO#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@B#RRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZRB@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@B#RRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOB@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@B#RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOB@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@B#RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZRB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@B###RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ#@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@BB####RRRRRRRROOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZO@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@BB#####RRRRRRRROOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOB@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@BB######RRRRRRRROOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZO#@@@@@@@@@@@@@@@
@@@@@@@@@@@@BBB######RRRRRRRROOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZO#@@@@@@@@@@@@@@
@@@@@@@@@@@BBBBB#####RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZR@@@@@@@@@@@@@
@@@@@@@@@@BBBBBB#####RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZO#@@@@@@@@@@@@
@@@@@@@@@BBBBBBB#####RRRRRRRRROOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOB@@@@@@@@@@@
@@@@@@@@BBBBBBBB######RRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOB@@@@@@@@@@
@@@@@@@@BBBBBBBBB#####RRRRRRRRROOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOR@@@@@@@@@@
@@@@@@@BBBBBBBBBB######RRRRRRRROOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOB@@@@@@@@@
@@@@@@@BBBBBBBBBBB#####RRRRRRRRROOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOR@@@@@@@@@
@@@@@@@BBBBBBBBBBB######RRRRRRRRROOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOB@@@@@@@@
@@@@@@BBBBBBBBBBBBB######RRRRRRRRROOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOB@@@@@@@@
@@@@@@BBBBBBBBBBBBBB######RRRRRRRRROOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOOO#@@@@@@@@
@@@@@@BBBBBBBBBBBBBBB######RRRRRRRRROOOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOOOOO#@@@@@@@@
@@@@@@BBBBBBBBBBBBBBB######RRRRRRRRRROOOOOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOOOOOOOR@@@@@@@@
@@@@@@BBBBBBBBBBBBBBBB#######RRRRRRRRRROOOOOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOOOOOOOOOO#@@@@@@@@
@@@@@@BBBBBBBBBBBBBBBBB#######RRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZOOOOOOOOOOOOOOOOOOOO#@@@@@@@@
@@@@@@BBBBBBBBBBBBBBBBBBB######RRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOZZZZZZZZZZZZZZZZZZZZOOOOOOOOOOOOOOOOOOOOOOOOORB@@@@@@@@
@@@@@@BBBBBBBBBBBBBBBBBBBB#######RRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORB@@@@@@@@
@@@@@@@BBBBBBBBBBBBBBBBBBBBB#######RRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORRRR@@@@@@@@@
@@@@@@@BBBBBBBBBBBBBBBBBBBBBB########RRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORRRRRB@@@@@@@@@
@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBB########RRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORRRRRRR#@@@@@@@@@@
@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBB########RRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORRRRRRRRRRB@@@@@@@@@@
@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBB########RRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOORRRRRRRRRRRRRRB@@@@@@@@@@@
@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBB#########RRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOOOOOOOORRRRRRRRRRRRRRRRRR##@@@@@@@@@@@@
@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBB#########RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR###B@@@@@@@@@@@@
@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB###########RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR######B@@@@@@@@@@@@@
@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#############RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR########BB@@@@@@@@@@@@@@
@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB###############RRRRRRRRRRRRRRRRRRRRRRRRRRR#############BB@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#################################################BBB@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#######################################BBBBBBB@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB########################BBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BBBBBBBBBBBBBBBBBBBBBBBBBBBB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*/

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/// Color lib is a custom library for handling the math functions required to generate the gradient step colors
/// Originally written in javascript, this is a solidity port.
library ColorLib {
  struct HSL {
    uint256 h;
    uint256 s;
    uint256 l;
  }

  /// Lookup table for cubicinout range 0-99
  function cubicInOut(uint16 p) internal pure returns (int256) {
    if (p < 13) {
      return 0;
    }
    if (p < 17) {
      return 1;
    }
    if (p < 19) {
      return 2;
    }
    if (p < 21) {
      return 3;
    }
    if (p < 23) {
      return 4;
    }
    if (p < 24) {
      return 5;
    }
    if (p < 25) {
      return 6;
    }
    if (p < 27) {
      return 7;
    }
    if (p < 28) {
      return 8;
    }
    if (p < 29) {
      return 9;
    }
    if (p < 30) {
      return 10;
    }
    if (p < 31) {
      return 11;
    }
    if (p < 32) {
      return 13;
    }
    if (p < 33) {
      return 14;
    }
    if (p < 34) {
      return 15;
    }
    if (p < 35) {
      return 17;
    }
    if (p < 36) {
      return 18;
    }
    if (p < 37) {
      return 20;
    }
    if (p < 38) {
      return 21;
    }
    if (p < 39) {
      return 23;
    }
    if (p < 40) {
      return 25;
    }
    if (p < 41) {
      return 27;
    }
    if (p < 42) {
      return 29;
    }
    if (p < 43) {
      return 31;
    }
    if (p < 44) {
      return 34;
    }
    if (p < 45) {
      return 36;
    }
    if (p < 46) {
      return 38;
    }
    if (p < 47) {
      return 41;
    }
    if (p < 48) {
      return 44;
    }
    if (p < 49) {
      return 47;
    }
    if (p < 50) {
      return 50;
    }
    if (p < 51) {
      return 52;
    }
    if (p < 52) {
      return 55;
    }
    if (p < 53) {
      return 58;
    }
    if (p < 54) {
      return 61;
    }
    if (p < 55) {
      return 63;
    }
    if (p < 56) {
      return 65;
    }
    if (p < 57) {
      return 68;
    }
    if (p < 58) {
      return 70;
    }
    if (p < 59) {
      return 72;
    }
    if (p < 60) {
      return 74;
    }
    if (p < 61) {
      return 76;
    }
    if (p < 62) {
      return 78;
    }
    if (p < 63) {
      return 79;
    }
    if (p < 64) {
      return 81;
    }
    if (p < 65) {
      return 82;
    }
    if (p < 66) {
      return 84;
    }
    if (p < 67) {
      return 85;
    }
    if (p < 68) {
      return 86;
    }
    if (p < 69) {
      return 88;
    }
    if (p < 70) {
      return 89;
    }
    if (p < 71) {
      return 90;
    }
    if (p < 72) {
      return 91;
    }
    if (p < 74) {
      return 92;
    }
    if (p < 75) {
      return 93;
    }
    if (p < 76) {
      return 94;
    }
    if (p < 78) {
      return 95;
    }
    if (p < 80) {
      return 96;
    }
    if (p < 82) {
      return 97;
    }
    if (p < 86) {
      return 98;
    }
    return 99;
  }

  /// Lookup table for cubicid range 0-99
  function cubicIn(uint256 p) internal pure returns (uint8) {
    if (p < 22) {
      return 0;
    }
    if (p < 28) {
      return 1;
    }
    if (p < 32) {
      return 2;
    }
    if (p < 32) {
      return 3;
    }
    if (p < 34) {
      return 3;
    }
    if (p < 36) {
      return 4;
    }
    if (p < 39) {
      return 5;
    }
    if (p < 41) {
      return 6;
    }
    if (p < 43) {
      return 7;
    }
    if (p < 46) {
      return 9;
    }
    if (p < 47) {
      return 10;
    }
    if (p < 49) {
      return 11;
    }
    if (p < 50) {
      return 12;
    }
    if (p < 51) {
      return 13;
    }
    if (p < 53) {
      return 14;
    }
    if (p < 54) {
      return 15;
    }
    if (p < 55) {
      return 16;
    }
    if (p < 56) {
      return 17;
    }
    if (p < 57) {
      return 18;
    }
    if (p < 58) {
      return 19;
    }
    if (p < 59) {
      return 20;
    }
    if (p < 60) {
      return 21;
    }
    if (p < 61) {
      return 22;
    }
    if (p < 62) {
      return 23;
    }
    if (p < 63) {
      return 25;
    }
    if (p < 64) {
      return 26;
    }
    if (p < 65) {
      return 27;
    }
    if (p < 66) {
      return 28;
    }
    if (p < 67) {
      return 30;
    }
    if (p < 68) {
      return 31;
    }
    if (p < 69) {
      return 32;
    }
    if (p < 70) {
      return 34;
    }
    if (p < 71) {
      return 35;
    }
    if (p < 72) {
      return 37;
    }
    if (p < 73) {
      return 38;
    }
    if (p < 74) {
      return 40;
    }
    if (p < 75) {
      return 42;
    }
    if (p < 76) {
      return 43;
    }
    if (p < 77) {
      return 45;
    }
    if (p < 78) {
      return 47;
    }
    if (p < 79) {
      return 49;
    }
    if (p < 80) {
      return 51;
    }
    if (p < 81) {
      return 53;
    }
    if (p < 82) {
      return 55;
    }
    if (p < 83) {
      return 57;
    }
    if (p < 84) {
      return 59;
    }
    if (p < 85) {
      return 61;
    }
    if (p < 86) {
      return 63;
    }
    if (p < 87) {
      return 65;
    }
    if (p < 88) {
      return 68;
    }
    if (p < 89) {
      return 70;
    }
    if (p < 90) {
      return 72;
    }
    if (p < 91) {
      return 75;
    }
    if (p < 92) {
      return 77;
    }
    if (p < 93) {
      return 80;
    }
    if (p < 94) {
      return 83;
    }
    if (p < 95) {
      return 85;
    }
    if (p < 96) {
      return 88;
    }
    if (p < 97) {
      return 91;
    }
    if (p < 98) {
      return 94;
    }
    return 97;
  }

  /// Lookup table for quintin range 0-99
  function quintIn(uint256 p) internal pure returns (uint8) {
    if (p < 39) {
      return 0;
    }
    if (p < 45) {
      return 1;
    }
    if (p < 49) {
      return 2;
    }
    if (p < 52) {
      return 3;
    }
    if (p < 53) {
      return 4;
    }
    if (p < 54) {
      return 4;
    }
    if (p < 55) {
      return 5;
    }
    if (p < 56) {
      return 5;
    }
    if (p < 57) {
      return 6;
    }
    if (p < 58) {
      return 6;
    }
    if (p < 59) {
      return 7;
    }
    if (p < 60) {
      return 7;
    }
    if (p < 61) {
      return 8;
    }
    if (p < 62) {
      return 9;
    }
    if (p < 63) {
      return 9;
    }
    if (p < 64) {
      return 10;
    }
    if (p < 65) {
      return 11;
    }
    if (p < 66) {
      return 12;
    }
    if (p < 67) {
      return 13;
    }
    if (p < 68) {
      return 14;
    }
    if (p < 69) {
      return 15;
    }
    if (p < 70) {
      return 16;
    }
    if (p < 71) {
      return 18;
    }
    if (p < 72) {
      return 19;
    }
    if (p < 73) {
      return 20;
    }
    if (p < 74) {
      return 22;
    }
    if (p < 75) {
      return 23;
    }
    if (p < 76) {
      return 25;
    }
    if (p < 77) {
      return 27;
    }
    if (p < 78) {
      return 28;
    }
    if (p < 79) {
      return 30;
    }
    if (p < 80) {
      return 32;
    }
    if (p < 81) {
      return 34;
    }
    if (p < 82) {
      return 37;
    }
    if (p < 83) {
      return 39;
    }
    if (p < 84) {
      return 41;
    }
    if (p < 85) {
      return 44;
    }
    if (p < 86) {
      return 47;
    }
    if (p < 87) {
      return 49;
    }
    if (p < 88) {
      return 52;
    }
    if (p < 89) {
      return 55;
    }
    if (p < 90) {
      return 59;
    }
    if (p < 91) {
      return 62;
    }
    if (p < 92) {
      return 65;
    }
    if (p < 93) {
      return 69;
    }
    if (p < 94) {
      return 73;
    }
    if (p < 95) {
      return 77;
    }
    if (p < 96) {
      return 81;
    }
    if (p < 97) {
      return 85;
    }
    if (p < 98) {
      return 90;
    }
    return 95;
  }

  // Util for keeping hue range in 0-360 positive
  function clampHue(int256 h) internal pure returns (uint256) {
    unchecked {
      h /= 100;
      if (h >= 0) {
        return uint256(h) % 360;
      } else {
        return (uint256(-1 * h) % 360);
      }
    }
  }

  /// find hue within range
  function lerpHue(
    uint8 optionNum,
    uint256 direction,
    uint256 uhue,
    uint8 pct
  ) internal pure returns (uint256) {
    // unchecked {
    uint256 option = optionNum % 4;
    int256 hue = int256(uhue);

    if (option == 0) {
      return
        clampHue(
          (((100 - int256(uint256(pct))) * hue) +
            (int256(uint256(pct)) * (direction == 0 ? hue - 10 : hue + 10)))
        );
    }
    if (option == 1) {
      return
        clampHue(
          (((100 - int256(uint256(pct))) * hue) +
            (int256(uint256(pct)) * (direction == 0 ? hue - 30 : hue + 30)))
        );
    }
    if (option == 2) {
      return
        clampHue(
          (
            (((100 - cubicInOut(pct)) * hue) +
              (cubicInOut(pct) * (direction == 0 ? hue - 50 : hue + 50)))
          )
        );
    }

    return
      clampHue(
        ((100 - cubicInOut(pct)) * hue) +
          (cubicInOut(pct) *
            int256(
              hue +
                ((direction == 0 ? int256(-60) : int256(60)) *
                  int256(uint256(optionNum > 128 ? 1 : 0))) +
                30
            ))
      );
    // }
  }

  /// find lightness within range
  function lerpLightness(
    uint8 optionNum,
    uint256 start,
    uint256 end,
    uint256 pct
  ) internal pure returns (uint256) {
    uint256 lerpPercent;
    if (optionNum == 0) {
      lerpPercent = quintIn(pct);
    } else {
      lerpPercent = cubicIn(pct);
    }
    return 1 + (((100.0 - lerpPercent) * start + (lerpPercent * end)) / 100);
  }

  /// find saturation within range
  function lerpSaturation(
    uint8 optionNum,
    uint256 start,
    uint256 end,
    uint256 pct
  ) internal pure returns (uint256) {
    unchecked {
      uint256 lerpPercent;
      if (optionNum == 0) {
        lerpPercent = quintIn(pct);
        return 1 + (((100.0 - lerpPercent) * start + lerpPercent * end) / 100);
      }
      lerpPercent = pct;
      return ((100.0 - lerpPercent) * start + lerpPercent * end) / 100;
    }
  }

  /// encode a color string
  function encodeStr(
    uint256 h,
    uint256 s,
    uint256 l
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        "hsl(",
        Strings.toString(h),
        ", ",
        Strings.toString(s),
        "%, ",
        Strings.toString(l),
        "%)"
      );
  }

  /// get gradient color strings for the given addresss
  function gradientForAddress(address addr)
    internal
    pure
    returns (bytes[5] memory)
  {
    unchecked {
      bytes32 addrBytes = bytes32(uint256(uint160(addr)));
      uint256 startHue = (uint256(uint8(addrBytes[31 - 12])) * 24) / 17; // 255 - 360
      uint256 startLightness = (uint256(uint8(addrBytes[31 - 2])) * 5) /
        34 +
        32; // 255 => 37.5 + 32 (32, 69.5)
      uint256 endLightness = 97;
      endLightness += (((uint256(uint8(addrBytes[31 - 8])) * 5) / 51) + 72); // 72-97
      endLightness /= 2;

      uint256 startSaturation = uint256(uint8(addrBytes[31 - 7])) / 16 + 81; // 0-16 + 72

      uint256 endSaturation = uint256(uint8(addrBytes[31 - 10]) * 11) /
        128 +
        70; // 0-22 + 70
      if (endSaturation > startSaturation - 10) {
        endSaturation = startSaturation - 10;
      }

      return [
        // 0
        encodeStr(
          lerpHue(
            uint8(addrBytes[31 - 3]),
            uint8(addrBytes[31 - 6]) % 2,
            startHue,
            0
          ),
          lerpSaturation(
            uint8(addrBytes[31 - 3]) % 2,
            startSaturation,
            endSaturation,
            100
          ),
          lerpLightness(
            uint8(addrBytes[31 - 5]) % 2,
            startLightness,
            endLightness,
            100
          )
        ),
        // 1
        encodeStr(
          lerpHue(
            uint8(addrBytes[31 - 3]),
            uint8(addrBytes[31 - 6]) % 2,
            startHue,
            10
          ),
          lerpSaturation(
            uint8(addrBytes[31 - 3]) % 2,
            startSaturation,
            endSaturation,
            90
          ),
          lerpLightness(
            uint8(addrBytes[31 - 5]) % 2,
            startLightness,
            endLightness,
            90
          )
        ),
        // 2
        encodeStr(
          lerpHue(
            uint8(addrBytes[31 - 3]),
            uint8(addrBytes[31 - 6]) % 2,
            startHue,
            70
          ),
          lerpSaturation(
            uint8(addrBytes[31 - 3]) % 2,
            startSaturation,
            endSaturation,
            70
          ),
          lerpLightness(
            uint8(addrBytes[31 - 5]) % 2,
            startLightness,
            endLightness,
            70
          )
        ),
        // 3
        encodeStr(
          lerpHue(
            uint8(addrBytes[31 - 3]),
            uint8(addrBytes[31 - 6]) % 2,
            startHue,
            90
          ),
          lerpSaturation(
            uint8(addrBytes[31 - 3]) % 2,
            startSaturation,
            endSaturation,
            20
          ),
          lerpLightness(
            uint8(addrBytes[31 - 5]) % 2,
            startLightness,
            endLightness,
            20
          )
        ),
        // 4
        encodeStr(
          lerpHue(
            uint8(addrBytes[31 - 3]),
            uint8(addrBytes[31 - 6]) % 2,
            startHue,
            100
          ),
          lerpSaturation(
            uint8(addrBytes[31 - 3]) % 2,
            startSaturation,
            endSaturation,
            0
          ),
          startLightness
        )
      ];
    }
  }
}
