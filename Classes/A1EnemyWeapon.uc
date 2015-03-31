class A1EnemyWeapon extends UTWeap_LinkGun;

var A1Game GameInfo;
var float DamageMultiplier;
var int _ProjMode;
var A1Projectile latestProjectile;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
	FireInterval[0] = GameInfo.FireInterval;
	DamageMultiplier = GameInfo.DamageMultiplier;
}


//OVERRIDE weapon drop
function DropFrom(vector StartLocation, vector StartVelocity);

function setMode(int i){
	_ProjMode = i;
}

DefaultProperties
{
	WeaponFireTypes(0)=EWFT_Projectile
	FireInterval(0)=0.25
	FireInterval(1)=0.25
	ShotCost(0)=0
	ShotCost(1)=0
	DamageMultiplier = 1
}
