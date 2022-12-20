// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Drop.sol";

contract GenerativeArt is ERC721Drop {
    string public script;
    mapping(uint256 => bytes32) public tokenToHash;
    mapping(bytes32 => uint256) public hashToToken;

    function setScript(string calldata _script) public onlyOwner {
        script = _script;
    }

    function _mintGenerative(address _to, uint256 _startTokenId, uint256 _qty) internal virtual {
        for (uint256 i = 0; i < _qty; i++) {
            uint256 _id = _startTokenId + i;
            bytes32 mintHash = keccak256(abi.encodePacked(_id, blockhash(block.number -1), _to));

            tokenToHash[_id] = mintHash;
            hashToToken[mintHash] = _id;
        }
    }

    function _transferTokensOnClaim(address _to, uint256 _quantityBeingClaimed) internal virtual override returns (uint256 startTokenId) {
        startTokenId = _currentIndex;
        _mintGenerative(_to, startTokenId, _quantityBeingClaimed);
        _safeMint(_to, _quantityBeingClaimed);
    }

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient,
        string memory _script
    )
        ERC721Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {
        script = _script;
    }
}
