// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Snack_Point {
    address payable public owner;
    uint rand = 0;
    string[] public Iteams;
    uint TotalTransactions = 0;
    mapping (uint => uint) public TotalQuantity;
    mapping (uint => uint) public ItemToPrice;
    mapping (uint => address payable) public Users;
    modifier onlyOnwer() {
        require( msg.sender == owner);
        _;
    }
    using SafeMath for uint;
    constructor() {
        owner = payable(msg.sender);
        Iteams.push("Hot-Coffee");
        Iteams.push("Cold-Coffee");
        Iteams.push("Tea");
        Iteams.push("Black-Tea");
        for (uint i = 0; i < 4; i++) {
            TotalQuantity[i] = 5;
        }
        ItemToPrice[0] = 2;
        ItemToPrice[1] = 2;
        ItemToPrice[2] = 2;
        ItemToPrice[3] = 2;
    }

    function GetReFill(uint _Index, uint _Quantity) public onlyOnwer {
        TotalQuantity[_Index] = TotalQuantity[_Index].add(_Quantity);
    }

    function GetBalance() public onlyOnwer view returns(uint) {
        return owner.balance;
    }

    function SelectItems(uint _Index, uint amt) public payable {
        require(ItemToPrice[_Index] <= amt,"Insufficient Funds!");
        require(TotalQuantity[_Index] >=1,"Item, Not available!");
        TotalQuantity[_Index] = TotalQuantity[_Index].sub(1);
        recieve();
        Users[TotalTransactions] = payable(msg.sender);
        TotalTransactions++;
    }

    function recieve() public payable {
        owner.transfer(2);
    }

    function RandomNumberGenerator(uint _modulus) public returns (uint) {
        rand++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, rand))) % _modulus;
    }

    function LuckyWinner() public onlyOnwer {
        uint _index = RandomNumberGenerator(TotalTransactions);
        require(GetBalance() >= 2 ether,"Low Balance!");
        Users[_index].transfer(2 ether);
    }
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
}
