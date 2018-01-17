//
// damage.qc -- used for any sort of down, hit, etc that the player or entity experiences
//

void() EndGame_Restart = 
{
	localcmd("restart");
}

// Fade to black function, creates another think for restart
void() EndGame_FadePrompt =
{
	PromptLevelChange(time + 6, 2, self);
	self.think = EndGame_Restart;
	self.nextthink = time + 5;
}

//Actual endgame function, all zombies die, music plays
void() EndGame =
{
	local entity oldself;
	local entity who;

	self.health = 0;
	//WriteByte (MSG_ALL, SVC_INTERMISSION);
	self.origin = '0 0 0';
	setorigin (self, self.origin);
	self.velocity = '0 0 0';
	sound (self, CHAN_AUTO, "sounds/music/end.wav", 1, ATTN_NORM);

	oldself = self;
	
	who = find(world,classname,"ai_zombie");
	while(who != world)
	{
		if(who.health)
		{
			self = who;
			self.th_die();
			self = oldself;
		}
		
		who = find(who,classname,"ai_zombie");
	}
	
	self.think = EndGame_FadePrompt;
	self.nextthink = time + 33; //33
}

// removes revive icon from downed player heads, used as a recursive think function
void() remove_revive =
{
	if (self.owner.beingrevived)
		setmodel (self, "progs/Sprites/revive_white.spr");
	else
		setmodel (self, "progs/Sprites/revive.spr");

	if (!self.owner.downed || self.owner.isspec)
		SUB_Remove ();
	else {
		self.think = remove_revive;
		self.nextthink = time + 0.1;
	}
}

// when dead and other players exist and are alive, throw user into spectate mode
void() startspectate =
{
	if (!self.downed)
		return;
		
	if (self.beingrevived)
	{
		self.think = startspectate;
		self.nextthink = time + 0.1;
		return;
	}
	
	self.downedloop = 0;
	self.beingrevived = false;
	self.model = "";
	setmodel(self, self.model);
	self.health = 100;
	self.weaponmodel = "";
	self.weapon2model = "";
	self.downed = 0;
	self.frame = 0;

	UpdateVmodel(self.weaponmodel, GetWepSkin(self.weapon));
	UpdateV2model(self.weapon2model, GetWepSkin(self.weapon));
	
	SpectatorSpawn();
}

// searches for players that are alive given which clients have which playernumbers
//      Returns 1 if there IS someone in the world that's not downed
float() PollPlayersAlive = 
{
	float i, gotalive;
	entity playerent;
	
	gotalive = 0;
	
	for (i = 1; i <= 4; i++)
	{
		playerent = findfloat(world, playernum, i);
		
		if (playerent) {
			if (!playerent.downed && !playerent.isspec) {
				gotalive = 1;
				break;
			}
		}
	}
	
	return gotalive;
}

// Endgamesetup -- think function for setting up the death of everyone
void() EndGameSetup =
{
	game_over = true;
	self.health = 10;
	self.think = EndGame;
	self.nextthink = time + 5;
	self.weapon = 0;
	self.currentammo = 0;
	self.currentmag = 0;
	self.weaponmodel = "";
	self.weapon2model = "";
	self.animend = SUB_Null;
	self.perks = 0;
	self.isspec = true;
	SetPerk(self, self.perks);
	SwitchWeapon(0);		
    return;
}

// rec_downed is used as a recursive loop where we consistently check to see if ALL players are downed
//    if they aren't dead, we keep looping until our OWN death (45 seconds, so 450 loops)
void() rec_downed = 
{
	self.downedloop++;
	if (self.downedloop == 450) {
		startspectate();
		return;
	}
	
	float gotalive = PollPlayersAlive();
	
	if (!gotalive) {
		EndGameSetup();
		return;
	}
	
	self.think = rec_downed;
	self.nextthink = time + 0.1;
}

void() removeDummy =
{
	local entity tempe;
	tempe = spawn();
	SetPerk(self.owner, self.perks);
	setorigin(self.owner, self.origin);
	tempe = self;
	self = self.owner;
	returnWeapon();
	self.owner = self;
	self = tempe;
	remove(self);
}

void() touchDummy =
{
	if (other.classname != "player")
		return;

	local float revtime;
	if (other.perks & P_REVIVE)
		revtime = 120;
	else
		revtime = 240;

	if (!other.isrevived)
		useprint(other, 13, 0, 0);
	if (other.button7 && !other.isrevived) {
		local entity tempe;
		tempe = self;
		self = other;
		Set_W_Frame (0, 21, 0, 0, SPRINT, SUB_Null, "models/v_morphine.mdl", false, S_BOTH);
		other = self;
		self = tempe;
		other.isrevived = 1;
		other.revivingwho = 1;
	}
	if (other.revivingwho)
		other.revivingwho += 1;
	if (other.revivingwho >= revtime)
		removeDummy();
}

