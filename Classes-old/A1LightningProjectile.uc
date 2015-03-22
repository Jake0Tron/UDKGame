class A1LightningProjectile extends A1Projectile;

var A1EnemyPawn EnemyPawn;
var A1Pawn PlayerPawn;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}


simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	local int ii;
	local Rotator _dir;

	PlayerPawn = A1Pawn(Instigator);
	EnemyPawn = A1EnemyPawn(Other);
	_dir = self.Rotation;
	
	if(PlayerPawn != None && EnemyPawn != None){			
		if(EnemyPawn.IsAliveAndWell()){
			super.Touch(Other, OtherComp, HitLocation, HitNormal);

			for (ii = 0; ii < GameInfo.OnHitEffects.Length; ii++)
			{
				GameInfo.OnHitEffects[ii].OnHit(PlayerPawn, EnemyPawn, self);
			}
			//get the vector direction of the projectile
			//spawn the projectile to continue the directions
			if(PlayerPawn.Weapon != None){
				EnemyPawn._LightningEffect(EnemyPawn,PlayerPawn,HitLocation,_dir,A1Weapon(PlayerPawn.Weapon).DamageMultiplier);
			}
		}
		else{
			self.Destroy();
		}
	}
}


DefaultProperties
{
	index = 3
	Damage = 25
	ColorLevel = (X=5.3,Y=5.3,Z=0.0)

	Speed=4400
	MaxSpeed=8000
	AccelRate=5000.0

	WeaponEffectName = "Lightning Effect"
	WeaponEffectDesc = "Travels faster and penetrates target at 30% less damage"
	WeaponEffectNote = ""
}
