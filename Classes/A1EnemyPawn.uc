class A1EnemyPawn extends UTPawn;

var A1EnemyPawn this; //Reference to pawn that was hit
var A1Pawn that; //Reference to original instigator

//Save Default Values
var float _defaultGroundSpeed;
var float _defaultFireRate;
/////////////////////

//FrostEffect Variables
var bool FrostBeenHit;
var bool FrostEffect;
var int FrostStacks;
var float FrostDuration;
var float FrostBeginTime;
var float FrostTimer;
///////////////////////

//FireEffect Variables/
var bool FireBeenHit;
var bool FireEffect;
var bool FireTick;
var int FireStacks;
var float FireDamage;
var float FireProjectileDmg;
var float FireDmgMulti;
var float FireDuration;
var float FireTimer;
var float FireAltTimer;
var float FireAltCount;
var float FireBeginTime;
///////////////////////

//Lightning Variables///
var Rotator _rotator;
var float LDM;
var Vector Hitloc;
////////////////////////



simulated event PostBeginPlay(){
	super.PostBeginPlay();
	_defaultGroundSpeed = GroundSpeed;
	self.Tick(WorldInfo.DeltaSeconds);
}

/**
 * Upgrade Functions
**/
//this function randomizes the upgrades
function decideUpgrade(){
	if(A1Weapon(self.Weapon) != None){
		A1Weapon(self.Weapon).FireInterval[0] = 0.25;
		rateUpgrade(A1Game(WorldInfo.Game).activeChamberIndex);
		dmgUpgrade(A1Game(WorldInfo.Game).activeChamberIndex);
		RWE(4);
	}
	hltUpgrade(A1Game(WorldInfo.Game).activeChamberIndex);
	moveUpgrade(A1Game(WorldInfo.Game).activeChamberIndex);
}

/** Upgrade Functions **/
//Upgrade Weapon Fire Rate increase by 5% per chamber
function rateUpgrade(int amt){
	local float percentage;
	local int count;
	
	percentage = 0.05;	
	percentage = 1 - percentage;

	for(count = 0;count < amt;count++){
		A1Weapon(self.Weapon).FireInterval[0] = FMax(0.1, A1Weapon(self.Weapon).FireInterval[0] * percentage);
	}	

	if(A1Weapon(self.Weapon).FireInterval[0] < 0.10){
		A1Weapon(self.Weapon).FireInterval[0] = 0.10;		
	}

	A1Weapon(self.Weapon).FireInterval[1] = A1Weapon(self.Weapon).FireInterval[0];

	//Save Upgrade
	_defaultFireRate = A1Weapon(self.Weapon).FireInterval[0];
}

//Upgrade Weapon Damage increase by 5% per chamber
function dmgUpgrade(int amt){
	local float percentage;
	percentage = 0.05;

	A1Weapon(self.Weapon).DamageMultiplier = (1 + (percentage*amt));
}

//Weapon Effect Randomizer For AI
function RWE(int x){
	local int rn;

	rn = rand(x);
	A1Weapon(self.Weapon).setMode(rn);
}

//Upgrade Pawn Health increase by 20% per chamber
function hltUpgrade(int amt){
	local float percentage;
	percentage = 0.20;
	Health *= (1 + percentage*amt);
}

//Upgrade Move Speed
function moveUpgrade(int amt){
	local float percentage;
	percentage = 0.05;
	GroundSpeed *= (1 + (percentage*amt));
}

//Frost FUNCTIONS/////////////////////////////////////////////////////////////////////////////
function _FrostDebuff(bool hit, A1EnemyPawn _self){
	this = _self;
	this.FrostBeenHit = hit;
	this.FrostEffect = true;
}

function moveDowngrade(int amt){
	local float percentage;
	local int count;
	local float _temp;
	percentage = 0.05;
	
	_temp = _defaultGroundSpeed;
	for(count = 0; count < amt; count++){
		_temp *= (1 - percentage);
	}
	GroundSpeed = _temp;
}

function rateDowngrade(int amt){
	local float percentage;
	local int count;
	local float _temp;
	percentage = 0.08;
	_temp = _defaultFireRate;
	
	for(count = 0; count < amt; count++){
			_temp *= (1 + percentage);
	}

	A1Weapon(self.Weapon).FireInterval[0] = _defaultFireRate * (1 + _temp);
	A1Weapon(self.Weapon).FireInterval[1] = A1Weapon(self.Weapon).FireInterval[0];
	this.FireRateChanged(); //Update FireRate Changes (Prevents Fire Hold Abuse)
}
//////////////////////////////////////////////////////////////////////////////////////////////
//FIRE FUNCTIONS//////////////////////////////////////////////////////////////////////////////
function _FireDebuff(bool hit, A1EnemyPawn _Enemy, float DmgMulti,int ProjDmg){
	this = _Enemy;
	this.FireBeenHit = hit;
	this.FireEffect = true;
	this.FireDmgMulti = DmgMulti;
	this.FireProjectileDmg = ProjDmg;
}
//////////////////////////////////////////////////////////////////////////////////////////////
//LIGHTNING FUNCTIONS/////////////////////////////////////////////////////////////////////////
function _LightningEffect(A1EnemyPawn _Enemy, A1Pawn _self,Vector HitLocation, Rotator _dir, float LightningDmgMulti){
	//local Projectile SpawnedProjectile;
	this = _Enemy;
	that = _self;
	this._rotator = _dir;
	this.LDM = LightningDmgMulti;
	this.Hitloc = HitLocation;
	this.ProjectileFire();
}

