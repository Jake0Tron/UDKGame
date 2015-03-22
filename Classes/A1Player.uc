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
exec function SelectProjectile(int x){
	if(x == 1){
		A1Weapon(self.Pawn.Weapon).setMode(0);
	}
	if(x == 2){
		A1Weapon(self.Pawn.Weapon).setMode(1);
	}
	if(x == 3){
		A1Weapon(self.Pawn.Weapon).setMode(2);
	}
	if(x == 4){
		A1Weapon(self.Pawn.Weapon).setMode(3);
	}
}

DefaultProperties
{
	InputClass=class'A1Input'
}