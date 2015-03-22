class A1DamageUp extends A1PowerUp;

function Apply(A1Pawn P)
{	
	local A1Weapon playerWeapon;

	super.Apply(P);

	playerWeapon = A1Weapon(P.Weapon);

	playerWeapon.DamageMultiplier += 0.25;
	GameInfo.DamageMultiplier = playerWeapon.DamageMultiplier;
}

DefaultProperties
{
	PowerUpName = "Damage Up"
	PowerDescription = "Weapon damage up 25%" 

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.UDamage.Mesh.S_Pickups_UDamage'
		Translation=(Z=64)
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}
