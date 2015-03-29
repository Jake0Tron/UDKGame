class A1Bazooka extends A1ActiveItem;

var SoundCue LaunchSound;
var SoundCue ReloadedSound;
var bool OnCoolDown;
var A1Player player;

const CoolDown = 5;

simulated function PostBeginPlay()
{	
	super.PostBeginPlay();
	LaunchSound.VolumeMultiplier = 2.5;
	ReloadedSound.VolumeMultiplier = 2.5;
}

/** called when the bound key is pressed */
function StartActivate()
{
	local UTProj_Rocket rocket;

	if (OnCoolDown)
	{
		return;
	}

	if (player == none)
	{
		foreach AllActors(class'A1Player', player)
		{
			break;
		}
	}
	
		rocket = Spawn(class'UTProj_Rocket', player.Pawn,,player.pawn.Location, player.Rotation);
		rocket.Init(vector(player.Rotation));

		PlaySound(LaunchSound,,,,player.Pawn.Location);

		OnCoolDown = true;
		SetTimer(CoolDown);
}

function Timer()
{    
    OnCoolDown = false;
	
	PlaySound(ReloadedSound,,,,player.Pawn.Location);
}

/** called when the bound key is released 
(ignore this one if you only need to tap to activate) */
function StopActivate();

DefaultProperties
{
	OnCoolDown = false;
	LaunchSound = SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Fire_Cue'
	ReloadedSound = SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Load_Cue'

	PowerupName = "Bazooka"
	PowerDescription = "Unguided rocket, watch the backblast!"
	Unique = false

	begin object Name=PickupMeshComp
		StaticMesh=StaticMesh'GP_Onslaught.Mesh.S_GP_Ons_Weapon_Locker'
		HiddenGame=true
	end object

	PickupMesh = PickupMeshComp
	Components.Add(PickupMeshComp)
}
