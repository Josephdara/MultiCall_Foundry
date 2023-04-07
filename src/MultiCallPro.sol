// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/// @title MultiCallProOne
/// @author Josephdara.eth
contract MultiCallProOne{

/// @notice Struct to Store User interactions
     struct Caller{
        address sender;
        uint value;
    }

///@notice Mapping from a uint to the Caller struct
    mapping (uint => Caller) public called;
 
///@dev This function uses the abi.encodeWithSelector to select the function to CALL with the first four bytes of the keccak256 hash referencing the function
///@param _addy address of the target contract
///@param to address to receive the _value of native token
///@param _value Value of native token to be sent IN WEI
    function foobar(address _addy, address to, uint _value) public payable {
        ( bool s, ) = _addy.call{value: _value}(abi.encodeWithSelector(bytes4(keccak256("barfuzz(address,uint256)")), to, _value));
        require(s);
        called[3] = Caller(msg.sender, msg.value);
    }   
   
}




/// @title MultiCallProTwo
/// @author Josephdara.eth

contract MultiCallProTwo {
    
 /// @notice Struct to Store User interactions
     struct Caller{
        address sender;
        uint value;
    }

///@notice Mapping from a uint to the Caller struct
    mapping (uint => Caller) public called;


///@dev This function uses the abi.encodeWithSignature to CALL a function, taking in the function name and argument types as a string, then we pass the argument variables
///@param amount Amount of ERC20 tokens to transfer
///@notice TOKEN DECIMALS must be multiplied to amount
///@param to Address we are transferring tokens to
///@param token Token Contract Address

    function fuzz( uint amount, address to, address token) public {
      (bool s2, ) =  token.call(abi.encodeWithSignature("transferFrom(address,address,uint256)",msg.sender, to , amount));
      require(s2);
      called[1] = Caller(msg.sender, amount);
    }

///@dev This function sends eth from the address/transaction to the address specified
///@param to Receiver Address
///@param _value Amont of eth tobe sent to the receiver address
    function barfuzz(address to, uint _value) public payable {
        (bool s, ) = payable(to).call{value: _value}("");
        require(s);
         called[2] = Caller(msg.sender, msg.value);
    }

}

/// @title Joes
/// @author Josephdara.eth
/// @notice Simple ERC20 Token Smart Contract (OpenZeppelin's implementation)
/// @notice minting is restricted to deployer only, State variable to count number of times fallback is called
contract Joes is ERC20 {

    address deployerr;
    uint public  fallbackCalled;
    uint constant INITIAL_SUPPLY = 45_000;
    constructor () ERC20("JOES", "JS"){
        _mint(msg.sender, INITIAL_SUPPLY * 10 ** decimals());
        deployerr = msg.sender;
    }

    function mint (address destination, uint256 amount) public {
        require(msg.sender == deployerr);
        _mint(destination, amount);
    }

    fallback () external payable {
        fallbackCalled++;
    }
}




