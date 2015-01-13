class A1FrostProjectile extends A1Projectile;

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
				if(GameInfo.OnHitEffects[ii].Class != class'A1Knockback'){
					GameInfo.OnHitEffects[ii].OnHit(PlayerPawn, EnemyPawn, self);
				}
			}

			//Apply Effect
			EnemyPawn._FrostDebuff(true,EnemyPawn);
		}
		else{
			self.Destroy();
		}
	}
}

DefaultProperties
{
	index = 1
	Damage = 20
	ColorLevel = (X=0.3,Y=0.3,Z=5)
	WeaponEffectName = "Frost Effect"
	WeaponEffectDesc = "Reduces enemy Move Speed and Fire Rate by 5%. Stacks 5 times."
	WeaponEffectNote = "Knockback does not work with this projectile"
}
