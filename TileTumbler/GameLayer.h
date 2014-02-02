
#import "cocos2d.h"
#import "TTBoard.h"

#import "PauseLayer.h"

// Currently a blank and empty Introduction layer to initialise the
// library then pass on to the GameLayer.
@interface GameLayer : CCLayer <TileHandlerDelegate, MenuButtonsClicked>
{
  TTBoard *testBoard;
  
  CCLabelTTF *scoreLabel;
  uint currentScore;
  
  CCLabelTTF *timerLabel;
  uint startTime;
  uint timeRemaining;
  BOOL timePaused;
  
  CCMenu *pauseMenu;
  CCLabelTTF *pauseLabel;
  
  PauseLayer *pauseOverlay;
  
  CCSprite *headerBar;
  
  // Keeps track of the last (Valid) touch location
  CGPoint lastTouch;
}

-(void) pauseButtonClicked;

+(CCScene *) scene;

@end
