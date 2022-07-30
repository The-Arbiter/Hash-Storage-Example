// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/HashStore.sol";

contract HashStoreTest is Test {

    HashStore hashStore; 

    function setUp() public {
        hashStore = new HashStore();
    }

    function testHashStoreAndCompare() public {
            
            address a = address(1);

            address b = address(2);

            address[] memory c = new address[](5);
            c[0] = address(3);
            c[1] = address(4);
            c[2] = address(5);
            c[3] = address(6);
            c[4] = address(7);

            uint256[] memory d = new uint256[](5);
            d[0] = 1 ether;
            d[1] = 10 ether; 
            d[2] = 100 ether; 
            d[3] = 1000 ether; 
            d[4] = 10000 ether; 

            uint64 e = 69420;

            for(uint256 i=0; i<1000; ++i){
                e++;
                
                // STORE THE HASH (About 25000 gas)

                bytes32 storedHash = hashStore.storeStructAsHash(a,b,c,d,e);
                //string memory storedHashString = string(abi.encodePacked(storedHash));
                //console2.log("Stored hash is",storedHashString);

                bytes32 recalculatedHash = keccak256(abi.encodePacked(a,b,c,d,e));
                //string memory recalculatedHashString = string(abi.encodePacked(recalculatedHash));
                //console2.log("Recalculated hash is",recalculatedHashString);

                assertTrue(storedHash == recalculatedHash);

                // TRY AND VALIDATE IT (About 2750 gas)

                bool hashValidity = hashStore.validateHash(i,a,b,c,d,e);
                assertTrue(hashValidity);

                // TRY AND FAIL VALIDATION (About 3750 gas)
                vm.expectRevert(HashStore.IncorrectHash.selector);
                hashValidity = hashStore.validateHash(i+1,a,b,c,d,e);

            }
            
    }

   
}
