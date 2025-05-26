/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int gappx     = 10;        /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int vertpad            = 10;       /* vertical padding of bar */
static const int sidepad            = 10;       /* horizontal padding of bar */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const int user_bh            = 30;        /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const char *fonts[]          = { "Jetbrains Mono Nerd Font:size=10" };
static const char dmenufont[]       = "Jetbrains Mono Nerd Font:size=10";
static const char col_gray1[]       = "#282828"; // background
static const char col_gray2[]       = "#282828"; // inactive border
static const char col_gray3[]       = "#ebdbb2"; // inactive text
static const char col_gray4[]       = "#282828"; // active text
static const char col_cyan[]        = "#ebdbb2"; // active border
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray1, col_gray3,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
  { "St",       "floatterm", NULL,          0,         1,          -1 },
  { "Viewnior",  			NULL,       NULL,       0,       	  1,           1,           -1 },
  { "Lxappearance",  		NULL,       NULL,       0,       	  1,           1,           -1 },
  { "VirtualBox Manager",  			NULL,       NULL,       0,       	  1,           1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *powercmd[]  = { "/home/cid/suckless/dwm/scripts/rofi_powermenu", NULL };
static const char *rofiss[]  = { "/home/cid/suckless/dwm/scripts/rofi_ss", NULL };

/* Hardware keys for volume and brightness */
#include <X11/XF86keysym.h>
static const char *mutevol[] 			= { "/home/cid/suckless/dwm/scripts/volume", "--toggle",  NULL };
static const char *upvol[]   			= { "/home/cid/suckless/dwm/scripts/volume", "--inc",  	NULL };
static const char *downvol[] 			= { "/home/cid/suckless/dwm/scripts/volume", "--dec",    	NULL };
static const char *upbl[] 				= { "/home/cid/suckless/dwm/scripts/brightness", "--inc",    NULL };
static const char *downbl[] 			= { "/home/cid/suckless/dwm/scripts/brightness", "--dec",  NULL };

/* Screenshot */
static const char *shotnow[]  			= { "/home/cid/suckless/dwm/scripts/screenshot", "--now", NULL };
static const char *shotin5[]  			= { "/home/cid/suckless/dwm/scripts/screenshot", "--in5", NULL };
static const char *shotin10[]  			= { "/home/cid/suckless/dwm/scripts/screenshot", "--in10", NULL };
static const char *shotwin[]  			= { "/home/cid/suckless/dwm/scripts/screenshot", "--win", NULL };
static const char *shotarea[]  			= { "/home/cid/suckless/dwm/scripts/screenshot", "--area", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
// Hardware Keys -----------
	{ 0, 							XF86XK_AudioMute, 			spawn, {.v = mutevol } },
	{ 0, 							XF86XK_AudioLowerVolume, 	spawn, {.v = downvol } },
	{ 0, 							XF86XK_AudioRaiseVolume, 	spawn, {.v = upvol   } },
	{ 0, 							XF86XK_MonBrightnessUp, 	spawn, {.v = upbl   } },
	{ 0, 							XF86XK_MonBrightnessDown, 	spawn, {.v = downbl   } },

	// Print Keys -----------
	{ 0, 							              XK_Print, 					spawn, {.v = shotnow } },
	{ ALTKEY, 						          XK_Print, 					spawn, {.v = shotin5 } },
	{ ShiftMask, 					          XK_Print, 					spawn, {.v = shotin10 } },
	{ ControlMask, 					        XK_Print, 					spawn, {.v = shotwin } },
	{ MODKEY, 						          XK_Print, 					spawn, {.v = shotarea } },
	{ MODKEY,                       XK_p,               spawn, {.v = dmenucmd } },
  { MODKEY,                       XK_s,               spawn, {.v = rofiss } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY|ShiftMask,             XK_Return, spawn,           SHCMD("st -n floatterm -t 'Floating ST'") },
	{ MODKEY|ShiftMask,             XK_a,       zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY,             			    XK_x,	   spawn,          {.v = powercmd } },
  { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
  { MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
