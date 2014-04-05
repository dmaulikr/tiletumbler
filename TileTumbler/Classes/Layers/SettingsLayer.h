
/*
 * SettingsLayer.h
 *
 * Tile Tumbler
 *
 * This layer functions as the controller for the volume settings of our game and also displays
 * credits.
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"

#import "Utility.h"
#import "Constants.h"
#import "CCControlExtension.h"

#ifndef TileTumbler_SettingsLayer_H_
#define TileTumbler_SettingsLayer_H_

@interface SettingsLayer : CCLayer {
  
  id<MenuButtonsClicked> _handler;
  
  CCControlSlider *backgroundVolumeSlider;
  CCControlSlider *soundEffectsSlider;
  
  CCLabelBMFont *backgroundSoundLabel;
  CCLabelBMFont *soundEffectsLabel;
  
  CCSprite *volumeBox;
  CCSprite *infoBox;
}

-(instancetype) initWithDelegate:(id<MenuButtonsClicked>)handler;

@end

#endif    // TileTumbler_SettingsLayer_H_