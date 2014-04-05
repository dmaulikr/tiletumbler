
/*
 * Constants.h
 *
 * Tile Tumbler
 *
 * This header contains all the constants, magic numbers and strings found throughout
 * the project. 
 *
 * @author Ronan Turner
 */

#include "cocos2d.h"

#ifndef TileTumbler_Constants_H_
#define TileTumbler_Constants_H_

#pragma mark - Filenames

static NSString * const MUSIC_FILE_BACKGROUND = @"track-loop.mp3";
static NSString * const MUSIC_FILE_EFFECTS = @"pop.mp3";

static NSString * const UI_HEADER_OVERLAY_FILE = @"TTUI_Header";
static NSString * const UI_MENU_BACKGROUND = @"TTUI_MenuBG";
static NSString * const UI_BLACK_OVERLAY = @"TTUI_Overlay.png";
static NSString * const UI_MENU_OVERLAY = @"TTUI_MenuOverlay";

static NSString * const UI_TILE_SPRITE = @"TTUI_Tile.png";
static NSString * const UI_TIMER_SPRITE = @"TTUI_Timer.png";

static NSString * const UI_CREDITS_INFO_BOX = @"TTUI_CreditsBG";
static NSString * const UI_CREDITS_VOL_BOX = @"TTUI_CreditsBox";

static NSString * const UI_CREDITS_SLIDER_BACKGROUND = @"UI_Slider_Background";
static NSString * const UI_CREDITS_SLIDER_TRACK = @"UI_Slider_Track";
static NSString * const UI_CREDITS_SLIDER_THUMB = @"UI_Slider_Thumb";

static NSString * const UI_ICON_VOL_MIN = @"TTUI_Icon_VolMin";
static NSString * const UI_ICON_VOL_MAX = @"TTUI_Icon_VolMax";

#pragma mark Fonts

static NSString * const UI_FONT_SUPERLOW = @"CaviarDreamsSuperLow.fnt";
static NSString * const UI_FONT_LOW = @"CaviarDreams18.fnt";
static NSString * const UI_FONT_STANDARD = @"CaviarDreams.fnt";
static NSString * const UI_FONT_LARGE = @"CaviarDreamsLarge.fnt";
static NSString * const UI_FONT_SUPERLARGE = @"CaviarDreams60.fnt";

#pragma mark Strings

static NSString * const UI_STRING_MENU_PLAY = @"PLAY";
static NSString * const UI_STRING_MENU_SETTINGS = @"SETTINGS";

static NSString * const UI_STRING_PAUSE_RESUME = @"RESUME";
static NSString * const UI_STRING_PAUSE_SETTINGS = @"SETTINGS";
static NSString * const UI_STRING_PAUSE_MENU = @"MAIN MENU";

static NSString * const UI_STRING_ENDGAME_NEW = @"NEW GAME";
static NSString * const UI_STRING_ENDGAME_MENU = @"MAIN MENU";
static NSString * const UI_STRING_ENDGAME_TITLE = @"Round Over";

static NSString * const UI_STRING_SETTINGS_MENU = @"Return to Menu";
static NSString * const UI_STRING_SETTINGS_CREDITS1 = @"Thanks to Kirstine, for the push,";
static NSString * const UI_STRING_SETTINGS_CREDITS2 = @"to Aly, for the time,";
static NSString * const UI_STRING_SETTINGS_CREDITS3 = @"to Lauren Thompson, for the font,";
static NSString * const UI_STRING_SETTINGS_CREDITS4 = @"to all the testers";
static NSString * const UI_STRING_SETTINGS_CREDITS5 = @"and the wonderful Cocos2D team.";

static NSString * const UI_STRING_GAME_PAUSE = @"PAUSE";

static NSString * const UI_STRING_GAME_BONUSTITLE = @"Bonus Mode!";
static NSString * const UI_STRING_GAME_BONUSTEXT = @"DRAG to remove";

#pragma mark Opacity Values

typedef NS_ENUM(NSInteger, TTOpacityConstants) {
  TTHeaderOpacity = 170,
  TTCreditsOpacity = 180,
  TTEndgameOverlayOpacity = 200,
  TTTileOpacity = 220,
  TTMenuOpacity = 245,
};

#pragma mark Z-Order Values

