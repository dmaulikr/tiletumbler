#import "Constants.h"

#import "PauseLayer.h"

@implementation PauseLayer

#pragma mark Lifecycle

-(instancetype) initWithScore:(uint)score time:(uint)timeRemains caller:(id<MenuButtonsClicked>)callback {
  
  if ((self = [super init])) {
    
    caller = callback;
    
    [self setPosition:CGPointZero];
    [self setAnchorPoint:CGPointZero];
    
    gameScore = score;
    gameTime = timeRemains;
    
    [self buildBackgrounds];
    [self buildLabels];
    [self buildMenu];
    
  }
  
  return self;
}

#pragma mark Interface Building

-(void) buildBackgrounds {
  
  CCSprite *uiOverlay = [CCSprite spriteWithFile:UI_BLACK_OVERLAY];
  
  [uiOverlay setPosition:CGPointZero];
  [uiOverlay setAnchorPoint:CGPointZero];
  
  [uiOverlay setScaleX:contentSize_.width/uiOverlay.contentSize.width];
  [uiOverlay setScaleY:contentSize_.height/uiOverlay.contentSize.height];
  
  [uiOverlay setOpacity:TTEndgameOverlayOpacity];
  
  [self addChild:uiOverlay z:TTOverlayHeight];
  
  CCSprite *menuBg = [CCSprite spriteWithFile: [Utility findPathForImage:UI_MENU_OVERLAY]];
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  [menuBg setAnchorPoint:CGPointMake(0.5, 0.5)];
  [menuBg setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
  
  [self addChild:menuBg z:TTMenuHeight];
}

-(void) buildLabels {
  
  CGPoint centre = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  CCLabelBMFont *paused = [CCLabelBMFont labelWithString:@"Paused" fntFile:fontName];
  [paused setPosition:CGPointMake(centre.x, centre.y + 80)];
  
  [self addChild:paused z:TTMenuLabelHeight];
  
  NSString *scoreString = [NSString stringWithFormat:@"Score: %@", [Utility formattedScore:gameScore]];
  CCLabelBMFont *score = [CCLabelBMFont labelWithString:scoreString fntFile:fontName];
  
  [score setPosition:CGPointMake(centre.x, centre.y + 50)];
  
  [self addChild:score z:TTMenuLabelHeight];
  
  [score setColor:PAUSEMENU_LABEL_COLOR_SCORE];
  
  CCSprite *timer = [CCSprite spriteWithFile:UI_TIMER_SPRITE];
  [timer setColor:PAUSEMENU_LABEL_COLOR_TIMER];
  
  CCLabelBMFont *timerText = [CCLabelBMFont labelWithString:[Utility formattedTime:gameTime] fntFile:fontName];
  [timerText setColor:PAUSEMENU_LABEL_COLOR_TIMER];
  
  [timer setScale:(timerText.contentSize.height - 5) / timer.contentSize.height];
  [timer setAnchorPoint:CGPointMake(1, 0.5)];
  
  [timerText setAnchorPoint:CGPointMake(0, 0.5)];
  
  CCNode *holder = [[CCNode alloc] init];
  
  [holder addChild:timer];
  [holder addChild:timerText];
  
  [holder setContentSize:CGSizeMake(timer.contentSize.width + 10 + timerText.contentSize.width,
                                    timerText.contentSize.height)];
  [holder setPosition:CGPointMake(centre.x, centre.y + 20)];
  [timer setPosition:CGPointMake(-10, 0)];
  
  [self addChild:holder z:TTMenuLabelHeight];
}

-(void) buildMenu {
  
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  CCLabelBMFont *resumeText = [CCLabelBMFont labelWithString:UI_STRING_PAUSE_RESUME fntFile:fontName];
  
  CCMenuItemLabel *resumeLabel = [CCMenuItemLabel itemWithLabel:resumeText
                                                         target:caller
                                                       selector:@selector(buttonClicked:)];
  [resumeLabel setPosition:CGPointMake(0, -15)];
  
  CCLabelBMFont *settingsText = [CCLabelBMFont labelWithString:UI_STRING_PAUSE_SETTINGS fntFile:fontName];
  
  CCMenuItemLabel *settingsLabel = [CCMenuItemLabel itemWithLabel:settingsText
                                                           target:caller
                                                         selector:@selector(buttonClicked:)];
  [settingsLabel setPosition:CGPointMake(0, -45)];
  
  CCLabelBMFont *menuText = [CCLabelBMFont labelWithString:UI_STRING_PAUSE_MENU fntFile:fontName];
  
  CCMenuItemLabel *menuLabel = [CCMenuItemLabel itemWithLabel:menuText
                                                       target:caller
                                                     selector:@selector(buttonClicked:)];
  [menuLabel setPosition:CGPointMake(0, -75)];
  
  CCMenu *pausedMenu = [CCMenu menuWithItems:resumeLabel, settingsLabel, menuLabel, nil];
  
  [self addChild:pausedMenu z:TTMenuLabelHeight];
}

@end
