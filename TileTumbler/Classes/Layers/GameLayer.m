
#import "Constants.h"

#import "GameLayer.h"
#import "MainMenuLayer.h"

#import "SimpleAudioEngine.h"

@implementation GameLayer

#pragma mark - Lifecycle

// Returns a standard scene with the GameLayer initialised and placed within.
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
  
  layer.isTouchEnabled = YES;

	[scene addChild: layer];
  
	return scene;
}

-(instancetype) init {
  
  if ((self = [super init])) {
    
    timeRemaining = TTRoundTimeSeconds;
    currentScore = TTInitialScoreValue;
    
    [self buildTileBoard];
    [self buildInterface];
    [self buildMenu];
    
    [self schedule:@selector(updateLoop) interval:1 repeat:kCCRepeatForever delay:0];
  }
  
  return self;
}

// Generates the tile board at the appropriate size for our device and adds it to the board.
-(void) buildTileBoard {
  
  // Construct a slightly larger tile board if we have a 5th generation device
  if (IS_PHONEPOD5()) {
    tileBoard = [[TTBoard alloc] initWithSize:CGSizeMake(TTBoardDimensionsWidth, TTBoardDimensionsHeightTall)];
  } else {
    tileBoard = [[TTBoard alloc] initWithSize:CGSizeMake(TTBoardDimensionsWidth, TTBoardDimensionsHeight)];
  }
  
  [self addChild:tileBoard z:TTBoardHeight];
  [tileBoard setTileDelegate:self];
}

// Constructs our interface, including the header, labels and sprites for this layer.
-(void) buildInterface {
  
  CGSize contentSize = [CCDirector sharedDirector].winSize;
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  headerBar = [CCSprite spriteWithCGImage:[UIImage imageNamed:UI_HEADER_OVERLAY_FILE].CGImage key: UI_HEADER_OVERLAY_FILE];
  [headerBar setOpacity:TTHeaderOpacity];
  
  [headerBar setAnchorPoint:CGPointMake(1,1)];
  [headerBar setPosition:ccp(contentSize.width, contentSize.height)];
  
  [headerBar setScaleX:(float)contentSize.width/headerBar.contentSize.width];
  [headerBar setScaleY:(float)([tileBoard tileSize].height - 5)/headerBar.contentSize.height];
  
  [self addChild:headerBar z:TTHeaderHeight];
  
  scoreLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", currentScore] fntFile:fontName];
  
  [scoreLabel setColor:GAMELAYER_SCORE_COLOR];
  
  [scoreLabel setPosition:CGPointMake(5, contentSize.height - 2)];
  [scoreLabel setAnchorPoint:CGPointMake(0, 1)];
  
  timerLabel = [CCLabelBMFont labelWithString:[Utility formattedTime:timeRemaining] fntFile:fontName];
  
  [timerLabel setColor:GAMELAYER_TIMER_COLOR];
  [timerLabel setPosition:CGPointMake(contentSize.width-5,
                                      contentSize.height - 2)];
  [timerLabel setAnchorPoint:CGPointMake(1, 1)];
  
  [self addChild: timerLabel z:TTHeaderItemHeight];
  
  [self addChild: scoreLabel z:TTHeaderItemHeight];
}

