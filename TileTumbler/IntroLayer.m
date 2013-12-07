
#import "IntroLayer.h"

#pragma mark - IntroLayer

@implementation IntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
  
  // Allow touches
  layer.isTouchEnabled = YES;

	[scene addChild: layer];
  
	return scene;
}

-(id) init
{
  if ((self = [super init])) {
    
    // Add a tile to check initialisation works
    testBoard = [[TTBoard alloc] initWithSize:CGSizeMake(10, 15)];
    
    [self addChild: testBoard];
  }
  
  return self;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  if (touch == nil) return;
  
  // Convert our point to our object-relative coordinates
  CGPoint touchNode = [self convertTouchToNodeSpace:touch];
  
  if (CGRectContainsPoint(testBoard.boundingBox, touchNode))
    [testBoard boardTouched:touchNode];
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