void() spawnWho =
{
	local entity spawn = find(world, classname, "info_player_start");
	setorigin(self.owner, spawn.origin);
	setmodel(self, "models/player.mdl");
	self.frame = 37;
	self.solid = SOLID_TRIGGER;

	self.owner.movetype = MOVETYPE_WALK;
	self.owner.view_ofs = VEC_VIEW_OFS;
	self.owner.classname = "player";

	self.touch = touchDummy;

	self.owner.weapon = W_COLT;
	self.owner.currentmag = 8;
	self.owner.currentammo = 32;
	SwitchWeapon(self.weapon);
	self.owner.secondaryweapon = 0;
	self.owner.thirdweapon = 0;
}

void() WhoDown =
{
	RemovePerk(self, P_WHO);
	local entity who;
	who = spawn();
	who.perks = self.perks;
	self.perks = 0;
	SetPerk(self, self.perks);
	setorigin(who, self.origin);
	who.owner = self;
	who.think = spawnWho;
	who.nextthink = time + 2;
	self.view_ofs = VEC_VIEW_PRONE;
	self.movetype = MOVETYPE_NONE;
	self.classname = "downed_who"; //tells zombs to stop trying to kill us

	backupWeapon();
}

void() TombQuit =
{
	useprint(self.owner, 22, 0, 0);
	self.nextthink = time + 0.1;
}

void() DownTomb =
{
	local entity useprintguy;
	useprintguy = spawn();
	RemovePerk(self, P_TOMB); //don't want the record of having tombstone..
	BackUpPerks(self);
	self.view_ofs = VEC_VIEW_PRONE;
	self.classname = "downed";

	backupWeapon();

	if (self.weapon != W_BIATCH) {
		self.weapon = W_BIATCH;
		self.currentmag = 6;
		self.currentmag2 = 6;
		self.currentammo = 12;
		SwitchWeapon(self.weapon);
	}

	useprintguy.owner = self;
	useprintguy.think = TombQuit;
	useprintguy.nextthink = time + 0.1;
}

void(entity who, optional float end) GetDown =
{
	if (who.alcount > 0 && who.aldowned == 0) {
		DownAL();
		return;
	}
	float startframe;
	float endframe;
	local string modelname;
	
	playdown();
	
	who.view_ofs = '0 0 -15';
	who.velocity = '-80 0 -80';           			// Stop any old movement
	who.zoom = 0;
	who.downed = true;
	who.movetype = MOVETYPE_NONE;
	
	float gotalive = PollPlayersAlive();
	
	if (!(who.perks & P_REVIVE) || (coop && !gotalive) || end)
	{
		EndGameSetup();
		return;
	}
	else if (coop) {
	who.health = 19; 
	who.downed = true;
	} else {
		who.health = 19;
	}
	
	if ((who.perks & P_REVIVE) && !coop) {	
		who.progress_bar = 10 + time;     
		who.progress_bar_time = 10;
		who.progress_bar_percent = 1;
	}
	who.points = 10*rint((who.points*0.95)/10);
	addmoney(who, 0, true);						// used to call a broadcast
	BroadcastMessage(time + 3, 2);
	
	who.perks = 0;
	SetPerk(who, who.perks);
	who.weaponbk = who.weapon;
	who.currentammobk = who.currentammo;
	who.currentmagbk = who.currentmag;
	who.currentmagbk2 = who.currentmag2;
	if (who.tertiary == who.weapon)
		who.weapon = 0;
	else if (who.tertiary == who.secondaryweapon)
		who.secondaryweapon = 0;
	else
		who.thirdweapon = 0;
	if (who.weapon == W_BIATCH || who.secondaryweapon == W_BIATCH || who.thirdweapon == W_BIATCH || who.progress_bar_percent > 0) {
		who.weapon = W_BIATCH;
		who.currentammo = 12;
		who.currentmag = 6;
		who.currentmag2 = 6;
	} else {
		who.weapon = W_COLT;
		who.currentammo = 16;
		who.currentmag = 8;
	}
      
  	modelname = GetWeaponModel(who.weapon, 0);
	who.weaponmodel = modelname;
	SwitchWeapon(who.weapon);
	
	startframe = GetFrame(who.weapon,TAKE_OUT_START);
	endframe = GetFrame(who.weapon,TAKE_OUT_END);
	Set_W_Frame (startframe, endframe, 0, 0, 0, SUB_Null, modelname, false, S_BOTH);

	if (!coop)
		return;
	
	local entity revive;
	
	revive = spawn ();
	revive.owner = who;
	revive.movetype = MOVETYPE_NONE;
	revive.solid = SOLID_NOT;
	revive.think = remove_revive;
	revive.nextthink = time + 0.1;

	setmodel (revive, "progs/Sprites/revive.spr");
	revive.origin = who.origin + VEC_VIEW_OFS;
	setorigin (revive, revive.origin);
	
	SetPerk(who, 0);
	
	who.think = rec_downed;
	who.nextthink = time + 0.1;
}

