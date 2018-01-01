void setup_bank(entity who);

void create_bank_data(entity who)
{
	float file;
	string h;
	h = strcat("bank/", mapname, ".bnk");
	file = fopen (h, FILE_WRITE);
	fputs(file,"0\n");
	fclose(file);
	setup_bank(who);
}

void setup_bank(entity who)
{
	float file;
	string h;
	h = strcat("bank/", mapname, ".bnk");
	file = fopen (h, FILE_READ);
	if (file == -1) {
		fclose(file);
		create_bank_data(who);
		return;
	}
	who.balance = stof(fgets(file));
	fclose(file);
}

void update_bank(entity who)
{
	float file;
	string h, oof;
	oof = ftos(who.balance);
	h = strcat("bank/", mapname, ".bnk");
	file = fopen (h, FILE_WRITE);
	fputs(file, oof);
	fclose(file);
}

void bank_withdrawal()
{
	if (other.classname != "player")
		return;

	useprint(other, 19, 0, 0);
	if (other.button7 && other.bankdelay < time) {
		other.bankdelay = 0.2 + time;
		if (other.balance <= 0) {
			sound (other, CHAN_ITEM, "sounds/misc/denybuy.wav", 1, ATTN_NORM);
			return;
		}
		addmoney(other, 1000, 0);
		other.balance -= 1000;
		update_bank(other);
		sound (other, CHAN_ITEM, "sounds/misc/ching.wav", 1, ATTN_NORM);
	}
}

void func_bank_withdrawal()
{
	self.classname = "func_bank_withdrawal";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.touch = bank_withdrawal;
	precache_model(self.model);
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}

void bank_deposit()
{
	if (other.classname != "player")
		return;

	useprint(other, 20, 0, 0);
	if (other.button7 && other.bankdelay < time) {
		other.bankdelay = 0.2 + time;
		if (other.points <= 1100) {
			sound (other, CHAN_ITEM, "sounds/misc/denybuy.wav", 1, ATTN_NORM);
			return;
		}
		addmoney(other, -1100, 0);
		other.balance += 1000;
		update_bank(other);
		sound (other, CHAN_ITEM, "sounds/misc/ching.wav", 1, ATTN_NORM);
	}
}

void func_bank_deposit()
{
	self.classname = "func_bank_deposit";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.touch = bank_deposit;
	precache_model(self.model);
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
}