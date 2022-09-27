// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/***My Notes***/
/*One environment is "JavaScript Virtual Machine" 
 *so this means that we are able to deploy our smart contract 
 *not into the real blockchain network
 */

/*Selecting "Injected Web3" enviroment here, remix ide browser connects to metamask wallet
 *Testnet or Mainnet
 */

//The code of this smart contract cannot be changed after it is deployed.

/*The larger the smart contract, the more variables can be used, 
 *which means more memory usage. 
 *The transaction fee is high.
 */

contract FeeCollector {
    //Events
    event EtherSent(address from, uint amount);
    event EtherTransfered(address destinationAddress, uint amount);

    //State Variables
    //"Public" is visibility
    address public immutable owner;
    uint public totalBalance;
    mapping(address => uint) public balances;

    //Special Function
    constructor() {
        //Person which calls - "msg.sender"
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw");
        _;
    }

    modifier minEtherAmount() {
        require(msg.value >= 0.001*10**18, "Insufficient ether");
        _;
    }

    receive() payable external  minEtherAmount() {
        //How much ether was sent to the smart contract  - "msg.value"
        
        //Local variables
        address account = msg.sender;
        uint value = msg.value;

        totalBalance += value;
        balances[account] = value;

        emit EtherSent(account, value);
    }

    //"Public" means everybody can call it
    /*function withdraw(uint amount, address payable destinationAddress) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= totalBalance, "Insufficient funds");
        destinationAddress.transfer(amount);
        totalBalance -= amount;

    }*/

    function withdraw(address payable destinationAddress) public onlyOwner {
        //Local variables
        uint amount = balances[destinationAddress];

        destinationAddress.transfer(amount);
        totalBalance -= amount;

        emit EtherTransfered(destinationAddress, amount);
    }
}
