class A1Player extends UTPlayerController;

var A1Game GameInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	GameInfo = A1Game(WorldInfo.Game);
}

function UpdateRotation( float DeltaTime )
{
   local Rotator DeltaRot, newRotation, ViewRotation;
	
   ViewRotation = Rotation;
	
   // call base pawn method to set rotation before tick
   if (Pawn!=none)
      Pawn.SetDesiredRotation(ViewRotation);

   // Calculate Delta to be applied on ViewRotation pitch and yaw
   DeltaRot.Yaw = PlayerInput.aTurn;
   DeltaRot.Pitch = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);

   NewRotation = ViewRotation;
   NewRotation.Roll = Rotation.Roll;

   if ( Pawn != None )
      Pawn.FaceRotation(NewRotation, deltatime);
}   

exec function SpawnItem()
{
	local a1itemspawner iter;
	foreach AllActors(class'A1ItemSpawner', iter)
	{
		iter.SpawnItem();
	}
}   

exec function SpawnSpecificItem(int index)
{
	local a1itemspawner iter;
	foreach AllActors(class'A1ItemSpawner', iter)
	{
		iter.SpawnSpecificItem(index);
	}
}

exec function StartActivate()
{
	if (GameInfo.CurrentItem != none)
	{
		GameInfo.CurrentItem.StartActivate();
	}
}

exec function StopActivate()
{
	if (GameInfo.CurrentItem != none)
	{
		GameInfo.CurrentItem.StopActivate();
	}
}

//SELECT PROJECTILE
exec function SelectProjectile(int x)
{
		A1Weapon(self.Pawn.Weapon).setMode( x );
}


// advance to next projectile type, or roll back
exec function nextProj(){
	local int cType;
	cType = A1Weapon(self.Pawn.Weapon)._ProjMode;
	
	if (cType >= 0 && cType <=3)
	{	// go to next
		if (cType >= 3 || cType < 0)
		{
			cType=0;
		}else{
			cType++;
		}
		SelectProjectile(cType);
	}
	else return;
}
// advance to prev projectile type, or roll back
exec function prevProj(){
	local int cType;
	cType = A1Weapon(self.Pawn.Weapon)._ProjMode;

	if (cType >= 0 && cType <= 3)
	{	// go to next
		if (cType <= 0 || cType > 3)
		{
			cType=3;
		}else{
			cType--;
		}
		SelectProjectile(cType);
	}
		else return;
}

state PlayerWalking
{
//ignores SeePlayer, HearNoise, Bump;

   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         // Update ViewPitch for remote clients
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      Pawn.Acceleration = NewAccel;

      CheckJumpOrDuck();
   }
}

DefaultProperties
{
	InputClass=class'A1Input'
}