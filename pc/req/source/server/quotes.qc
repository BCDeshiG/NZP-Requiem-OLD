//==- Quote System -==//
void(string snd) PlayQuote =
{
	string directory = strcat("sounds/player/quotes/", ftos(self.character), "/");
	string subdir;

	switch (world.chartype) {
		case 1: subdir = "kdt"; break;
		default: return;
	}
	precache_sound(strcat(directory, subdir, "/", snd, ".wav"));
	sound (self, CHAN_AUTO, strcat(directory, subdir, "/", snd, ".wav"), 1, ATTN_NONE);
}
void(float which) QuotePlay =
{
	switch (which) {
		case Q_SPAWN: 
			PlayQuote("spawn");
			break;
	}
}