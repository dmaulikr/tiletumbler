
/*
 * EndgameLayer.h
 *
 * Tile Tumbler
 *
 * This layer represents the |Round Over| layer found after a game's time has finished. It
 * displays a selection to offer a |New Game| or |Main Menu| and displays the round's final score. 
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"

#import "TTBoard.h"

#import "Utility.h"

#ifndef TileTumbler_EndgameLayer_H_
#define TileTumbler_EndgameLayer_H_

@interface EndgameLayer : CCLayer {
  
  uint gameScore;
  
  id<MenuButtonsClicked> caller;
}

-(instancetype) initWithScore:(uint)score caller:(id<MenuButtonsClicked>)callback;

@end

#endif    // TileTumbler_EndgameLayer_H_