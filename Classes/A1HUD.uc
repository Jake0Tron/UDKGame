class A1HUD extends UTHUD;

//var Array<class> classArray;

/** Pawn for active Item*/
var A1Pawn pawn;
/** Chamber reference*/
var A1Chamber chamber;
// local player 
var A1Player player;


var int secondsFrameCounter ;
var string textToDisplay ;

var A1Game GameInfo;
var bool bShowingStats;

var float PlayerSpeed;
var float PlayerDamage;
var float FireSpeed;
var bool bLaser;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	Gameinfo = A1Game(WorldInfo.Game);
}

function DrawHUD(){

	//local A1Pawn pawn;
	local UTWeapon weapon;

	/** Color to use when Drawing on Canvas*/
	local Color c;
	
	/** Color to use when writing text*/
	local Color tc;

	/** Health calculation Variables*/
	local float HealthAmount;   // %Health left from player.Pawn.Health
	local int HealthCount;      // Pawn's current Remaining Health from player.Pawn.Health
	local float maxHealth;      // pawn's max health

	/** HUD dimensions and coordinates
	 * Health bar will span across the top of the screen*/
	// hud outline Size
	local float HudSizeX;
	local float HudSizeY;
	// health bar size
	local float barSizeX;
	local float barSizeY;
	// health bar position
	local float barPosX;
	local float barPosY;
	
	// Health Bar BackGround Position
	local float HudPosX;
	local float HudPosY;
	local float HealthHUDSize;

	// Stat HUD Position will be top left (0,0), no variable needed; 
	// Stat HUD size; uses BarSizeY to match health bar size)
	local float TLHudSizeX; 

	/** Onscreen Player Stats */
	local int textSizeX, textSizeY;

	/** Local Powerups*/
	local A1Bazooka bazooka;
	local A1JetPack jetpack;
	/* powerup variables */
	local float fuelMax;
	local float fuelAmount;
	local float fuelSizeX;

	local A1Projectile LatestProj;

	local string statString;

	// cast to A1Player
	player = A1Player(PlayerOwner);

	// ensure we're controlling the player
	if (player.Pawn == None ) return;

	weapon = UTWeapon(player.Pawn.Weapon);
	weapon = A1Weapon(weapon);

	// cast 
	if (A1Weapon(weapon) != None){	
		
		/** set player Damage */
		PlayerDamage = A1Weapon(weapon).getDamage();
		
		// PROJECTILE INFO DISPLAY
		Canvas.SetPos(Canvas.SizeX * 0.9f, Canvas.SizeY * 0.85f);
		// set color
		c.A=255;
		c.R=255;
		c.G=255; 
		c.B=255;
		Canvas.SetDrawColorStruct(c);	
		LatestProj =  A1Weapon(weapon).latestProjectile;	
		if (LatestProj != None){
			Canvas.Font = class'Engine'.static.GetMediumFont();
			Canvas.DrawText(LatestProj.WeaponEffectName, true);
			Canvas.DrawText(LatestProj.WeaponEffectDesc, true);
			Canvas.DrawText(LatestProj.WeaponEffectNote, true);
		}

		drawLaser(A1Weapon(weapon));
	}// End if weapon != None

	//////////////////////////////////
	/** HUD STAT SETUP - see above for PlayerDamage*/
	//////////////////////////////////

	/** Health*/
	HealthCount = player.Pawn.Health;
	// obtain %value for DrawRect
	MaxHealth = player.Pawn.HealthMax;
	// % value
	HealthAmount = (HealthCount/MaxHealth) * 1.0f;

	/** Movement Speed*/
	PlayerSpeed = player.Pawn.GroundSpeed;

	/** Fire Speed*/
	FireSpeed = weapon.GetFireInterval(byte(0));

	/////////////////////////////////////////
	// HUD LOCATION SETUP - BOX DRAWING ONLY
	/////////////////////////////////////////

	// Top HUD: 75% WIDTH
	HudPosX = (Canvas.SizeX * 0.125f);
	HudPosY = 0;
	// HUD SIZE
	HudSizeX = (Canvas.SizeX * 0.75f); 
	HudSizeY = (Canvas.SizeY * 0.10f);
	// Top Left HUD
	TLHudSizeX = (Canvas.SizeX *0.125f);
	// scaling health bar
	barSizeX = (HudSizeX * 0.9f);
	barSizeY = HudSizeY*0.5f;
	HealthHUDSize = (barSizeX * HealthAmount);
	// positioning bar
	barPosX = HudPosX + (HudSizeX * 0.05f);
	barPosY = HudPosY + (HudSizeY * 0.25f);
	
	////////////////
	/** Health HUD */
	////////////////
	/** Health - Grey BackGround*/
		c.A=200;
		c.R=50;
		c.G=50;
		c.B=50;
	
	Canvas.SetDrawColorStruct(c);
	// position
	Canvas.SetPos( HudPosX, HudPosY );
	Canvas.DrawRect( HudSizeX, HudSizeY );

	/** Changing Health Bar Colors - GREEN>75%, yellow 75-25%, red 25%-0*/
	if(HealthCount > MaxHealth * 0.75f )
	{
	// adjust Bar Color
		c.A=255;
		c.R=64;
		c.G=128;
		c.B=0;
	// adjust text color
		tc.A=255;
		tc.R=128;
		tc.G=255;
		tc.B=0;
	}
	else if (HealthCount >=  MaxHealth * 0.25f && HealthCount <=  MaxHealth * 0.75f ){
	// adjust Bar Color
		c.A=255;
		c.R=205;
		c.G=205;
		c.B=0;
	// adjust text color	
		tc.A=255;
		tc.R=60;
		tc.G=60;
		tc.B=0;
	}
	else if (HealthCount <  MaxHealth * 0.25f){	
	// adjust Bar Color
		c.A=255;
		c.R=225;
		c.G=0;
		c.B=0;
	// adjust text color
		tc.A=255;
		tc.R=64;
		tc.G=0;
		tc.B=0;
	}

	Canvas.SetDrawColorStruct(c);
	// draw % of box with health remaining
	// position
	Canvas.SetPos( barPosX, barPosY );
	// draw box
	Canvas.DrawRect( HealthHUDSize,  barSizeY );

	// Health Outline
	c.A=200;
	c.R=0;
	c.G=0;
	c.B=0;
	Canvas.SetDrawColorStruct(c);
	Canvas.SetPos( barPosX, barPosY );
	Canvas.DrawBox( barSizeX + 2, barSizeY );
	
	// Heath Text Display
	Canvas.Font = class'Engine'.static.GetLargeFont();
	c.A=255;
	c.R=128;
	c.G=255;
	c.B=0;
	Canvas.SetDrawColorStruct(tc);
	Canvas.SetPos( (barPosX + HealthAmount) + 16, (Canvas.SizeY * 0.035f) );
	Canvas.DrawText(HealthCount$"/"$int(MaxHealth) ,false);

	/** SCORE DISPLAY */
	c.A=255;
	c.R=128;
	c.G=255;
	c.B=0;
	Canvas.SetDrawColorStruct(c);
	Canvas.SetPos( Canvas.SizeX * 0.5f,Canvas.SizeY * 0.85f );
	Canvas.DrawText("SCORE : " $int(GameInfo.Teams[0].Score)$"" ,true);


	/** STAT Text Display*/
	
	/** Toggleable stat display*/
	if (bShowingStats){
		///////////////////////
		/** Stat HUD TOP LEFT*/
		///////////////////////
		//color
		c.A=200;
		c.R=50;
		c.G=50;
		c.B=50;
		Canvas.SetDrawColorStruct(c);
	
		// location
		Canvas.setPos(0, HudPosY);
		//draw
		Canvas.DrawRect(TLHudSizeX, HudSizeY);
		Canvas.Font = class'Engine'.static.GetMediumFont();
		tc.A=255;
		tc.R=255;
		tc.G=0;
		tc.B=0;
		Canvas.SetDrawColorStruct(tc);
		Canvas.SetPos( 32, 0 );
		Canvas.DrawText("MSPD  : "$int(PlayerSpeed) ,true);
		Canvas.DrawText("FSPD  : "$int(1/FireSpeed)$"/sec",true);
		Canvas.DrawText("DMG   : " $int(PlayerDamage)$" dmg",true);
	}

	/** ACTIVE ITEM DISPLAY*/
	pawn = A1Pawn(player.Pawn);

	if (GameInfo.CurrentItem != None){
		Canvas.Font = class'Engine'.static.GetMediumFont();
		tc.A=255;
		tc.R=255;
		tc.G=255;
		tc.B=255;
		Canvas.SetDrawColorStruct(tc);
		statString = GameInfo.CurrentItem.PowerUpName$" "$GameInfo.CurrentItem.PowerDescription;
		Canvas.Font.GetStringHeightAndWidth(statString,textSizeY,textSizeX);
		Canvas.SetPos(
			(HudSizeX + TLHudSizeX + (textSizeX * 0.25f)),
			((textSizeY * 0.5f)) 
			);
		Canvas.DrawText(GameInfo.CurrentItem.PowerUpName, true);
		//description display
		Canvas.Font = class'Engine'.static.GetMediumFont();
		Canvas.DrawText(GameInfo.CurrentItem.PowerDescription, true);
		
		// jetpack Fuel Display
		if (GameInfo.CurrentItem.PowerUpName == "Jet Pack"){
			jetpack = A1JetPack(GameInfo.CurrentItem);
			// max fuel amount
			fuelMax = jetPack.MaxFuel;
			// percent remaining fuel
			fuelAmount = (jetPack.Fuel / fuelMax);
			fuelSizeX = fuelAmount * 128;

			Canvas.SetPos(
			(HudSizeX + TLHudSizeX + (textSizeX * 0.25f)),
			((textSizeY * 4.0f)) 
			);
			tc.A=255;
			tc.R=128;
			tc.G=128;
			tc.B=128;
			Canvas.SetDrawColorStruct(tc);
			Canvas.DrawRect(128, 16);
			
			Canvas.SetPos(
			(HudSizeX + TLHudSizeX + (textSizeX * 0.25f)),
			((textSizeY * 4.0f)) 
			);

			tc.A=255;
			tc.R=255;
			tc.G=255;
			tc.B=255;
			Canvas.SetDrawColorStruct(tc);
			Canvas.DrawRect( fuelSizeX , 16);
		}

		// Bazooka cooldown display
		if (GameInfo.CurrentItem.PowerUpName == "Bazooka"){
			bazooka = A1Bazooka(GameInfo.CurrentItem);
			if (bazooka.OnCoolDown){
				tc.A=255;
				tc.R=255;
				tc.G=128;
				tc.B=0;
				Canvas.SetDrawColorStruct(tc);
				Canvas.DrawText("Cooldown...");
			}
			else{
				tc.A=255;
				tc.R=64;
				tc.G=255;
				tc.B=0;
				Canvas.SetDrawColorStruct(tc);
				Canvas.DrawText("Ready!");
			}		
		}
	}
	
	DisplayTextForSeconds();
}

