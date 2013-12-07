
#import "cocos2d.h"
#import "TTBoard.h"

// Currently a blank and empty Introduction layer to initialise the
// library then pass on to the GameLayer.
@interface IntroLayer : CCLayer
{
  TTBoard *testBoard;
}

+(CCScene *) scene;

@end
