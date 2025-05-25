/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static const unsigned int alpha = 0xc0;     /* Amount of opacity. 0xff is opaque             */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 700;                    /* minimum width when centered */
static int max_width = 800;  // Adjust this value as needed

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Jetbrains Mono Nerd Font:style=Medium:size=11:antialias=true:autohint=true",
	"Jetbrains Mono Nerd Font:style=Medium:pixelsize=18:antialias=true:autohint=true"
};

static const char *prompt = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*                            fg         bg       */
	[SchemeNorm]          = { "#ebdbb2", "#282828" },
	[SchemeSel]           = { "#282828", "#ebdbb2" },
	[SchemeOut]           = { "#000000", "#00ffff" },
	[SchemeNormHighlight] = { "#ffc978", "#222222" },
	[SchemeSelHighlight]  = { "#ebdbb2", "#458488" },
	[SchemeOutHighlight]  = { "#ffc978", "#00ffff" },
	[SchemeHp]            = { "#f38813", "#333333" }
};

static const unsigned int alphas[SchemeLast][2] = {
	/*                          fg      bg    */
	[SchemeNorm]          = { OPAQUE, alpha },
	[SchemeSel]           = { OPAQUE, alpha },
	[SchemeOut]           = { OPAQUE, alpha },
	[SchemeNormHighlight] = { OPAQUE, alpha },
	[SchemeSelHighlight]  = { OPAQUE, alpha },
	[SchemeOutHighlight]  = { OPAQUE, alpha },
	[SchemeHp]            = { OPAQUE, alpha }
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines = 10;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 2;

/* Nav history and search it */
static unsigned int maxhist = 64;
