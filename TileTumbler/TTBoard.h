
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TTBoard : CCNode
{
  // The dimensions of the board (in tiles)
  CGSize boardSize;
  
  // The dimensions of a tile in pixels
  CGSize tileSize;
  
  // Holds all the tiles on our board
  NSMutableArray *tiles;
}

// Initialises a new TTBoard with the bottom-left position at (0,0) and
// with dimensions: boardSize.
-(id)initWithSize:(CGSize)boardSize;

// Method used to generate a whole new set of random tiles for the board,
// replacing any previous tiles present.
-(void)generateRandomTiles;

// A method to be called to pass touch events to this board
-(void)boardTouched:(CGPoint)touchLocation;

@end