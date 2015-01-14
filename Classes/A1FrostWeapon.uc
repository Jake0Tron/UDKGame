class A1FrostWeapon extends A1Weapon;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated function Projectile ProjectileFire()
{
	latestProjectile = A1FrostProjectile(super.ProjectileFire());

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
DefaultProperties
{
	_ProjMode = 1
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
