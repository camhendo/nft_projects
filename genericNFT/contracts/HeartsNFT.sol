//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import 'base64-sol/base64.sol';

contract HeartsNFT is ERC721URIStorage, Ownable {
    
    uint256 public tokenCounter;
    bool public mintLive;
    
    mapping(uint256 => string) public tokenIdToSaying;
    mapping(uint256 => address) public tokenIdToOwner;
    
    event NewHeartCreated(uint256 indexed tokenId);

    constructor() ERC721('ValentinesNFT','URHOT') {
        tokenCounter = 0;
        mintLive = true;
    }

    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function isItValengthtinesYet(bool pause) external onlyOwner {
        if (pause == true) {
            mintLive = false;
        } else if (pause == false) {
            mintLive = true;
        }
    }

    function mintHeart(string memory word) external payable {
        require(bytes(word).length <= 19, 'max characters is 19');
        require(mintLive == true, 'minting is not live right now');
        require(msg.value >= 21400000000000000 wei, 'minting costs 0.0214 eth!');
        uint256 tokenId = tokenCounter;
        tokenCounter = tokenCounter + 1;
        tokenIdToSaying[tokenId] = word;
        tokenIdToOwner[tokenId] = msg.sender;
        address creator = msg.sender;
        _safeMint(msg.sender, tokenId);
        makeHeart(tokenId, word, creator);
        payable(owner()).transfer(msg.value);
        emit NewHeartCreated(tokenId);
    }

    function makeHeart(uint256 _tokenId, string memory _word, address creator) private {
        uint256 baseRandom = uint256(keccak256(abi.encodePacked(_tokenId,creator)));
        string[4] memory colorArray = getVars(baseRandom);
        string memory imageURI = heartToImageURI(_word, colorArray);
        string memory heartURI = getJson(imageURI,_tokenId, colorArray[0],colorArray[1],colorArray[2]);
        _setTokenURI(_tokenId, heartURI);
    }


    function getVars(uint256 _baseRandom) private pure returns (string[4] memory colorArray) {
        string[10] memory bkgColorArr = ['#FFBFDF','#FF3562','#FFDE2A','#DF0000','#645FFF','#FF6AD3','#CC55FF','#FF4A59','#FFD4DC','#CFB4FF'];
        string[8] memory bkgHeartArr = ['pink','#E8345B','#6A15FF','#FFD13F','#D400D1','#AA0017','#FF8A8D','#F40044'];
        string[7] memory frtHeartArr = ['red','#B71818','#FFF035','#7FC7FF','#FF94EB','#FF74C2','#FF1F26'];
        string[5] memory fntColorArr = ['black','#1300E9','#FBFF15','#8A00E9','#FFFFFF'];
        string memory bckColor = bkgColorArr[(_baseRandom % bkgColorArr.length)];
        string memory bckHeart = bkgHeartArr[(_baseRandom % bkgHeartArr.length)];
        string memory frtHeart = frtHeartArr[(_baseRandom % frtHeartArr.length)];
        uint256 one = _baseRandom % frtHeartArr.length;
        uint256 two = _baseRandom % fntColorArr.length;
        string memory fntColor;
        if (one == two) {
                fntColor = fntColorArr[0];
        }
        fntColor = fntColorArr[(_baseRandom % fntColorArr.length)];
        colorArray = [bckColor,bckHeart,frtHeart,fntColor];
    }

    function heartToImageURI(string memory _word, string[4] memory colorArray) private pure returns (string memory imageURI) {
        string memory fontsize;
        if (bytes(_word).length > 9) { //determine font size
            fontsize = string(abi.encodePacked('font-size: 14px;'));
        } else {
            fontsize = string(abi.encodePacked('font-size: 26px;'));
        }
        string memory oneSVG = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" version="1.1" height="325" width="325" viewBox="0 0 325 325"> <rect width="100%" height="100%" fill="',colorArray[0],'"/>'));
        string memory twoSVG = string(abi.encodePacked('<style>#d{fill:',colorArray[3],'; text-anchor:middle; transform-origin:bottom left; font-family: monospace;'));
        string memory threeSVG = string(abi.encodePacked('animation: beat 1.45s infinite; white-space: pre; -moz-user-select: none; -khtml-user-select: none; -webkit-user-select: none; -ms-user-select: none; user-select: none;}#h, #h2 {transform-origin: bottom left; animation: beat 1.45s infinite} @keyframes beat {0% {transform: scale(1.0);} 20% {transform: scale(1.2);} 40% {transform: scale(1.15);} 60% {transform: scale(1.2);} 80% {transform: scale(1.2);} 100% {transform: scale(1.0);}}</style>'));
        string memory fourSVG = string(abi.encodePacked('<defs><g id="h"><path d="M50 160 l95 125 l95 -125 a45 50, 35, 0,0 -95,-45 a45,50 -35 0,0 -95,45 z"/></g><g id="h2"><path d="M65 160 l88 115 l88 -115 a40 45, 35, 0,0 -88,-45 a40,45 -35 0,0 -88,45 z"/></g></defs>')); 
        string memory fiveSVG = string(abi.encodePacked('<use href="#h" class="heart" fill="',colorArray[1],'"> </use>','<use href="#h2" class="heart" fill="',colorArray[2]));
        string memory sixSVG = string(abi.encodePacked('"></use>','<text id="d" class="base" x="150px" y="160">',_word,'</text></svg>'));
        string memory partHeartOne = combiner(oneSVG,twoSVG,fontsize);
        string memory partHeartTwo = combiner(threeSVG,fourSVG,fiveSVG);
        string memory finalHeart = combiner(partHeartOne,partHeartTwo,sixSVG);
        imageURI = string(abi.encodePacked('data:image/svg+xml;base64,',Base64.encode(bytes(abi.encodePacked(finalHeart)))));
    }

    function getJson(string memory _heartURI, uint256 _tokenId, string memory _bckColor, string memory _bckHeart, string memory _frtHeart) private pure returns (string memory) { 
        string memory baseURL = 'data:application/json;base64,';
        string memory name = string(abi.encodePacked('{"name": "Heart 4 U #',uint2str(_tokenId),'",'));
        string memory tokenURI = string(abi.encodePacked(
                            name,
                            '"description": "Make hearts, dont break them. Get your own heart, send it to a loved one. Images are SVG and will be stored forever on-chain.",',
                            '"attributes":[{"Background":"',_bckColor,'", "Back Heart":"',_bckHeart,'","Front Heart":"',_frtHeart,'"}],',
                            '"image_data":"',_heartURI,'"}'
                        ));
        return string(
            abi.encodePacked(
                baseURL,
                Base64.encode(
                    bytes(tokenURI)
                )
            )
        );
    }
    function combiner(string memory one, string memory two, string memory three) private pure returns (string memory) {
        return string(abi.encodePacked(one,two,three));
    }

    function uint2str(uint _i) private pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

}