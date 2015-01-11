class A1JetPack extends A1ActiveItem;

var bool JetPackOn;

var float Thrust;

var float MaxFuel;
var float Fuel;
var float FuelConsumptionRate;
var float FuelRegenRate;

var ParticleSystem Trail;

var ParticleSystemComponent foobar;

var A1Player PlayerC;
var pawn PlayerPawn;

simulated function PostBeginPlay()
{	
	super.PostBeginPlay();
}

simulated function Tick(float deltaTime)
{
    local vector X,Y,Z;

	if (!Held) return;

	if (JetPackOn)
	{
		if (Fuel <= 0)
		{
			// fuel wont regen as long as the button is held down
			return;
		}		

		foreach AllActors(class'A1Player', PlayerC)
		{
			PlayerPawn = PlayerC.Pawn;
			break;
		}

		if (foobar == none)
		{
			foobar = WorldInfo.MyEmitterPool.SpawnEmitter(Trail, PlayerPawn.Location, PlayerPawn.Rotation, PlayerPawn);
		}

		GetAxes(PlayerC.Rotation, X, Y, Z);
		PlayerPawn.AddVelocity(Z * Thrust * DeltaTime, Location, class'DamageType');
		
		// consume fuel
		Fuel = FMax(Fuel - (deltaTime * FuelConsumptionRate), 0);
	}
	else if (!JetPackOn)
	{
		// regen fuel when jetpack is off
		Fuel = FMin(Fuel + (deltaTime * FuelRegenRate), MaxFuel);
	}
}

function StartActivate()
{	
	JetPackOn = true;
	foobar.ActivateSystem();
}

function StopActivate()
{
	JetPackOn = false;
	foobar.DeactivateSystem();
}

DefaultProperties
{
	Thrust = 1500
	JetPackOn = false

	MaxFuel = 100
	Fuel = 0
	FuelConsumptionRate = 50
	FuelRegenRate = 30

	Trail = ParticleSystem'Castle_Assets.FX.P_FX_Fire_SubUV_01'

	PowerupName = "Jet Pack"
	PowerDescription = "Hold Shift to use, Beware fall damage!"
	Unique = true

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'Pickups.Armor.Mesh.S_Pickups_Armor'
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}
