//*********************************************************************/
//							HUD Drawing Code						   /
//																	   /
//*********************************************************************/


/*******************
*    HUD_Health   *
*******************/

void(float width, float height) HUD_Health =
{
	local float health;
	float alpha;

	health = getstatf(STAT_HEALTH);

	if (health < 100)
	{
		alpha = (100.0 - ((1.25 * health) - 25))/100*255;
		if (alpha <= 0.0)
			return;
		float modifier = (sin(time * 10) * 20) - 20;//always negative
		if(modifier < -35.0)
		modifier = -35.0;

		alpha += modifier;

		if(alpha < 0.0)
			return;
		float color = 255.0 + modifier;

		drawpic([0,0,0], "gfx/hud/blood.tga", [width, height, 0], [10,0,0], alpha/2000); // naievil -- alpha factor division here makes it easy to use legacy code
	}

}

/*===============
   HUD_Afterlife
  ===============*/

void(float width, float height) HUD_ALCount =
{
	local float alcount;

	alcount = getstatf(STAT_ALCOUNT);

	if (alcount != -1) {
		drawpic([0.875*width + 25, 0.58*height + 32, 0], "gfx/hud/alcount.tga", [50, 25, 0], [1,1,1], 1);
		drawstring([0.925*width + 28, 0.6*height + 32, 0], ftos(alcount), [0.02*width, 0.02*width, 0], [1, 1, 1], 1, 1);
	}
}

void(float width, float height) HUD_ALHUD =
{
	drawfill ([0, 0, 0], [g_width, g_height, 0], [0, 102, 255], 0.2); //blue overlay

	local float atime = getstatf(STAT_ALTIME) / 30;

	float bar_width = 0.0175*width * 20;
	float bar_height = 0.0175*width;
	float bar_x = (width - bar_width)/2;
	float bar_y = height*0.75;

	drawfill ([bar_x - 1, bar_y - 1, 0], [bar_width+2, bar_height, 0], [0, 0, 0], 0.4);
	drawfill ([bar_x, bar_y, 0], [bar_width * atime, bar_height-2, 0], [0, 102, 255], 0.4);
}

/*******************
*    HUD_Ammo      *
*******************/

void(float width, float height) HUD_Ammo =
{
	if (getstatf(STAT_ACTIVEWEAPON) == 0)
		return;

	switch(getstatf(STAT_WEAPONSTATUS)) {
		case STATE_BUYING:
		case STATE_PAP:
			return;
	}

	local float ammo, curmag, benis, benis2;
	string ammostring, ammostring_1, ammostring_2;
	vector color;

	curmag = getstatf(STAT_CURRENTMAG);
	ammo = getstatf(STAT_AMMO);

	benis = strlen(ftos(ammo));
	benis2 = strlen(ftos(curmag));
	benis = benis + benis2;

	if (GetLowAmmo(getstatf(STAT_ACTIVEWEAPON), 1) >= getstatf(STAT_CURRENTMAG))
		color = [215/255, 0, 0];
	else
		color = [1, 1, 1];

	if (GetLowAmmo(getstatf(STAT_ACTIVEWEAPON), 0) >= getstatf(STAT_AMMO))
		vector color_2 = [215/255, 0, 0];
	else
		color_2 = [1, 1, 1];


	if (IsDualWeapon(getstatf(STAT_ACTIVEWEAPON))) {
		float curmag2 = getstatf(STAT_CURRENTMAG2);

		ammostring = strcat(ftos(curmag2), " ", ftos(curmag), "/", ftos(ammo));
		drawstring([width - (42/480)*width - (benis*20*width/1024), 0.96*height, 0], ammostring, [0.02*width, 0.02*width, 0], [1,1,1], 1, 1);
	} else {
		ammostring_1 = ftos(curmag);
		ammostring_2 = strcat("/",ftos(ammo));
		drawstring([width - (42/480)*width - (benis*20*width/1024), 0.96*height, 0], ammostring_1, [0.02*width, 0.02*width, 0], color, 1, 1);
		drawstring([width - (42/480)*width - ((benis-strlen(ftos(curmag)))*20*width/1024), 0.96*height, 0], ammostring_2, [0.02*width, 0.02*width, 0], color_2, 1, 1);
	}
}

void() HUD_AmmoString =
{
	vector textcolor = [1, 1, 1];
	string message = "";

	if (GetLowAmmo(getstatf(STAT_ACTIVEWEAPON), 1) >= getstatf(STAT_CURRENTMAG) && getstatf(STAT_WEAPONZOOM) != 2)
	{
		if (0 < getstatf(STAT_AMMO) && getstatf(STAT_CURRENTMAG) >= 0) {
			message = "Reload";
			textcolor = [1, 1, 1];
		} else if (0 < getstatf(STAT_CURRENTMAG)) {
			message = "LOW AMMO";
			textcolor = [219/255, 203/255, 19/255];
		} else {
			message = "NO AMMO";
			textcolor = [215/255, 0, 0];
		}
		drawstring([g_width/2, g_height/2 + (30/272)*g_height, 0], message, [0.02*g_width, 0.02*g_width, 0], textcolor, 1, 1);
	}
}

