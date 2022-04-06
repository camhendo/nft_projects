//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import 'base64-sol/base64.sol';

contract Egg is ERC721URIStorage, Ownable {
    
    uint256 public tokenCounter;
    bool public mintLive;
    
    mapping(uint256 => string) public tokenIdToEgg;
    mapping(uint256 => address) public tokenIdToOwner;

    
    event NewEgg(uint256 indexed tokenId);

    constructor() ERC721('EggNFT','EGG') {
        tokenCounter = 0;
        mintLive = true;
    }

    function withdraw() public payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function isItEasterYet(bool pause) public onlyOwner {
        if (pause == true) {
            mintLive = false;
        } else if (pause == false) {
            mintLive = true;
        }
    }

    function mintEgg() public payable {
        require(mintLive == true, 'minting is not live right now');
        require(msg.value >= 12 ether, 'minting costs 12 matic!');
        uint256 tokenId = tokenCounter;
        uint256 baseR = uint256(keccak256(abi.encodePacked(tokenId,msg.sender)));
        tokenCounter = tokenCounter + 1;
        tokenIdToOwner[tokenId] = msg.sender;
        _safeMint(msg.sender, tokenId);
        makeEgg(tokenId, baseR);
        payable(owner()).transfer(msg.value);
        emit NewEgg(tokenId);
    }

    struct Eggo {
        uint8[5] choices;
        string[6] atts;
        string svg;
    }

    mapping(uint => Eggo) public eggo;

    function makeEgg(uint256 _tokenId, uint256 _baseR) private {
        Eggo storage egg = eggo[0];        
        (egg.svg, egg.choices, egg.atts) = svgComponents.getVars(_baseR);
        getBody();
        delete eggo[0].choices;
        egg.svg = string(abi.encodePacked('data:image/svg+xml;base64,',Base64.encode(bytes(abi.encodePacked(eggo[0].svg)))));
        string memory eggURI = getJson(_tokenId);
        tokenIdToEgg[_tokenId] = eggURI;
        _setTokenURI(_tokenId, eggURI);
    }

    function getJson(uint256 _tokenId) private returns (string memory) { 
        string memory baseURL = 'data:application/json;base64,';
        string memory name = string(abi.encodePacked('{"name": "egg #',uint2str(_tokenId),'",'));
        string memory tokenURI = string(abi.encodePacked(
                            name,
                            '"description": "Make eggs, dont break them. Get your own egg, hide it for a loved one, throw one at a friend. Images are randomly generated then built in SVG and will be stored forever on-chain.",',
                            '"attributes":[{"Colors":"',eggo[0].atts[0],'", "Pattern":"',eggo[0].atts[1],'","Bottom Design":"',eggo[0].atts[2],'","Middle Design":"',eggo[0].atts[3],'","Top Design":"',eggo[0].atts[4],'","Golden Egg":"',eggo[0].atts[5],'"}],',
                            '"image":"',eggo[0].svg,'"}'
                        ));
        delete eggo[0];
        return string(
            abi.encodePacked(
                baseURL,
                Base64.encode(
                    bytes(tokenURI)
                )
            )
        );
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
    function addString(string memory s, string memory n1, string memory n2, string memory n3) private pure returns (string memory str) { 
        str = string(abi.encodePacked(s,n1,n2,n3));
    }

    function getBody() private {
        getUse();
        if (eggo[0].choices[4] == 1) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<text class="base" letter-spacing="10" font-size="28px"><path id="cr" fill="none" stroke="none" d="M 145 250 a 280 130 0 0 0 280 -10"/><textPath href="#cr">golden egg</textPath></text>'));
        }
        eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<rect mask="url(#mask)" height="100%" width="100%" class="bck"/></svg>'));
    }

    function getUse() private {
        {
            string memory pU = '<rect x="0" y="0" width="100%" height="100%"';
            if (eggo[0].choices[0] == 0) {
                pU = string(abi.encodePacked(pU,' transform="rotate(10)" fill="url(#p1)"></rect>'));
                eggo[0].svg = string(abi.encodePacked(eggo[0].svg,pU));
            } else if (eggo[0].choices[0] == 1) {
                eggo[0].svg= string(abi.encodePacked(eggo[0].svg,pU,' fill="url(#p2)"></rect>'));
            } else if (eggo[0].choices[0] == 2) {
                eggo[0].svg= string(abi.encodePacked(eggo[0].svg,pU,' transform="rotate(10)" fill="url(#p3)"></rect>'));
            } else if (eggo[0].choices[0] == 3) {
                if (eggo[0].choices[3] < 5) {
                    eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#dw2" transform-origin="center" transform="translate(-100,30) rotate(-70)"/>'));
                } else {
                    eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#dw2" transform-origin="center" transform="scale(1.4) translate(0,-90)"/>'));
                }
            } else if (eggo[0].choices[0] == 4) {
                string[10] memory wavs = ['40','42','44','46','48','50','52','54','56','58'];
                for (uint i = 0; i<10; i++) {
                    eggo[0].svg = addString(eggo[0].svg,'<use x="-100" y="-',wavs[i],'0px" class="s2" stroke-width="5" fill="none" transform="scale(1.8)rotate(85)" href="#wav"/>');
                }
            } else if (eggo[0].choices[0] == 5) {
                eggo[0].svg= string(abi.encodePacked(eggo[0].svg,pU,' transform="rotate(10)" fill="url(#p4)"></rect>'));
            } else if (eggo[0].choices[0] == 6) {
                eggo[0].svg= string(abi.encodePacked(eggo[0].svg,pU,' transform="rotate(10)" fill="url(#p5)"></rect>'));
            }
            if (eggo[0].choices[0] != 4 && eggo[0].choices[0] != 5 && eggo[0].choices[0] != 6) {
                db();
                dm();
                dt();
            }
        }
    }

    function db() private {
        if (eggo[0].choices[1] == 0) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d1" y="-30" class="s1"/><use href="#d1" y="20" class="s2"/>'));
        } else if (eggo[0].choices[1] == 1) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d2" x="30" y="100" class="s1" transform="scale(1.3)" transform-origin="center"/><use href="#d2" x="30" y="100" class="s1" transform="scale(-1.3,1.3)" transform-origin="center"/>'));
        } else if (eggo[0].choices[1] == 2) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d3" x="-470" y="-600" class="b" transform="rotate(180)"/>'));
        } else if (eggo[0].choices[1] == 3) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#wav" x="-50" y="-40" class="s1" stroke-width="10" fill="none" transform="scale(1.2)"/>'));
        } else if (eggo[0].choices[1] == 4) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d5" x="-80" y="110" class="b" transform="scale(1.2) rotate(-8) skewX(-10)" transform-origin="center"/><use href="#d5" x="80" y="110" class="b" transform="scale(1.2) rotate(8) skewX(10)" transform-origin="center"/>'));
        }
    }

    function dm() private {
        if (eggo[0].choices[2] == 0) {
            eggo[0].svg =string(abi.encodePacked(eggo[0].svg,'<use href="#d1" y="-100" class="s1" transform="scale(.9,.7)" transform-origin="center"/><use href="#d1" y="-160" class="s2" transform="scale(.9,.7)" transform-origin="center"/>'));
        } else if (eggo[0].choices[2] == 1) {
            eggo[0].svg =string(abi.encodePacked(eggo[0].svg,'<use href="#d2" x="30" y="-30" class="s1" transform="scale(1.3)" transform-origin="center"/><use href="#d2" x="30" y="30" class="s2" transform="scale(-1.3,1.3)" transform-origin="center"/>'));
        } else if (eggo[0].choices[2] == 2) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use x="80" y="-100" class="m" transform="scale(0.8)" href="#d3"/>'));
        } else if (eggo[0].choices[2] == 3) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#wav" x="-45" y="-150" class="s2" stroke-width="20" fill="none" transform="scale(1.2)"/>'));
        } else if (eggo[0].choices[2] == 4) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d5" x="-135" y="-8" class="m" transform="rotate(12) skewX(-10)" transform-origin="center"/><use href="#d5" y="-20" class="m" transform="scale(1,1.1)" transform-origin="center"/><use href="#d5" x="135" y="-8" class="m" transform="rotate(-12) skewX(10)" transform-origin="center"/>'));
        }
    }

    function dt() private {
        if (eggo[0].choices[3] == 0) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d1" y="-300" class="s2" transform="scale(.9,.7)" transform-origin="center"/><use href="#d1" y="-360" class="s1" transform="scale(.9,.7)" transform-origin="center"/>'));
        } else if (eggo[0].choices[3] == 1) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d2" x="30" y="-100" class="s2" transform="scale(1.5)" transform-origin="center"/><use href="#d2" x="30" y="-100" class="s1" transform="scale(-1.5,1.5)" transform-origin="center"/>'));
        } else if (eggo[0].choices[3] == 2) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use x="-510" y="-50" class="t" transform="rotate(-90)" href="#d3"/><use x="50" y="-550" class="t" transform="rotate(90)" href="#d3"/>'));
        } else if (eggo[0].choices[3] == 3) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#wav" x="25" y="-250" class="s1" stroke-width="5" fill="none" transform="scale(.9)"/>'));
        } else if (eggo[0].choices[3] == 4) {
            eggo[0].svg = string(abi.encodePacked(eggo[0].svg,'<use href="#d5" y="-265" class="t" transform="scale(1.4,.8)" transform-origin="center"/>'));
        } 
    }
}


