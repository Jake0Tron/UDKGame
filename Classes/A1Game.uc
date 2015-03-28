class A1Game extends UTTeamGame;

var array<A1Chamber> Chambers ;
var int activeChamberIndex ;
var A1Player player;

var bool chambersInitialized ;
var bool restoreHealth ;
var bool currentChamberClear;

// powerups
var A1ActiveItem CurrentItem;
var array<A1OnHit> OnHitEffects;
var array<A1PowerUp> PowerUps;

var float DamageMultiplier;
var float FireInterval;
var int MaxHealth;
var float defaultDamage;

function PostBeginPlay ( )
{
  bPlayersBalanceTeams = false ;
  super.PostBeginPlay() ;
  self.InitializeChambers() ;  

  // instantiate all powerups
	PowerUps.AddItem(spawn(class'A1DamageUp'));
	PowerUps.AddItem(spawn(class'A1FireRateUp'));
	PowerUps.AddItem(spawn(class'A1JetPack'));
	PowerUps.AddItem(spawn(class'A1LifeSteal'));
	PowerUps.AddItem(spawn(class'A1HealthUp'));
	PowerUps.AddItem(spawn(class'A1Knockback'));
	PowerUps.AddItem(spawn(class'A1Bazooka'));		
}

function InitializeChambers ( )
{
  if ( ! self.chambersInitialized )
  {
    self.resetChambers() ;
    self.chambersInitialized = true ;
  }
}

function int SelectRandomChamber ( optional int pCurrent = -1 )
{
  //Right now, this goes sequentially and not randomly
  return ( pCurrent + 1 ) % self.Chambers.Length ;
}

function resetChambers ( )
{
  local A1Chamber lChamber ;
  foreach AllActors( class'A1Chamber' , lChamber )
  {
    lChamber.InitializeChamber() ;
    self.Chambers.AddItem( lChamber ) ;
  }
}

function ActivateChamber ( A1Chamber pChamber )
{
	if (self.ThereIsHuman()){
	  pChamber.game = self ;
	  pChamber.FillWithEnemies() ;
	  pChamber.ItemSpawner.Reset();
	  
	}
}

//True is there is an alive human player in the game.
function bool ThereIsHuman ( )
{
  local A1Player lPlayer ;
  foreach AllActors( class'A1Player' , lPlayer )
  {
    self.player = lPlayer ;
    return lPlayer != None && lPlayer.Pawn != None && lPlayer.Pawn.Health > 0 ;
  }

  return false ;
}

function Tick ( float pDeltaTime )
{
  super.Tick( pDeltaTime ) ;
  self.InitializeChambers() ;
 if (!ThereIsHuman())
	return;
  self.healthRestore() ;
}

function healthRestore ( )
{
  local A1Player lPlayer ;

  if ( self.restoreHealth )
  {
    foreach AllActors( class'A1Player' , lPlayer ) break ;

    while ( lPlayer.Pawn.Health < lPlayer.Pawn.HealthMax )
    {
      lPlayer.Pawn.Health ++ ;
      return ;
    }

    self.restoreHealth = false ;
  }
}

//Prevents Parent classes from spawning bots.
function bool NeedPlayers ( )
{
  return false ;
}

//Prevents Parent classes from kicking bots.
function bool TooManyBots(Controller botToRemove)
{
  return false ;
}


function NavigationPoint FindPlayerStart(Controller pPlayer, optional byte InTeam, optional string incomingName)
{
  self.InitializeChambers() ;

  if ( self.activeChamberIndex <  0 )
  {
    self.activeChamberIndex = self.SelectRandomChamber() ;
  }

  if ( self.Chambers.Length < 1 )
  {
    return super.FindPlayerStart(pPlayer, InTeam, incomingName) ;
  }

  if ( A1Player( pPlayer ) == None )
  {
    return self.Chambers[ self.activeChamberIndex ].NextEnemySpawnPoint() ;
  }
  else
  {
    return self.Chambers[ self.activeChamberIndex ].HumanSpawn ;
  }
}

//Always add bots to the same team
function UTBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
  return super.AddBot( BotName , true , 1 ) ;
}

//Always choose the same team for all bots
function UTTeamInfo GetBotTeam(optional int TeamBots,optional bool bUseTeamIndex,optional int TeamIndex)
{
  return super.GetBotTeam( TeamBots , true , 1 ) ;
}

//turn off team balancing
event InitGame( string Options, out string ErrorMessage )
{
  super.InitGame( Options , ErrorMessage ) ;
  self.bPlayersBalanceTeams = false ;
}

//turn off team balancing
function RestartGame()
{
  self.bPlayersBalanceTeams = false ;
  super.RestartGame() ;
}

//turn off team balancing
function byte PickTeam(byte num, Controller C)
{
  self.bPlayersBalanceTeams = false ;
  return super.PickTeam( num , C ) ;
}

// disable "you killed" message
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> damageType)
{
}

// disable "you killed" message
function NotifyKilled(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType)
{
}

function bool AllEnemiesAreDead ( )
{
	return Chambers[activeChamberIndex].AllEnemiesAreDead();
}



DefaultProperties
{
	MapPrefixes[0]="A1"
	//PLAYER & CONTROL
	PlayerControllerClass=class'A1Player'
	DefaultPawnClass=class'A1Pawn'
	//HUD
	HUDType=class'A1HUD'
	bUseClassicHUD=true
	// Weapon
	DefaultInventory(0)=class'A1Weapon'
	activeChamberIndex=-1
	 BotClass=class'A1EnemyBot'
	 chambersInitialized=false
	 bPlayersVsBots=true

	// powerups
	MaxHealth = 150
	FireInterval = 0.25
	DamageMultiplier = 1
	defaultDamage = 30
}