/*******************
*    HUD_Points    *
*******************/

void(float width, float height) HUD_Points =
{
	local float pointlength = 0, increm = 10, i = 0;
	vector TEXTCOLOR;

	for (i = 3; i >= 0; i = i - 1)
	{
		if (playerpoints[i] == -1)
			continue;

		switch(i) {
			case 1: TEXTCOLOR = TEXT_LIGHTBLUE; break;
			case 2: TEXTCOLOR = TEXT_ORANGE; break;
			case 3: TEXTCOLOR = TEXT_GREEN; break;
			default: TEXTCOLOR = [1, 1, 1]; break;
		}

		if ((i+1) == getstatf(STAT_PLAYERNUM)) {
			pointlength = strlen(ftos(playerpoints[i]));
			drawpic([0.8*width,0.70*height - (.061*height*i),0], "gfx/hud/moneyback.tga", [0.2*width, 0.07*height, 0], [1,1,1], 1);
			drawstring([.9414*width - pointlength*20*width/1024, 0.715*height - 0.06*height*i, 0], ftos(playerpoints[i]), [0.022*width, 0.022*width, 0], TEXTCOLOR, 1, 1);
		}
		else {
			pointlength = strlen(ftos(playerpoints[i]));
			drawpic([0.85*width,0.70*height - (.071*height*i*0.8),0], "gfx/hud/moneyback.tga", [0.2*width*0.8, 0.07*height*0.8, 0], [1,1,1], 1);
			drawstring([.97*width - pointlength*20*width/1024, 0.715*height - 0.07*height*i*0.8, 0], ftos(playerpoints[i]), [0.022*width*0.8, 0.022*width*0.8, 0], TEXTCOLOR, 1, 1);
		}
	}
}

/*******************
*    HUD_Grenades  *
*******************/

void(float width, float height) HUD_Grenades =
{
	local float grenades;
	local float betties;

	grenades = getstatf(STAT_GRENADES);
	betties = getstatf(STAT_SECGRENADES);
	drawpic([0.9*width,0.825*height,0], "gfx/hud/frag.tga", [50, 50, 0], [1,1,1], 1);
	drawstring([0.9*width + 28, 0.825*height + 32, 0], ftos(grenades), [0.025*width, 0.025*width, 0], [1, 1, 1], 1, 1);

	if (betties != -1) {
		drawpic([0.825*width,0.825*height,0], "gfx/hud/betty.tga", [50, 50, 0], [1,1,1], 1);
		drawstring([0.825*width + 28, 0.825*height + 32, 0], ftos(betties), [0.025*width, 0.025*width, 0], [1, 1, 1], 1, 1);
	}
}

/*******************
*    HUD_Rounds    *
*******************/

float 	color_shift[3];
float 	color_shift_end[3];
float 	color_shift_steps[3];
int		color_shift_init;
int 	blinking;
string sb_round[5];
string sb_round_num[10];
int alphabling;
float endroundchange;
float round_center_x;
float round_center_y;

