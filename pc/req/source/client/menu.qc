//==-           Menu.qc           -==//
//==- Menu Revamped By MotoLegacy -==//
void() DumpSettings;
float menuTime; //Used to prevent flickering

/* ===========
    Main Menu
   =========== */

#define M_Menu_Main_CursorMax	5
float M_Menu_Main_Cursor;

void() M_Menu_Main_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Requiem", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Main_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Solo", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Main_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Cooperative (N/A)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Main_Cursor != 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Achievements (N/A)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Main_Cursor != 3)
		drawstring([0.025*g_width, 0.275*g_height, 0], "Settings (In Progress)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Main_Cursor != 4)
		drawstring([0.025*g_width, 0.325*g_height, 0], "Credits (N/A)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Main_Cursor != 5)
		drawstring([0.025*g_width, 0.375*g_height, 0], "Quit", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	if (M_Menu_Main_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Solo", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Cooperative (N/A)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Achievements (N/A)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 3)
		drawstring([0.025*g_width, 0.275*g_height, 0], "Settings (In Progress)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 4)
		drawstring([0.025*g_width, 0.325*g_height, 0], "Credits (N/A)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 5)
		drawstring([0.025*g_width, 0.375*g_height, 0], "Quit", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	//Version info
	drawstring([0.025*g_width, 0.900*g_height, 0], "Requiem Alpha II", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Main_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Main_Cursor++;
		if (M_Menu_Main_Cursor > M_Menu_Main_CursorMax)
			M_Menu_Main_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Main_Cursor--;
		if (M_Menu_Main_Cursor == -1)
			M_Menu_Main_Cursor = M_Menu_Main_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Main_Cursor) {
			case 0: in_menu = MENU_SINGLE; menuTime = time + 0.2; break;
			case 1: localcmd("echo Unavailable at this time\n"); menuTime = time + 0.2; break;
			case 2: localcmd("echo Unavailable at this time\n"); menuTime = time + 0.2; break;
			case 3: in_menu = MENU_SETTINGS; setMen = 0; menuTime = time + 0.2; break;
			case 4: in_menu = MENU_CREDITS; menuTime = time + 0.2; break; //motolegacy -- credits are fucked :pp
			case 5: localcmd("quit\n"); break;
		}
	}
}

/* ======
    Solo
   ====== */

#define M_Menu_Solo_CursorMax	2
float M_Menu_Solo_Cursor;

void() M_Menu_Solo_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Map List", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Solo_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Classic", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Solo_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "NZ:P Beta", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Solo_Cursor != 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Community Maps", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	if (M_Menu_Solo_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Classic", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Maps from the Call of Duty Series", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Solo_Cursor == 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "NZ:P Beta", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Maps from Nazi Zombies: Portable Beta", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Solo_Cursor == 2) {
		drawstring([0.025*g_width, 0.225*g_height, 0], "Community Maps", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Maps made by the community", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Solo_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Solo_Cursor++;
		if (M_Menu_Solo_Cursor > M_Menu_Solo_CursorMax)
			M_Menu_Solo_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Solo_Cursor--;
		if (M_Menu_Solo_Cursor == -1)
			M_Menu_Solo_Cursor = M_Menu_Solo_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_MAIN;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Solo_Cursor) {
			case 0: in_menu = MENU_CLASSIC; menuTime = time + 0.2; break;
			case 1: in_menu = MENU_BETA; menuTime = time + 0.2; break;
			case 2: in_menu = MENU_COMMUNITY; menuTime = time + 0.2; break;
		}
	}
}

/* ==============
    Classic Maps
   ============== */

#define M_Menu_Classic_CursorMax	1
float M_Menu_Classic_Cursor;

void() M_Menu_Classic_Draw =
{

	drawstring([0.025*g_width, 0.050*g_height, 0], "Classic Maps", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Classic_Cursor != 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Nacht der Untoten", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	}
	if (M_Menu_Classic_Cursor != 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "Kino der Toten", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	}

	//Selection

	if (M_Menu_Classic_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Nacht der Untoten", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "You drove them deep into the heart of the Reich.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "You thought they were dead. You were wrong.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawpic([0.025 * g_width, 0.550 * g_height, 0], "menu/ndu", [g_width * 0.25, g_height * 0.25, 1], [1,1,1], 1);
	}
	if (M_Menu_Classic_Cursor == 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "Kino der Toten", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "Battle the undead in this theatrical installment.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "New twists could uncover the final plan. It's show time!", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawpic([0.025 * g_width, 0.550 * g_height, 0], "menu/kino", [g_width * 0.25, g_height * 0.25, 1], [1,1,1], 1);
	}

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Load Map      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Classic_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Classic_Cursor++;
		if (M_Menu_Classic_Cursor > M_Menu_Classic_CursorMax)
			M_Menu_Classic_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Classic_Cursor--;
		if (M_Menu_Classic_Cursor == -1)
			M_Menu_Classic_Cursor = M_Menu_Classic_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_SINGLE;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Classic_Cursor) {
			case 0: localcmd("map ndu\n"); break;
			case 1: localcmd("map Kino_Der_Toten\n"); break;
		}
	}
}

/* ==========
	Settings
   ========== */

#define M_Menu_GSettings_CursorMax 	2
float M_Menu_GSettings_Cursor;

void() M_Menu_GSettings_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Game Settings", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_GSettings_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "FOV", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_GSettings_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Running While Sprinting", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_GSettings_Cursor != 2)
		drawstring([0.025*g_width, 0.900*g_height, 0], "Back", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_GSettings_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "FOV", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_GSettings_Cursor == 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Running While Sprinting", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_GSettings_Cursor == 2)
		drawstring([0.025*g_width, 0.900*g_height, 0], "Back", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	drawstring([0.900*g_width, 0.125*g_height, 0], ftos(cvar("fov")), [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (cvar("sprintrun"))
		drawstring([0.900*g_width, 0.175*g_height, 0], "On", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	else
		drawstring([0.900*g_width, 0.175*g_height, 0], "Off", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter/Apply      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_GSettings_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_GSettings_Cursor++;
		if (M_Menu_GSettings_Cursor > M_Menu_GSettings_CursorMax)
			M_Menu_GSettings_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_GSettings_Cursor--;
		if (M_Menu_GSettings_Cursor == -1)
			M_Menu_GSettings_Cursor = M_Menu_GSettings_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (M_Menu_GSettings_Cursor == 0)
			localcmd(strcat("fov ", ftos(cvar("fov") - 5)));
		if (M_Menu_GSettings_Cursor == 1) {
			if (cvar("sprintrun"))
				localcmd("sprintrun 0");
			else
				localcmd("sprintrun 1");
		}
		if (M_Menu_GSettings_Cursor == 2) {
			DumpSettings();
			in_menu = MENU_SETTINGS;
		}
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (M_Menu_GSettings_Cursor == 0)
			localcmd(strcat("fov ", ftos(cvar("fov") + 5)));
		if (M_Menu_GSettings_Cursor == 1) {
			if (cvar("sprintrun"))
				localcmd("sprintrun 0");
			else
				localcmd("sprintrun 1");
		}
		if (M_Menu_GSettings_Cursor == 2) {
			DumpSettings();
			in_menu = MENU_SETTINGS;
		}
		menuTime = 0.2 + time;
	}
}

#define M_Menu_VSettings_CursorMax 	1
float M_Menu_VSettings_Cursor;

void() M_Menu_VSettings_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Video Settings", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_VSettings_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Fullbright", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_VSettings_Cursor != 1)
		drawstring([0.025*g_width, 0.900*g_height, 0], "Back", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_VSettings_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Fullbright", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_VSettings_Cursor == 1)
		drawstring([0.025*g_width, 0.900*g_height, 0], "Back", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	if (cvar("r_fullbright"))
		drawstring([0.900*g_width, 0.125*g_height, 0], "On", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	else
		drawstring([0.900*g_width, 0.125*g_height, 0], "Off", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter/Apply      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_VSettings_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_VSettings_Cursor++;
		if (M_Menu_VSettings_Cursor > M_Menu_VSettings_CursorMax)
			M_Menu_VSettings_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_VSettings_Cursor--;
		if (M_Menu_VSettings_Cursor == -1)
			M_Menu_VSettings_Cursor = M_Menu_VSettings_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (M_Menu_VSettings_Cursor == 0) {
			if (cvar("r_fullbright"))
				cvar_set("r_fullbright", "0");
			else
				cvar_set("r_fullbright", "1");
			localcmd("vid_restart\n");
		}
		if (M_Menu_VSettings_Cursor == 1) {
			DumpSettings();
			in_menu = MENU_SETTINGS;
		}
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (M_Menu_VSettings_Cursor == 0) {
			if (cvar("r_fullbright"))
				cvar_set("r_fullbright", "0");
			else
				cvar_set("r_fullbright", "1");
			localcmd("vid_restart\n");
		}
		if (M_Menu_VSettings_Cursor == 1) {
			DumpSettings();
			in_menu = MENU_SETTINGS;
		}
		menuTime = 0.2 + time;
	}
}

#define M_Menu_Settings_CursorMax 	1
float M_Menu_Settings_Cursor;

void() M_Menu_Settings_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Settings", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Settings_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Video Settings", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Settings_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Game Settings", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_Settings_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Video Settings", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Settings_Cursor == 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Game Settings", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	//Selection

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter/Apply      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Settings_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Settings_Cursor++;
		if (M_Menu_Settings_Cursor > M_Menu_Settings_CursorMax)
			M_Menu_Settings_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Settings_Cursor--;
		if (M_Menu_Settings_Cursor == -1)
			M_Menu_Settings_Cursor = M_Menu_Settings_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (!setMen)
			in_menu = MENU_MAIN;
		else
			in_menu = MENU_PAUSE;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Settings_Cursor) {
			case 0: in_menu = MENU_VSET; menuTime = 0.2 + time; break;
			case 1: in_menu = MENU_GSET; menuTime = 0.2 + time; break;
		}
	}
}

/* ===========
	Beta Maps
   =========== */

#define M_Menu_Beta_CursorMax 	1
float M_Menu_Beta_Cursor;

void() M_Menu_Beta_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "NZ:P Beta Maps", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Beta_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Warehouse", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Beta_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Christmas Special", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_Beta_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Warehouse", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "Old warehouse full of zombies! Fight your way", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "to the power switch through the hordes.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawpic([0.025 * g_width, 0.550 * g_height, 0], "menu/warehouse", [g_width * 0.25, g_height * 0.25, 1], [1,1,1], 1);
	}
	if (M_Menu_Beta_Cursor == 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "Christmas Special", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "No Santa this year, but I'm sure you will get some", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "presents from the undead.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawpic([0.025 * g_width, 0.550 * g_height, 0], "menu/cs", [g_width * 0.25, g_height * 0.25, 1], [1,1,1], 1);
	}

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Load Map      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Beta_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Beta_Cursor++;
		if (M_Menu_Beta_Cursor > M_Menu_Beta_CursorMax)
			M_Menu_Beta_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Beta_Cursor--;
		if (M_Menu_Beta_Cursor == -1)
			M_Menu_Beta_Cursor = M_Menu_Beta_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_SINGLE;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Beta_Cursor) {
			case 0: localcmd("map warehouse\n"); break;
			case 1: localcmd("map christmas_special\n"); break;
		}
	}
}

