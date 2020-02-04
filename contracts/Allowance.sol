pragma solidity ^0.5.13;

import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract Allowance is Ownable{
    using SafeMath for uint;
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    mapping (address => uint) public allowance;
    
    function setAllownce (address _who, uint _amount) public onlyOwner{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
       allowance[_who]= _amount;
    }
    
    modifier ownerOrAllowed(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }
    
    function reduceAllowance (address _who, uint _amount) internal ownerOrAllowed(_amount){
         emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
         allowance[_who]= allowance[_who].sub(_amount);
    }
     function() payable external {
        emit MoneyReceived(msg.sender, msg.value);
        }

    
    function renounceOwnership()public onlyOwner{
        revert ("Can't revert ownership here");
    }
    
   
}