class A1ActiveItem extends A1PowerUp;

var bool Held;

function Apply(A1Pawn P)
{
	super.Apply(P);

	if (GameInfo.CurrentItem != none)
	{
		GameInfo.CurrentItem.Held = false;
	}

	Held = true;
	GameInfo.CurrentItem = self;
}

/** called when the bound key is pressed */
function StartActivate();

/** called when the bound key is released 
(ignore this one if you only need to tap to activate) */
function StopActivate();

DefaultProperties
{
	Held = false
	PowerUpName=""
	PowerDescription=""
}
