class A1LifeSteal extends A1OnHit;

var float LifestealMultiplier;

function OnHit(A1Pawn PlayerPawn, A1EnemyPawn EnemyPawn, UTProj_LinkPowerPlasma Projectile)
{
	if (EnemyPawn == none || PlayerPawn == none || A1Player(PlayerPawn.Controller) == none)
	{
		return;
	}

	//`log("healing " $ PlayerPawn.GetHumanReadableName() $ " for " $ Projectile.Damage * LifestealMultiplier);
	PlayerPawn.GiveHealth(Projectile.Damage * LifestealMultiplier, PlayerPawn.HealthMax);
}

DefaultProperties
{
	LifestealMultiplier = 0.10
	PowerUpName = "Life Steal"
	PowerDescription = "Dealing damage heals you"
	Unique = true

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.Health_Large.Mesh.S_Pickups_Health_Large_Keg'
		Translation=(Z=64)
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}
