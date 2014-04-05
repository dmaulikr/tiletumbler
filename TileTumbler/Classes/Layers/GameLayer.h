
#import "cocos2d.h"

#import "TTBoard.h"

#import "PauseLayer.h"
#import "EndgameLayer.h"
#import "SettingsLayer.h"

#import "Constants.h"

#ifndef TileTumbler_GameLayer_H_
#define TileTumbler_GameLayer_H_

/*
 * GameLayer.h
 *
 * Tile Tumbler
 *
 * This class handles the management of the game state when a round is being played. 
 *
 * It also receives notifications of buttons clicked from various layers placed on top of it as well
 * as notifications of tiles being removed from the tile board.
 *
 * @author Ronan Turner
 */
@interface GameLayer : CCLayer <TileHandlerDelegate, MenuButtonsClicked> {
  
  TTBoard *tileBoard;
  
  CCSprite *headerBar;
  
  CCLabelBMFont *scoreLabel;
  CCLabelBMFont *timerLabel;
  CCLabelBMFont *pauseLabel;
  
  uint currentScore;
  
  uint timeRemaining;
  
  BOOL paused;
  BOOL finished;
  BOOL dragEnabled;
  
  CCMenu *pauseMenu;
  
  PauseLayer *pauseOverlay;
  EndgameLayer *endOverlay;
  SettingsLayer *settingsOverlay;
  
  CGPoint lastTouch;
}

+(CCScene *) scene;

@end

#endif    // TileTumbler_GameLayer_H_