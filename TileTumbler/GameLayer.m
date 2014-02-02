
#import "GameLayer.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "PauseLayer.h"

#pragma mark - IntroLayer

@implementation GameLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
  
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
    
    CGSize contentSize = [CCDirector sharedDirector].winSize;
    
    // Add our header bar
    headerBar = [CCSprite spriteWithFile:@"HeaderBar.png" ];
    
    [headerBar setOpacity:170];
    
    [headerBar setAnchorPoint:CGPointMake(1,1)];
    [headerBar setPosition:ccp(contentSize.width, contentSize.height)];
    
    [headerBar setScaleX:(float)contentSize.width/headerBar.contentSize.width];
    [headerBar setScaleY:(float)25/headerBar.contentSize.height];
    
    [self addChild:headerBar z:8];
    
    // Initialise the label and position at the lower left of the board
    currentScore = 0;
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"GillSans" fontSize:11];
    
    [scoreLabel setColor:ccc3(255, 255, 255)];
    [scoreLabel setPosition:CGPointMake(5, contentSize.height - 5)];
    [scoreLabel setAnchorPoint:CGPointMake(0, 1)];
    
    [self addChild: scoreLabel z:10];
    
    
    CCSprite *timerSprite = [CCSprite spriteWithFile:@"Timer.png"];
    
    [timerSprite setPosition:CGPointMake(contentSize.width - 5, contentSize.height - 7)];
    [timerSprite setAnchorPoint:CGPointMake(1, 1)];
    
    [self addChild:timerSprite z:10];
    
    // Initalise the timer and position at the upper right of the board
    timeRemaining = 180;
    
    [self schedule:@selector(tickTimer) interval:1];
    
    timerLabel = [CCLabelTTF labelWithString:@"3:00" fontName:@"GillSans" fontSize:11];
    
    [timerLabel setColor:ccc3(255, 255, 255)];
    [timerLabel setPosition:CGPointMake(contentSize.width-10-timerSprite.contentSize.width,
                                        contentSize.height - 5)];
    [timerLabel setAnchorPoint:CGPointMake(1, 1)];
    
    [self addChild: timerLabel z:10];
    
    pauseLabel = [CCLabelTTF labelWithString:@"PAUSE" fontName:@"GillSans" fontSize:11];
    
    [pauseLabel setColor:ccc3(255, 255, 255)];
    [pauseLabel setPosition:CGPointZero];
    [pauseLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    CCMenuItemLabel *pauseMenuLabel = [CCMenuItemLabel itemWithLabel:pauseLabel target:self selector:@selector(pauseButtonClicked)];
    [pauseMenuLabel setPosition:CGPointZero];
    [pauseMenuLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    pauseMenu = [CCMenu menuWithItems:pauseMenuLabel, nil];
    [pauseMenu setPosition:CGPointMake(contentSize.width/2, contentSize.height-12)];
    [pauseMenu setAnchorPoint:CGPointMake(0.5, 1)];
    pauseMenu.isTouchEnabled = YES;
    
    [self addChild: pauseMenu z:10];
    
    [self addChild: testBoard z:0];
    
    [testBoard setTileDelegate:self];
    
  }
  
  return self;
}

-(void) resumeClicked {
  
  [self pauseButtonClicked];
}

-(void) menuClicked {
  
  [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1 scene:[MainMenuLayer scene]]];
}

-(void) pauseButtonClicked {
  
  if (!timePaused) {
    
    timePaused = YES;
    
    pauseOverlay = [[PauseLayer alloc] initWithScore:currentScore time:timeRemaining caller:self];
    pauseOverlay.isTouchEnabled = YES;
    
    [self addChild:pauseOverlay z:500];
  } else {
    
    [self removeChild:pauseOverlay cleanup:YES];
    pauseOverlay = nil;
    
    timePaused = NO;
  }
}

-(void) tickTimer {
  
  if (!timePaused) {
    if (timeRemaining > 0)
      timeRemaining--;
    
    uint minutes = floor((float)timeRemaining / 60);
    uint seconds = timeRemaining - (minutes * 60);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##"];
    
    NSString *secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
    NSString *timeString = [NSString stringWithFormat:@"%d:%@", minutes, secondString];
    
    [timerLabel setString:timeString];
  }
  if (timeRemaining > 0)
    [self schedule:@selector(tickTimer) interval:1];
}

-(void) tilesRemoved:(uint)number {
  
  NSString *dScoreString = [NSString stringWithFormat:@"+%d", number];
  CCLabelTTF *dScore = [CCLabelTTF labelWithString:dScoreString fontName:@"Arial" fontSize:12];
  
  [dScore setPosition: lastTouch];
  
  CGPoint centerScore = ccp(scoreLabel.boundingBox.origin.x + scoreLabel.boundingBox.size.width/2,
                            scoreLabel.boundingBox.origin.y + scoreLabel.boundingBox.size.height/2);
  
  id moveAction = [CCMoveTo actionWithDuration:1 position:centerScore];
  id fadeAction = [CCFadeTo actionWithDuration:1 opacity:50];
  
  id postAction = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    
    currentScore += number;
    [scoreLabel setString:[NSString stringWithFormat:@"%d", currentScore]];
    
    [self removeChild:dScore cleanup:YES];
  }];
  
  [[SimpleAudioEngine sharedEngine] playEffect:@"beep.mp3"];
  
  [dScore runAction:[CCSpawn actionOne:[CCSequence actions:moveAction, postAction, nil] two:fadeAction]];
  [self addChild: dScore];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  if (touch == nil) return;
  
  // Convert our point to our object-relative coordinates
  CGPoint touchNode = [self convertTouchToNodeSpace:touch];
  
  lastTouch = touchNode;
  
  if (CGRectContainsPoint(headerBar.boundingBox, touchNode) && !timePaused)
    [pauseMenu ccTouchBegan:touch withEvent:event];
  else if (CGRectContainsPoint(testBoard.boundingBox, touchNode) && !timePaused)
    [testBoard boardTouched:touchNode];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self ccTouchesBegan:touches withEvent:event];
}

@end
