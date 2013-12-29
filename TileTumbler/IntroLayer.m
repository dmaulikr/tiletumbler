
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
    
    // Initialise the label and position at the lower left of the board
    currentScore = 0;
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:20];
    
    [scoreLabel setColor:ccc3(255, 255, 255)];
    [scoreLabel setPosition:CGPointMake(10, 10)];
    [scoreLabel setAnchorPoint:CGPointMake(0, 0)];
    
    [self addChild: scoreLabel z:2];
    [self addChild: testBoard z:0];
    
    [testBoard setTileDelegate:self];
  }
  
  return self;
}

-(void) tilesRemoved:(uint)number {
  
  currentScore += number;
  [scoreLabel setString:[NSString stringWithFormat:@"%d", currentScore]];
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
