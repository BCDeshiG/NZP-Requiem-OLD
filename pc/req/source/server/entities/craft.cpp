/* ==================================
                CRAFT.QC
    AUTHOR: IAN BOWLING / MOTOLEGACY
   ================================== */
void PlaceShield() =
{
	precache_model("models/craft/g_shield.mdl");
	local entity shield;
	shield = spawn();
	setorigin(shield, self.origin + '0 0 26');
	setmodel(shield, "models/craft/g_shield.mdl");
	self.craft = 1;
}

float checkParts(entity who, float item)
{
	switch (item) {
		case SHIELD:
			if (who.inventory & PART_DOLLY && who.inventory & PART_GRATE && who.inventory & PART_CLAMP)
				return 1;
		default:
			return 0;
	}
}

void touch_table() =
{
	if (other.classname != "player" || other.weaponmodel == "models/craft/v_craft.mdl")
		return;

	if (!other.craft && !self.craft) {
		useprint(other, 23, 0, 0);
	} else if (self.craft && !other.special) {
		useprint(other, 24, 0, 1);
	}

	if (other.button7) {
		if (!self.craft && checkParts(other, SHIELD)) {
			local entity tempe;
			tempe = self;
			self = other;
			Set_W_Frame (0, 22, 0, 0, PERK, ReturnWeaponModel, "models/craft/v_craft.mdl", true, S_BOTH);
			self.movetype = MOVETYPE_NONE;
			self.crafttime = time + 2.8;
			self.craft = 1;
			other = self;
			self = tempe;
			self.think = PlaceShield;
			self.nextthink = time + 2.8;
		} else if (!self.craft && !checkParts(other, SHIELD)) {
			useprint(other, 26, 0, 0);
		}
	}
}

void touch_part() =
{
	if (other.classname != "player")
		return;

	useprint(other, 25, 0, 0);

	if (other.button7) {
		switch(self.classname) {
			case "part_dolly":
				other.inventory = other.inventory | PART_DOLLY;
			case "part_clamp":
				other.inventory = other.inventory | PART_CLAMP;
			case "part_grate":
				other.inventory = other.inventory | PART_GRATE;
		}

		remove(self);
	} 
}

void crafting_table() = 
{
	precache_model("models/craft/table.mdl");

	self.classname = "crafting_table";
	setorigin(self, self.origin);
	setmodel(self, "models/craft/table.mdl"); 
	self.solid = SOLID_TRIGGER;
	self.touch = touch_table;
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}

void part_dolly() =
{
	precache_model("models/craft/dolly.mdl");

	self.classname = "part_dolly";
	self.touch = touch_part;
	setorigin(self, self.origin);
	setmodel(self, "models/craft/dolly.mdl"); 
	self.solid = SOLID_TRIGGER;
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}

void part_grate() =
{
	precache_model("models/craft/grate.mdl");

	self.classname = "part_grate";
	self.touch = touch_part;
	setorigin(self, self.origin);
	setmodel(self, "models/craft/grate.mdl"); 
	self.solid = SOLID_TRIGGER;
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}

void part_clamp() =
{
	precache_model("models/craft/clamps.mdl");

	self.classname = "part_clamp";
	self.touch = touch_part;
	setorigin(self, self.origin);
	setmodel(self, "models/craft/clamps.mdl"); 
	self.solid = SOLID_TRIGGER;
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}