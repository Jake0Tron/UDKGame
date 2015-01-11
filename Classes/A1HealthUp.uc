class A1HealthUp extends A1PowerUp;

const HealthIncrease = 15;

function Apply(A1Pawn P)
{
	super.Apply(P);

	P.HealthMax += HealthIncrease;
	P.GiveHealth(HealthIncrease, P.HealthMax);
	GameInfo.MaxHealth = P.HealthMax;
}

DefaultProperties
{
	PowerUpName = "Health Up"
	PowerDescription = "Health up 15" 

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.Health_Medium.Mesh.S_Pickups_Health_Medium'
		Translation=(Z=64)
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}