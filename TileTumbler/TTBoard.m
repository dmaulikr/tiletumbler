
#import "TTBoard.h"
#import "TTTile.h"

@implementation TTBoard

-(id)initWithSize:(CGSize)_boardSize {
  
  if ((self = [super init])) {
  
    // Pre-stored constants
    tileSize = CGSizeMake(32, 32);
    
    boardSize = _boardSize;
    
    [self setContentSize:CGSizeMake(tileSize.width*boardSize.width,
                                    tileSize.height*boardSize.height)];
    
    // Initialise the tiles array and generate a new set of tiles
    [self setupNewTiles];
    [self generateRandomTiles];
  }
  
  return self;
}

// Initialises the tiles array and prepopulates with blank elements
// at each index in the array to allow direct replacing with tiles
-(void) setupNewTiles {
  
  uint totalTiles = boardSize.width * boardSize.height;
  
  tiles = [NSMutableArray arrayWithCapacity: totalTiles];
  
  // Iterate through the array, creating blank elements
  for (uint i = 0; i < totalTiles; i++) {
    
    // The null instance of a class (easily replaceable)
    [tiles addObject: [NSNull null]];
  }
}

-(void) generateRandomTiles {
  
  // Iterate through the array
  for (uint index = 0; index < tiles.count; index++) {
    
    // Remove and cleanup the previous tile stored here if present
    TTTile *oldTile = tiles[index];
    
    if (oldTile != nil)
      [self removeChild:oldTile cleanup:YES];
    
    // Calculate the position in the world-space for this new tile
    CGPoint position = [self positionFromIndex: index];
    CGPoint positionMult = CGPointMake(tileSize.width, tileSize.height);
    
    CGPoint positionWorld = ccpCompMult(position, positionMult);
    
    // Generate the new tile
    TTTile *newTile = [[TTTile alloc] initWithFile:@"Block.png"
                                          Position:positionWorld
                                              Size:tileSize];
    
    // Decide on a new colour for the tile
    uint colorCode = rand() % 4;
    [newTile setColourCode:colorCode];
    
    // Add the tile to the array and the board's children
    [tiles replaceObjectAtIndex:index withObject: newTile];
    [self addChild: newTile];
  }
}

// A method to be called to pass touch events to this board
-(void)boardTouched:(CGPoint)touchLocation {
  
  NSLog(@"Board touched at (%d, %d)", (int)roundf(touchLocation.x),
          (int)roundf(touchLocation.y));
  
  // 1. Attempt to find the tile index that we clicked on
  for (int i = 0; i < tiles.count; i++) {
    
    TTTile *tile = tiles[i];
    
    if (tile != (id)[NSNull null]) {
      
      if (CGRectContainsPoint(tile.boundingBox, touchLocation)) {
        
        uint arrayIndex = i;
        CGPoint tileIndex = [self positionFromIndex:arrayIndex];
        
        NSLog(@"Tile chosen at (%d, %d)", (int)tileIndex.x, (int)tileIndex.y);
        [tile setColourCode:4];
      }
    }
  }
}


// Generates the position that a tile should be in based on the position
// in the array. Works with x increasing horizontally and y increasing
// vertically.
-(CGPoint) positionFromIndex:(uint)index {
  
  uint y = index / (uint)boardSize.width;
  uint x = index - (y * (uint)boardSize.width);
  
  return CGPointMake(x, y);
}

// Generates an index into the tile array that should represent the
// given position on the board. Works with x increasing horizontaly and y
// increasing vertically.
-(uint) indexFromPosition:(CGPoint)position {
  
  return ((uint)position.y * (uint)boardSize.width) + (uint)position.y;
}

@end