void(float width, float height) HUD_Rounds =
{
	float roundheight = 48/272*height;
	float roundwidth = 0.02291666*width;

	float roundwidth_4 = (60/480)*width;
	float roundheight_4 = (48/272)*height;

	float roundheight_num = 48/272*height;
	float roundwidth_num = 48/480*height; // naievil -- was 32, but more square makes it look better

//	drawstring([0.01*width, 0.70*height, 0], ftos(rounds_change), [0.03*width, 0.03*width, 0], [1, 1, 1], 1, 1); // draw roundchange

	int i, x_offset, icon_num, savex;
	int num[3];
	x_offset = 0;
	savex = 0;

	sb_round[0] = "gfx/hud/r1.tga";
	sb_round[1] = "gfx/hud/r2.tga";
	sb_round[2] = "gfx/hud/r3.tga";
	sb_round[3] = "gfx/hud/r4.tga";
	sb_round[4] = "gfx/hud/r5.tga";

	sb_round_num[0] = "gfx/hud/r_num0.tga";
	sb_round_num[1] = "gfx/hud/r_num1.tga";
	sb_round_num[2] = "gfx/hud/r_num2.tga";
	sb_round_num[3] = "gfx/hud/r_num3.tga";
	sb_round_num[4] = "gfx/hud/r_num4.tga";
	sb_round_num[5] = "gfx/hud/r_num5.tga";
	sb_round_num[6] = "gfx/hud/r_num6.tga";
	sb_round_num[7] = "gfx/hud/r_num7.tga";
	sb_round_num[8] = "gfx/hud/r_num8.tga";
	sb_round_num[9] = "gfx/hud/r_num9.tga";

	if (rounds_change == 1)//this is the rounds icon at the middle of the screen
	{
		alphabling = alphabling + 15;

		if (alphabling < 0)
			alphabling = 0;
		else if (alphabling > 255)
			alphabling = 255;

		round_center_x = (g_width - (11*g_width/480)) /2;
		round_center_y = (g_height - (48*g_height/272)) /2;

		drawpic([round_center_x,round_center_y,0], sb_round[0], [roundwidth, roundheight, 1], [107/255,1/255,0], alphabling/255);

	}
	else if (rounds_change == 2)//this is the rounds icon moving from middle
	{
		float round_center_y_offset, round_center_x_offset;

		drawpic([round_center_x + round_center_x_offset,round_center_y + round_center_y_offset,0], sb_round[0], [roundwidth,roundheight, 1], [107/255,(1/255),0], 1);

		round_center_x = round_center_x - (((229/108)*2 - 0.2)*(width/480)/8);
		round_center_y = round_center_y + ((2*(height/272))/8);
		if (round_center_x <= (5/480)*height)
			round_center_x = (5/480)*height;
		if (round_center_y >= (220/272)*height)
			round_center_y = (220/272)*height;

	}
	else if (rounds_change == 3)//shift to white
	{
		if (!color_shift_init)
		{
			color_shift[0] = 107;
			color_shift[1] = 1;
			color_shift[2] = 0;
			for (i = 0; i < 3; i = i + 1)
			{
				color_shift_end[i] = 255;
				color_shift_steps[i] = (color_shift_end[i] - color_shift[i])/60;
			}
			color_shift_init = 1;
		}
		for (i = 0; i < 3; i = i + 1)
		{
			if (color_shift[i] < color_shift_end[i])
				color_shift[i] = color_shift[i] + color_shift_steps[i];

			if (color_shift[i] >= color_shift_end[i])
				color_shift[i] = color_shift_end[i];
		}
		if (rounds > 0 && rounds < 11)
		{

			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5,height - roundheight, 0], sb_round[4], [roundwidth_4,roundheight_4, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);
					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num, roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;
			drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}
	}
	else if (rounds_change == 4)//blink white
	{

		if (endroundchange > time)
		{
			blinking = ((int)(time*1000)&510) - 255;
			blinking = fabs(blinking);
		}
		else
		{
			if (blinking)
				blinking = blinking - 1;
			else
				blinking = 0;
		}


		if (rounds > 0 && rounds < 11)
		{
			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);

					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

					drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;
			drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}

		if (endroundchange == 0)
			endroundchange = time + 2;
	}
	else if (rounds_change == 5)//blink white
	{
		if (blinking > 0)
			blinking = blinking - 10;
		if (blinking < 0)
			blinking = 0;
		if (rounds > 0 && rounds < 11)
		{
			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);
					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;
			drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}
	}
	else if (rounds_change == 6)//blink white while fading back
	{
		endroundchange = 0;

		color_shift_init = 0;
		blinking = ((int)(time*1000)&510) - 255;

		blinking = fabs(blinking);

		if (rounds > 0 && rounds < 11)
		{
			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [1,1,1], blinking/255);

					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;
			drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [1,1,1], blinking/255);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}
	}
	else if (rounds_change == 7)//blink white while fading back
	{
		if (!color_shift_init)
		{
			color_shift_end[0] = 107;
			color_shift_end[1] = 1;
			color_shift_end[2] = 0;
			for (i = 0; i < 3; i = i + 1)
			{
				color_shift[i] = 255;
				color_shift_steps[i] = (color_shift[i] - color_shift_end[i])/60;
			}
			color_shift_init = 1;
		}
		for (i = 0; i < 3; i = i + 1)
		{
			if (color_shift[i] > color_shift_end[i])
				color_shift[i] = color_shift[i] - color_shift_steps[i];

			if (color_shift[i] < color_shift_end[i])
				color_shift[i] = color_shift_end[i];
		}
		if (rounds > 0 && rounds < 11)
		{
			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([2+x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num,roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([2+x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;
			drawpic([2+x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [color_shift[0]/255,color_shift[1]/255,color_shift[2]/255], 1);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}
	}
	else
	{
		color_shift[0] = 107;
		color_shift[1] = 1;
		color_shift[2] = 0;
		color_shift_init = 0;
		alphabling = 0;
		if (rounds > 0 && rounds < 11)
		{
			for (i = 0; i < rounds; i = i + 1)
			{
				if (i == 4)
				{
					drawpic([5, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [107/255,1/255,0], 1);

					savex = x_offset + (10*width/480);
					x_offset = x_offset + (10*width/480);
					continue;
				}
				if (i == 9)
				{
					drawpic([5 + savex, height - roundheight - (4*height/272),0], sb_round[4], [roundwidth_4,roundheight_4, 1], [107/255,1/255,0], 1);

					continue;
				}
				if (i > 4)
					icon_num = i - 5;
				else
					icon_num = i;

				drawpic([5 + x_offset, height - roundheight - (4*height/272),0], sb_round[icon_num], [roundwidth,roundheight, 1], [107/255,1/255,0], 1);

				x_offset = x_offset +  roundwidth + (3*width/480);
			}
		}
		else
		{
			if (rounds >= 100)
			{
				num[2] = (int)(rounds/100);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[2]], [roundwidth_num,roundheight_num, 1], [107/255,1/255,0], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[2] = 0;
			if (rounds >= 10)
			{
				num[1] = (int)((rounds - num[2]*100)/10);
				drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[1]], [roundwidth_num,roundheight_num, 1], [107/255,1/255,0], 1);

				x_offset = x_offset +  roundwidth_num - (8*width/480);
			}
			else
				num[1] = 0;

			num[0] = rounds - num[2]*100 - num[1]*10;

			if(rounds == 0)
				return;

			drawpic([2 + x_offset, height - roundheight - (4*height/272),0], sb_round_num[num[0]], [roundwidth_num,roundheight_num, 1], [107/255,1/255,0], 1);

			x_offset = x_offset +  roundwidth_num - (8*width/480);
		}
	}
}

/*******************
*    HUD_Useprint  *
*******************/

void(float width, float height) HUD_Useprint =
{

		string usestring, usebutton;
		float print_width, x, back_width;

		tokenize(findkeysforcommand("+button7"));
		usebutton = strtoupper(keynumtostring(stof(argv(0))));

		switch (useprint_type) {
			case 0://clear
				usestring = "";
				break;
			case 1://door
				usestring = strcat("Hold ",usebutton, " to open door [Cost:", ftos(useprint_cost),"]");
				break;
			case 2://debris
				usestring = strcat("Hold ",usebutton, " to remove debris [Cost:", ftos(useprint_cost),"]");
				break;
			case 3://ammo
				usestring = strcat("Hold ",usebutton, " to buy ammo for ", GetWeaponName(useprint_weapon), " [Cost:", ftos(useprint_cost),"]");
				break;
			case 4://weapon
				usestring = strcat("Hold ",usebutton, " to buy ", GetWeaponName(useprint_weapon), " [Cost:", ftos(useprint_cost),"]");
				break;
			case 5://window
				usestring = strcat("Hold ",usebutton, " to Rebuild Barrier");
				break;
			case 6://box
				usestring = strcat("Hold ",usebutton, " for Mystery Box [Cost:", ftos(useprint_cost),"]");
				break;
			case 7://box take
				usestring = strcat("Hold ",usebutton, " to take weapon");
				break;
			case 8://power
				usestring = "The power must be activated first";
				break;
			case 9://perk
				usestring = strcat("Hold ",usebutton, " to buy ", GetPerkName(useprint_weapon), " [Cost:", ftos(useprint_cost),"]");
				break;
			case 10://turn on power
				usestring = strcat("Hold ",usebutton, " to turn on the power");
				break;
			case 11://turn on power
				usestring = strcat("Hold ",usebutton, " to active the electric barrier [Cost:", ftos(useprint_cost), "]");
				break;
			case 12://packapunch
				usestring = strcat("Hold ",usebutton, " to Pack-a-Punch [Cost:", ftos(useprint_cost), "]");
				break;
			case 13://revive
				usestring = strcat("Hold ",usebutton, " to revive player");
				break;
			case 14:
				usestring = strcat("Hold ",usebutton, " to enter Afterlife");
				break;
			case 15:
				usestring = strcat("Hold ",usebutton, " to revive yourself");
				break;
			case 16:
				usestring = strcat("Hold ",usebutton, " to dispense GobbleGum [Cost:", ftos(useprint_cost), "]");
				break;
			case 17:
				usestring = strcat("Hold ",usebutton, " to take ", getGumName(useprint_weapon));
				break;
			case 18:
				usestring = strcat("Press ",usebutton, " to fuckin go");
				break;
			case 19:
				usestring = strcat("Hold ",usebutton, " to widthdrawal 1000");
				break;
			case 20:
				usestring = strcat("Hold ",usebutton, " to deposit 1000 [Fee: 100]");
				break;
			case 21:
				usestring = strcat("Hold ",usebutton, " to win [Cost: ", ftos(useprint_cost), "]");
				break;
			default:
				usestring = "This should not happen you dum fuck";
				break;
		}
			print_width = stringwidth (usestring, 0, [0.015625*width, 0.015625*width, 0]);
			back_width = stringwidth (usestring, 0, [0.015625*width, 0.015625*width, 0]);
			x = (width - print_width)/2;
			drawfill ([x, 0.67*height, 0], [back_width, 0.015625*width, 0], [0, 0, 0], 0.4);
			drawstring([x, 0.67*height, 0], usestring, [0.015625*width, 0.015625*width, 0], [1, 1, 1], 1, 1);
}

/*******************
*    HUD_Perks     *
*******************/

int perk_order[19];
int current_perk_order;

void(float width, float height) HUD_Perks =
{

	int i, s;
	int y = height - 100 - 22/*sb_round[1]->height - 22 //(round height minus perk icon height)*/;
	int x;
	local float type;
	x = 2;
	string directory, subdir;
	switch(getstatf(STAT_HUDTYPE)) {
		case 0: subdir = "demo"; type = 1; break;
		case 1: subdir = "beta"; type = 1; break;
		case 2: subdir = "bo1"; break;
		case 3: subdir = "bo2"; break;
		case 4: subdir = "bo3"; break;
	}

	directory = strcat("gfx/hud/", subdir, "/");

	//drawstring([0.01*width, 0.10*height, 0], ftos(perks), [0.03*width, 0.03*width, 0], [1, 1, 1], 1, 1);

	for (i = 0; i < 10; i = i + 1)
	{
		if (perk_order[i])
		{
			if (perk_order[i] == P_JUG)
			{
				drawpic([x,y,0], strcat(directory, "jug.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_DOUBLE)
			{
				drawpic([x,y,0], strcat(directory, "double.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_SPEED)
			{
				drawpic([x,y,0], strcat(directory, "speed.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_REVIVE)
			{
				drawpic([x,y,0], strcat(directory, "revive.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_FLOP)
			{
				drawpic([x,y,0], strcat(directory, "flopper.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_STAMIN)
			{
				drawpic([x,y,0], strcat(directory, "stamin.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_MULE)
			{
				drawpic([x,y,0], strcat(directory, "mule.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_DEAD)
			{
				drawpic([x,y,0], strcat(directory, "dead.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_BLOOD) {
				drawpic([x,y,0], strcat(directory, "blood.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_CANDO) {
				drawpic([x,y,0], strcat(directory, "cando.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_TOMB) {
				drawpic([x,y,0], strcat(directory, "tomb.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
			else if (perk_order[i] == P_CHERRY) {
				drawpic([x,y,0], strcat(directory, "cherry.tga"), [25, 25, 1], [1,1,1], 1);
				if (type)
					y -= 27;
				else
					x += 27;
			}
		}
	}
}

/*******************
*    HUD Weapons   *
*******************/

void(float width, float height) HUD_Weaponstring =
{
	string weaponstring;
	float ws_offset;

	weaponstring = GetWeaponName(getstatf(STAT_ACTIVEWEAPON));
	ws_offset = (strlen(weaponstring));

	drawstring([0.925*width + (40*width/1024) - ws_offset*20*width/1024, 0.75*height + 10, 0], weaponstring, [0.02*width, 0.02*width, 0], [1, 1, 1], 1, 1);
}

/*******************
* HUD Progress Bar *
*******************/

void(float width, float height) HUD_Progressbar =
{
	float percent = getstatf(STAT_PROGRESSBAR);
	if (!percent) {
		return;
	}

	string progress;
	local float ws_offset;

	progress = ftos(percent);
	ws_offset = (strlen(progress) - 1);

	float bar_width = 0.0175*width * 20;
	float bar_height = 0.0175*width;
	float bar_x = (width - bar_width)/2;
	float bar_y = height*0.75;

	drawfill ([bar_x - 1, bar_y - 1, 0], [bar_width+2, bar_height, 0], [0, 0, 0], 0.4);
	drawfill ([bar_x, bar_y, 0], [bar_width * percent, bar_height-2, 0], [1, 1, 1], 0.4);

	drawstring([(width - (88))/2, height*0.77 + 10, 0], "Reviving...", [0.0175*width, 0.0175*width, 0], [1, 1, 1], 1, 1);
}

/*******************
*    HUD Hitmark   *
*******************/

void() HUD_Hitmark =
{
	drawpic([g_width/2 - (8/480)*g_width, g_height/2 - (8/480)*g_width,0], "gfx/hud/hit_marker.tga", [(16/480)*g_width, (16/480)*g_width, 1], [1,1,1], 1);
}

/*******************
*   HUD Crosshair  *
*******************/

float croshhairmoving; // naievil --used t o see if we are moving or not
float cur_spread;
float crosshair_offset_step;

void() Draw_Crosshair =
{
	//Don't draw the crosshair
	switch (getstatf(STAT_WEAPONSTATUS)) {
		case STATE_BUYING:
		case STATE_RELOAD:
		case STATE_MELEE:
		case STATE_PAP:
			return;
		default:
			break;
	}

	if (getstatf(STAT_ACTIVEWEAPON) == 0)
		return;

	if (K_BACKDOWN || K_FORWARDDOWN || K_LEFTDOWN || K_RIGHTDOWN)
		croshhairmoving = 1;
	else
		croshhairmoving = 0;


	if (getstatf(STAT_WEAPONZOOM) == 2 && zoom_2_time < time)
    {
		setmodel(vmodel, "");
		setmodel(v2model, "");
		drawfill('0 0 0',  [g_width/2 - g_height/2, g_height, 0], '0 0 0', 1);
		drawpic([(g_width/2 - g_height/2),0,0], "gfx/hud/scope.tga", [g_height, g_height, 1], [1,1,1], 1);
		drawfill([(g_width/2 + g_height/2),0,0],  [g_width, g_height, 0], '0 0 0', 1);
	}

	if (getstatf(STAT_HEALTH) < 11)
		return;

	if (crosshair_spread_time > time && crosshair_spread_time)
    {
        cur_spread = cur_spread + 10;
		if (cur_spread >= CrossHairMaxSpread(getstatf(STAT_ACTIVEWEAPON)))
			cur_spread = CrossHairMaxSpread(getstatf(STAT_ACTIVEWEAPON));

		if (!croshhairmoving)
			cur_spread *= 1/2;
    }
    else if (crosshair_spread_time < time && crosshair_spread_time)
    {
        cur_spread = cur_spread - 4;
		if (cur_spread <= 0)
		{
			cur_spread = 0;
			crosshair_spread_time = 0;
		}
    }

	if (getstatf(STAT_ACTIVEWEAPON) == W_M2 || getstatf(STAT_ACTIVEWEAPON) == AL)
	{
		drawstring([(g_width/2 - g_width*0.0175/2), (g_height/2 - g_height*0.0175/2), 0], "O", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);
	}
	else if (/*crosshair.value == 1 && */getstatf(STAT_WEAPONZOOM) != 1 && getstatf(STAT_WEAPONZOOM) != 2 && getstatf(STAT_ACTIVEWEAPON) != W_PANZER) // naievil (FIXME) crosshair cvar
    {
        int x_value, y_value;
        int crosshair_offset; /*= CrossHairWeapon() + cur_spread;*/

        /*if (sv_player->v.view_ofs[2] != 32) // naievil -- changed weapon spread if crouched or not
         crosshair_offset = CrossHairWeapon()*(.8) + cur_spread;
        else*/
         crosshair_offset = CrossHairWeapon(getstatf(STAT_ACTIVEWEAPON)) + cur_spread;

		if (CrossHairMaxSpread(getstatf(STAT_ACTIVEWEAPON)) < crosshair_offset || croshhairmoving)
		{
			crosshair_offset = CrossHairMaxSpread(getstatf(STAT_ACTIVEWEAPON));
		}

		crosshair_offset_step += (crosshair_offset - crosshair_offset_step) * 0.5;
		if (perk & P_DEAD)
			crosshair_offset_step *= 0.80;

		x_value = ((480 - 8)/2 - crosshair_offset_step)*(g_width/480);
		y_value = ((272 - 8)/2)*g_height/272;
		drawstring([x_value, y_value, 0], "-", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);

		x_value = ((480 - 8)/2 + crosshair_offset_step)*(g_width/480);
		y_value = ((272 - 8)/2)*g_height/272;
		drawstring([x_value, y_value, 0], "-", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);

		x_value = ((480 - 8)/2)*(g_width/480);
		y_value = ((272 - 8)/2 - crosshair_offset_step)*g_height/272;
		drawstring([x_value, y_value, 0], "|", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);

		x_value = ((480 - 8)/2)*(g_width/480);
		y_value = ((272 - 8)/2 + crosshair_offset_step)*g_height/272;
		drawstring([x_value, y_value, 0], "|", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);

    }
    else if (/*crosshair.value && */getstatf(STAT_WEAPONZOOM) != 1 && getstatf(STAT_WEAPONZOOM) != 2) // naievil (FIXME) crosshair cvar
		drawstring([((480 - 8)/2/480)*g_width, ((272 - 8)/2)*(g_height/272), 0], ".", [0.0175*g_width, 0.0175*g_width, 0], [1, 1, 1], 1, 1);
}

void() HUD_Powerups = {

	//moto -- (fixme) improve locations!
	if(getstatf(STAT_X2))
		drawpic([(g_width/2 - (28/272)*g_height),0,0], "gfx/hud/2x.tga", [(28/272)*g_height, (28/272)*g_height, 1], [1,1,1], 1);
	if(getstatf(STAT_INSTA))
		drawpic([((g_width/2 - (5/480)*g_width) + 10),0,0], "gfx/hud/in_kill.tga", [(28/272)*g_height, (28/272)*g_height, 1], [1,1,1], 1);
	if(getstatf(STAT_SALE))
		drawpic([(g_width/2 + (28/272)*g_height),0,0], "gfx/hud/sale.tga", [(28/272)*g_height, (28/272)*g_height, 1], [1,1,1], 1);
}

void() HUD_Broadcast = {

	string broadcast_msg = "";
	float health = getstatf(STAT_HEALTH);

		switch(broadcast_type) {
			case 2: broadcast_msg = "A Player needs to be revived"; break;
			default: broadcast_msg = "benis"; break;
		}
	float print_width = stringwidth (broadcast_msg, 0, [0.015*g_width, 0.015*g_width, 0]);
	float x = (g_width - print_width)/2;
	if (broadcast_type == 2 && health > 19)
		drawstring([x, g_height/2, 0], broadcast_msg, [0.015*g_width, 0.015*g_width, 0], [1, 1, 1], 1, 1);
}

float opac, maxheight;
string maxa = "MAX AMMO!";
void() HUD_MAXAMMO =
{
	if (!(getstatf(STAT_MAX))) {
		opac = 1;
		maxheight = (g_height/2) + 75;
	}
	else {
		float width = stringwidth(maxa, 0, [0.015*g_width, 0.015*g_width, 0]);
		width = (g_width - width)/2;
		drawstring([width, maxheight, 0], maxa, [0.015*g_width, 0.015*g_width, 0], [1, 1, 1], opac, 1);
		maxheight -= 0.12;
		opac -= 0.005;
	}
}

void() HUD_Scores =
{
	string subtext = "Name                             Score";
	float xback, i, x;
	vector TEXTCOLOR = [1, 1, 1];

	if(serverkey("constate") != "disconnected")
	{
		float print_width = stringwidth(subtext, 0, [0.015*g_width, 0.015*g_width, 0]);
		x = (g_width - print_width)/2;
		drawstring([x,g_height*(5/12), 0], subtext, [0.015*g_width, 0.015*g_width, 0], [1, 1, 1], 1, 1);

		xback = x;

		for (i = 0; i < 4; i = i + 1)
		{
			if (playerpoints[i] == -1)
				break;

			switch(i) {
				case 1: TEXTCOLOR = TEXT_LIGHTBLUE; break;
				case 2: TEXTCOLOR = TEXT_ORANGE; break;
				case 3: TEXTCOLOR = TEXT_GREEN; break;
				default: TEXTCOLOR = [1, 1, 1]; break;
			}

			print_width = stringwidth(ftos(playerpoints[i]), 0, [0.015*g_width, 0.015*g_width, 0]);
			x = (g_width + (0.5*g_width) - print_width)/2;
			drawstring([x,g_height*(5.75/12)+(i*g_width*0.03), 0], ftos(playerpoints[i]), [0.015*g_width, 0.015*g_width, 0], TEXTCOLOR, 1, 1);
			drawstring([xback,g_height*(5.75/12)+(i*g_width*0.03), 0], playernames[i], [0.015*g_width, 0.015*g_width, 0], TEXTCOLOR, 1, 1);
		}
	}
}

void() HUD_Endgame = {

	string roundstr, message, survive, survived;
	if (rounds == 1)
		roundstr = " round";
	else
		roundstr = " rounds";
	if (getstats(STAT_GMSG) != "")
		message = getstats(STAT_GMSG);
	else
		message = "GAME OVER";
	if (getstats(STAT_GMSG2) != "")
		survived = getstats(STAT_GMSG2);
	else
		survived = "You survived ";

	survive = strcat(survived,ftos(rounds),roundstr);


	// first message
	float print_width = stringwidth(message, 0, [(1/30)*g_width, (1/30)*g_width, 0]);
	float x = (g_width - print_width)/2;
	drawstring([x, g_height*(1/4), 0], message, [(1/30)*g_width, (1/30)*g_width, 0], [1, 1, 1], 1, 1);

	// second message
	print_width = stringwidth(survive, 0, [0.025*g_width, 0.025*g_width, 0]);
	x = (g_width - print_width)/2;
	drawstring([x,g_height*(1/3), 0], survive, [0.025*g_width, 0.025*g_width, 0], [1, 1, 1], 1, 1);

	// we can reuse our tab scores for the endgame
	HUD_Scores();
}

float oldfade_alpha;
void() HUD_Fade =
{
	float alpha;

	if (fade_type == 1) {
		alpha = cos(fade_time - time);
			if (oldfade_alpha > 0.95)
			alpha = 1;

			alpha = invertfloat(alpha);

		drawfill ([0, 0, 0], [g_width, g_height, 0], [0, 0, 0], alpha);	// background
		oldfade_alpha = alpha;
	}
	else if (fade_type == 2) {
		alpha = sin(((fade_time - time) * 2));
		if (oldfade_alpha > 0.95)
			alpha = 1;

		drawfill ([0, 0, 0], [g_width, g_height, 0], [0, 0, 0], alpha);	// background
		oldfade_alpha = alpha;
	}
}

//==- HUD_PlayerName -==//

//==- TODO -==//
/*
	1. Re-do scaling
*/
//==- By: MotoLegacy -==//

float hasChoosen;
string char7;
void(float width, float height) HUD_PlayerName =
{
	local float playername, plroffset, p1o, p2o, p3o, p4o;
	local string pname, p1, p2, p3, p4;
	float playernum = getstatf(STAT_CHARACTER);

	switch(getstatf(STAT_CREWTYPE))
	{
		case 1:
			p1 = "Dempsey";
			p1o = 0.700;
			p2 = "Nikolai";
			p2o = 0.710;
			p3 = "Takeo";
			p3o = 0.725;
			p4 = "Richtofen";
			p4o = 0.675;
			break;
		case 2:
			p1 = "Kennedy";
			p1o = 0.700;
			p2 = "McNamara";
			p2o = 0.700;
			p3 = "Nixon";
			p3o = 0.730;
			p4 = "Castro";
			p4o = 0.725;
			break;
		case 3:
			p1 = "Gellar";
			p1o = 0.720;
			p2 = "Englund";
			p2o = 0.715;
			p3 = "Trejo";
			p3o = 0.730;
			p4 = "Rooker";
			p4o = 0.725;
			break;
		case 4:
			p1 = "Stuhlinger";
			p1o = 0.675;
			p2 = "Marlton";
			p2o = 0.715;
			p3 = "Misty";
			p3o = 0.730;
			p4 = "Russman";
			p4o = 0.700;
			break;
		case 5:
			p1 = "Finn";
			p1o = 0.760;
			p2 = "Weasel";
			p2o = 0.715;
			p3 = "DeLuca";
			p3o = 0.725;
			p4 = "Billy";
			p4o = 0.730;
			break;
		case 6:
			p1 = "Campbell";
			p1o = 0.700;
			p2 = "Rose";
			p2o = 0.750;
			p3 = "Nero";
			p3o = 0.750;
			p4 = "Vincent";
			p4o = 0.700;
			break;
	}

	if (getstatf(STAT_CREWTYPE) == 7) {
		local float which;

		which = random();

		if (which < 0.5 && hasChoosen == 0)
			char7 = "CIA";

		else if (hasChoosen == 0)
			char7 = "CDC";

		p1 = p2 = p3 = p4 = char7;
		p1o = p2o = p3o = p4o = 0.775;

		hasChoosen = 1;
	}

	switch(getstatf(STAT_CHARACTER))
	{
		case 0:
			pname = p1;
			plroffset = p1o;
			break;
		case 1:
			pname = p2;
			plroffset = p2o;
			break;
		case 2:
			pname = p3;
			plroffset = p3o;
			break;
		case 3:
			pname = p4;
			plroffset = p4o;
			break;
	}

	drawstring([plroffset*width, 0.725*height, 0], pname, [0.015*width, 0.015*width, 0], [1, 1, 1], 1, 1);
}

/*******************
*     HUD Draw     *
*******************/

void(float width, float height) HUD_Draw =
{
	if (mapname == "menu") {
		in_menu = MENU_MAIN;
		time_in_menu = 0;
		setcursormode(TRUE,"menu/cursor");
		return;
	}
	if (!getstatf(STAT_SPECTATING) && (getstatf(STAT_HEALTH) > 10) && !score_show)
	{
		Draw_Crosshair();

		if (getstatf(STAT_ACTIVEWEAPON) == AL)
			HUD_ALHUD(width, height);

		if (getstatf(STAT_ACTIVEWEAPON) != AL) {
			HUD_Health(width, height);
			HUD_Points(width, height);
			HUD_Rounds(width, height);
			HUD_Perks(width, height);
			HUD_Powerups();
			HUD_AmmoString();
			HUD_MAXAMMO();
		}
		HUD_Progressbar(width, height);

		if (HUD_Change_time > time && getstatf(STAT_ACTIVEWEAPON) != AL)
		{
			HUD_ALCount(width, height);
			HUD_Ammo(width, height);
			HUD_Grenades(width, height);
			HUD_Weaponstring(width, height);
			HUD_PlayerName(width, height);
		}

		if (useprint_time > time)
			HUD_Useprint(width, height);

		if (Hitmark_time > time)
			HUD_Hitmark();
	}

	// Only keep broadcast messages outside in case they are important
	if (broadcast_time > time)
		HUD_Broadcast();

	if (getstatf(STAT_HEALTH) <= 10 && getstatf(STAT_SPECTATING) && !find(world, classname, "ai_zombie"))
		HUD_Endgame();

	if (score_show)
		HUD_Scores();

	if (fade_time > time)
		HUD_Fade();
}

void UpdatePerks (float newperks) {
	float s;
	if (newperks & P_JUG && !(perk & P_JUG))
	{
		perk_order[current_perk_order] = P_JUG;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_DOUBLE && !(perk & P_DOUBLE))
	{
		perk_order[current_perk_order] = P_DOUBLE;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_SPEED && !(perk & P_SPEED))
	{
		perk_order[current_perk_order] = P_SPEED;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_REVIVE && !(perk & P_REVIVE))
	{
		perk_order[current_perk_order] = P_REVIVE;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_FLOP && !(perk & P_FLOP))
	{
		perk_order[current_perk_order] = P_FLOP;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_STAMIN && !(perk & P_STAMIN))
	{
		perk_order[current_perk_order] = P_STAMIN;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_MULE && !(perk & P_MULE))
	{
		perk_order[current_perk_order] = P_MULE;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_DEAD && !(perk & P_DEAD))
	{
		perk_order[current_perk_order] = P_DEAD;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_BLOOD && !(perk & P_BLOOD))
	{
		perk_order[current_perk_order] = P_BLOOD;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_CANDO && !(perk & P_CANDO))
	{
		perk_order[current_perk_order] = P_CANDO;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_TOMB && !(perk & P_TOMB))
	{
		perk_order[current_perk_order] = P_TOMB;
		current_perk_order = current_perk_order + 1;
	}
	if (newperks & P_CHERRY && !(perk & P_CHERRY))
	{
		perk_order[current_perk_order] = P_CHERRY;
		current_perk_order = current_perk_order + 1;
	}
	if (perk & P_JUG && !(newperks & P_JUG))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_JUG)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_DOUBLE && !(newperks & P_DOUBLE))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_DOUBLE)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_SPEED && !(newperks & P_SPEED))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_SPEED)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_REVIVE && !(newperks & P_REVIVE))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_REVIVE)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_FLOP && !(newperks & P_FLOP))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_FLOP)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_STAMIN && !(newperks & P_STAMIN))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_STAMIN)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_MULE && !(newperks & P_MULE))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_MULE)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_DEAD && !(newperks & P_DEAD))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_DEAD)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_BLOOD && !(newperks & P_BLOOD))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_BLOOD)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_CANDO && !(newperks & P_CANDO))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_CANDO)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_TOMB && !(newperks & P_TOMB))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_TOMB)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}
	if (perk & P_CHERRY && !(newperks & P_CHERRY))
	{
		for (s = 0; s < 19; s++)
		{
			if (perk_order[s] == P_CHERRY)
			{
				perk_order[s] = 0;
				while (perk_order[s+1])
				{
					perk_order[s] = perk_order[s+1];
					perk_order[s+1] = 0;
				}
				break;
			}
		}
		current_perk_order = current_perk_order - 1;
	}

	perk = newperks;
}