function drawLaser(A1Weapon we){
	local Actor HitActor;
	local Vector AimingAt;  // represents direction player is facing
	local Vector AimNormal; // normal of their aim trace
	local Vector TraceStart;// start trace point (taken from instantFireStartTrace()
	local Vector TraceEnd;  // end trace point ( startPoint + weapon'sMaxRange*player's rotation)
	local Vector ScreenPos; // where on the screen to draw the CrossHair Size on screen

	local float CrosshairSize;
	local Color c;

	TraceStart = we.InstantFireStartTrace();
	TraceEnd = TraceStart + (we.MaxRange() * 0.5f )* vector(PlayerOwner.Rotation);
	HitActor = player.Pawn.Trace(AimingAt, AimNormal, TraceEnd, TraceStart, true, /*vect(0,0,0)*/,, TRACEFLAG_Bullet); 

	ScreenPos = Canvas.Project(AimingAt); 
	CrosshairSize = 32 * (Canvas.ClipY / (Canvas.SizeY * 0.75f)) * (Canvas.ClipX / ((Canvas.SizeX * 0.75f) ));

	if (bLaser){

		if(Pawn(HitActor) == None)
		{
			/** draw laser/reticle*/
			// laser Green, not hitting anyone
			AimingAt = TraceEnd;
			c.A=255;
			c.R=0;
			c.G=255; 
			c.B=0;
			Canvas.SetDrawColorStruct(c);
			Draw3DLine(TraceStart, TraceEnd, c);
		}
		else if (Pawn(HitActor) != None){
			/** draw laser/reticle*/
			// laser Red, Enemy spotted
			c.A=255;
			c.R=255;
			c.G=0; 
			c.B=0;
			Canvas.SetDrawColorStruct(c);
			Draw3DLine(TraceStart, TraceEnd, c);
			Canvas.SetDrawColor(255,0,0,255);

			Canvas.SetPos(ScreenPos.X - (CrosshairSize * 0.5f) + 8, ScreenPos.Y -(CrosshairSize * 0.5f));
			Canvas.DrawTile(class'UTHUD'.default.AltHudTexture, CrosshairSize, CrosshairSize, 666 , 256 , 64 ,64);
		}else if (HitActor == None){
			AimingAt = TraceEnd;
			c.A=255;
			c.R=0;
			c.G=255; 
			c.B=0;
			Canvas.SetDrawColorStruct(c);
			Draw3DLine(TraceStart, TraceEnd, c);
		}
	}
}

