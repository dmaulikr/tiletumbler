
#import "PauseLayer.h"

@implementation PauseLayer

-(id) initWithScore:(uint)score time:(uint)timeRemains caller:(id<MenuButtonsClicked>)callback
{
  if ((self = [super init])) {
    
    caller = callback;
    
    [self setPosition:CGPointZero];
    [self setAnchorPoint:CGPointZero];
    
    // Assign our stored variables
    gameScore = score;
    gameTime = timeRemains;
    
    // Add our background overlay
    CCSprite *uiOverlay = [CCSprite spriteWithFile:@"overlay.png"];
    
    [uiOverlay setPosition:CGPointZero];
    [uiOverlay setAnchorPoint:CGPointZero];
    
    [uiOverlay setScaleX:contentSize_.width/uiOverlay.contentSize.width];
    [uiOverlay setScaleY:contentSize_.height/uiOverlay.contentSize.height];
    
    [uiOverlay setOpacity:200];
    
    [self addChild:uiOverlay z:0];
    
    CCSprite *menuBg = [CCSprite spriteWithFile:@"overlay.png"];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    [menuBg setAnchorPoint:CGPointMake(0.5, 0.5)];
    [menuBg setPosition:CGPointMake(winSize.width/2, winSize.height/2)];
    
    [menuBg setScaleX:(float)((32*6)-10) / menuBg.contentSize.width];
    [menuBg setScaleY:(float)(32*6) / menuBg.contentSize.height];
    
    [self addChild:menuBg z:1];
    
    CCSprite *menuBorder = [CCSprite spriteWithFile:@"Border.png"];
    
    [menuBorder setAnchorPoint:CGPointMake(0.5, 0.5)];
    [menuBorder setPosition:CGPointMake(contentSize_.width/2, contentSize_.height/2)];
    
    [menuBorder setScaleX:(float)(180) / menuBorder.contentSize.width];
    [menuBorder setScaleY:(float)(190) / menuBorder.contentSize.height];
    
    [self addChild:menuBorder z:2];
    
    // Create Paused Menu Item
    CGSize labelSize = CGSizeMake(4*32, 32);
    
    CCLabelTTF *paused = [CCLabelTTF labelWithString:@"Paused"
                                          dimensions:labelSize
                                          hAlignment:kCCTextAlignmentCenter
                                            fontName:@"Arial"
                                            fontSize:13];
    
    CCMenuItemLabel *pausedLabel = [CCMenuItemLabel itemWithLabel:paused];
    [pausedLabel setPosition:CGPointMake(0, 70)];
    
    // Create Score Menu Item
    NSString *scoreString = [NSString stringWithFormat:@"Score:  %d", gameScore];
    CCLabelTTF *score = [CCLabelTTF labelWithString:scoreString
                                         dimensions:labelSize
                                         hAlignment:kCCTextAlignmentCenter
                                           fontName:@"Arial"
                                           fontSize:12];
    
    CCMenuItemLabel *scoreLabel = [CCMenuItemLabel itemWithLabel:score];
    [scoreLabel setPosition:CGPointMake(0, 35)];
    
    // Add Time Sprite and Label Item to Sprite Parent
    CCSprite *timer = [CCSprite spriteWithFile:@"Timer.png"];
    
    uint minutes = floor((float)gameTime / 60);
    uint seconds = gameTime - (minutes * 60);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##"];
    
    NSString *secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
    NSString *timeString = [NSString stringWithFormat:@"%d:%@", minutes, secondString];
    
    CCLabelTTF *timerText = [CCLabelTTF labelWithString:timeString fontName:@"Arial" fontSize:12];
    [timerText setAnchorPoint:CGPointMake(0, 0.5)];
    [timerText setPosition:CGPointMake(timer.contentSize.width+10, timer.contentSize.height/2.0)];
    
    [timer addChild: timerText];
    [timer setContentSize:CGSizeMake(timer.contentSize.width+timerText.contentSize.width+10,
                                     timer.contentSize.height)];
  
    CCMenuItemSprite *spriteLabel = [CCMenuItemSprite itemWithNormalSprite:timer
                                                            selectedSprite:nil];
    [spriteLabel setPosition:CGPointMake(15, 15)];
    
    // Create Resume Menu Label
    CCLabelTTF *resumeText = [CCLabelTTF labelWithString:@"RESUME"
                                              dimensions:labelSize
                                              hAlignment:kCCTextAlignmentCenter
                                                fontName:@"Arial"
                                                fontSize:11];
    
    CCMenuItemLabel *resumeLabel = [CCMenuItemLabel itemWithLabel:resumeText
                                                           target:caller
                                                         selector:@selector(resumeClicked)];
    [resumeLabel setPosition:CGPointMake(0, -35)];
    
    // Create Main Menu Menu Label
    CCLabelTTF *menuText = [CCLabelTTF labelWithString:@"MAIN MENU"
                                              dimensions:labelSize
                                              hAlignment:kCCTextAlignmentCenter
                                                fontName:@"Arial"
                                                fontSize:11];
    
    CCMenuItemLabel *menuLabel = [CCMenuItemLabel itemWithLabel:menuText
                                                         target:caller
                                                       selector:@selector(menuClicked)];
    [menuLabel setPosition:CGPointMake(0, -75)];
    
    // Create Menu
    CCMenu *pausedMenu = [CCMenu menuWithItems:pausedLabel,
                          scoreLabel, spriteLabel, resumeLabel, menuLabel, nil];
    
    
    // Add Menu at Appropriate Position
    [self addChild:pausedMenu z:3];
  }
  
  return self;
}

@end
