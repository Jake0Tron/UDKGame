class A1Projectile extends UTProj_LinkPowerPlasma;
// default projectile class

var A1Game GameInfo;

//Description
var String WeaponEffectName;
var String WeaponEffectDesc;
var String WeaponEffectNote;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
}

simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	
}

DefaultProperties
{
	Damage = 39
	Speed=1400
	MaxSpeed=4000
	AccelRate=2000.0
	ColorLevel = (X=5.3,X=0.3,Z=5.3)
	WeaponEffectName = ""
	WeaponEffectDesc = ""
	WeaponEffectNote = ""
}
