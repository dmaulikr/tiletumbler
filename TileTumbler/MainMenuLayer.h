
#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "TTBoard.h"

@interface MainMenuLayer : CCLayer {
  
  // The TileBoard used as the backdrop
  TTBoard *tileBoard;
  
  CCLabelTTF *playLabel;
  CCMenu *playMenu;
}

+(CCScene *) scene;

@end
