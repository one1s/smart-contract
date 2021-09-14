pragma solidity ^0.5.12;

import "./zombieHelper.sol";

contract ZombieAttack is ZombieHelper{
    
    uint randNonce = 0;
    uint public attackVictoryProbability = 30;
    uint public attackeFee = 0;
    uint public a_float_point = 10**7;
    
    function randMod(uint _modulus) internal returns(uint){
        randNonce++;
        return uint(keccak256(abi.encodePacked(now,msg.sender,randNonce))) % _modulus;
    }
    
    function setAttackVictoryProbability(uint _attackVictoryProbability)public onlyOwner{
        attackVictoryProbability = _attackVictoryProbability;
    }
    
    function attack(uint _zombieId,uint _targetId)external onlyOwnerOf(_zombieId) payable returns(uint){
        require(msg.sender != zombieToOwner[_targetId],'The target zombie is yours!');
        require(msg.value * a_float_point >= attackeFee);
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie),'Your zombie is not ready!');
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);
        if(rand<=attackVictoryProbability){
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            multiply(_zombieId,enemyZombie.dna);
            return _zombieId;
        }else{
            myZombie.lossCount++;
            enemyZombie.winCount++;
            _triggerCooldown(myZombie);
            return _targetId;
        }
    }
    
    function setAttackFee(uint value)  onlyOwner public{
        attackeFee = value;
    }
    function setFloatPoint(uint value) onlyOwner public{
        a_float_point = value;
    }
    
    
}