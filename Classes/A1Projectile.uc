class A1Projectile extends UTProj_LinkPowerPlasma;
// default projectile class

var A1Game GameInfo;

//Description
var String WeaponEffectName;
var String WeaponEffectDesc;
var String WeaponEffectNote;
var int index;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
}

simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	local int ii;
	local A1EnemyPawn EnemyPawn;
	local A1Pawn PlayerPawn;

	PlayerPawn = A1Pawn(Instigator);
	EnemyPawn = A1EnemyPawn(Other);

	if(PlayerPawn != None && EnemyPawn != None){			
		if(EnemyPawn.IsAliveAndWell()){
			super.Touch(Other, OtherComp, HitLocation, HitNormal);

			for (ii = 0; ii < GameInfo.OnHitEffects.Length; ii++)
			{
				GameInfo.OnHitEffects[ii].OnHit(PlayerPawn, EnemyPawn, self);
			}
		}
		else{
			self.Destroy();
		}
	}
}

DefaultProperties
{
	Damage = 40
	Speed=1400
	MaxSpeed=4000
	AccelRate=2000.0
	ColorLevel = (X=5.3,X=0.3,Z=5.3)
	WeaponEffectName = ""
	WeaponEffectDesc = ""
	WeaponEffectNote = ""
}
