
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

-(TTTile *)generateTileFor:(uint)index {
  
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
  
  return newTile;
}

-(void) generateRandomTiles {
  
  // Iterate through the array
  for (uint index = 0; index < tiles.count; index++) {
    
    // Remove and cleanup the previous tile stored here if present
    TTTile *oldTile = tiles[index];
    
    if (oldTile != nil)
      [self removeChild:oldTile cleanup:YES];
    
    TTTile *newTile = [self generateTileFor:index];
    
    // Add the tile to the array and the board's children
    [tiles replaceObjectAtIndex:index withObject: newTile];
    [self addChild: newTile];
  }
}

// A method to be called to pass touch events to this board
-(void)boardTouched:(CGPoint)touchLocation {
  
  // 1. Attempt to find the tile index that we clicked on
  for (int i = 0; i < tiles.count; i++) {
    
    TTTile *tile = tiles[i];
    
    if (tile != (id)[NSNull null]) {
      
      if (CGRectContainsPoint(tile.boundingBox, touchLocation)) {
        
        // 2. Pass the message on
        [self tileTouched: tile];
      }
    }
  }
}

// Removes the given tile from the board
-(void)tileTouched:(TTTile *)tile {
  
  [self getConnectedTo:tile];
  //[self removeTile: tile];
  //[self fixBoard];
}

// Iterates across the board, finding any NULL tiles and
// generating a new tile for each of these.
-(void)fixBoard {
  
  for (uint i = 0; i < tiles.count; i++) {
    
    if (tiles[i] == (id)[NSNull null]) {
      
      CGPoint startingPosition = [self positionFromIndex:i];
      
      for (uint y = startingPosition.y; y < boardSize.height; y++) {
        
        // If we're still not at the top, drop the above tiles down
        if (y < boardSize.height-1) {
          
          // Information of tile above our current loop's position
          CGPoint abovePosition = CGPointMake(startingPosition.x, y+1);
          TTTile *tileAbove = tiles[[self indexFromPosition:abovePosition]];
          
          CGPoint pixelPosition = tileAbove.position;
          CGPoint sub = CGPointMake(0, tileSize.height);
          
          // Information of tile at our current loop's position
          CGPoint currentPosition = CGPointMake(startingPosition.x, y);
          uint currentIndex = [self indexFromPosition:currentPosition];
          
          // Move tile's actual position down
          [tileAbove setPosition:ccpSub(pixelPosition, sub)];
          [tiles replaceObjectAtIndex:currentIndex withObject:tileAbove];
          
        } else {
          
          // We're at the top; generate a new tile
          CGPoint topPoint = CGPointMake(startingPosition.x, y);
          uint topIndex = [self indexFromPosition:topPoint];
          
          TTTile *newTile = [self generateTileFor:topIndex];
          [tiles replaceObjectAtIndex:topIndex withObject:newTile];
          
          [self addChild:newTile];
        }
      }
    }
  }
}

// The entry method to our recursive search for connected tiles, takes
// a given tile and determines all the adjacent tiles that are connected to it
// via the same colour.
-(NSArray *)getConnectedTo:(TTTile *)tile {
  
  NSMutableSet *connectedSet = [NSMutableSet set];
  [self getConnectedTo:tile WithSet:connectedSet];
  
  // Highlight the connected tiles by changing colour
  for (TTTile *tile in connectedSet) {
    tile.ColourCode = 4;
  }
  
  return connectedSet.allObjects;
}

// Our recursive companion to the above method, used in recursive calls to
// neighbouring tiles. Takes the set /found/ which identifies all tiles
// that have already been indexed and so no recursive calls should be made
// on these.
-(void)getConnectedTo:(TTTile *)tile WithSet:(NSMutableSet *)found {
  
  // Can't have a nil set as we don't return a value!
  if (found == nil) return;
  
  // Get the colour of our original tile and set this tile as searched
  uint originColour = tile.ColourCode;
  [found addObject:tile];
  
  // Check if each neighbour qualifies as connected then recursively call them
  CGPoint currentPosition = [self findTilePosition:tile];
  
  NSMutableArray *validNeighbours = [NSMutableArray arrayWithCapacity:4];
  
  // Left Neighbour
  if (currentPosition.x >= 0) {
    
    CGPoint leftPos = CGPointMake(currentPosition.x-1, currentPosition.y);
    TTTile *left = tiles[[self indexFromPosition:leftPos]];
    
    if (left.ColourCode == originColour && ![found containsObject:left])
      [validNeighbours addObject:left];
  }
  
  // Right Neighbour
  if (currentPosition.x < boardSize.width-1) {
    
    CGPoint rightPos = CGPointMake(currentPosition.x+1, currentPosition.y);
    TTTile *right = tiles[[self indexFromPosition:rightPos]];
    
    if (right.ColourCode == originColour && ![found containsObject:right])
      [validNeighbours addObject:right];
  }
  
  // Upper Neighbour
  if (currentPosition.y < boardSize.height-1) {
    
    CGPoint upperPos = CGPointMake(currentPosition.x, currentPosition.y+1);
    TTTile *upper = tiles[[self indexFromPosition:upperPos]];
    
    if (upper.ColourCode == originColour && ![found containsObject:upper])
      [validNeighbours addObject:upper];
  }
  
  // Lower Neighbour
  if (currentPosition.y > 0) {
    
    CGPoint lowerPos = CGPointMake(currentPosition.x, currentPosition.y-1);
    TTTile *lower = tiles[[self indexFromPosition:lowerPos]];
    
    if (lower.ColourCode == originColour && ![found containsObject:lower])
      [validNeighbours addObject:lower];
  }
  
  // For each neighbour, recursively call and add to set
  for (TTTile *neighbour in validNeighbours) {
    
    // Mutable set passed so we don't need to add any results
    [self getConnectedTo:neighbour WithSet:found];
  }
}

-(void)removeTile:(TTTile *)tile {
  
  // Find the tile in our array and replace with null
  for (int i = 0; i < tiles.count; i++) {
    if (tiles[i] == tile)
      [tiles replaceObjectAtIndex:i withObject:(id)[NSNull null]];
  }
  
  // Remove the tile from the board's children
  [self removeChild:tile cleanup:YES];
}

// Convenience method to check the tile index is valid
// then pass it to tileTouched:(TTTile *)
-(void)tileTouchedAt:(uint)index {
  
  if (tiles[index] != (id)[NSNull null])
    [self getConnectedTo:tiles[index]];
    //[self tileTouched: tiles[index]];
}

// Attempts to find the given tile's position in the board coordinates,
// returns (-1,-1) if not found.
-(CGPoint) findTilePosition:(TTTile *)tile {
  
  if (![self.children containsObject:tile])
    return CGPointMake(-1, -1);
  
  for (int i = 0; i < tiles.count; i++) {
    
    if (tiles[i] == tile) return [self positionFromIndex:i];
  }
  
  return CGPointMake(-1, -1);
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
  
  return ((uint)position.y * (uint)boardSize.width) + (uint)position.x;
}

@end
