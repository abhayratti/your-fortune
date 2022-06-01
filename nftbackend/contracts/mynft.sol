// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1; 

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol"; 

import { Base64 } from "./libraries/base64.sol";

// inherit the openzeppelin contract to get access to it's methods
contract MyNFT is ERC721URIStorage {
    // openzepplin to help keep track of token ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["NextWeek", "Tomorrow", "2MonthsFromNow", "NextMonth", "2HoursFromNow", "TheNext45Mins", "TheNextYear", "Today", "ThisYear", "ThisWeek", "ThisSunday", "ThisMonday", "ThisTuesday", "ThisWednesday", "ThisThursday", "ThisFriday", "ThisSaturday"];
    string[] secondWords = ["WillBe"];
    string[] thirdWords = ["Incredible", "Joyous", "Amazing", "Rough", "FullOfGrowth", "Frustrating", "Awesome", "Enjoyable", "Interesting...", "Bad", "SuperFortunate", "Mysterious", "Intriguing"];

    string[] colors = ["purple", "green", "black", "orange", "blue", "yellow", "pink", "red"];

    event NewNFTMinted(address sender, uint256 tokenId);

    // name + symbol of nft token
    constructor () ERC721 ("Your Fortune", "TRUTH") {
        console.log("The truth, only the truth, nothing but the truth");
    }

    // randomly pick word from arrays
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Second_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
 
    // function for user to get nft
    function mintNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory randomColor = pickRandomColor(newItemId);

        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // title of nft:
                        combinedWord,
                        '", "description": "The truth, only the truth, nothing but the truth", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log("NFT w/ ID %s has been minted to: %s", newItemId, msg.sender);
    }
}