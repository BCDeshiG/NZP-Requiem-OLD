//==- Afterlife.qc -==//
//=- By MotoLegacy -==//
void() backupWeapon;
void() returnWeapon;
void() InitRounds;
void() turnpower1;
void(entity who, optional float end) GetDown;
void() door_go_up;
void(float which) QuotePlay;

void() ALDie =
{
	local entity tempe;
	tempe = self;
	self = self.owner;
	returnWeapon();
	GetDown(self);
}

void() SubtractAL =
{
	if (self.owner.altime == 0) {
		if (self.owner.weapon == AL)
			ALDie();
		remove(self);
	}
	self.owner.altime -= 0.01;
	if (self.owner.isrevivingal)
		self.owner.altime += 0.01;
	self.nextthink = time + 0.01;
}

void() getUpAL =
{
	local entity dummy;
	dummy = find(world, classname, "dummy_al");
	setorigin(self, dummy.origin);
	remove(dummy);

	local entity alcheck;
	alcheck = find(world, classname, "alcheck");
	remove(alcheck);

	self.gravity *= 10;
	self.classname = "player";
	self.movetype = MOVETYPE_WALK;
	self.isrevivingal = false;
	self.altime = 0;
	returnWeapon();

	if (self.spawnal == 1 && self.hasentered == 0) {
		SetRound(self, rounds);
		PromptLevelChange(self.nextthink + 3, 1, self);
		self.hasentered = 1;
		sound (self, CHAN_AUTO, strcat("sounds/rounds/", roundstr, "/splash.wav"), 1, ATTN_NONE);
		QuotePlay(Q_SPAWN);
	}
}

void() dummyRevive =
{
	//So we don't die out

	other.movetype = MOVETYPE_NONE;
	other.isrevivingal = true;
	Set_W_Frame (63, 79, 0, 0, 0, SUB_Null, GetWeaponModel(self.weapon, 0), false, S_BOTH);
	other.nextthink = time + 1.5;
	other.think = getUpAL;
}

void() touch_dummy =
{
	if (other.classname != "player_al")
		return;
	if (other.isrevivingal == true)
		return;
	useprint(other, 15, 0, 0);
	if (other.button7)
		dummyRevive();
}

void() placeDummy =
{
	local entity dummy;
	dummy = spawn();
	dummy.classname = "dummy_al";
	dummy.solid = SOLID_TRIGGER;
	setmodel(dummy, "models/player.mdl");
	setsize (dummy, VEC_HULL2_MIN, VEC_HULL2_MAX);
	setorigin(dummy, self.origin);
	dummy.frame = 37;
	dummy.touch = touch_dummy;
}

void() stage2 =
{

	placeDummy();
	self.movetype = MOVETYPE_WALK;
	self.view_ofs = VEC_VIEW_OFS;
	self.gravity *= 0.1;

	backupWeapon();
	self.weapon = AL;
	self.currentmag = getWeaponMag(self.weapon);
	self.weaponmodel = GetWeaponModel(self.weapon, 0);
	self.secondaryweapon = 0;
	self.altime = 30;
	SwitchWeapon(AL);

	local entity aldecrease;
	aldecrease = spawn();
	aldecrease.owner = self;

	aldecrease.nextthink = time + 0.01;
	aldecrease.think = SubtractAL;
}

void() enterAfterlife =
{
	other.movetype = MOVETYPE_NONE;
	other.classname = "player_al";
	other.view_ofs = VEC_VIEW_PRONE;
	other.nextthink = time + 2.5;
	other.think = stage2;
}

void() DownAL =
{
	self.perks = 0;
	self.alcount--;
	self.movetype = MOVETYPE_NONE;
	self.classname = "player_al";
	self.view_ofs = VEC_VIEW_PRONE;
	self.nextthink = time + 2.5;
	self.think = stage2;
}

void() touch_panel =
{
	if (other.classname != "player" || other.alcount <= 0)
		return;
	useprint (other, 14, 0, 0);
	if (other.button7 && other.alcount > 0) {
		other.alcount--;
		enterAfterlife();
	}
}

void() al_panel =
{
	self.solid = SOLID_TRIGGER;
	precache_model ("models/machines/albox.mdl");
	setorigin (self, self.origin);
	setmodel (self, "models/machines/albox.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.classname = "al_panel";
	self.touch = touch_panel;
}

void(entity trg) AlReact =
{
	entity old_self, starte;

	switch (trg.classname)
	{
		case "perk_speed":
			trg.effects = EF_GREEN;
			return;
		case "perk_juggernog":
			trg.effects = EF_RED;
			return;
		case "perk_revive":
			trg.effects = EF_BLUE;
			return;
		case "door_nzp":
			old_self = self;
			self = trg;
			starte = self;
			door_go_up();
			trg.classname = "door_open";
			trg = find (trg, targetname, "door_nzp");
			self = old_self;
	}
}

void(entity attacker) activateVoltmeter =
{
	entity tr;
	tr = find (world, targetname, self.target);
	if (attacker.weapon != AL)
		return;
	turnpower1();
	self.takedamage = DAMAGE_NO;
	tr.requirespower = 0;
	AlReact(tr);
}

void() al_voltmeter =
{
	self.solid = SOLID_BBOX;
	precache_model("models/machines/power_switch.mdl");
	setorigin(self, self.origin);
	setmodel(self, "models/machines/power_switch.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.classname = "al_voltmeter";
	self.health = 300;
	self.takedamage = DAMAGE_YES;
}

/* =================
    AFTERLIFE WALLS
   =================*/

void() touch_al_wall =
{
	switch(other.classname) {
		case "player": self.solid = SOLID_BSP; break;
		case "player_al": self.solid = SOLID_NOT; break;
		default: self.solid = SOLID_BSP; break;
	}
}

void() func_al_wall =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	self.classname = "func_al_wall";
	self.touch = touch_al_wall;
}