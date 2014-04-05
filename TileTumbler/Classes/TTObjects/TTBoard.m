#import "Constants.h"

#import "TTBoard.h"
#import "TTTile.h"

@implementation TTBoard

#pragma mark Lifecycle

-(instancetype)initWithSize:(CGSize)_boardSize {
  
  if ((self = [super init])) {
    
    srand(time(NULL));
    
    CGSize contentSize = [CCDirector sharedDirector].winSize;
  
    tileSize = CGSizeMake(contentSize.width/_boardSize.width, contentSize.height/_boardSize.height);
    
    boardSize = _boardSize;
    
    CGSize boardContentSize = CGSizeMake(tileSize.width*boardSize.width,
                                    tileSize.height*boardSize.height);
    [self setContentSize:boardContentSize];
    
    [self setupNewTiles];
    [self generateRandomTiles];
  }
  
  return self;
}

// Places placeholder 'NULL' values into each of the positions in our board array to provide a
// known starting setup for our algorithm.
-(void) setupNewTiles {
  
  uint totalTiles = boardSize.width * boardSize.height;
  
  tiles = [NSMutableArray arrayWithCapacity: totalTiles];
  
  for (uint i = 0; i < totalTiles; i++) {
    
    [tiles addObject: [NSNull null]];
  }
}

#pragma mark Accessors

-(CGSize) tileSize {
  
  return tileSize;
}

#pragma mark Board Updates

// Generates a tile for the |index| provided and calculates the position that it should
// be located in based on this.
-(TTTile *)generateTileForIndex:(uint)index {
  
  CGPoint position = [self positionFromIndex: index];
  CGPoint positionMult = CGPointMake(tileSize.width, tileSize.height);
  
  CGPoint positionWorld = ccpCompMult(position, positionMult);
  
  TTTile *newTile = [[TTTile alloc] initWithFile:UI_TILE_SPRITE
                                        Position:positionWorld
                                            Size:tileSize];
  
  [newTile setOpacity:TTTileOpacity];
  
  uint colorCode = rand() % TTNumberTileColours;
  [newTile setColourCode:colorCode];
  
  return newTile;
}

// An initialisation method. Removes any old tiles present in the board array and generates
// completely new tiles for each position.
-(void) generateRandomTiles {
  
  for (uint index = 0; index < tiles.count; index++) {
    
    TTTile *oldTile = tiles[index];
    
    if (oldTile != nil) {
      [self removeChild:oldTile cleanup:YES];
    }
      
    TTTile *newTile = [self generateTileForIndex:index];
    
    [tiles replaceObjectAtIndex:index withObject: newTile];
    [self addChild: newTile];
  }
}

// The hardest working algorithm of the project. This handles the actions required to 'drop' the
// tiles downwards if they have no space below them and finds a suitable method for generating
// new tiles above.
-(void)fixBoard {
  
  // Iterate across the columns of the board
  for (int i = 0; i < boardSize.width; i++) {
    
    uint nullCount = 0;
    
    // ...then iterate up the columns from the bottom row
    for (uint y = 0; y < boardSize.height; y++) {
      
      uint tileIndex = [self indexFromPosition:CGPointMake(i, y)];
      
      if (tiles[tileIndex] == (id)[NSNull null]) {
        nullCount++;
        
      // We only need to move a tile down if the null count is larger than 0, meaning we have a
      // blank space below
      } else if (nullCount > 0) {
        
        // Below position relative to tile indices
        CGPoint belowPosition = CGPointMake(i, y - nullCount);
        uint belowIndex = [self indexFromPosition:belowPosition];
        
        // The below position, now in pixels
        CGPoint belowPixelPosition = CGPointMake(belowPosition.x * tileSize.width,  belowPosition.y * tileSize.height);
        
        id move = [CCMoveTo actionWithDuration:TTTileDropDuration position:belowPixelPosition];
        
        [tiles[tileIndex] runAction:move];
        [tiles replaceObjectAtIndex:belowIndex withObject:tiles[tileIndex]];
      }
    }
    
    // After the previous iteration, we now know that we have |nullCount| tiles left to generate,
    // and these will all be blank tile spaces as we previously moved the tiles down
    for (uint y = boardSize.height - nullCount; y < boardSize.height; y++) {
      
      CGPoint expectedPosition = CGPointMake(i, y);
      CGPoint expectedPxPosition = CGPointMake(expectedPosition.x * tileSize.width, expectedPosition.y * tileSize.height);
      
      uint tileIndex = [self indexFromPosition:expectedPosition];
      
      id move = [CCMoveTo actionWithDuration:TTTileDropDuration position:expectedPxPosition];
      
      TTTile *newTile = [self generateTileForIndex:tileIndex];
      [newTile setPosition:CGPointMake(expectedPxPosition.x, expectedPxPosition.y + nullCount*tileSize.height)];
      [newTile runAction:move];
      
      [tiles replaceObjectAtIndex:tileIndex withObject:newTile];
      [self addChild:newTile];
    }
  }
}

