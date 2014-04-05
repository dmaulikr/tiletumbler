
/*
 * TTBoard.h
 *
 * Tile Tumbler
 *
 * This class represents the tile board from the game. It handles the management of the tiles
 * and how they move when removed from the board. 
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"

#ifndef TileTumbler_TTBoard_H_
#define TileTumbler_TTBoard_H_

@protocol TileHandlerDelegate <NSObject>

-(void) removedTilesWithCount:(uint)count;

@end

@interface TTBoard : CCNode
{
  CGSize boardSize;
  
  CGSize tileSize;
  
  NSMutableArray *tiles;
}

@property (nonatomic) id <TileHandlerDelegate> TileDelegate;

-(instancetype)initWithSize:(CGSize)boardSize;

-(void)boardTouchedAtPosition:(CGPoint)touchLocation;

-(CGSize) tileSize;

@end

#endif    // TileTumbler_TTBoard_H_