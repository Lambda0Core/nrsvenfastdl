//Weapons
#include "weapons/weapon_bts_crowbar"
#include "weapons/weapon_bts_glock"
#include "weapons/weapon_bts_beretta"
#include "weapons/weapon_bts_m16"
#include "weapons/weapon_bts_mp5"
#include "weapons/weapon_bts_mp5gl"
#include "weapons/weapon_bts_python"
#include "weapons/weapon_bts_shotgun"
#include "weapons/weapon_bts_eagle"
#include "weapons/weapon_bts_pipe"
#include "weapons/weapon_bts_screwdriver"
#include "weapons/weapon_bts_poolstick"
#include "weapons/weapon_bts_sbshotgun"
#include "weapons/weapon_bts_axe"
#include "weapons/weapon_bts_m79"
#include "weapons/weapon_bts_saw"
#include "weapons/weapon_bts_knife"
#include "weapons/weapon_bts_m4"
#include "weapons/weapon_bts_m4sd"
#include "weapons/weapon_bts_flare"
#include "weapons/weapon_bts_flashlight"
#include "weapons/weapon_bts_glocksd"
#include "weapons/weapon_bts_flaregun"
#include "weapons/weapon_bts_dartgun"
#include "weapons/weapon_bts_glock18"
#include "weapons/weapon_bts_handgrenade"
#include "weapons/weapon_bts_uzi"
#include "weapons/weapon_bts_glock17f"

//Base
#include "hl_utils"

void RegisterRaptor()
{
	// Register Weapons
	HL_CROWBAR::RegisterHLCrowbar(); // HL Crowbar Register
	HL_GLOCK::RegisterHLGlock(); // HL Glock Register
	HL_BERETTA::RegisterHLBeretta(); // HL Beretta M9 Register 
    HL_M16A3::RegisterHLM16(); // HL M16 w/ M203 (556 Caliber) Register
	HL_MP5GL::RegisterHLMP5GL(); // HL MP5 With GL Register
	HL_MP5::RegisterHLMP5(); // HL MP5 w/o GL Register
	CPython::Register(); // HL 357 Python Register
	HL_SHOTGUN::RegisterHLShotgun(); // HL SPAS-12 Shotgun Register
	BTS_DEAGLE::RegisterBTSDeagle(); // Desert Eagle w/ Torchlight attached
	HL_PIPE::RegisterPipe(); // Visitor Pipe Register
	HL_SCREWDRIVER::RegisterScrewdriver(); // Screwdriver Register
	HL_POOLSTICK::RegisterPoolstick(); // Azure Sheep Poolstick Register
	HL_SBSHOTGUN::RegisterSBShotgun(); // Mossberg 500 w/ Torchlight attached Register
	HL_AXE::RegisterAxe(); // Brave Brain Fire Axe Register
	HL_M79::RegisterM79(); // KernCore's M79 Grenade Launcher Register
	CM249::Register(); // OP4 M249 SAW LMG Register
	BTS_KNIFE::RegisterOP4Knife(); // OP4 Combat Knife Register
	BTS_M4::RegisterM4(); // M4A1 Register
	BTS_M4SD::RegisterM4SD(); // Suppressed M4A1 Register
	BTS_FLARE::RegisterFLARE(); // Black Mesa Emergency Flare Register
	BTS_FLASHLIGHT::RegisterBTSFlashlight(); // Black Mesa Staff Flashlight
	HL_GLOCKSD::RegisterHLGlockSD(); // HL Suppressed/Silenced Glock Register
	BTS_FLAREGUN::Register(); // Emergency Flare Gun
	BTS_DARTGUN::Register(); // Dartgun (Secret Weapon)
	BTS_GLOCK18::Register(); // Glock 18 (Toggleable Mode)
	BTS_HANDGRENADE::Register(); // Custom Hand Grenade
	BTS_UZI::Register(); // Custom Single Uzi
	BTS_GLOCK17F::Register(); // Glock 17 w/ Torchlight variant
}