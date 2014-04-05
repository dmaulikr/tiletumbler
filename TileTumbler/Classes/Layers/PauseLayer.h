
/*
 * PauseLayer.h
 *
 * Tile Tumbler
 *
 * This layer is the layer displayed when the current game is paused. It displays the time left
 * in the round and the current score, alongside an option to return to the game, display settings
 * or go back to the main menu.
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"

#import "TTBoard.h"

#import "Constants.h"
#import "Utility.h"

#ifndef TileTumbler_PauseLayer_H_
#define TileTumbler_PauseLayer_H_

@interface PauseLayer : CCLayer {
 
  uint gameScore;
  
  uint gameTime;
  
  id<MenuButtonsClicked> caller;
}

-(instancetype) initWithScore:(uint)score time:(uint)timeRemains caller:(id<MenuButtonsClicked>)callback;

@end

#endif     // TileTumbler_PauseLayer_H_