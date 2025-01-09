//This script is used for the alien machine puzzle section of adato2.bsp
//created from scratch by BonkTurnip
//if this script works properly first try, it's a miracle (hint: it didn't)

array<CBaseEntity@> g_puzPos(5);
void checkParts(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	int numCorrect = 0;
	int numWrong = 0;
	//this gets the entity handles for the machine slots and func_pushables
	//hopefully this doesn't lag the game too much...
	CBaseEntity@ pPuzPos0 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzPos0");
	CBaseEntity@ pPuzPos1 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzPos1");
	CBaseEntity@ pPuzPos2 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzPos2");
	CBaseEntity@ pPuzPos3 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzPos3");
	CBaseEntity@ pPuzPos4 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzPos4");
	
	CBaseEntity@ pPuzBlock0 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzBlock0");
	CBaseEntity@ pPuzBlock1 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzBlock1");
	CBaseEntity@ pPuzBlock2 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzBlock2");
	CBaseEntity@ pPuzBlock3 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzBlock3");
	CBaseEntity@ pPuzBlock4 = g_EntityFuncs.FindEntityByTargetname(null, "alienPuzBlock4");
	
	//add each position entity handle to the array of object handles
	@g_puzPos[0] = @pPuzPos0;
	@g_puzPos[1] = @pPuzPos1;
	@g_puzPos[2] = @pPuzPos2;
	@g_puzPos[3] = @pPuzPos3;
	@g_puzPos[4] = @pPuzPos4;
	
	if(isTouchingAPos(pPuzBlock0, g_puzPos) && isTouchingAPos(pPuzBlock1, g_puzPos) && isTouchingAPos(pPuzBlock2, g_puzPos) && isTouchingAPos(pPuzBlock3, g_puzPos) && isTouchingAPos(pPuzBlock4, g_puzPos))
	{
		g_EntityFuncs.FireTargets("alienGates", null, null, USE_ON, 0.0f, 0.0f);
		if(pPuzBlock0.Intersects(pPuzPos0))
		{
			numCorrect++;
		}
		if(pPuzBlock1.Intersects(pPuzPos1))
		{
			numCorrect++;
		}
		if(pPuzBlock2.Intersects(pPuzPos2))
		{
			numCorrect++;
		}
		if(pPuzBlock3.Intersects(pPuzPos3))
		{
			numCorrect++;
		}
		if(pPuzBlock4.Intersects(pPuzPos4))
		{
			numCorrect++;
		}
		numWrong = 5 - numCorrect;
		if(numWrong == 0)
		{
			g_EntityFuncs.FireTargets("correctInstall_mm", null, null, USE_TOGGLE, 0.0f, 0.0f);
		}
		else
		{
			g_Scheduler.SetInterval( "playWrongSnd", 1, numWrong );
			g_EntityFuncs.FireTargets("alienGates", null, null, USE_OFF, 0.0f, 5.0f);
		}
	}
	else
	{
		g_Game.AlertMessage( at_console, "One or more parts are not touching a position\n" );
	}
}

bool isTouchingAPos(CBaseEntity@ pAlienBlock, array<CBaseEntity@> posEntities)
{
	bool isTouch = pAlienBlock.Intersects(posEntities[0]) || pAlienBlock.Intersects(posEntities[1]) || pAlienBlock.Intersects(posEntities[2]) || pAlienBlock.Intersects(posEntities[3]) || pAlienBlock.Intersects(posEntities[4]);
	g_Game.AlertMessage( at_console, "Bool returned by isTouchingAPos: "+isTouch+"\n" );
	return isTouch;
}

void playWrongSnd()
{
	g_EntityFuncs.FireTargets("playWrongSnd", null, null, USE_TOGGLE, 0.0f, 0.0f);
}