// Constructs the pause menu label and button at the top of the screen.
-(void) buildMenu {
  
  CGSize contentSize = [CCDirector sharedDirector].winSize;
  NSString *fontName = IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW;
  
  pauseLabel = [CCLabelBMFont labelWithString:UI_STRING_GAME_PAUSE fntFile:fontName];
  
  [pauseLabel setColor:GAMELAYER_PAUSE_COLOR];
  
  [pauseLabel setPosition:CGPointZero];
  [pauseLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
  
  CCMenuItemLabel *pauseMenuLabel = [CCMenuItemLabel itemWithLabel:pauseLabel target:self selector:@selector(pauseButtonClicked)];
  
  [pauseMenuLabel setPosition:CGPointZero];
  [pauseMenuLabel setAnchorPoint:CGPointMake(0.5, 0.5)];
  
  pauseMenu = [CCMenu menuWithItems:pauseMenuLabel, nil];
  
  [pauseMenu setPosition:CGPointMake(contentSize.width/2, contentSize.height-12)];
  [pauseMenu setAnchorPoint:CGPointMake(0.5, 1)];
  
  pauseMenu.isTouchEnabled = YES;
  
  [self addChild: pauseMenu z:TTHeaderItemHeight];
}

// Creates a new game by replacing the current scene with another newly generated one.
-(void) startNewGame {
  
  CCDirector *director = [CCDirector sharedDirector];
  
  if (director.isPaused) {
    [director resume];
  }
  
  [director replaceScene:[GameLayer scene]];
}

-(void) pauseGame {
  
  paused = YES;
  [[CCDirector sharedDirector] pause];
}

-(void) resumeGame {
  
  paused = NO;
  [[CCDirector sharedDirector] resume];
}

-(void) updateLoop {
  
  if (paused) {
    return;
  }
  
  if (timeRemaining > 0) {
    timeRemaining--;
    
    if (!dragEnabled && timeRemaining <= TTBonusRoundInitTime) {
      [self enableDragMode];
    }
  }
  
  // Don't use an |else if| as the timeRemaining is modified above in the if conditional body
  if (timeRemaining <= 0) {
    
    [[CCDirector sharedDirector] pause];
    
    paused = YES;
    finished = YES;
    
    endOverlay = [[EndgameLayer alloc] initWithScore:currentScore caller:self];
    endOverlay.isTouchEnabled = YES;
    
    [self addChild:endOverlay z:TTPauseLayerHeight];
    
    [self unschedule:@selector(updateLoop)];
  }
  
  [timerLabel setString: [Utility formattedTime:timeRemaining]];
}

#pragma mark - Interface States

-(void) showMainMenu {
  
  CCDirector *director = [CCDirector sharedDirector];
  
  if (director.isPaused) {
    [director resume];
  }
  
  [director replaceScene:[CCTransitionCrossFade transitionWithDuration:TTMenuTransitionTime scene:[MainMenuLayer scene]]];
}

-(void) showSettings {
  
  [pauseOverlay setVisible:NO];
  
  settingsOverlay = [[SettingsLayer alloc] initWithDelegate:self];
  [self addChild:settingsOverlay z:TTPauseSettingsHeight];
}

-(void) hideSettings {
  
  [pauseOverlay setVisible:YES];
  
  [self removeChild:settingsOverlay cleanup:YES];
}

#pragma mark - Game States

// Constructs the labels to be temporarily displayed indicating to the user that our bonus mode
// is activated, displays these and sets the flag to enable our bonus mode.
-(void) enableDragMode {
  
  dragEnabled = YES;
  
  NSString *fontName = IS_RETINA ? UI_FONT_SUPERLARGE : UI_FONT_LARGE;
  
  CCLabelBMFont *bonusLabel = [CCLabelBMFont labelWithString:UI_STRING_GAME_BONUSTITLE fntFile:fontName];
  
  fontName = IS_RETINA ? UI_FONT_LARGE : UI_FONT_STANDARD;
  
  CCLabelBMFont *infoLabel = [CCLabelBMFont labelWithString:UI_STRING_GAME_BONUSTEXT fntFile:fontName];
  
  [bonusLabel setPosition:ccp(contentSize_.width/2, contentSize_.height/2)];
  [infoLabel setPosition:ccpAdd(bonusLabel.position, ccp(0,-35))];
  
  [self addChild:bonusLabel];
  [self addChild:infoLabel];
  
  id fadeOut = [CCFadeOut actionWithDuration:TTActionTimeBonusModeFade];
  
  CCCallBlockN *removeNodes = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    [self removeChild:bonusLabel cleanup:YES];
  }];
  
  [bonusLabel runAction:[CCSequence actions:fadeOut, removeNodes, nil]];
  
  fadeOut = [CCFadeOut actionWithDuration:TTActionTimeBonusModeFade];
  removeNodes = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    [self removeChild:infoLabel cleanup:YES];
  }];
  
  // Delay the lower description to fade one second after the larger text, giving time to read.
  [infoLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1], fadeOut, removeNodes, nil]];
}

// Utility method to update the score label and time the score is modified.
-(void) modifyScoreByAmount:(int)difference {
  
  currentScore += difference;
  
  [scoreLabel setString:[Utility formattedScore:currentScore]];
}

#pragma mark - Responding Methods