simulated function Projectile ProjectileFire()
{
	local Projectile	SpawnedProjectile;

	// tell remote clients that we fired, to trigger effects
	//IncrementFlashCount();
    if(that != this){
		if( Role == ROLE_Authority )
		{
			// Spawn projectile
			SpawnedProjectile = Spawn(class'A1LightningProjectile',,, this.Location,this._rotator,,);
			SpawnedProjectile.Instigator = that;		

			if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
			{
				SpawnedProjectile.Init(Vector(this._rotator));
			}		

			if ( SpawnedProjectile != None)
			{
				SpawnedProjectile.Damage *= (LDM * 0.70);
			}

			// Return it up the line
			return SpawnedProjectile;
		}
	}

	return None;

}


//DEBUFF Duration
event Tick( float DeltaTime ){
	if(this != None){
		/**============================================================================**/
		/**===============================FROST EFFECT LOGIC===========================**/
		/**============================================================================**/
		//Do if FrostEffect
		if(this.FrostEffect){
			this.FrostTimer += DeltaTime;

			//Resets The Timer If Hit
			if(this.FrostBeenHit && this.FrostStacks >= 5){
				this.FrostTimer = DeltaTime;
				this.FrostBeenHit = false;
			}

			if(this.FrostStacks <= 5 && this.FrostBeenHit){
				this.FrostStacks++;

				this.moveDowngrade(this.FrostStacks);
				this.rateDowngrade(this.FrostStacks);

				this.FrostBeginTime = DeltaTime;
				this.FrostTimer = DeltaTime;
				this.FrostBeenHit = false;
			}
			
			//Check Timer
			if(this.FrostTimer - this.FrostBeginTime >= this.FrostDuration && this.FrostStacks > 0){
				this.FrostEffect = false;
				this.FrostBeginTime = 0.0f;
				this.FrostTimer = 0.0f;
				//Reset Defaults
				this.FrostStacks = 0;
				this.GroundSpeed = this._defaultGroundSpeed;
				A1Weapon(this.Weapon).FireInterval[0] = this._defaultFireRate;
				A1Weapon(this.Weapon).FireInterval[1] = this._defaultFireRate;
				this.FireRateChanged();
			}
		}
		/**============================================================================**/
		/**==============================FIRE EFFECT LOGIC=============================**/
		/**============================================================================**/
		//Do Fire Effect
		if(this.FireEffect){
			this.FireTimer += DeltaTime;
			this.FireAltTimer += DeltaTime;
			
			if(!FireTick){
				this.FireAltCount = DeltaTime;
				this.FireTick = true;
			}

			//Resets The Timer If Hit
			if(this.FireBeenHit && this.FireStacks >= 5){
				this.FireTimer = DeltaTime;
				this.FireBeginTime = DeltaTime;
				this.FireBeenHit = false;
			}

			if(this.FireStacks <= 5 && this.FireBeenHit){
				this.FireStacks++;

				//FOR PLAYER
				if(this.Controller.Class != class'A1Player'){
					this.FireDamage = ((this.FireProjectileDmg + this.FireStacks) * this.FireDmgMulti)/FireDuration;
				}
				else{
					`log(this.FireDmgMulti);
					this.FireDamage = (this.FireProjectileDmg + this.FireStacks) /FireDuration;//fix scaling
				}

				this.FireBeginTime = DeltaTime;
				this.FireTimer = DeltaTime;
				this.FireBeenHit = false;
			}

			//DO DAMAGE
			if(this.FireAltTimer - this.FireAltCount >= 1 && this.FireStacks > 0){
				if(this.Health - this.FireDamage >= 0){
					this.Health -= this.FireDamage;
				}
				else{
					this.Health = 1;
				}
				this.FireAltTimer = DeltaTime;
				this.FireAltCount = DeltaTime;
				this.FireTick = false;
			}

			//Check Timer
			if(this.FireTimer - this.FireBeginTime >= this.FireDuration && this.FireStacks > 0){
				this.FireEffect = false;
				this.FireBeginTime = 0.0f;
				this.FireTimer = 0.0f;
				this.FireDamage = 0.0f;
				this.FireAltTimer = 0.0f;
				this.FireStacks = 0;
				this.FireAltCount = 0.0f;
			}
		}
	}
}


Defaultproperties
{
	ControllerClass=class'A1EnemyBot'
	_defaultFireRate = 0.25

	//====Frost Defaults=====//
	FrostEffect = false
	FrostStacks = 0
	FrostDuration = 5
	FrostBeginTime = 0.0f
	FrostBeenHit = false
	//=======================//

	//====Fire Defaults======//
	FireEffect = false
	FireStacks = 0
	FireDuration = 2
	FireBeginTime = 0.0f
	FireBeenHit = false
	FireDamage = 0.0f
	FireAltCount = 0.0f
	FireTick = false
	//=======================//
}