# from https://github.com/Misterio77/nix-colors@b92df8f
{ lib, globals }:

with builtins;
let
	hexToDecMap = {
		"0" = 0;
		"1" = 1;
		"2" = 2;
		"3" = 3;
		"4" = 4;
		"5" = 5;
		"6" = 6;
		"7" = 7;
		"8" = 8;
		"9" = 9;
		"a" = 10;
		"b" = 11;
		"c" = 12;
		"d" = 13;
		"e" = 14;
		"f" = 15;
	};

	pow = base: exp:
		if exp > 1 then
			let
				x = pow base (exp / 2);
				oddp = (lib.mod exp 2) == 1;
			in
				x * x * (if oddp then base else 1)
		else if exp == 1 then
			base
		else if exp == 0 then
			1
		else
			throw "undefined";

	base16To10 = exp: scl: scl * pow 16 exp;

	hexCharToDec = hex:
		let
			lower = lib.toLower hex;
		in
			if hexToDecMap ? ${lower} then
				hexToDecMap.${lower}
			else
				throw "Character '${hex}' is not a hexadecimal value.";
in rec {
	hexToDec = hex:
		let
			dec = map hexCharToDec (lib.stringToCharacters hex);
			decAsc = lib.reverseList dec;
			decPow = lib.imap0 base16To10 decAsc;
		in
			lib.foldl add 0 decPow;

	hexToRGB = hex:
		let
			rgbStartIdx = [ 0 2 4 ];
			hexList = map (x: substring x 2 hex) rgbStartIdx;
		in
			map hexToDec hexList;

	hexToFloatRGB = hex: map (x: x / 255.0) (hexToRGB hex);

	RGBConcat = rgb: sep: lib.concatMapStringsSep sep toString rgb;
}