exec function toggleLaser(){
	if(bLaser){
		bLaser = false;
	}else{
		bLaser = true;
	}
}


function SetDisplayTextForSeconds ( string pText , int pSeconds )
{
  textToDisplay = pText ;
  secondsFrameCounter = pSeconds * 60 ;
}

function DisplayTextForSeconds ( )
{
	local Color tc;
	local int textSizeX, textSizeY;

	if (Canvas == None) return;

	if ( secondsFrameCounter > 0 )
	{
		tc.A=255;
		tc.R=255;
		tc.G=255;
		tc.B=255;
		Canvas.SetDrawColorStruct(tc);
		Canvas.Font = class'Engine'.static.GetLargeFont();
		Canvas.Font.GetStringHeightAndWidth(textToDisplay,textSizeY,textSizeX);
		Canvas.SetPos( 
				((Canvas.SizeX * 0.5f)  - (textSizeX * 0.5f )) , (Canvas.SizeY * 0.5f) 
				);
		Canvas.DrawText( textToDisplay , true);
		secondsFrameCounter -- ;
	}
}


exec function ShowStatsOn(){
	bShowingStats = true;
}

exec function ShowStatsOff(){
	bShowingStats = false;
}


DefaultProperties{
	FrameCount=0
	bShowingStats=false
	bLaser = false
}