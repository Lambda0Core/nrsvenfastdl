#include "../kmkz/func_savestate"
#include "../kmkz/func_loadstate"
#include "../kmkz/func_global"
#include "../kmkz/env_model_coop"
#include "../kmkz/trigger_changesky2"

void LoadSettings() 
{
	// Language setting. Change to LANGUAGE_ENGLISH For english language.
	
	iLanguage = LANGUAGE_ENGLISH;
	
	////////////////////////////////////////////
	
	// Change level sprite settings. Disabled by default.

	ChangeLevelSpriteAllow =false;
	
	// data_savestate settings
	
	SaveAllowed =			false;
	SaveVoteAlowed = 		true;	// "false" value allows to directly save at the slot chosen|| "true" value calls a vote to chose if you all want to save in that slot or not.
	SaveVotePercentage =	90; 	// chose a value between 0 and 100 as percentage to pass the vote.
	SaveVoteTime =			5;
	// data_loadstate settings
	
	LoadAllowed =			false;
	LoadVoteAlowed =		true; 	// "false" value allows to directly load the map from the slot chosen|| "true"  calls a vote to chose if you all want to load map from that slot or not.
	LoadVotePercentage =	90; 	// chose a value between 0 and 100 as percentage to pass the vote.
	LoadVoteTime =			5;
	
	//---------------------------------------------------------------------------//
	
	if (ChangeLevelSpriteAllow == false){g_EntityFuncs.FireTargets("cl_sprite", null, null, USE_OFF, 0.0f, 5.0f);}	
}

void MapInit()
{
	RegisterFuncGlobal();
	RegisterEnvModelCoop();
	RegisterFuncSavestate();
	RegisterFuncLoadstate();
	RegisterGameSpriteText();
	RegisterGameSpriteTextButton();
	g_CustomEntityFuncs.RegisterCustomEntity( "CChangeSky", "trigger_changesky2" );
	LoadSettings();
}

