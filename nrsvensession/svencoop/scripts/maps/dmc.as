#include "weapon_custom/v9/weapon_custom"
#include "trigger_observer_proto_20220918_noinit"

void dmc_precache(){
	g_SoundSystem.PrecacheSound("dmc/misc/talk.wav");
	g_SoundSystem.PrecacheSound("dmc/player/death1.wav");
	g_SoundSystem.PrecacheSound("dmc/player/death2.wav");
	g_SoundSystem.PrecacheSound("dmc/player/death3.wav");
	g_SoundSystem.PrecacheSound("dmc/player/death4.wav");
	g_SoundSystem.PrecacheSound("dmc/player/death5.wav");
	g_SoundSystem.PrecacheSound("dmc/player/drown1.wav");
	g_SoundSystem.PrecacheSound("dmc/player/drown2.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain1.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain2.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain3.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain4.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain5.wav");
	g_SoundSystem.PrecacheSound("dmc/player/pain6.wav");
  g_Game.PrecacheModel("models/dmc/pow_quad.mdl");
  g_Game.PrecacheModel("models/dmc/pow_invuln.mdl");
  g_Game.PrecacheModel("models/dmc/pow_invis.mdl");
	g_SoundSystem.PrecacheSound("dmc/items/damage.wav");
	g_SoundSystem.PrecacheSound("dmc/items/damage2.wav");
	g_SoundSystem.PrecacheSound("dmc/items/damage3.wav");
	g_SoundSystem.PrecacheSound("dmc/items/protect.wav");
	g_SoundSystem.PrecacheSound("dmc/items/protect2.wav");
	g_SoundSystem.PrecacheSound("dmc/items/protect3.wav");
	g_SoundSystem.PrecacheSound("dmc/items/inv1.wav");
	g_SoundSystem.PrecacheSound("dmc/items/inv2.wav");
	g_SoundSystem.PrecacheSound("dmc/items/inv3.wav");
	g_SoundSystem.PrecacheSound("dmc/items/suit.wav");
  g_CustomEntityFuncs.RegisterCustomEntity("dmc_artifact_quad", "dmc_artifact_quad");
  g_CustomEntityFuncs.RegisterCustomEntity("dmc_artifact_invuln", "dmc_artifact_invuln");
  g_CustomEntityFuncs.RegisterCustomEntity("dmc_artifact_invis", "dmc_artifact_invis");
  g_ItemRegistry.RegisterItem("dmc_artifact_quad","dmc/artifacts");
  g_ItemRegistry.RegisterItem("dmc_artifact_invuln","dmc/artifacts");
  g_ItemRegistry.RegisterItem("dmc_artifact_invis","dmc/artifacts");
}
void dmc_init(){
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @Chat);
	g_Hooks.RegisterHook(Hooks::Player::PlayerKilled, @Death);
  g_Hooks.RegisterHook(Hooks::Player::PlayerTakeDamage, @Damage);
  g_Hooks.RegisterHook(Hooks::Player::PlayerSpawn, @PlayerSpawn);
}
//========= Sounds =========
HookReturnCode Chat(SayParameters@ pParams){
	CBasePlayer@ pPlayer = pParams.GetPlayer();
 	const CCommand@ args = pParams.GetArguments();
	if(args[0]==".dmc_version" && pPlayer.IsConnected()){
		g_PlayerFuncs.SayText(pPlayer, "Deathmatch Classic: Sven Co-op remake v4.\n");
		pParams.set_ShouldHide(true);
	}
	else if(args[0]==".dmc_spectate" && pPlayer.IsConnected()){
        Observer@ Obs = pPlayer.GetObserver();
        if(!Obs.IsObserver()){
                pPlayer.Killed(pPlayer.pev, GIB_ALWAYS);
                TriggerObserver::StartObserving(pPlayer, false);
        }
        else {TriggerObserver::StopObserving(pPlayer, true);}
	}
	if(pPlayer.IsPlayer() && args[0]!="")g_SoundSystem.PlaySound(pPlayer.edict(), CHAN_VOICE, "dmc/misc/talk.wav", 1, ATTN_NONE);
	return HOOK_CONTINUE;
}
HookReturnCode Death(CBasePlayer@ pPlayer, CBaseEntity@ pAttacker, int iGib){
  if(pPlayer.pev.health > -30){
    if (pPlayer.pev.waterlevel >= WATERLEVEL_HEAD) {
		  g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_BODY, "dmc/player/drown"+string(Math.RandomLong(1,2))+".wav", Math.RandomFloat(0.9, 1.0), ATTN_NORM);
	  }
	  else {
      		g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_BODY, "dmc/player/death"+string(Math.RandomLong(1,5))+".wav", Math.RandomFloat(0.9, 1.0), ATTN_NORM);
    }
  }
  dmc_RemovePowerup(pPlayer, 1);
  dmc_RemovePowerup(pPlayer, 2);
  dmc_RemovePowerup(pPlayer, 3);
	return HOOK_CONTINUE;}
