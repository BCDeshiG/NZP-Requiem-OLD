//==-           Menu.qc           -==//
//==- Menu Revamped By MotoLegacy -==//

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
		drawstring([0.025*g_width, 0.325*g_height, 0], "Credits (In Progress)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
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
		drawstring([0.025*g_width, 0.325*g_height, 0], "Credits (In Progress)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	if (M_Menu_Main_Cursor == 5)
		drawstring([0.025*g_width, 0.375*g_height, 0], "Quit", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

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
			case 3: in_menu = MENU_SETTINGS; menuTime = time + 0.2; break;
			case 4: in_menu = MENU_CREDITS; menuTime = time + 0.2; break;
			case 5: localcmd("quit\n"); break;
		}
	}
}

/* ======
    Solo
   ====== */

#define M_Menu_Solo_CursorMax	1
float M_Menu_Solo_Cursor;

void() M_Menu_Solo_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Map List", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Solo_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Classic", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	if (M_Menu_Solo_Cursor != 1)
		drawstring([0.025*g_width, 0.175*g_height, 0], "NZ:P Beta (N/A)", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	if (M_Menu_Solo_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Classic", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Maps from the Call of Duty Series", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
	}
	if (M_Menu_Solo_Cursor == 1) {
		drawstring([0.025*g_width, 0.175*g_height, 0], "NZ:P Beta (N/A)", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "Maps from Nazi Zombies: Portable Beta", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
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
		}
	}
}

/* ==============
    Classic Maps
   ============== */

#define M_Menu_Classic_CursorMax	0
float M_Menu_Classic_Cursor;

void() M_Menu_Classic_Draw =
{

	drawstring([0.025*g_width, 0.050*g_height, 0], "Classic Maps", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Classic_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Nacht der Untoten", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	//Selection

	if (M_Menu_Classic_Cursor == 0) {
		drawstring([0.025*g_width, 0.125*g_height, 0], "Nacht der Untoten", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.850*g_height, 0], "You drove them deep into the heart of the Reich.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawstring([0.025*g_width, 0.900*g_height, 0], "You thought they were dead. You were wrong.", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);
		drawpic([0.025 * g_width, 0.550 * g_height, 0], "menu/ndu", [g_width * 0.25, g_height * 0.25, 1], [1,1,1], 1);
	}

	//Directions
	drawstring([0.025*g_width, 0.950*g_height, 0], "W/S: Navigate      D: Enter      A: Return", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
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
		}
	}
}

/* ==========
	Settings
   ========== */

#define M_Menu_Settings_CursorMax 	0
float M_Menu_Settings_Cursor;

void() M_Menu_Settings_Draw =
{
	drawstring([0.025*g_width, 0.050*g_height, 0], "Settings", [g_height * 0.04, g_height * 0.04, 1], [1, 0.5, 0], 1, 1); //Title

	//FIXME - Text is opaque so we can't draw over each other without a weird effect

	if (M_Menu_Settings_Cursor != 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Fullbright", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

	if (M_Menu_Settings_Cursor == 0)
		drawstring([0.025*g_width, 0.125*g_height, 0], "Fullbright", [g_height * 0.03, g_height * 0.03, 1], [1, 0.5, 0], 1, 1);

	if (cvar("r_fullbright"))
		drawstring([0.900*g_width, 0.125*g_height, 0], "On", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	else
		drawstring([0.900*g_width, 0.125*g_height, 0], "Off", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

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
		in_menu = MENU_MAIN;
		menuTime = time + 0.2;
	}

	if (K_RIGHTDOWN) {
		sound(self, 0, "sounds/menu/enter.wav", 1, ATTN_NONE);
		if (M_Menu_Settings_Cursor == 0) {
			if (cvar("r_fullbright"))
				cvar_set("r_fullbright", "0");
			else
				cvar_set("r_fullbright", "1");
			localcmd("vid_restart\n");
			menuTime = 0.2 + time;
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
	float w1, w2, w3, w4;

	if (hasStartedCredits == 0) {
		creditsHeight = 0.950;
		hasStartedCredits = 1;
	}

	w1 = stringwidth ("Nazi Zombies: Portable", 0, [0.03*g_width, 0.03*g_width, 0]);
	w1 = w1/2;

	w2 = stringwidth ("PROGRAMMING:", 0, [0.03*g_width, 0.03*g_width, 0]);
	w2 = w2/2;

	w3 = stringwidth ("Jukki", 0, [0.03*g_width, 0.03*g_width, 0]);
	w3 = w3/2;

	w4 = stringwidth ("Blubswillrule", 0, [0.03*g_width, 0.03*g_width, 0]);
	w4 = w4/2;

	drawstring([w1, creditsHeight*g_height, 0], "Nazi Zombies: Portable", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	drawstring([w2, (creditsHeight+0.150)*g_height, 0], "PROGRAMMING:", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	drawstring([w3, (creditsHeight+0.200)*g_height, 0], "Jukki", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);
	drawstring([w4, (creditsHeight+0.250)*g_height, 0], "Blubswillrule", [g_height * 0.03, g_height * 0.03, 1], [0.8, 0.8, 0.8], 1, 1);

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

//
//	Menu stuff
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

float songTime;

void() Draw_Menu =
{
	if (songTime < time && mapname == "menu") {
		sound(self, 0, "sounds/menu/theme.wav", 1, ATTN_NONE);
		songTime = 196 + time;
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
		case MENU_CREDITS:
			M_Menu_Credits_Draw();
			M_Menu_Credits_Keys();
			break;
		case MENU_PAUSE:
			title = "PAUSED";
			break;
		case MENU_IGS:
			title = "SETTINGS";
			break;
		case MENU_RES:
			title = "RESTART";
			break;
		default:
			title = "Nazi Zombies: Portable";
	}

	//Update buttons
	local float i;

	for(i = 0; i < BUTTONS_COUNT; i++)
	{
		Update_Button(i);
	}
};