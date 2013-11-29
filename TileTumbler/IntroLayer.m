
#import "IntroLayer.h"
#import "TTBoard.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];

	[scene addChild: layer];
  
  CCDirector *sharedDirector = [CCDirector sharedDirector];
  CGSize winSize = sharedDirector.winSize;
  
  // Add a tile to check initialisation works
  TTBoard *testBoard = [[TTBoard alloc] initWithSize:CGSizeMake(8, 12)];
  
  [layer addChild: testBoard];
	
	return scene;
}

-(void) onEnter
{
	[super onEnter];
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	// Do nothing yet.
}
@end
