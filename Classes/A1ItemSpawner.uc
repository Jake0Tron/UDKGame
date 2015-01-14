class A1ItemSpawner extends Actor
	placeable
	ClassGroup(A1);

var bool ItemSpawned;
var bool Taken;

// currently active power up, one is selected at random from PowerUps when you call SpawnItem
var A1PowerUp CurrentPowerUp;

var SoundCue PickupSound;
var SoundCue SpawnedSound;

var A1Game GameInfo;

// Call this once before you do anything else with this instance
function PostBeginPlay()
{
    super.PostBeginPlay();

	GameInfo = A1Game(WorldInfo.Game);
	PickupSound.VolumeMultiplier = 1.5;
	SpawnedSound.VolumeMultiplier = 1.5;
}

// Should be called upon entering a room
function Reset()
{
	if (CurrentPowerUp != None)
	{
		CurrentPowerUp.PickupMesh.SetHidden(true);
		ItemSpawned = false;
		Taken = false;
	}

}

// choose a random item and make it available for pickup
function SpawnItem()
{
	while(!SpawnSpecificItem(Rand(GameInfo.PowerUps.Length)))
	{
		// this loop will try to spawn another item if the chosen item is unique and taken
	}
}

function bool SpawnSpecificItem(int itemIndex)
{
	local A1PowerUp nextItem;

	nextItem = GameInfo.PowerUps[Clamp(itemIndex, 0, GameInfo.PowerUps.Length - 1)];

	// check for unique items
	if (nextItem.Unique && nextItem.PickedUp)
	{
		`Log("Can't spawn another unique " $ nextItem.PowerUpName);
		return false;
	}

	CurrentPowerUp = nextItem;
	//`Log("Spawned " $ CurrentPowerUp.PowerUpName);

	// move the actor so we can see the mesh
	CurrentPowerUp.SetLocation(location);

	PlaySound(SpawnedSound);
	CurrentPowerUp.PickupMesh.SetHidden(false);

	ItemSpawned = true;
	Taken = false;

	return true;
}

// Apply will be called when the player pawn touches this actor while item is spawned but has not been taken
function Touch(Actor Other, PrimitiveComponent OtherComp, Object.Vector HitLocation, Object.Vector HitNormal)
{
	local A1Player player;
	local A1Pawn playerPawn;

	playerPawn = A1Pawn(Other);

	if (playerPawn == none || 
		PlayerController(playerPawn.Controller) == none || 
		!ItemSpawned  || 
		Taken )
	{
		return;
	}

	player = A1Player(playerPawn.Owner);
	CurrentPowerUp.Apply(playerPawn);
	//`Log("Powered up: " $ CurrentPowerUp.PowerUpName);

	A1HUD(player.myHUD).SetDisplayTextForSeconds( CurrentPowerUp.PowerUpName$"\n"$CurrentPowerUp.PowerDescription , 5 ) ;
	A1HUD(player.myHUD).DisplayTextForSeconds();
	
	PlaySound(PickupSound);
	
	CurrentPowerUp.PickupMesh.SetHidden(true);
	Taken = true;
}

DefaultProperties
{ 
	bCollideActors = true
	CollisionType = COLLIDE_TouchAll

	ItemSpawned = false
	Taken = false

	PickupSound = SoundCue'A_Pickups.Health.Cue.A_Pickups_Health_Super_Cue'
	SpawnedSound = soundcue'A_Pickups.Generic.Cue.A_Pickups_Generic_ItemRespawn_Cue'

	begin object class=StaticMeshComponent Name=BaseMesh
		StaticMesh=StaticMesh'Pickups.Base_Armor.Mesh.S_Pickups_Base_Armor'
	end object

	begin object class=CylinderComponent Name=CollisionComponent
		CollisionRadius=16
		CollisionHeight=96
	end object

	Components.Add(BaseMesh)
	Components.Add(CollisionComponent)

	CollisionComponent = CollisionComponent
}
