class A1PowerUp extends actor;

var string PowerUpName;
var string PowerDescription;

var bool Unique;
var bool PickedUp;

var StaticMeshComponent PickupMesh;

var A1Game GameInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
}

// called upon touching an available pickup
// place your powerup logic here
function Apply(A1Pawn P)
{
	PickedUp = true;
}

defaultproperties
{
	Unique = false
	PickedUp = false

	// assign your power up's mesh to this component to have different meshes for each powerup
	begin object class=staticmeshcomponent Name=PickupMeshComp
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}