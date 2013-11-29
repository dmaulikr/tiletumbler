
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TTBoard : CCNode
{
  // Holds all the tiles on our board
  NSMutableArray *tiles;
}

// Initialises a new TTBoard with the bottom-left position at (0,0) and
// with dimensions: boardSize.
-(id)initWithSize:(CGSize)boardSize;

@end