
#import "TTTile.h"

@implementation TTTile

-(id) initWithFile:(NSString *)filename {
  
  if ((self = [super initWithFile:filename])) {
    
    // Store the pixel size
    float w = super.contentSize.width;
    float h = super.contentSize.height;
    
    pixelSize = CGSizeMake(w, h);
    
    [self setAnchorPoint:CGPointMake(0, 0)];
  }
  
  return self;
}

-(id) initWithFile:(NSString *)filename Position:(CGPoint)position {
  
  if ((self = [self initWithFile:filename])) {
    
    [self setPosition: position];
  }
  
  return self;
}

-(id) initWithFile:(NSString *)filename Position:(CGPoint)position Size:(CGSize)size {
  
  if ((self = [super initWithFile:filename])) {
    
    // Store our size
    pixelSize = size;
    
    [self setScaleX: pixelSize.width/self.contentSize.width];
    [self setScaleY: pixelSize.height/self.contentSize.height];
    
    // Set our position
    [self setPosition: position];
    
    [self setAnchorPoint:CGPointMake(0, 0)];
  }
  
  return self;
}

@end
