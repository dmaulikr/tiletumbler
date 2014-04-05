
#import "Constants.h"
#import "EndgameLayer.h"

@implementation EndgameLayer

#pragma mark Lifecycle

-(instancetype) initWithScore:(uint)score caller:(id<MenuButtonsClicked>)callback {
  
  if ((self = [super init])) {
    
    [self setPosition:CGPointZero];
    [self setAnchorPoint:CGPointZero];
    
    caller = callback;
    gameScore = score;
    
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
  
  [menuBg setScaleX:(float)((32*6)-10) / menuBg.contentSize.width];
  [menuBg setScaleY:(float)(32*6) / menuBg.contentSize.height];
  
  [self addChild:menuBg z:TTMenuHeight];
}

-(void) buildLabels {
  
  CGPoint centre = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  CCLabelBMFont *paused = [CCLabelBMFont labelWithString:UI_STRING_ENDGAME_TITLE fntFile:fontName];
  
  [paused setPosition:CGPointMake(centre.x, centre.y + (IS_RETINA ? 80 : 70))];
  
  [paused setColor:ENDGAME_LABEL_COLOR_ROUNDOVER];
  
  [self addChild:paused z:TTMenuLabelHeight];
  
  NSString *scoreString = [NSString stringWithFormat:@"Score: %@", [Utility formattedScore:gameScore]];
  CCLabelBMFont *score = [CCLabelBMFont labelWithString:scoreString fntFile:fontName];
  
  [score setPosition:CGPointMake(centre.x, centre.y + 25)];
  
  [score setColor:ENDGAME_LABEL_COLOR_SCORE];
  
  [self addChild:score z:TTMenuLabelHeight];
}

-(void) buildMenu {
  
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  CCLabelBMFont *resumeText = [CCLabelBMFont labelWithString:UI_STRING_ENDGAME_NEW fntFile:fontName];
  
  [resumeText setColor:ENDGAME_LABEL_COLOR_NEWGAME];
  CCMenuItemLabel *resumeLabel = [CCMenuItemLabel itemWithLabel:resumeText
                                                         target:caller
                                                       selector:@selector(buttonClicked:)];
  
  [resumeLabel setPosition:CGPointMake(0, -35)];
  
  CCLabelBMFont *menuText = [CCLabelBMFont labelWithString:UI_STRING_ENDGAME_MENU fntFile:fontName];
  
  [menuText setColor:ENDGAME_LABEL_MAINMENU];
  
  CCMenuItemLabel *menuLabel = [CCMenuItemLabel itemWithLabel:menuText
                                                       target:caller
                                                     selector:@selector(buttonClicked:)];
  [menuLabel setPosition:CGPointMake(0, -75)];
  
  CCMenu *pausedMenu = [CCMenu menuWithItems:resumeLabel, menuLabel, nil];
  
  [self addChild:pausedMenu z:TTMenuLabelHeight];
}

@end
