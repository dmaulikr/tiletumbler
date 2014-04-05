
/*
 * MainMenuLayer.h
 *
 * Tile Tumbler
 *
 * This layer is the first menu presented to the user - containing two labels: Play and Settings,
 * and a tile board in the background with tiles being randomly removed every now and then.
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"
#import "SettingsLayer.h"

#import "TTBoard.h"

#ifndef TileTumbler_MainMenuLayer_H_
#define TileTumbler_MainMenuLayer_H_

@interface MainMenuLayer : CCLayer<MenuButtonsClicked> {
  
  TTBoard *tileBoard;
  
  CCLabelBMFont *playLabel;
  CCLabelBMFont *tileLabel;
  CCLabelBMFont *tumbleLabel;
  
  CCMenu *playMenu;
  
  CCSprite *menuBackground;
  
  SettingsLayer *settingsLayer;
}

+(CCScene *) scene;

@end

#endif    // TileTumbler_MainMenuLayer_H_