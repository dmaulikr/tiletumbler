
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"

#define CCRANDOM_X_Y(__X__, __Y__) (((__Y__) - (__X__)) * (arc4random() / (float)0xffffffff) + (__X__))

@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
  
  // Allow touches
  layer.isTouchEnabled = YES;
  
	[scene addChild: layer];
  
	return scene;
}

-(id) init {
  
  if ((self = [super init])) {
    
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.2f;
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3" loop:YES];
    
    // Generate tile board at base order
    tileBoard = [[TTBoard alloc] initWithSize:CGSizeMake(10, 15)];
    [self addChild:tileBoard z:1];
    
    // Add menu overlay
    CCSprite *menuBackground = [CCSprite spriteWithFile:@"TileTumbler.png"];
    
    [menuBackground setAnchorPoint:CGPointMake(0.5, 0.5)];
    [menuBackground setPosition:CGPointMake(contentSize_.width/2, contentSize_.height/2)];
    [menuBackground setScaleX:32*4 / menuBackground.contentSize.width];
    [menuBackground setScaleY:32*5 / menuBackground.contentSize.height];
    
    [self addChild:menuBackground z:2];
    
    // Add play button to click
    playLabel = [CCLabelTTF labelWithString:@"PLAY" fontName:@"GillSans" fontSize:13];
    
    [playLabel setColor:ccc3(140, 20, 33)];
    [playLabel setPosition:CGPointZero];
    [playLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    CCMenuItemLabel *playMenuLabel = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playButtonTouched)];
    [playMenuLabel setPosition:CGPointZero];
    
    playMenu = [CCMenu menuWithItems:playMenuLabel, nil];
    [playMenu setPosition:CGPointMake(contentSize_.width/2, contentSize_.height/2 - 32)];
    [playMenu setAnchorPoint:CGPointMake(0.5, 0.5)];
    playMenu.isTouchEnabled = YES;
    
    [self addChild:playMenu z:3];
    
    // Schedule random clicks to the board
    [self schedule:@selector(randomTouch) interval:2];
  }
  
  return self;
}

-(void) playButtonTouched {
  
  id transition = [CCTransitionCrossFade transitionWithDuration:0.5 scene:[GameLayer scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) randomTouch {
  
  CGSize contentSize = [CCDirector sharedDirector].winSize;
  
  int xTouch = CCRANDOM_X_Y(0, 32*6);
  int yTouch = CCRANDOM_X_Y(10, contentSize.height);
  
  [tileBoard boardTouched:CGPointMake(xTouch > 32*3 ? xTouch + 32*4 : xTouch, yTouch)];
  
  [self schedule:@selector(randomTouch) interval:2];
}

@end
