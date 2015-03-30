class A1DefaultProjectile extends A1Projectile;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Damage = GameInfo.defaultDamage;
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
	Speed=3200
	MaxSpeed=4000
	AccelRate=2000.0
	
	WeaponEffectName = ""
	WeaponEffectDesc = ""
	WeaponEffectNote = ""
}