/* ================
	Community Maps
   ================ */

#define M_Menu_Community_CursorMax 	3
float M_Menu_Community_Cursor;

void() M_Menu_Community_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Community Maps", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Community_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Cavern - By Naievil", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Community_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Farmhouse - By Slugparty", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Community_Cursor != 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Woodhut - By True Nightmare", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Community_Cursor != 3)
		drawstring([0.025*g_width, 0.275*g_height, 0], "Corner - By Naievil", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_Community_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Cavern - By Naievil", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "From the 2015 NZ:P Mapping Competition comes a", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "collapsed cavern in the process of flooding.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Community_Cursor == 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "Farmhouse - By Slugparty", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "Farmhouse from SAS: Zombie Assault 3 recreated", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "in NZ:P.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Community_Cursor == 2) {
		drawstring([0.025*g_width, 0.225*g_height, 0], "Woodhut - By True Nightmare", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "Woodhut from NZ:P Beta ported by Naievil. One box.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Four windows. Four perks. How long will you last?", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Community_Cursor == 3) {
		drawstring([0.025*g_width, 0.275*g_height, 0], "Corner - By Naievil", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Challenge yourself in another small map by Naievil.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}

	//Selection

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Load Map      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Community_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Community_Cursor++;
		if (M_Menu_Community_Cursor > M_Menu_Community_CursorMax)
			M_Menu_Community_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Community_Cursor--;
		if (M_Menu_Community_Cursor == -1)
			M_Menu_Community_Cursor = M_Menu_Community_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_SINGLE;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Community_Cursor) {
			case 0: localcmd("map cavern\n"); break;
			case 1: localcmd("map farmhouse\n"); break;
			case 2: localcmd("map woodhut\n"); break;
			case 3: localcmd("map corner\n"); break;
		}
	}
}

