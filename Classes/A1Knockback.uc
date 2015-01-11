class A1Knockback extends A1OnHit;

var float KnockbackForce;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	PickupMesh.SetScale(2);
}

function OnHit(A1Pawn PlayerPawn, A1EnemyPawn EnemyPawn, UTProj_LinkPowerPlasma Projectile)
{	
    local vector X,Y,Z;

	if (EnemyPawn == none || PlayerPawn == none || A1Player(PlayerPawn.Controller) == none)
	{
		return;
	}

	`log("knocking back " $ EnemyPawn.GetHumanReadableName());
	
	GetAxes(Projectile.Rotation, X, Y, Z);
	EnemyPawn.AddVelocity((Z * (KnockbackForce / 2)) + (X * KnockbackForce), Projectile.Location, class'DamageType');
}

DefaultProperties
{
	KnockbackForce = 500

	PowerUpName = "Knockback"
	PowerDescription = "Hit enemies are knocked around"
	Unique = true

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.Ammo_Shock.Mesh.S_Ammo_ShockRifle'
		Translation=(Z=64)
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}