
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TTTile : CCSprite
{
  // Stores the dimensions of the tile in pixels for easy access
  CGSize pixelSize;
}

// Default initialisation - simply uses the sprite's image size and
// starts at position (0,0)
-(id) initWithFile:(NSString *)filename;

// Similar to the default, but specifies a new anchor point away from the
// origin
-(id) initWithFile:(NSString *)filename Position:(CGPoint)position;

// As above, but specifies the tile's pixel dimensions to scale to.
-(id) initWithFile:(NSString *)filename Position:(CGPoint)position Size:(CGSize)size;

@end
