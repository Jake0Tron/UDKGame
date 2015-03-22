class A1FireRateUp extends A1PowerUp;

function Apply(A1Pawn P)
{	
	local A1Weapon playerWeapon;

	super.Apply(P);

	playerWeapon = A1Weapon(P.Weapon);

	if(P._defaultFireRate == 0){
		P._defaultFireRate = GameInfo.FireInterval;
	}

	playerWeapon.FireInterval[0] = FMax(0.1, playerWeapon.FireInterval[0] * 0.75);
	//This updated the Player's dufault fire rate while under the effects of frost
	P._defaultFireRate = FMax(0.1, P._defaultFireRate * 0.75);;
	GameInfo.FireInterval = P._defaultFireRate;
}

defaultproperties
{
	PowerUpName = "Fire Rate Up"
	PowerDescription = "Weapon fire rate increased by 25%"

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.Berserk.Mesh.S_Pickups_Berserk'
		Translation=(Z=64)
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}
