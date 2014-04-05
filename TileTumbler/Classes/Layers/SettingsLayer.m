
#import "SettingsLayer.h"
#import "CCControlExtension.h"
#import "SimpleAudioEngine.h"

#import "cocos2d.h"

@implementation SettingsLayer

#pragma mark Lifecycle

-(instancetype) initWithDelegate:(id<MenuButtonsClicked>)handler {
  
  if ((self = [super init])) {
    
    [self buildBackgrounds];
    [self buildLabels];
    [self buildMenu];
    [self buildSliders];
    
    _handler = handler;
  }
  
  return self;
}

#pragma mark Interface Building

-(void) buildBackgrounds {
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  CCSprite *overlay = [CCSprite spriteWithFile:UI_BLACK_OVERLAY];
  
  [overlay setScaleX:winSize.width/overlay.contentSize.width];
  [overlay setScaleY:winSize.height/overlay.contentSize.height];
  
  [overlay setPosition:CGPointZero];
  [overlay setAnchorPoint:CGPointZero];
  
  [overlay setOpacity:TTCreditsOpacity];
  
  [self addChild:overlay z:TTOverlayHeight];
  
  infoBox = [CCSprite spriteWithFile: [Utility findPathForImage:UI_CREDITS_INFO_BOX]];
  
  [infoBox setAnchorPoint:CGPointMake(0.5, 0)];
  [infoBox setPosition:ccp(contentSize_.width/2, IS_PHONEPOD5() ? 67 : 32)];
  
  [self addChild:infoBox z:TTCreditsBoxHeight];
  
  volumeBox = [CCSprite spriteWithFile: [Utility findPathForImage:UI_CREDITS_INFO_BOX]];
  
  [volumeBox setAnchorPoint:CGPointMake(0.5, 0)];
  [volumeBox setPosition:ccp(contentSize_.width/2, infoBox.position.y + infoBox.contentSize.height + (IS_PHONEPOD5() ? 67 : 32))];
  
  [self addChild:volumeBox z:TTCreditsBoxHeight];
}

-(void) buildLabels {
  
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  CCLabelBMFont *volLabel = [CCLabelBMFont labelWithString:@"Volume" fntFile:fontName];
  
  [volLabel setPosition:CGPointMake(contentSize_.width/2, contentSize_.height - 50)];
  [volLabel setColor:CREDITS_LABEL_COLOR_VOLUME];
  
  [self addChild:volLabel z:TTCreditsLabelHeight];
  
  fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  backgroundSoundLabel = [CCLabelBMFont labelWithString:@"Background" fntFile:fontName];
  
  [backgroundSoundLabel setPosition:ccpAdd(volLabel.position, ccp(0,-32))];
  [backgroundSoundLabel setColor:CREDITS_LABEL_COLOR_BACKGROUND];
  
  [self addChild:backgroundSoundLabel z:TTCreditsLabelHeight];
  
  soundEffectsLabel = [CCLabelBMFont labelWithString:@"Sound Effects" fntFile:fontName];
  
  [soundEffectsLabel setPosition:ccpAdd(backgroundSoundLabel.position, ccp(0,-60))];
  [soundEffectsLabel setColor:CREDITS_LABEL_COLOR_FX];
  
  [self addChild:soundEffectsLabel z:TTCreditsLabelHeight];
  
  // Add the credits labels
  fontName = IS_RETINA ? UI_FONT_LOW : UI_FONT_SUPERLOW;
  
  CCLabelBMFont *infoLabel = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_CREDITS1 fntFile:fontName];
  
  uint yPos = infoBox.position.y + infoBox.contentSize.height - 32;
  
  [infoLabel setPosition:ccp(contentSize_.width/2, yPos)];
  [infoLabel setColor:CREDITS_LABEL_COLOR_LINE1];
  
  [self addChild:infoLabel z:TTCreditsLabelHeight];
  
  infoLabel = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_CREDITS2 fntFile:fontName];
  
  yPos -= 30;
  [infoLabel setPosition:ccp(contentSize_.width/2, yPos)];
  [infoLabel setColor:CREDITS_LABEL_COLOR_LINE2];
  
  [self addChild:infoLabel z:TTCreditsLabelHeight];
  
  infoLabel = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_CREDITS3 fntFile:fontName];
  
  yPos -= 30;
  [infoLabel setPosition:ccp(contentSize_.width/2, yPos)];
  [infoLabel setColor:CREDITS_LABEL_COLOR_LINE3];
  
  [self addChild:infoLabel z:TTCreditsLabelHeight];
  
  infoLabel = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_CREDITS4 fntFile:fontName];
  
  yPos -= 30;
  [infoLabel setPosition:ccp(contentSize_.width/2, yPos)];
  [infoLabel setColor:CREDITS_LABEL_COLOR_LINE4];
  
  [self addChild:infoLabel z:TTCreditsLabelHeight];
  
  infoLabel = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_CREDITS5 fntFile:fontName];
  
  yPos -= 30;
  [infoLabel setPosition:ccp(contentSize_.width/2, yPos)];
  [infoLabel setColor:CREDITS_LABEL_COLOR_LINE1];
  
  [self addChild:infoLabel z:TTCreditsLabelHeight];
}

