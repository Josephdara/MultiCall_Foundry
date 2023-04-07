// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MultiCallPro.sol";


contract MultiCallProTest is Test {
    MultiCallProOne public multiCallProOne;
    MultiCallProTwo public multiCallProTwo;
    Joes public joes;
    address alice;
    address bob;
    address vick;

    /// @dev Explain to a developer any extra details
    function setUp() public {
        alice = vm.addr(1);
        bob = vm.addr(2);
        vick = vm.addr(3);
        alice.call{value: 1 * 10 **18}("");
        bob.call{value: 1 * 10 **18}("");
        vm.startPrank(alice);
      multiCallProOne = new MultiCallProOne();
      multiCallProTwo = new MultiCallProTwo();
      joes = new Joes();  
      vm.stopPrank();

     
    }

    function testBalances() public {
        assertEq(vick.balance, 0);
        assertEq(alice.balance, 1 ether);
        assertEq(joes.balanceOf(bob), 0); 
        assertEq(joes.balanceOf(alice), 45_000 * 10 **18);        
    }

    function testFoobar() public {
        vm.startPrank(bob);
        multiCallProOne.foobar{value:2000000000000901}(address(multiCallProTwo), vick, 2000000000000000);
        vm.stopPrank();
        console.log(vick.balance);
        assertEq(address(multiCallProOne).balance, 901);
        assertEq(vick.balance, 2 * 10 **15);
        assertEq(bob.balance, 997999999999999099);
    }

    function testfuzz_tokencall () public {
        vm.startPrank(alice);
        joes.approve(address(multiCallProTwo), 10000 * 10 **18);
        multiCallProTwo.fuzz(8520 * 10 **18, vick, address(joes));
        vm.stopPrank();
        assertEq(joes.balanceOf(vick), 8_520 * 10 **18);
        assertEq(joes.balanceOf(alice), 36_480 * 10 **18);
    }

    function testbarfuzz () public {
        vm.startPrank(alice);
        multiCallProTwo.barfuzz{value: 21000}(address(joes), 21_000);
        assertEq(address(joes).balance, 21000);
        assertEq(joes.fallbackCalled(), 1);
    }


   
}
