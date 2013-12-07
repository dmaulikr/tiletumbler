
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

// Automatically assigns the appropriate colour based on
// the tile's assigned colour-code.
-(void) setColourCode:(uint)ColourCode {
  
  switch (ColourCode) {
    case 0:
      [self setColor:ccc3(217, 35, 50)];
      break;
      
    case 1:
      [self setColor:ccc3(51, 130, 161)];
      break;
      
    case 2:
      [self setColor:ccc3(242, 216, 82)];
      break;
      
    case 3:
      [self setColor:ccc3(80, 191, 101)];
      break;
      
    default:
      NSLog(@"Warning, no colour known for code %d.", ColourCode);
      break;
  }
  
  _ColourCode = ColourCode;
}

@end
