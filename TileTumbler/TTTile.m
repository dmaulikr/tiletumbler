
#import "TTTile.h"

@implementation TTTile

-(id) initWithFile:(NSString *)filename {
  
  if ((self = [super initWithFile:filename])) {
    
    // Store the pixel size
    float w = super.boundingBox.size.width;
    float h = super.boundingBox.size.height;
    
    pixelSize = CGSizeMake(w, h);
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
    
    // Scale ourselves to fit this size
    [self setScaleX: pixelSize.width/self.boundingBox.size.width];
    [self setScaleY: pixelSize.height/self.boundingBox.size.height];
    
    // Set our position
    [self setPosition: position];
  }
  
  return self;
}

@end