/* =========
    Credits
   ========= */

//Let's sacriface optimization for scrolling... yay..
float creditsHeight;
float hasStartedCredits;

void() M_Menu_Credits_Draw =
{
	setcursormode(TRUE,"menu/cursor");
	float w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22;
	float x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22;

	if (hasStartedCredits == 0) {
		creditsHeight = 0.950;
		hasStartedCredits = 1;
	}

	x1 = stringwidth("Nazi Zombies: Portable", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w1 = (g_width - x1)/2;
	x2 = stringwidth("PROGRAMMING:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w2 = (g_width - x2)/2;
	x3 = stringwidth("Jukki", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w3 = (g_width - x3)/2;
	x4 = stringwidth("Blubswillrule", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w4 = (g_width - x4)/2;
	x5 = stringwidth("MAPPING:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w5 = (g_width - x5)/2;
	x6 = stringwidth("Ju[s]tice", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w6 = (g_width - x6)/2;
	x7 = stringwidth("MODELING & GRAPHICS:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w7 = (g_width - x7)/2;
	x8 = stringwidth("Blubswillrule", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w8 = (g_width - x8)/2;
	x9 = stringwidth("Ju[s]tice", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w9 = (g_width - x9)/2;
	x10 = stringwidth("SOUND DESIGN:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w10 = (g_width - x10)/2;
	x11 = stringwidth("Blubswillrule", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w11 = (g_width - x11)/2;
	x12 = stringwidth("Biodude", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w12 = (g_width - x12)/2;
	x13 = stringwidth("Nazi Zombies Portable: Unofficial Patch", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w13 = (g_width - x13)/2;
	x14 = stringwidth("PROGRAMMING:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w14 = (g_width - x14)/2;
	x15 = stringwidth("PerikiyoXD", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w15 = (g_width - x15)/2;
	x16 = stringwidth("Naievil", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w16 = (g_width - x16)/2;
	x17 = stringwidth("Nazi Zombies Portable: Requiem", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w17 = (g_width - x17)/2;
	x18 = stringwidth("PROGRAMMING:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w18 = (g_width - x18)/2;
	x19 = stringwidth("MotoLegacy", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w19 = (g_width - x19)/2;
	x20 = stringwidth("MODELING:", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w20 = (g_width - x20)/2;
	x21 = stringwidth("Derped_Crusader", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w21 = (g_width - x21)/2;
	x22 = stringwidth("That One Lazy Animator", 0, [0.015625*g_width, 0.015625*g_width, 0]);
	w22 = (g_width - x22)/2;
	// One sad boi: BCDeshiG
	drawstring([w1, creditsHeight*g_height, 0], "Nazi Zombies: Portable", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w2, (creditsHeight+0.100)*g_height, 0], "PROGRAMMING:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w3, (creditsHeight+0.150)*g_height, 0], "Jukki", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w4, (creditsHeight+0.200)*g_height, 0], "Blubswillrule", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w5, (creditsHeight+0.300)*g_height, 0], "MAPPING:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w6, (creditsHeight+0.350)*g_height, 0], "Ju[s]tice", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w7, (creditsHeight+0.450)*g_height, 0], "MODELING & GRAPHICS:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w8, (creditsHeight+0.500)*g_height, 0], "Blubswillrule", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w9, (creditsHeight+0.550)*g_height, 0], "Ju[s]tice", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w10, (creditsHeight+0.650)*g_height, 0], "SOUND DESIGN:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w11, (creditsHeight+0.700)*g_height, 0], "Blubswillrule", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w12, (creditsHeight+0.750)*g_height, 0], "Biodude", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w13, (creditsHeight+0.850)*g_height, 0], "Nazi Zombies Portable: Unofficial Patch", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w14, (creditsHeight+0.950)*g_height, 0], "PROGRAMMING:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w15, (creditsHeight+1.000)*g_height, 0], "PerikiyoXD", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w16, (creditsHeight+1.050)*g_height, 0], "Naievil", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w17, (creditsHeight+1.150)*g_height, 0], "Nazi Zombies Portable: Requiem", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w18, (creditsHeight+1.250)*g_height, 0], "PROGRAMMING:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w19, (creditsHeight+1.300)*g_height, 0], "MotoLegacy", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w20, (creditsHeight+1.400)*g_height, 0], "MODELING:", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w21, (creditsHeight+1.450)*g_height, 0], "Derped_Crusader", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);
	drawstring([w22, (creditsHeight+1.500)*g_height, 0], "That One Lazy Animator", [0.015625*g_width, 0.015625*g_width, 0], [1, 1, 1], 1, 1);

	creditsHeight -= 0.0001;
}

void() M_Menu_Credits_Keys =
{
	if (menuTime > time)
		return;

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_MAIN;
		menuTime = time + 0.2;
		hasStartedCredits = 0;
	}
}

#define M_Menu_Pause_CursorMax 	3
float M_Menu_Pause_Cursor;

void() M_Menu_Pause_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Requiem", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Pause_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Resume Carnage", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Pause_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Restart", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Pause_Cursor != 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Settings", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Pause_Cursor != 3)
		drawstring([0.025*g_width, 0.275*g_height, 0], "Main Menu", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	if (M_Menu_Pause_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Resume Carnage", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Pause_Cursor == 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "Restart", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Pause_Cursor == 2)
		drawstring([0.025*g_width, 0.225*g_height, 0], "Settings", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Pause_Cursor == 3)
		drawstring([0.025*g_width, 0.275*g_height, 0], "Main Menu", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
}

void() M_Menu_Pause_Keys =
{
	if (menuTime > time)
		return;

	if (K_BACKDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Pause_Cursor++;
		if (M_Menu_Pause_Cursor > M_Menu_Pause_CursorMax)
			M_Menu_Pause_Cursor = 0;
		menuTime = time + 0.2;
	}

	if (K_FORWARDDOWN) {
		sound(self, 0, "sounds/menu/navigate.wav", 1, ATTN_NONE);
		M_Menu_Pause_Cursor--;
		if (M_Menu_Pause_Cursor == -1)
			M_Menu_Pause_Cursor = M_Menu_Pause_CursorMax;
		menuTime = time + 0.2;
	}

	if (K_LEFTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		in_menu = MENU_NONE;
		setcursormode(FALSE);
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		switch (M_Menu_Pause_Cursor) {
			case 0: in_menu = MENU_NONE; setcursormode(FALSE); break;
			case 1: localcmd("restart"); break;
			case 2: in_menu = MENU_SETTINGS; menuTime = time + 0.2; setMen = 1; break;
			case 3: localcmd("map menu"); break;
		}
	}
}

float songTime;

void() Draw_Menu =
{
	if (songTime < time && mapname == "menu") {
		sound(self, 0, "sounds/menu/theme.wav", 1, ATTN_NONE);
		songTime = 196 + time;
	}

	if(getstatf(STAT_ISNOCLIP)) {
		setcursormode(FALSE);
		return;
	}

	local string title = "";
	switch(in_menu)
	{
		case MENU_MAIN:
			M_Menu_Main_Draw();
			M_Menu_Main_Keys();
			break;
		case MENU_SINGLE:
			M_Menu_Solo_Draw();
			M_Menu_Solo_Keys();
			break;
		case MENU_CLASSIC:
			M_Menu_Classic_Draw();
			M_Menu_Classic_Keys();
			break;
		case MENU_SETTINGS:
			M_Menu_Settings_Draw();
			M_Menu_Settings_Keys();
			break;
		case MENU_VSET:
			M_Menu_VSettings_Draw();
			M_Menu_VSettings_Keys();
			break;
		case MENU_GSET:
			M_Menu_GSettings_Draw();
			M_Menu_GSettings_Keys();
			break;
		case MENU_CREDITS:
			M_Menu_Credits_Draw();
			M_Menu_Credits_Keys();
			break;
		case MENU_COMMUNITY:
			M_Menu_Community_Draw();
			M_Menu_Community_Keys();
			break;
		case MENU_BETA:
			M_Menu_Beta_Draw();
			M_Menu_Beta_Keys();
			break;
		case MENU_PAUSE:
			M_Menu_Pause_Draw();
			M_Menu_Pause_Keys();
			break;
		default:
			break;
	}
};

//
//	OLD MENU
//


void() menu_single =
{
	in_menu = MENU_SINGLE;
	time_in_menu = 0;
};

void() menu_restart =
{
	in_menu = MENU_RES;
};

void() menu_resy =
{
	localcmd("restart\n");
};

void() menu_resn =
{
	in_menu = MENU_PAUSE;
};

void() menu_settings2 =
{
	in_menu = MENU_IGS;
	time_in_menu = 0;
}

void() menu_quit =
{
	localcmd("quit\n");
};

void() menu_back =
{
	in_menu = MENU_MAIN;
	time_in_menu = 0;
};

void() menu_back2 =
{
	in_menu = MENU_PAUSE;
};

void() menu_loadndu =
{
	print("loading ndu\n");
	localcmd("map ndu\n");
};

void() menu_loadwh =
{
	print("loading warehouse\n");
	localcmd("map warehouse\n");
};

void() menu_join =
{
	setcursormode(TRUE,"menu/cursor");
	in_menu = MENU_JOIN;
};

void() game_join =
{	
	localcmd("cmd joingame\n");
	in_menu = MENU_NONE;
	setcursormode(FALSE);
};

void() game_spec =
{
	localcmd("cmd specgame\n");
	in_menu = MENU_NONE;
	setcursormode(FALSE);
};

void() menu_resume =
{
	in_menu = MENU_NONE;
	setcursormode(FALSE);
	localcmd("cmd pause\n");
};

void() menu_main =
{
	in_menu = MENU_MAIN;
	localcmd("disconnect\n");
};

//struct for all buttons, note pos and scale are going to be multiplied with width/height in draw step, so keep them between 0 and 1
var struct
{
	vector pos;
	vector scale;
	string text;
	float active; //used for mouseover hilight (positive values) and alpha (negative values)
	void() action; //function that is called when the button is pressed
	float group; //a bit field, button will be usable/visible when these bits are active
} buttons[] =
{
	{[0.025, 0.175, 0], [0.325, 0.06, 0], " Solo", -1, menu_single, 0},
	{[0.025, 0.250, 0], [0.325, 0.06, 0], " Cooperative", -1, menu_single, 0},
	{[0.025, 0.325, 0], [0.325, 0.06, 0], " Settings", -1, menu_single, 0},
	{[0.025, 0.400, 0], [0.325, 0.06, 0], " Achievements", -1, menu_main, 0},
	{[0.025, 0.475, 0], [0.325, 0.06, 0], " Credits", -1, menu_single, 0},
	{[0.025, 0.550, 0], [0.325, 0.06, 0], " Quit", -1, menu_quit, 0},
	{[0.025, 0.900, 0], [0.325, 0.06, 0], "Back", -1, menu_back, 0},
	{[0.025, 0.175, 0], [0.425, 0.06, 0], "Nacht Der Untoten", -1, menu_loadndu, 0},
	//{[0.025, 0.575, 0], [0.250, 0.05, 0], "Warehouse", -1, menu_loadwh, MENU_SINGLE},
	{[0.475, 0.500, 0], [0.250, 0.05, 0], "Join", -1, game_join, 0},
	{[0.475, 0.575, 0], [0.250, 0.05, 0], "Spectate", -1, game_spec, 0},
	{[0.025, 0.500, 0], [0.250, 0.05, 0], "Resume", -1, menu_resume, MENU_PAUSE},
	{[0.025, 0.575, 0], [0.250, 0.05, 0], "Restart", -1, menu_restart, MENU_PAUSE},
	{[0.025, 0.650, 0], [0.250, 0.05, 0], "Settings", -1, menu_settings2, MENU_PAUSE},
	{[0.025, 0.725, 0], [0.250, 0.05, 0], "Main Menu", -1, menu_main, MENU_PAUSE},
	{[0.025, 0.925, 0], [0.250, 0.05, 0], "Back", -1, menu_back2, MENU_IGS},
	{[0.025, 0.500, 0], [0.250, 0.05, 0], "Yes", -1, menu_resy, MENU_RES},
	{[0.025, 0.575, 0], [0.250, 0.05, 0], "No", -1, menu_resn, MENU_RES},
};

//REMEMBER TO UPDATE THIS CONST IF YOU ADD BUTTONS
const float BUTTONS_COUNT = 17;

float mapdesc = 0;


//this function handles drawing the buttons and checking if they should be active/hilighted
void(float index) Update_Button = 
{
	if(in_menu != in_menu & buttons[index].group)
		buttons[index].active = -1;
		
	if(buttons[index].active == -1)
	{
		if(in_menu == in_menu & buttons[index].group)
			buttons[index].active = 1;
		else
			return;
	}
	
	local vector pos = buttons[index].pos;
	pos_x *= g_width;
	pos_y *= g_height;
	local vector scale = buttons[index].scale;
	scale_x *= g_width;
	scale_y *= g_height;
	
	local float alphafactor;
	
	if(buttons[index].active > 0) //Add navigate.wav here when we figure out how to do a check to see if it was already executed.
	{
		alphafactor = 1;
		drawfill(pos, scale, [0.6,0.6,0.6] + [0.15,0.15,0.15]*buttons[index].active, 0.3 * alphafactor); //Solid Background
		drawline(1, pos, [pos_x + scale_x, pos_y, 0], [90,90,90], 1.5, 1); //top outline
		drawline(1, [pos_x, pos_y + scale_y, 0], [pos_x + scale_x, pos_y + scale_y, 0], [90,90,90], 1.5, 1); //bottom outline
	}
	else
		alphafactor = buttons[index].active + 1; //-1 invis, 0 normal
	
	if(cursor_pos_x > pos_x && cursor_pos_x < pos_x + scale_x && cursor_pos_y > pos_y && cursor_pos_y < pos_y + scale_y )
		buttons[index].active = 1;
	drawstring(pos + [scale_x*0.05, scale_y*0.25, 0], buttons[index].text, [scale_y*0.5, scale_y*0.5, 1], [0.8,0.8,0.8], 1 * alphafactor, 1);
	
	if(buttons[index].active > 0)
	{
		buttons[index].active -= frametime * 15;
		if(buttons[index].active < 0)
			buttons[index].active = 0;
	}
};


void(float index) Button_Click = 
{
	//don't click if not active
	if(buttons[index].active == -1)
		return;
		
	local vector pos = buttons[index].pos;
	pos_x *= g_width;
	pos_y *= g_height;
	local vector scale = buttons[index].scale;
	scale_x *= g_width;
	scale_y *= g_height;
	
	if(cursor_pos_x > pos_x && cursor_pos_x < pos_x + scale_x && cursor_pos_y > pos_y && cursor_pos_y < pos_y + scale_y )
	{
		buttons[index].action(); //do whatever this button is supposed to do
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
	}
};


void() Menu_Click =
{
	float i;
	for(i = 0; i < BUTTONS_COUNT; i++)
	{
		Button_Click(i);
	}
};