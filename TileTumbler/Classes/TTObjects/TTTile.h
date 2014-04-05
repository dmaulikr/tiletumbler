
/*
 * TTTile.h
 *
 * Tile Tumbler
 *
 * This class encapsulates the information of a single Tile from the board.
 *
 * @author Ronan Turner
 */

#import "cocos2d.h"

#ifndef TileTumbler_TTTile_H_
#define TileTumbler_TTTile_H_

@interface TTTile : CCSprite
{
  CGSize pixelSize;
}

@property (nonatomic) uint ColourCode;

-(instancetype) initWithFile:(NSString *)filename;

-(instancetype) initWithFile:(NSString *)filename Position:(CGPoint)position;

-(instancetype) initWithFile:(NSString *)filename Position:(CGPoint)position Size:(CGSize)size;

@end

#endif