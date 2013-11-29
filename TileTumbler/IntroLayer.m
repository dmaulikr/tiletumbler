
#import "IntroLayer.h"
#import "TTBoard.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];

	[scene addChild: layer];
  
  TTBoard *ttBoard;
	
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
