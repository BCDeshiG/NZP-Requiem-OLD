//==- Afterlife.qc -==//
//=- By MotoLegacy -==//
void() backupWeapon;
void() returnWeapon;
void() InitRounds;
void() turnpower1;

void() revertDoor =
{
	local entity ald;
	ald = find(world, classname, "func_al_wall");

	ald.velocity_z *= -100;
}

void() ALdoor =
{
	local entity ald;
	ald = find(world, classname, "func_al_wall");

	ald.velocity_z *= 100;
}

void() getUpAL =
{
	//revertDoor();

	local entity dummy;
	dummy = find(world, classname, "dummy_al");
	setorigin(self, dummy.origin);
	remove(dummy);

	self.gravity *= 2;
	self.classname = "player";
	self.movetype = MOVETYPE_WALK;
	self.isrevivingal = false;
	returnWeapon();

	if (self.spawnal == 1 && self.hasentered == 0) {
		SetRound(self, rounds);
		PromptLevelChange(self.nextthink + 3, 1, self);
		self.hasentered = 1;
		sound (self, CHAN_AUTO, strcat("sounds/rounds/", roundstr, "/splash.wav"), 1, ATTN_NONE);
	}
}

void() dummyRevive =
{
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
	//ALdoor();

	placeDummy();
	self.movetype = MOVETYPE_WALK;
	self.view_ofs = VEC_VIEW_OFS;
	self.gravity *= 0.5;

	backupWeapon();
	self.weapon = AL;
	self.currentmag = getWeaponMag(self.weapon);
	self.weaponmodel = GetWeaponModel(self.weapon, 0);
	SwitchWeapon(AL);
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

void(entity trg) AlLights =
{
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
	AlLights(tr);
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