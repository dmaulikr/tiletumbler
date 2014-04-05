#import "Constants.h"

#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLayer.h"
#import "SettingsLayer.h"

#import "Utility.h"

@implementation MainMenuLayer

#pragma mark Lifecycle

// Returns a standard scene with the GameLayer initialised and placed within.
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
  
  layer.isTouchEnabled = YES;
  
	[scene addChild: layer];
  
	return scene;
}

-(instancetype) init {
  
  if ((self = [super init])) {
    
    // Construct a slightly larger tile board if we have a 5th generation device.
    if (IS_PHONEPOD5()) {
      tileBoard = [[TTBoard alloc] initWithSize:CGSizeMake(TTBoardDimensionsWidth, TTBoardDimensionsHeightTall)];
    } else {
      tileBoard = [[TTBoard alloc] initWithSize:CGSizeMake(TTBoardDimensionsWidth, TTBoardDimensionsHeight)];
    }
    
    [self addChild:tileBoard z:TTBoardHeight];
    
    // Create and display a black overlay that labels are placed on in the centre of the screen.
    menuBackground = [CCSprite spriteWithFile:[Utility findPathForImage:UI_MENU_BACKGROUND]];
    
    [menuBackground setAnchorPoint:CGPointMake(0.5, 0)];
    [menuBackground setPosition:CGPointMake(contentSize_.width/2, [tileBoard tileSize].height*5)];
    
    [menuBackground setOpacity:TTMenuOpacity];
    
    [self addChild:menuBackground z:TTMenuHeight];
    
    NSString *fontFile = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
    
    tileLabel = [CCLabelBMFont labelWithString:@"TILE" fntFile:fontFile];
    tumbleLabel = [CCLabelBMFont labelWithString:@"TUMBLER" fntFile:fontFile];
    
    [tileLabel setColor:MENU_LABEL_COLOR_TILE];
    [tumbleLabel setColor:MENU_LABEL_COLOR_TUMBLE];
    
    [tileLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    [tumbleLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [tileLabel setPosition:CGPointMake(contentSize_.width/2, 45 + contentSize_.height/2)];
    [tumbleLabel setPosition:CGPointMake(contentSize_.width/2, 20 + contentSize_.height/2)];
    
    [self addChild:tileLabel z:TTMenuLabelHeight];
    [self addChild:tumbleLabel z:TTMenuLabelHeight];
    
    playLabel = [CCLabelBMFont labelWithString:UI_STRING_MENU_PLAY fntFile:fontFile];
    
    [playLabel setColor:MENU_LABEL_COLOR_PLAY];
    
    [playLabel setPosition:CGPointZero];
    [playLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    CCMenuItemLabel *playMenuLabel = [CCMenuItemLabel itemWithLabel:playLabel target:self selector:@selector(playButtonTouched)];
    [playMenuLabel setPosition:CGPointZero];
    
    CCLabelBMFont *creditsLabel = [CCLabelBMFont labelWithString:UI_STRING_MENU_SETTINGS fntFile:fontFile];
    [creditsLabel setColor:MENU_LABEL_COLOR_CREDITS];
    
    CCMenuItemLabel *creditsMenuLabel = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(settingsButtonTouched)];
    
    playMenu = [CCMenu menuWithItems:playMenuLabel, creditsMenuLabel, nil];
    [playMenu alignItemsVerticallyWithPadding:10];
    
    [playMenu setPosition:CGPointMake(contentSize_.width/2, contentSize_.height/2 - (IS_PHONEPOD5() ? 52 : 45))];
    [playMenu setAnchorPoint:CGPointMake(0.5, 0.5)];
    playMenu.isTouchEnabled = YES;
    
    [self addChild:playMenu z:TTMenuLabelHeight];
    
    // Schedule our game loop which clicks on the board at random every given interval.
    [self schedule:@selector(updateLoop) interval:TTMenuRandomClickInterval repeat:kCCRepeatForever delay:0];
  }
  
  return self;
}

#pragma mark Touch Methods

// Responds to the SettingsLayer pressing "Return to Menu" by making the interface visible again
// and removing the settings layer.
-(void) buttonClicked:(id)sender {
  
  [menuBackground setVisible:YES];
  [tileLabel setVisible:YES];
  [tumbleLabel setVisible:YES];
  [playMenu setVisible:YES];
  
  [self removeChild:settingsLayer cleanup:YES];
}

-(void) playButtonTouched {
  
  id transition = [CCTransitionCrossFade transitionWithDuration:TTMenuTransitionTime scene:[GameLayer scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

// Responds to the Settings button being pressed. Hides the interface so it doesn't show through
// then displays the SettingsLayer on top of the Main Menu - allowing the Tile Board to show through.
-(void) settingsButtonTouched {
  
  [menuBackground setVisible:NO];
  [tileLabel setVisible:NO];
  [tumbleLabel setVisible:NO];
  [playMenu setVisible:NO];
  
  settingsLayer = [[SettingsLayer alloc] initWithDelegate:self];
  
  [self addChild:settingsLayer z:TTPauseLayerHeight];
}

#pragma mark Routine

-(void) updateLoop {
  
  [self randomTouch];
}

// Creates a random touch event on the board at any point within the surface area.
-(void) randomTouch {
  
  CGSize contentSize = [CCDirector sharedDirector].winSize;
  
  int xTouch = CCRANDOM_X_Y(0, contentSize.width-1);
  int yTouch = CCRANDOM_X_Y(10, contentSize.height);
  
  [tileBoard boardTouchedAtPosition:ccp(xTouch, yTouch)];
}

@end
