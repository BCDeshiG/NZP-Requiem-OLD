/* ====================================
    stats.qc - Misc. stats for players
   ==================================== */

void giveAmmo(entity who)
{
	who.currentammo = getWeaponAmmo(who, who.weapon);
	who.secondaryammo = getWeaponAmmo(who, who.secondaryweapon);
	if (who.perks & P_MULE)
		who.thirdammo = getWeaponAmmo(who, who.thirdweapon);
}

void RemovePerk(entity who, float perk)
{
	//temp entity
	local entity fuck;
	fuck = spawn();

	//Backup player's perks
	if ((who.perks & P_REVIVE) && perk != P_REVIVE)
		fuck.perks = fuck.perks | 8;

	if ((who.perks & P_FLOP) && perk != P_FLOP)
		fuck.perks = fuck.perks | 16;

	if ((who.perks & P_JUG) && perk != P_JUG)
		fuck.perks = fuck.perks | 1;

	if ((who.perks & P_STAMIN) && perk != P_STAMIN)
		fuck.perks = fuck.perks | 32;

	if ((who.perks & P_SPEED) && perk != P_SPEED)
		fuck.perks = fuck.perks | 4;

	if ((who.perks & P_DOUBLE) && perk != P_DOUBLE)
		fuck.perks = fuck.perks | 2;

	if ((who.perks & P_MULE) && perk != P_MULE)
		fuck.perks = fuck.perks | 64;

	if ((who.perks & P_DEAD) && perk != P_DEAD)
		fuck.perks = fuck.perks | 128;

	if ((who.perks & P_BLOOD) && perk != P_BLOOD)
		fuck.perks = fuck.perks | 256;

	if ((who.perks & P_CANDO) && perk != P_CANDO)
		fuck.perks = fuck.perks | 512;

	//reset player's perks and give the temp entity's perks
	who.perks = 0;
	who.perks = fuck.perks;

	//update the hud
	SetPerk(who, who.perks);

	//kill fuck
	remove(fuck);
}