HookReturnCode Damage(DamageInfo@ pDamageInfo){
  if(pDamageInfo.flDamage > 100){
    g_SoundSystem.EmitSoundDyn(pDamageInfo.pVictim.edict(), CHAN_BODY, "dmc/player/gasp"+string(Math.RandomLong(1,2))+".wav", Math.RandomFloat(0.9, 1.0), ATTN_NORM);}
  else{
    g_SoundSystem.EmitSoundDyn(pDamageInfo.pVictim.edict(), CHAN_BODY, "dmc/player/pain"+string(Math.RandomLong(1,6))+".wav", Math.RandomFloat(0.9, 1.0), ATTN_NORM);}
  CBasePlayer@ Wounded = cast<CBasePlayer>(pDamageInfo.pVictim);
  float aDamage = pDamageInfo.flDamage;
  if(aDamage>Wounded.pev.armorvalue)aDamage=Wounded.pev.armorvalue;
  Wounded.TakeArmor(-(aDamage), pDamageInfo.bitsDamageType, 0); //It takes armor, but it also takes health if no armor present.
  return HOOK_CONTINUE;                                           //Hence such weird logic here.
}
//========= Artifacts =========
mixin class dmc_artifact{
  string model;
  string sound;
  string warnSnd;
  string useSnd;
  string PlayerKey;
  int type; // 1 = quad, 2 = invuln, 3 = invis
  float respawnTime = 300.0;

  void BaseSpawn(){
    BaseClass.Spawn();
    self.pev.movetype = MOVETYPE_TOSS;
    self.pev.solid = SOLID_TRIGGER;
    g_EntityFuncs.SetModel(self, model);
    g_EntityFuncs.SetSize(self.pev, Vector(-16, -16, 0), Vector(16, 16, 16));
    self.pev.noise = sound;
    SetThink(ThinkFunction(this.Rotate));
    SetTouch(TouchFunction(this.ArtifactTouch));
    self.pev.nextthink = g_Engine.time + 0.2;
  }
  void Rotate(){
    self.pev.angles.y += 1.25;
    self.pev.nextthink = g_Engine.time + 0.01;
  }
  void ArtifactTouch(CBaseEntity@ who){
    if(who is null)return;
    if(!who.IsPlayer())return;
    if(who.pev.health<1)return;
    CBasePlayer@ pPlayer = cast<CBasePlayer@>(who);
    if(PickedUp(pPlayer)){
      SetTouch(null);
      self.SUB_UseTargets(who, USE_TOGGLE, 0);
      g_SoundSystem.EmitSound(pPlayer.edict(), CHAN_ITEM, sound, 1.0, ATTN_NORM);
      Respawn();
    }
    else{return;}
  }
CBaseEntity@ Respawn() {
    self.pev.effects |= EF_NODRAW;
    SetThink(ThinkFunction(this.Materialize));
    self.pev.nextthink = g_Engine.time + respawnTime;
    return self;
  }
  void Materialize() {
    if ((self.pev.effects & EF_NODRAW) != 0) {
      g_SoundSystem.EmitSound(self.edict(), CHAN_ITEM, "dmc/items/suit.wav", 1.0, ATTN_NORM);
      self.pev.effects &= ~EF_NODRAW;
      self.pev.effects |= EF_MUZZLEFLASH;
    }
    SetThink(ThinkFunction(this.Rotate));
    SetTouch(TouchFunction(this.ArtifactTouch));
    self.pev.nextthink = g_Engine.time + 0.01;
  }
  bool PickedUp(CBasePlayer@ pPlayer) {
    float EndTime = g_Engine.time + 30.0;
    ApplyEffect(pPlayer);
    pPlayer.GetCustomKeyvalues().SetKeyvalue(PlayerKey, EndTime);
    g_Scheduler.SetTimeout("dmc_RemovePowerup", 30.0, @pPlayer, type);
    g_Scheduler.SetTimeout("dmc_PowerupWarning", 27.0, @pPlayer, warnSnd, PlayerKey);
    //g_Scheduler.SetInterval("dmc_DrawPowerups", 1.0, 31, @pPlayer);
    //dmc_DrawPowerups(pPlayer);
    return true;
  }
  void ArtifactSpawn(){
    respawnTime = 300.0;
    BaseSpawn();
  }
}
class dmc_artifact_quad : ScriptBaseEntity, dmc_artifact{
  void Spawn(){
    model = "models/dmc/pow_quad.mdl";
    sound = "dmc/items/damage.wav";
    warnSnd = "dmc/items/damage2.wav";
    useSnd = "dmc/items/damage3.wav";
    type = 1;
    PlayerKey = "$f_dmc_timequad";
    BaseSpawn();
  }
  void ApplyEffect(CBasePlayer@ pPlayer) {
    pPlayer.pev.renderfx = kRenderFxGlowShell;
    pPlayer.pev.rendercolor.z = 255;
    pPlayer.pev.renderamt = 4;
    pPlayer.m_flEffectDamage=5;
  }
}
class dmc_artifact_invuln : ScriptBaseEntity, dmc_artifact{
  void Spawn(){
    model = "models/dmc/pow_invuln.mdl";
    sound = "dmc/items/protect.wav";
    warnSnd = "dmc/items/protect2.wav";
    useSnd = "dmc/items/protect3.wav";
    type = 2;
    PlayerKey = "$f_dmc_timeinvuln";
    BaseSpawn();
  }
  void ApplyEffect(CBasePlayer@ pPlayer) {
    pPlayer.pev.renderfx = kRenderFxGlowShell;
    pPlayer.pev.rendercolor.x = 255;
    pPlayer.pev.renderamt = 4;
    pPlayer.pev.flags |= FL_GODMODE;
  }
}
class dmc_artifact_invis : ScriptBaseEntity, dmc_artifact{
  void Spawn(){
    model = "models/dmc/pow_invis.mdl";
    sound = "dmc/items/inv1.wav";
    warnSnd = "dmc/items/inv2.wav";
    useSnd = "dmc/items/inv3.wav";
    type = 3;
    PlayerKey = "$f_dmc_timeinvis";
    BaseSpawn();
  }
  void ApplyEffect(CBasePlayer@ pPlayer) {
    pPlayer.pev.effects |= EF_NODRAW;
    pPlayer.pev.flags |= FL_NOTARGET;
  }
}
//=== Artifact funcs ===
void dmc_RemovePowerup(CBasePlayer @pPlayer, int kind) {
  CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
  const float quad = pCustom.GetKeyvalue("$f_dmc_timequad").GetFloat();
  const float invuln = pCustom.GetKeyvalue("$f_dmc_timeinvuln").GetFloat();
  const float invis = pCustom.GetKeyvalue("$f_dmc_timeinvis").GetFloat();
  const float time = g_Engine.time + 0.1; // allow a slight error
  if ((kind & 1) != 0 && quad < time)
    pPlayer.pev.rendercolor.z = 0;
    pPlayer.m_flEffectDamage = 1;

  if ((kind & 2) != 0 && invuln < time) {
    pPlayer.pev.flags &= ~FL_GODMODE;
    pPlayer.pev.rendercolor.x = 0;
  }

  if ((kind & 3) != 0 && invis < time) {
    pPlayer.pev.effects &= ~EF_NODRAW;
    pPlayer.pev.flags &= ~FL_NOTARGET;
  }
}
bool dmc_CheckQuad(CBasePlayer @pPlayer) {
  CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
  float quad = pCustom.GetKeyvalue("$f_dmc_timequad").GetFloat();
  return quad > g_Engine.time;
}