typedef NS_ENUM(NSInteger, TTHeightConstants) {
  TTOverlayHeight = 0,
  TTBoardHeight = 0,
  TTMenuHeight = 2,
  TTScoreModifierHeight = 2,
  TTCreditsBoxHeight = 2,
  TTCreditsLabelHeight = 3,
  TTMenuLabelHeight = 3,
  TTHeaderHeight = 8,
  TTHeaderItemHeight = 10,
  TTPauseLayerHeight = 20,
  TTPauseSettingsHeight = 30,
};

#pragma mark Colours

static const ccColor3B GAMELAYER_SCORE_COLOR = {255, 255, 255};
static const ccColor3B GAMELAYER_TIMER_COLOR = {255, 255, 255};
static const ccColor3B GAMELAYER_PAUSE_COLOR = {255, 255, 255};
static const ccColor3B GAMELAYER_TIMER_COLOR_BONUS = {192,79,126};

static const ccColor3B MENU_LABEL_COLOR_TILE = {104,173,163};
static const ccColor3B MENU_LABEL_COLOR_TUMBLE = {220,195,106};
static const ccColor3B MENU_LABEL_COLOR_PLAY = {192,79,126};
static const ccColor3B MENU_LABEL_COLOR_CREDITS = {108,104,187};

static const ccColor3B ENDGAME_LABEL_MAINMENU = {108,104,187};
static const ccColor3B ENDGAME_LABEL_COLOR_NEWGAME = {104,173,163};
static const ccColor3B ENDGAME_LABEL_COLOR_ROUNDOVER = {192,79,126};
static const ccColor3B ENDGAME_LABEL_COLOR_SCORE = {220,195,106};

static const ccColor3B PAUSEMENU_LABEL_COLOR_SCORE = {220,195,106};
static const ccColor3B PAUSEMENU_LABEL_COLOR_TIMER = {104,173,163};

static const ccColor3B CREDITS_LABEL_COLOR_VOLUME = {192,79,126};
static const ccColor3B CREDITS_LABEL_COLOR_BACKGROUND = {220,195,106};
static const ccColor3B CREDITS_LABEL_COLOR_FX = {108,104,187};

static const ccColor3B CREDITS_LABEL_COLOR_LINE1 = {220,195,106};
static const ccColor3B CREDITS_LABEL_COLOR_LINE2 = {104,173,163};
static const ccColor3B CREDITS_LABEL_COLOR_LINE3 = {192,79,126};
static const ccColor3B CREDITS_LABEL_COLOR_LINE4 = {108,104,187};

static const ccColor3B CREDITS_LABEL_COLOR_MAINMENU = {104,173,163};

static const ccColor3B TILE_COLOR_1 = {0x86, 0x6F, 0xD7};
static const ccColor3B TILE_COLOR_2 = {0xEA, 0x3A, 0x93};
static const ccColor3B TILE_COLOR_3 = {0x5E, 0xD0, 0xBD};
static const ccColor3B TILE_COLOR_4 = {0xFF, 0xE6, 0x73};

#pragma mark Audio Values

static const uint TTLowerPitchThreshold = 6;

static const float TTSoundEffectsLowerPitch = 0.9f;
static const float TTSoundEffectsUpperPitch = 1.0f;

static const float TTDefaultBackgroundVolume = 0.5f;
static const float TTDefaultSoundEffectsVolume = 0.5f;

#pragma mark Size Values

typedef NS_ENUM(NSInteger, TTBoardDimensions) {
  TTBoardDimensionsWidth = 10,
  TTBoardDimensionsHeight = 15,
  TTBoardDimensionsHeightTall = 17,
};

#pragma mark Action / Transition Times

static const float TTActionTimeScoreModifierMove = 1;
static const float TTActionTimeScoreModifierFade = 1;
static const float TTActionTimeBonusModeFade = 4;
static const float TTActionTimeTileFade = 0.4;

static const uint TTActionValueScoreModifierFadeTo = 50;

static const float TTMenuTransitionTime = 0.4;

static const float TTTileDropDuration = 0.5;

#pragma mark Game State

static const uint TTInitialScoreValue = 0;

static const uint TTRoundTimeSeconds = 60;
static const uint TTBonusRoundInitTime = 10;

static const uint TTMenuRandomClickInterval = 2;

static const uint TTMinimumTileGroupSize = 3;

static const uint TTNumberTileColours = 4;

static NSString * const SETTINGS_KEY_BG_VOL = @"VOLUME_BG";
static NSString * const SETTINGS_KEY_FX_VOL = @"VOLUME_FX";

#endif    // TileTumbler_Constants_H_
