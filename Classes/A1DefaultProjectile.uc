class A1DefaultProjectile extends A1Projectile;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
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
	index = 0
	Damage = 39
	Speed=1400
	MaxSpeed=4000
	AccelRate=2000.0
	ColorLevel = (X=5.3,X=0.3,Z=5.3)
	WeaponEffectName = "Default Projectile"
	WeaponEffectDesc = "High Damage"
	WeaponEffectNote = ""
}
