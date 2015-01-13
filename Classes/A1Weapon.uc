class A1Weapon extends UTWeap_LinkGun;

var float DamageMultiplier;
var int _ProjMode;
var A1Projectile latestProjectile;

var A1Game GameInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
	FireInterval[0] = GameInfo.FireInterval;
	DamageMultiplier = GameInfo.DamageMultiplier;

}

simulated function Projectile ProjectileFire()
{
	latestProjectile = A1Projectile(super.ProjectileFire());

	if ( latestProjectile != None)
	{
		LatestProjectile.Damage *= DamageMultiplier;
	}
	
	return LatestProjectile;
}

//OVERRIDE
function DropFrom(vector StartLocation, vector StartVelocity);

//OVERRIDE
function class<Projectile> GetProjectileClass(){
	return WeaponProjectiles[_ProjMode]; 
}

function setMode(int i){
	_ProjMode = i;
}

DefaultProperties
{
	_ProjMode = 0
	WeaponProjectiles[0] = class'A1DefaultProjectile'
	WeaponProjectiles[1] = class'A1FrostProjectile'
	WeaponProjectiles[2] = class'A1FireProjectile'
	WeaponProjectiles[3] = class'A1LightningProjectile'
	
	WeaponFireTypes(0)=EWFT_Projectile
	FireInterval(0)=0.25
	FireInterval(1)=0.25
	ShotCost(0)=0
	ShotCost(1)=0
	DamageMultiplier = 1
}
