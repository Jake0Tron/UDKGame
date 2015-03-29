class A1EnemyBot extends UTBot;

simulated event PostBeginPlay(){
	super.PostBeginPlay();
	//decideUpgrade();
}

/** Adjusts AI Stats*/
function decideUpgrade(){	
	accuracyIncrease(Randomize(10));
	aggressiveIncrease(Randomize(10));
	strafIncrease(Randomize(10));
	cbtIncrease(Randomize(10));
	jmpIncrease(Randomize(10));
}
	
/** All Upgrades to Bots*/

//Increase Accuracy
function accuracyIncrease(float times){
	Accuracy = (times * 0.1);
	if(Accuracy > 1){
		Accuracy = 1;
	}
	if(Accuracy < -1){
		Accuracy = 0;
	}
}

//Increase Aggressiveness
function aggressiveIncrease(float times){
	BaseAggressiveness = (times * 0.2);
	if(BaseAggressiveness > 1){
		BaseAggressiveness = 1;
	}
	if(BaseAggressiveness < 0){
		BaseAggressiveness = 0.5;
	}
}

//Increase Strafing
function strafIncrease(float times){
	StrafingAbility = (times * 0.3);
	if(StrafingAbility > 1){
		StrafingAbility = 1;
	}
	if(StrafingAbility < -1){
		StrafingAbility = 0;
	}
}

//Increase Combat
function cbtIncrease(float times){
	CombatStyle = (times * 0.4);
	if(CombatStyle > 1){
		CombatStyle = 1;
	}
	if(CombatStyle < -1){
		CombatStyle = 0;
	}
}


//Increase Jump
function jmpIncrease(float times){
	Jumpiness = (times * 0.5);
	if(Jumpiness > 1){
		Jumpiness = 1;
	}
	if(Jumpiness < 0 ){
		Jumpiness = 0;
	}
}

/** Randomize number*/
function float Randomize(int num){
	return ((Rand(num) - Rand(num)) + 1);
}

state Dead
{
Begin:
  destroy() ;
}



DefaultProperties{
	Accuracy = 1			// -1 to 1 (0 is default, higher is more accurate)
	BaseAggressiveness = 0.75  // 0 to 1 (0.3 default, higher is more aggressive)
	StrafingAbility = 0.5	// -1 to 1 (higher uses strafing more)
	CombatStyle = 0.5		// -1 to 1 = low means tends to stay off and snipe, high means tends to charge and melee
	Jumpiness = 0.25		// 0 to 1
}