void dmc_PowerupWarning(CBasePlayer @pPlayer, string szSound, string szKey) {
  const float time = pPlayer.GetCustomKeyvalues().GetKeyvalue(szKey).GetFloat() - g_Engine.time;
  if (time > 2.0 && time < 4.0) // sanity check in case we picked up another powerup instance
    g_SoundSystem.EmitSoundDyn(pPlayer.edict(), CHAN_ITEM, szSound, 0.7, ATTN_NORM, 0, 100);
}
HookReturnCode PlayerSpawn(CBasePlayer@ pPlayer){
  CustomKeyvalues@ pCustom = pPlayer.GetCustomKeyvalues();
  pCustom.SetKeyvalue("$f_dmc_timequad", 0.0);
  pCustom.SetKeyvalue("$f_dmc_timeinvuln", 0.0);
  pCustom.SetKeyvalue("$f_dmc_timeinvis", 0.0);
  pPlayer.m_flEffectDamage = 1;
  return HOOK_CONTINUE;}
//========= Main =========
void MapInit(){
  g_Module.ScriptInfo.SetAuthor("Script: Zorik\nweapon_custom: W00tguy\nObserver: Adambean\n");

	dmc_precache();
	WeaponCustomMapInit();
	dmc_init();
	TriggerObserver::Init();
}
void MapActivate(){
	WeaponCustomMapActivate();
}