void () GetUp =
{
	local string modelname;
	float startframe;
	float endframe;
	
	playgetup();				// animation
	
	self.view_ofs = VEC_VIEW_OFS;
	self.health = 100;
	self.downedloop = 0;		// used for death timing vs endgame
	self.downed = 0;
	self.classname = "player";
	if (self.weaponbk)
	{
		self.weapon = self.weaponbk;
		self.currentammo = self.currentammobk;
		self.currentmag = self.currentmagbk;
		self.currentmag2 = self.currentmagbk2;
	}	
	modelname = GetWeaponModel(self.weapon, 0);
	self.weaponmodel = modelname;
	SwitchWeapon(self.weapon);
	self.movetype = MOVETYPE_WALK;
  
  	startframe = GetFrame(self.weapon,TAKE_OUT_START);
	endframe = GetFrame(self.weapon,TAKE_OUT_END);
	Set_W_Frame (startframe, endframe, 0, 0, 0, SUB_Null, modelname, false, S_BOTH);
	
};

// poll checking whether to see if our revive invoke is active
void(entity ent) CheckRevive =
{
	if (self.invoke_revive) {
		GetUp();
		self.invoke_revive = 0;
	}
}

void(entity attacker, float d_style) DieHandler =
{
    float t;

    t = random();

    if (self.classname == "ai_zombie" || self.classname == "ai_dog") {
        self.th_die();
    }

    if (attacker.classname == "player") {
        if (d_style == S_NORMAL) {
            addmoney(attacker, 60, true);
            total_powerup_points = total_powerup_points + 60;
        }
		else if (d_style == S_KNIFE){
			addmoney(attacker, 130, true);
			total_powerup_points = total_powerup_points + 130;
		}
    }
}

void(entity victim,entity attacker, float damage, float d_style) DamageHandler = {
	entity old_self;
	if (victim.classname == "ai_zombie" || victim.classname == "ai_dog") {

		if (attacker.classname == "player" && (victim.health - damage)> 0) {
			addmoney(attacker, 10, 1);
        }

		victim.health = victim.health - damage;

		if (d_style == S_EXPLOSIVE) {
			if (victim.health < z_health*0.5)
			{
				if (victim.crawling != TRUE && !(victim.health <= 0) && crawler_num < 5 && victim.classname != "ai_dog")
				{
					makeCrawler(victim);	
				}
				else
				{
					if (attacker.classname == "player" && (victim.health - damage)> 0)
					addmoney(attacker, 10, 1);
				}
			}
			else
				victim.th_die();	
				
			if (victim.health <= 0)
				addmoney(attacker, 60, 1);
		}

		if (victim.health <= 0 || instakill_finished) {
			old_self = self;
			self = victim;
			DieHandler(attacker, d_style);
			self = old_self;
		}
	} else if (victim.classname == "player" && !victim.downed) {
		if (victim.flags & FL_GODMODE) {
			return;
		}
		
		if (victim.perks & P_JUG)
			damage = ceil(damage*0.5);
		
		victim.health = victim.health - damage;
		victim.health_delay = time + 2;

		if (victim.health <= 20)
		{
			old_self = self;
			self = victim;
			if (self.perks & P_TOMB) {
				self.health = 100;
				DownTomb();
			} else if (self.perks & P_WHO) {
				self.health = 100;
				WhoDown();
			}
			self = old_self;
		}
	}
}

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
float(entity targ, entity inflictor) CanDamage =
{
	if (targ.flags == FL_GODMODE)
    return FALSE;
// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
    
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};

void(entity inflictor, entity attacker, float damage2, float mindamage, float radius) DamgageExplode =
{
	local	float 	final_damage;
	local	entity	ent;

	local float multi,r;
	ent = findradius(inflictor.origin, radius);
	
	while (ent)
	{
		if(ent.classname == "player")
		{
      if (ent.perks & P_FLOP)
        final_damage = 0;
      else
      {
        final_damage = radius - vlen(inflictor.origin - ent.origin);
        if(final_damage < 0)
          continue;
        
        if (final_damage > radius * 0.6)
          final_damage = 100;
          
          if (final_damage < other.health)
          {
            addmoney(self, 10, 0);
          }
          else if (final_damage > other.health)
          {
              addmoney(self, 60, 0);
              }
        else
        {
          final_damage /= radius;
          final_damage *= 60;
        }
        DamageHandler (attacker, attacker, final_damage, S_EXPLOSIVE);
    }
		}
		else if (ent.takedamage && ent.classname != "ai_zombie_head" && ent.classname != "ai_zombie_larm" && ent.classname != "ai_zombie_rarm")
		{			
			r = rounds;
			multi = 1.07;
			while(r > 0)
			{
				multi *= 1.05;
				r --;
			}
			
			if (mindamage == 75)
        final_damage = (200 * multi) + 185;
      else
        final_damage = (mindamage + damage2)/2;
			
			if (final_damage > 0)
			{
				/* ndaekill = true; */
				if (CanDamage (ent, inflictor))
					DamageHandler (ent, attacker, final_damage, S_EXPLOSIVE);
				/* kill = false; */
			}
		}
		ent = ent.chain;
	}
};