library svgComponents {

    function getVars(uint256 _baseR) external pure returns (string memory svg, uint8[5] memory choices, string[6] memory atts ) {
        string[18] memory eggColors = ['#E0BBE4','#957DAD','#D291BC','#FFDFD3','#FF9AA2','#ADD3FA','#FAFAD5','#77B3B5','#BFDEA4','#FFE4A1','#6CBB7A','#ED8C79','#6CCCC9','#F6BF85','#3284C2','#C56E90','#FFF6CC','#FFC2E2'];
        string[6] memory styles = ['b','s1','m','s2','t','bck'];
        svg = '<svg xmlns="http://www.w3.org/2000/svg" version="1.2" width="500px" height="500px"><style>';
        string[5] memory locs = ['260','320','380','440','500'];
        string[2] memory colors;
        string[2] memory color;
        for (uint i = 0; i < 6; i++) {
            uint256 tempNum = uint256(keccak256(abi.encodePacked(_baseR,i)));
            if (i%2 == 0 || i == 5) {
                svg = string(abi.encodePacked(svg,'.',styles[i],'{ fill:',eggColors[tempNum % 18],'}'));
            } else {
                svg = string(abi.encodePacked(svg,'.',styles[i],'{ stroke:',eggColors[tempNum % 18],'}'));
            }
            if (i == 2) {
                color[0] = eggColors[tempNum%18];
                colors[0] = string(abi.encodePacked('<radialGradient id="gd" cx="0.54" cy="0.75" fx="0.60" fy="0.80" spreadMethod="pad"><stop offset="0%" stop-color="',eggColors[(tempNum+1)%18]));
            } else if (i == 3) {
                color[1] = eggColors[tempNum%18];
                colors[0] = string(abi.encodePacked(colors[0],'"/><stop offset="100%" stop-color="',eggColors[(tempNum+1)%18],'"/></radialGradient>'));
            }
            if (i < 4) {
                colors[1] = string(abi.encodePacked(colors[1],'"/><path d="M100 ',locs[i],'a500 300 0 0 0 600 0" stroke="',eggColors[tempNum % 18]));
            } else if (i==4) {
                colors[1] = string(abi.encodePacked(colors[1],'"/><path d="M100 ',locs[i],'a500 300 0 0 0 600 0" stroke="',eggColors[tempNum % 18],'"'));
            }
        }
        svg = string(abi.encodePacked(svg,getDefs(colors)));
        uint8 gg;
        if (_baseR % 1000000 == 1) {
            gg = 1;
        } else {
            gg = 0;
        }
        choices = [uint8(_baseR % 14), uint8(_baseR % 6), uint8(_baseR % 5), uint8(_baseR % 7), gg];
        atts = getAtts(choices,color);
    }

    function getDefs(string[2] memory colors) private pure returns (string memory svg) {
        string memory g = '</style><defs><g id="d1" stroke-width="15" fill="none" ><path d="M 80 350 a340 350 0 0 0 340 0"/></g><g id="d2" stroke-width="8" fill="none"><path d="M100 250 c60 40,80 40,140 0 s100 20, 120 20 s90 -40, 100 -40"/></g><g id="d3"><path d="M 100 150 a250 450 0 0 0 250 0"/></g><g id="wav"><path d="M100 332 c10 30,20 30,40 0 s20 60,40 40 s20 -65,40 -5 s20 -75,50 -5 s20 -75,55 -8 s20 -90,60 -5 s20 -200,20 0"/></g><g id="d5" stroke="none"><polygon points="250 200,285 310,190 245,310 245,215 310"/></g>';
        string memory patterns = '<pattern id="p1" x="0" y="0" patternUnits="userSpaceOnUse" width="80" height="40" viewBox="0 0 80 40"><path stroke-width="5" fill="none" class="s2" d="M0 0 l40 40 l40 -40"></path></pattern><pattern id="p2" x="0" y="0" patternUnits="userSpaceOnUse" width="500" height="40" viewBox="0 0 500 40"><path stroke-width="5" fill="none" class="s1" d="M0 0 a500 350 0 0 0 500 0"/></pattern><pattern id="p3" x="0" y="0" patternUnits="userSpaceOnUse" width="500" height="80" viewBox="0 0 500 40"><path stroke-width="15" fill="none" class="s1" d="M0 0 a500 350 0 0 0 500 0"/></pattern><g id="wav"><path d="M100 332 c10 30,20 30,40 0 s20 60,40 40 s20 -65,40 -5 s20 -75,50 -5 s20 -75,55 -8 s20 -90,60 -5 s20 -200,20 0"/></g><pattern id="p4" x="0" y="126" patternUnits="userSpaceOnUse" width="126" height="200" viewBox="0 0 10 16"><g id="cube"><path class="b" d="M0 0 l5 3v5 l-5 -3z"></path><path class="t" d="M10 0 l-5 3v5l5 -3"></path></g><use x="5" y="8" href="#cube"></use><use x="-5" y="8" href="#cube"></use></pattern><pattern id="p5" x="0" y="0" patternUnits="userSpaceOnUse" width="100" height="72" viewBox="0 0 320 100" class="b"><text font-size="72px" font-weight="900" x="0" y="0">this is egg</text><text font-size="72px" font-weight="900" x="0" y="76">this is egg</text><text font-size="72px" font-weight="900" x="0" y="152">this is egg</text><text font-size="72px" font-weight="900" x="0" y="152">this is egg</text></pattern>';
        string memory gPat = string(abi.encodePacked('<g id="dw2" stroke-width="60" fill="none"><path d="M 100 200 a500 300 0 0 0 600 0" class="s1',colors[1],'/></g>'));
        string memory grad = string(abi.encodePacked(colors[0],'<mask id="mask"><rect width="100%" height="100%" fill="white"/><path d="M105 300 C 100 500, 400 500, 395 300C 380 -40, 120 -40, 105 300" fill="black"/></mask></defs><rect width="100%" height="100%" fill="url(#gd)"/>'));
        svg = string(abi.encodePacked(g,patterns,gPat,grad));
    }

    function getAtts(uint8[5] memory choices, string[2] memory colors) private pure returns (string[6] memory atts) {
        atts[0] = string(abi.encodePacked(colors[0],colors[1]));
        if (choices[0] == 0) {     
            atts[1] = "Triangle";
        } else if (choices[0] == 1) {
            atts[1] = "Tiger";
        } else if (choices[0] == 2) {
            atts[1] = "Swirly";
        } else if (choices[0] == 3) {
            atts[1] = "Rainbow";
        } else if (choices[0] == 4) {
            atts[1] = "Wavy";
        } else if (choices[0] == 5) {
            atts[1] = "Cube";
        } else if (choices[0] == 6) {
            atts[1] = "This Is Egg";
        } else if (choices[0] > 6) {
            atts[1] = "None";
        }
        uint8 x = 2;
        for (uint i = 1; i < 4; i++) {
            if (choices[i] == 0) {
                atts[x] = 'Line';
            } else if (choices[i] == 1) {
                atts[x] = 'Wave';
            } else if (choices[i] == 2) {
                atts[x] = 'Circle';
            } else if (choices[i] == 3) {
                atts[x] = 'Squiggle';
            } else if (choices[i] == 4) {
                atts[x] = 'Star';
            } else if (choices[i] > 4) {
                atts[x] = 'None';
            }
            x++;
        }
        if (choices[4] == 1) {
            atts[5] = 'Yes';
        } else {
            atts[5] = 'No';
        }
    }
}
