class A1Pawn extends A1EnemyPawn;
// NOTE: PLAYER STARTING HEALTH IS SET IN DEFAULTPROPERTIES

var bool ClearedChamber;

simulated function PostBeginPlay()
{
	local A1Game GameInf;

	super.PostBeginPlay();

	// initialize pawn variables
	GameInf = A1Game(WorldInfo.Game);
	HealthMax = GameInf.MaxHealth;
	GiveHealth(HealthMax, HealthMax);
	self._defaultFireRate = GameInf.FireInterval;		
}

//This calculates the camera’s viewpoint when viewing from the Pawn. 
/* Logic modified from:
 * http://udn.epicgames.com/Three/CameraTechnicalGuide.html
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
	local float DesiredCameraZOffset;   // ratio of what percent of pawn offset to use
	local UTPlayerController myPlayer;
	
	// cast 
	myPlayer = UTPlayerController(Controller);
	if (myPlayer == None) return false;

	//set player controller to behind view and make mesh visible
	myPlayer.SetBehindView(true);
	SetMeshVisibility(myPlayer.bBehindView);

	// Set location of camera
	CamStart = Location;
	
	// set Current offset to Pawn's offset
	CurrentCamOffset = CamOffset;
	
	// decide on where the camera Z is depending on player health, 
	// if alive set z to 1.3 times the vert collision height of the Pawn (overhead) 
	// uses GetCollisionHeight (assuming there is no interference)
	// if dead, set to 0
	DesiredCameraZOffset = (Health > 0) 
		? 1.3 * GetCollisionHeight() + Mesh.Translation.Z 
		: 0.f;
	
	
	CameraZOffset = (fDeltaTime < 0.2) 
		?DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset 
		:DesiredCameraZOffset;
   
	// player dead viewpoint
	if ( Health <= 0 )
	{
		CurrentCamOffset = vect(0,0,0);
		CurrentCamOffset.X = GetCollisionRadius();
	}

	// set Z axis appropriately
	CamStart.Z += CameraZOffset;

	// GetAxes takes a rotator and returns 3 vectors, relative to a forward X axis, a right Y axis, and a downward Z axis.
	GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
	
	// set camera scale
	CamDirX *= CurrentCameraScale;

	if ( (Health <= 0) || bFeigningDeath )
	{
		// makes sure that camera doesn't intersect with world geometry
		FindSpot(GetCollisionExtent(),CamStart);
	}

	// adjust camera scale fluidly 
	if (CurrentCameraScale < CameraScale)
	{
		CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
	}
	else if (CurrentCameraScale > CameraScale)
	{
		CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
	}

	// gets pawn's collision height, if the Camera's Z is greater than the Collision height, rotate the camera downwards (top-down esque)
	if (CamDirX.Z > GetCollisionHeight())
	{
		CamDirX *= square(cos(out_CamRot.Pitch * 0.0000958738)); // 0.0000958738 = 2*PI/65536
	}

	// set the camera location appropriate to the x,y,z                               
	out_CamLoc = CamStart - (CurrentCamOffset.X + 128 ) * CamDirX - (CurrentCamOffset.Y) * CamDirY + (CurrentCamOffset.Z + 16) * CamDirZ;
	
	if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
	{
		out_CamLoc = HitLocation;
	}

	return true;
}   

function toggleClearChamber(bool in){
	ClearedChamber = in;
	if (ClearedChamber)
	`Log("PLAYER Clear Status: "$ClearedChamber);
}

defaultproperties
{
	ClearedChamber = false
}