
#import "cocos2d.h"
#import "TTBoard.h"

// Currently a blank and empty Introduction layer to initialise the
// library then pass on to the GameLayer.
@interface IntroLayer : CCLayer <TileHandlerDelegate>
{
  TTBoard *testBoard;
  
  CCLabelTTF *scoreLabel;
  uint currentScore;
}

+(CCScene *) scene;

@end
