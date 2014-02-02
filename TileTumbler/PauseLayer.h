
#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "TTBoard.h"

@protocol MenuButtonsClicked <NSObject>

-(void) resumeClicked;
-(void) menuClicked;

@end

@interface PauseLayer : CCLayer {
 
  // The score from the game
  uint gameScore;
  
  // The remaining time in the game (Seconds)
  uint gameTime;
  
  // Delegates for pause / resume event
  id<MenuButtonsClicked> caller;
}

-(id) initWithScore:(uint)score time:(uint)timeRemains caller:(id<MenuButtonsClicked>)callback;

@end
