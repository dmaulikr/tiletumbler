
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
  
  NSArray *connected = [self getConnectedTo:tile];
  
  // Remove all our connected tiles
  for (TTTile *tile in connected) {
    
    [self removeTile: tile];
  }
  
  // Call our delegate, letting it know we've removed tiles.
  [self.TileDelegate tilesRemoved:connected.count];
  
  [self fixBoard];
}

// Iterates across the board, finding any NULL tiles and
// generating a new tile for each of these.
-(void)fixBoard {
  
  // Iterate across the columns of the board, starting at the bottom tile
  for (int i = 0; i < boardSize.width; i++) {
    
    // Count the number of null tiles in this column
    uint nullCount = 0;
    
    // Iterate up the column until we reach the top of the board, excusing
    // null tiles
    for (uint y = 0; y < boardSize.height; y++) {
      
      uint tileIndex = [self indexFromPosition:CGPointMake(i, y)];
      
      // If we find a null tile increase the null count and continue
      if (tiles[tileIndex] == (id)[NSNull null]) {
        
        nullCount++;
      } else if (nullCount > 0) {
        
        // Move tile to replace the lowermost null tile
        CGPoint belowPosition = CGPointMake(i, y - nullCount);
        uint belowIndex = [self indexFromPosition:belowPosition];
        
        // Create a moving transition to move the tile
        CGPoint belowPxPosition = CGPointMake(belowPosition.x * tileSize.width,  belowPosition.y * tileSize.height);
        
        id move = [CCMoveTo actionWithDuration:TILE_SPEED position:belowPxPosition];
        
        [tiles[tileIndex] runAction:move];
        [tiles replaceObjectAtIndex:belowIndex withObject:tiles[tileIndex]];
      }
    }
    
    // Generate new tiles for our upper null positions
    for (uint y = boardSize.height - nullCount; y < boardSize.height; y++) {
      
      CGPoint expectedPosition = CGPointMake(i, y);
      CGPoint expectedPxPosition = CGPointMake(expectedPosition.x * tileSize.width, expectedPosition.y * tileSize.height);
      
      uint tileIndex = [self indexFromPosition:expectedPosition];
      
      // Generate a move action to our expected position
      id move = [CCMoveTo actionWithDuration:TILE_SPEED position:expectedPxPosition];
      
      
      // Generate a new tile and place above the board, then start the move action
      TTTile *newTile = [self generateTileFor:tileIndex];
      [newTile setPosition:CGPointMake(expectedPxPosition.x, expectedPxPosition.y + nullCount*tileSize.height)];
      [newTile runAction:move];
      
      [tiles replaceObjectAtIndex:tileIndex withObject:newTile];
      [self addChild:newTile];
    }
  }
}

// The entry method to our recursive search for connected tiles, takes
// a given tile and determines all the adjacent tiles that are connected to it
// via the same colour.
-(NSArray *)getConnectedTo:(TTTile *)tile {
  
  NSMutableSet *connectedSet = [NSMutableSet set];
  [self getConnectedTo:tile WithSet:connectedSet];
  
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
  if (currentPosition.x > 0) {
    
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
