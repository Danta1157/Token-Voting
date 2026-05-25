// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        owner = msg.sender;

        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function mint(address _to, uint256 _amount) public OnlyOwner {
        _mint(_to, _amount);        
    }
}