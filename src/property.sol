// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Assets is ERC1155, Ownable {
    constructor() ERC1155("") {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount)
        public
        onlyOwner
    {
        bytes memory _data = new bytes(4);
        _data[0] = 0x48;
        _data[1] = 0x65;
        _data[2] = 0x6C;
        _data[3] = 0x6C;
        
        _mint(account, id, amount, _data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }
}