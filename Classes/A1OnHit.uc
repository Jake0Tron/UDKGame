class A1OnHit extends A1PowerUp;

function OnHit(A1Pawn PlayerPawn, A1EnemyPawn EnemyPawn, UTProj_LinkPowerPlasma Projectile);

function Apply(A1Pawn P)
{
	super.Apply(P);

	`log("inserting: " $ PowerUpName);
	GameInfo.OnHitEffects.AddItem(self);
}

DefaultProperties
{
}
