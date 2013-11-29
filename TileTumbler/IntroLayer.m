
#import "IntroLayer.h"
#import "TTTile.h"

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
  TTTile *testTile = [[TTTile alloc] initWithFile:@"CellRect.png" Position:CGPointMake(winSize.width/2, winSize.height/2)];
  
  [layer addChild: testTile];
	
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