// Finds and removes the given |tile| from our board.
-(void)removeTile:(TTTile *)tile {
  
  for (int i = 0; i < tiles.count; i++) {
    if (tiles[i] == tile) {
      [tiles replaceObjectAtIndex:i withObject:(id)[NSNull null]];
    }
  }
  
  // Fade out the tile rather than simply removing it - more 'juiciness'!
  id fadeOut = [CCFadeOut actionWithDuration:TTActionTimeTileFade];
  id callback = [CCCallBlockN actionWithBlock:^(CCNode *node) {
    [self removeChild:tile cleanup:YES];
  }];
  
  [tile runAction:[CCSequence actions:fadeOut, callback, nil]];
  
}

#pragma mark Responders

-(void)boardTouchedAtPosition:(CGPoint)touchLocation {
  
  for (int i = 0; i < tiles.count; i++) {
    
    TTTile *tile = tiles[i];
    
    if (tile != (id)[NSNull null] && CGRectContainsPoint(tile.boundingBox, touchLocation)) {
      
      // Indicate the tile has been touched and return - we only want one tile to be removed
      // per touch
      [self touchedWithTile: tile];
      return;
    }
  }
}

// Responds to the given tile being touched on the board by finding if it is connected to other
// tiles of the same colour (forming a group) and removing the group if necessary.
-(void)touchedWithTile:(TTTile *)tile {
  
  NSArray *connected = [self findConnectedToTile:tile];
  
  if (connected.count < TTMinimumTileGroupSize) {
    return;
  }
  
  for (TTTile *tile in connected) {
    
    [self removeTile: tile];
  }
  
  [self.TileDelegate removedTilesWithCount:connected.count];
  
  [self fixBoard];
}

-(void)tileTouchedAt:(uint)index {
  
  if (tiles[index] == (id)[NSNull null]) {
    return;
  }
  
  [self findConnectedToTile:tiles[index]];
}

#pragma mark Utility Methods

// Our base caller for finding connected tiles. Initiates the recursive algorithm found below.
-(NSArray *)findConnectedToTile:(TTTile *)tile {
  
  NSMutableSet *connectedSet = [NSMutableSet set];
  [self findConnectedToTile:tile WithSet:connectedSet];
  
  return connectedSet.allObjects;
}

// Recursive algorithm to find all tiles connected to the given parent |tile|. Neighbouring
// tiles that are the same colour have this same method recursively called on them. Valid
// neighbours are placed into the |found| set and returned.
-(void)findConnectedToTile:(TTTile *)tile WithSet:(NSMutableSet *)found {
  
  if (found == nil) {
    return;
  }
  
  uint originColour = tile.ColourCode;
  [found addObject:tile];
  
  CGPoint currentPosition = [self findTilePosition:tile];
  
  NSMutableArray *validNeighbours = [NSMutableArray arrayWithCapacity:4];
  
  // Left neighbour
  if (currentPosition.x > 0) {
    
    CGPoint leftPos = CGPointMake(currentPosition.x-1, currentPosition.y);
    TTTile *left = tiles[[self indexFromPosition:leftPos]];
    
    if (left.ColourCode == originColour && ![found containsObject:left]) {
      [validNeighbours addObject:left];
    }
  }
  
  // Right neighbour
  if (currentPosition.x < boardSize.width-1) {
    
    CGPoint rightPos = CGPointMake(currentPosition.x+1, currentPosition.y);
    TTTile *right = tiles[[self indexFromPosition:rightPos]];
    
    if (right.ColourCode == originColour && ![found containsObject:right]) {
      [validNeighbours addObject:right];
    }
  }
  
  // Above neighbour
  if (currentPosition.y < boardSize.height-1) {
    
    CGPoint upperPos = CGPointMake(currentPosition.x, currentPosition.y+1);
    TTTile *upper = tiles[[self indexFromPosition:upperPos]];
    
    if (upper.ColourCode == originColour && ![found containsObject:upper]) {
      [validNeighbours addObject:upper];
    }
  }
  
  // Below neighbour
  if (currentPosition.y > 0) {
    
    CGPoint lowerPos = CGPointMake(currentPosition.x, currentPosition.y-1);
    TTTile *lower = tiles[[self indexFromPosition:lowerPos]];
    
    if (lower.ColourCode == originColour && ![found containsObject:lower]) {
      [validNeighbours addObject:lower];
    }
  }
  
  for (TTTile *neighbour in validNeighbours) {
    
    [self findConnectedToTile:neighbour WithSet:found];
  }
}

-(CGPoint) findTilePosition:(TTTile *)tile {
  
  if (![self.children containsObject:tile]) {
    return CGPointMake(-1, -1);
  }
  
  for (int i = 0; i < tiles.count; i++) {
    
    if (tiles[i] == tile) {
      return [self positionFromIndex:i];
    }
  }
  
  return CGPointMake(-1, -1);
}

-(CGPoint) positionFromIndex:(uint)index {
  
  uint y = index / (uint)boardSize.width;
  uint x = index - (y * (uint)boardSize.width);
  
  return CGPointMake(x, y);
}

-(uint) indexFromPosition:(CGPoint)position {
  
  return ((uint)position.y * (uint)boardSize.width) + (uint)position.x;
}

@end
