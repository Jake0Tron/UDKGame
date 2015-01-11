class A1Chamber extends PathNode
  classgroup( A1 )
  hidecategories( Collision , Physics , Advanced , Debug ) ;

//Array of enemies in this chamber
var array<UTPawn> EnemyPawns ;

//Where the human player appears if this is the first chamber
var ( Chamber ) A1Spawn HumanSpawn ;

//Places where Enemies spawn
var( Chamber ) array<A1Spawn> Spawns ;
var int currentSpawnIndex ;

var( Chamber ) UTTeleporter Teleporter ;

var(Chamber) A1ItemSpawner ItemSpawner;

var bool TeleporterHidden ;
var bool wasActivated ;


//Reference to the game object
var A1Game game ;

function PostBeginPlay ( )
{
  super.PostBeginPlay() ;
  self.HideTeleporter() ;
}

function NavigationPoint NextEnemySpawnPoint ( )
{
  self.currentSpawnIndex = ( self.currentSpawnIndex + 1 ) % self.Spawns.Length ;
  return self.Spawns[ self.currentSpawnIndex ] ;
}

function NavigationPoint HumanPlayerSpawnPoint ( )
{
  return self.HumanSpawn ;
}

function InitializeChamber ( )
{
  self.HideTeleporter() ;
  self.wasActivated = false ;
  self.EnemyPawns.Length = 0 ;
}

function HideTeleporter ( )
{
  if ( ! self.TeleporterHidden )
  {
    self.Teleporter.SetHidden( true ) ;
    self.Teleporter.bEnabled = false ;
    self.TeleporterHidden = true ;
  }
}

function ShowTeleporter ( )
{
  if ( self.TeleporterHidden )
  {
    self.Teleporter.SetHidden( false ) ;
    self.Teleporter.bEnabled = true ;
    self.TeleporterHidden = false ;
  }
}

function FillWithEnemies ( )
{
  self.game.KillBots() ;
  self.game.AddBots( self.Spawns.Length ) ;
  self.wasActivated = true ;
}

function bool AllEnemiesAreDead ( )
{
  local int ii ;
  local A1EnemyPawn lEnemyPawn ;

  if ( self.EnemyPawns.Length < 1 )
  {
    //Initialize the enemies array if it hasnt yet
    foreach AllActors ( class'A1EnemyPawn' , lEnemyPawn )
    {
      if ( A1Player( lEnemyPawn.Controller ) == None )
      {
		//===========Enemy Upgrades==========//
		lEnemyPawn.decideUpgrade();
		//===================================//
        self.EnemyPawns.AddItem( lEnemyPawn ) ;
      }
    }
  }

  for ( ii = 0 ; ii < self.EnemyPawns.Length ; ii ++ )
  {
    if (( self.EnemyPawns[ ii ] != None ) && ( self.EnemyPawns[ ii ].Health > 0 ))
    {
      //If there is one enemy alive. Not all are dead.
      return false ;
    }
  }

  return true ;
}

function bool HasBeenBeat ( )
{
  return self.wasActivated && self.AllEnemiesAreDead() ;
}

DefaultProperties
{
  wasActivated=false
}