// Responding method to the notification that |count| tiles have been removed from
// the board. Constructs a modifier label and creates an action to move it to the score label.
-(void) removedTilesWithCount:(uint)count {
  
  NSString *dScoreString = [NSString stringWithFormat:@"+%d", count];
  
  CCLabelBMFont *dScore = [CCLabelBMFont labelWithString:dScoreString fntFile:IS_RETINA ? UI_FONT_STANDARD : UI_FONT_LOW];
  
  [dScore setPosition: lastTouch];
  
  CGPoint centerScore = ccp(scoreLabel.boundingBox.origin.x + scoreLabel.boundingBox.size.width/2,
                            scoreLabel.boundingBox.origin.y + scoreLabel.boundingBox.size.height/2);
  
  id moveAction = [CCMoveTo actionWithDuration:TTActionTimeScoreModifierMove position:centerScore];
  
  id fadeAction = [CCFadeTo actionWithDuration:TTActionTimeScoreModifierFade opacity:TTActionValueScoreModifierFadeTo];
  
  id postAction = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    
    [self modifyScoreByAmount: count];
    
    [self removeChild:dScore cleanup:YES];
  }];
  
  // Play the relevant sound for this being removed
  float soundPitch;
  
  if (count <= TTLowerPitchThreshold) {
    soundPitch = TTSoundEffectsLowerPitch;
  } else {
    soundPitch = TTSoundEffectsUpperPitch;
  }
  
  [[SimpleAudioEngine sharedEngine] playEffect:MUSIC_FILE_EFFECTS pitch:soundPitch pan:0 gain:1];
  
  [dScore runAction:[CCSpawn actionOne:[CCSequence actions:moveAction, postAction, nil] two:fadeAction]];
  
  [self addChild: dScore z:TTScoreModifierHeight];
}

// Responding to notifications from layers that a button has been pressed. Comparisons are made
// on the labels text to determine which label was pressed and our course of action
-(void) buttonClicked:(id)sender {
  
  CCMenuItemLabel *senderItem = (CCMenuItemLabel *)sender;
  NSString *label = [[senderItem label] string];
  
  if ([label isEqualToString:UI_STRING_PAUSE_RESUME]) {
    
    [self removeChild:pauseOverlay cleanup:YES];
    pauseOverlay = nil;
    
    [self resumeGame];
    
  } else if ([label isEqualToString:UI_STRING_ENDGAME_NEW]) {
    
    [self startNewGame];
    
  } else if ([label isEqualToString:UI_STRING_ENDGAME_MENU] || [label isEqualToString:UI_STRING_PAUSE_MENU]) {
    
    [self showMainMenu];
    
  } else if ([label isEqualToString:UI_STRING_PAUSE_SETTINGS]) {
    
    [self showSettings];
  } else if ([label isEqualToString:UI_STRING_SETTINGS_MENU]) {
    
    [self hideSettings];
  }
}

// The responding method to the Pause label being pressed at the top of the layer, displays
// the pause menu and pauses the game state.
-(void) pauseButtonClicked {
  
  [self pauseGame];
  
  if (pauseOverlay == nil) {
    
    pauseOverlay = [[PauseLayer alloc] initWithScore:currentScore time:timeRemaining caller:self];
    pauseOverlay.isTouchEnabled = YES;
    
    [self addChild:pauseOverlay z:TTPauseLayerHeight];
  }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  if (touch == nil) {
    return;
  }
  
  CGPoint touchNode = [self convertTouchToNodeSpace:touch];
  
  // Store the touch so that the score modifier label can be placed appropriately if
  // we need to.
  lastTouch = touchNode;
  
  // Only pass the touch to the pause menulabel if we aren't currently paused
  if (CGRectContainsPoint(headerBar.boundingBox, touchNode) && !paused) {
    [pauseMenu ccTouchBegan:touch withEvent:event];
    
  // Only pass touches to the board if we are not currently paused
  } else if (CGRectContainsPoint(tileBoard.boundingBox, touchNode) && !paused) {
    [tileBoard boardTouchedAtPosition:touchNode];
  }
}

// Responds to the user dragging their finger only if we have the bonus mode enabled
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  if (dragEnabled) {
    [self ccTouchesBegan:touches withEvent:event];
  }
}

@end
