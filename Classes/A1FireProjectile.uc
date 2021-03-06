class A1FireProjectile extends A1Projectile;

var A1EnemyPawn EnemyPawn;
var A1Pawn PlayerPawn;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	local int ii;

	PlayerPawn = A1Pawn(Instigator);
	EnemyPawn = A1EnemyPawn(Other);

	if(PlayerPawn != None && EnemyPawn != None){			
		if(EnemyPawn.IsAliveAndWell()){
			super.Touch(Other, OtherComp, HitLocation, HitNormal);

			for (ii = 0; ii < GameInfo.OnHitEffects.Length; ii++)
			{
				GameInfo.OnHitEffects[ii].OnHit(PlayerPawn, EnemyPawn, self);
			}
			if (EnemyPawn != None)
			//Apply Effect
			EnemyPawn._FireDebuff(true,EnemyPawn,A1Weapon(PlayerPawn.Weapon).DamageMultiplier,Damage);
		}
		else{
			self.Destroy();
		}
	}
}

DefaultProperties
{
	index = 2
	ColorLevel = (X=5.0,Y=0,Z=0)
	ExplosionColor=(X=5.0,Y=5.0,Z=0.0)


	Damage = 12
	Speed=3500
	MaxSpeed=4000
	AccelRate=2500.0

	WeaponEffectName = "Fire Bullet"
	WeaponEffectDesc = "Burn Damage Over Time"
	WeaponEffectNote = ""
}