-(void) buildMenu {
  
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  // Add the return to main menu button
  CCLabelBMFont *menuText = [CCLabelBMFont labelWithString:UI_STRING_SETTINGS_MENU fntFile:fontName];
  [menuText setColor:CREDITS_LABEL_COLOR_MAINMENU];
  
  CCMenuItemLabel *menuLabel = [CCMenuItemLabel itemWithLabel:menuText
                                                       target:self
                                                     selector:@selector(buttonClicked:)];
  CCMenu *menu = [CCMenu menuWithItems:menuLabel, nil];
  [menu setPosition:ccp(contentSize_.width/2, volumeBox.position.y + 25)];
  
  [self addChild:menu z:TTCreditsLabelHeight+1];
}

-(void) buildSliders {
  
  NSString *sliderBackground = [Utility findPathForImage:UI_CREDITS_SLIDER_BACKGROUND];
  NSString *sliderThumb = [Utility findPathForImage:UI_CREDITS_SLIDER_THUMB];
  NSString *sliderTrack = [Utility findPathForImage:UI_CREDITS_SLIDER_TRACK];
  
  backgroundVolumeSlider = [CCControlSlider sliderWithBackgroundFile:sliderBackground
                                                        progressFile:sliderTrack
                                                           thumbFile:sliderThumb];
  [backgroundVolumeSlider setPosition:CGPointMake(contentSize_.width/2, backgroundSoundLabel.position.y - 30)];
  [backgroundVolumeSlider addTarget:self action:@selector(valueChangedForSlider:) forControlEvents:CCControlEventValueChanged];
  [backgroundVolumeSlider setValue:[[SimpleAudioEngine sharedEngine] backgroundMusicVolume]];
  
  [self addChild:backgroundVolumeSlider z:TTCreditsLabelHeight];

  soundEffectsSlider = [CCControlSlider sliderWithBackgroundFile:sliderBackground
                                                    progressFile:sliderTrack
                                                       thumbFile:sliderThumb];
  [soundEffectsSlider setPosition:CGPointMake(contentSize_.width/2, soundEffectsLabel.position.y - 25)];
  [soundEffectsSlider addTarget:self action:@selector(valueChangedForSlider:) forControlEvents:CCControlEventValueChanged];
  [soundEffectsSlider setValue:[[SimpleAudioEngine sharedEngine] effectsVolume]];
  
  [self addChild:soundEffectsSlider z:TTCreditsLabelHeight];
  
  NSString *volMinIcon = [Utility findPathForImage:UI_ICON_VOL_MIN];
  NSString *volMaxIcon = [Utility findPathForImage:UI_ICON_VOL_MAX];
  
  CCSprite *volMin = [CCSprite spriteWithFile:volMinIcon];
  CCSprite *volMax = [CCSprite spriteWithFile:volMaxIcon];
  
  [volMin setPosition:ccp(backgroundVolumeSlider.position.x - (backgroundVolumeSlider.contentSize.width/2) - volMin.contentSize.width - 10,
                          backgroundVolumeSlider.position.y)];
  [volMax setPosition:ccp(backgroundVolumeSlider.position.x + (backgroundVolumeSlider.contentSize.width/2) + volMax.contentSize.width + 8,
                          backgroundVolumeSlider.position.y)];
  
  [self addChild:volMin z:TTCreditsLabelHeight];
  [self addChild:volMax z:TTCreditsLabelHeight];
  
  volMin = [CCSprite spriteWithFile:volMinIcon];
  volMax = [CCSprite spriteWithFile:volMaxIcon];
  
  [volMin setPosition:ccp(soundEffectsSlider.position.x - (soundEffectsSlider.contentSize.width/2) - volMin.contentSize.width - 10,
                          soundEffectsSlider.position.y)];
  [volMax setPosition:ccp(soundEffectsSlider.position.x + (soundEffectsSlider.contentSize.width/2) + volMax.contentSize.width + 8,
                          soundEffectsSlider.position.y)];
  
  [self addChild:volMin z:TTCreditsLabelHeight];
  [self addChild:volMax z:TTCreditsLabelHeight];
}

#pragma mark Responders

-(void) valueChangedForSlider:(CCControlSlider *)slider {
  
  float newVal = [slider value];
  
  if (slider == backgroundVolumeSlider) {
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:newVal];
    
  } else if (slider == soundEffectsSlider) {
    
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:newVal];
  }
}

// Responds to the SettingsLayer Main Menu button being pressed. Saves any changes that we
// have made to the volumes and then calls the delegate handling the button press.
-(void) buttonClicked:(id)button {
  
  [[NSUserDefaults standardUserDefaults]
   setObject:[NSNumber numberWithFloat:backgroundVolumeSlider.value] forKey:SETTINGS_KEY_BG_VOL];
  
  [[NSUserDefaults standardUserDefaults]
   setObject:[NSNumber numberWithFloat:soundEffectsSlider.value] forKey:SETTINGS_KEY_FX_VOL];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [_handler performSelector:@selector(buttonClicked:) withObject:button];
}

@end
