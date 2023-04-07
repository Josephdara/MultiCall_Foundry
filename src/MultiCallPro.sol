// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract MultiCallProOne{
     struct Caller{
        address sender;
        uint value;
    }

    mapping (uint => Caller) public called;
 
    function foobar(address _addy, address to, uint _value) public payable {
        ( bool s, ) = _addy.call{value: _value}(abi.encodeWithSelector(bytes4(keccak256("barfuzz(address,uint256)")), to, _value));
        require(s);
        called[3] = Caller(msg.sender, msg.value);
    }   
   
}

contract MultiCallProTwo {
     struct Caller{
        address sender;
        uint value;
    }

    mapping (uint => Caller) public called;
    function fuzz( uint amount, address to, address token) public {
      (bool s2, ) =  token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",msg.sender, to , amount));
      require(s2);
      called[1] = Caller(msg.sender, amount);
    }
    function barfuzz(address to, uint _value) public payable {
        (bool s, ) = payable(to).call{value: _value}("");
        require(s);
         called[2] = Caller(msg.sender, msg.value);
    }

}
contract Joes is ERC20 {

    address deployerr;
    uint public  fallbackCalled;
    uint constant INITIAL_SUPPLY = 45_000;
    constructor () ERC20("JOES", "JS"){
        _mint(msg.sender, INITIAL_SUPPLY * 10 ** decimals());
        deployerr = msg.sender;
    }

    function mint (address destination, uint256 amount) public {
        _mint(destination, amount);
    }

    fallback () external payable {
        fallbackCalled++;
    }
}




