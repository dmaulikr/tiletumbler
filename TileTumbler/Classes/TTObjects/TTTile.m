#import "Constants.h"

#import "TTTile.h"

@implementation TTTile

#pragma mark Lifecycle

-(instancetype) initWithFile:(NSString *)filename {
  
  if ((self = [super initWithFile:filename])) {
    
    float w = super.contentSize.width;
    float h = super.contentSize.height;
    
    pixelSize = CGSizeMake(w, h);
    
    [self setAnchorPoint:CGPointMake(0, 0)];
  }
  
  return self;
}

-(instancetype) initWithFile:(NSString *)filename Position:(CGPoint)position {
  
  if ((self = [self initWithFile:filename])) {
    
    [self setPosition: position];
  }
  
  return self;
}

-(instancetype) initWithFile:(NSString *)filename Position:(CGPoint)position Size:(CGSize)size {
  
  if ((self = [super initWithFile:filename])) {
    
    pixelSize = size;
    
    // Rescale our sprite to fit the size that we're passed
    [self setScaleX: pixelSize.width/self.contentSize.width];
    [self setScaleY: pixelSize.height/self.contentSize.height];
    
    [self setPosition: position];
    
    [self setAnchorPoint:CGPointMake(0, 0)];
  }
  
  return self;
}

// Assigns the correct colour to our tile based on the passed colour code
-(void) setColourCode:(uint)ColourCode {
  
  switch (ColourCode) {
    case 0:
      [self setColor:TILE_COLOR_1];
      break;
      
    case 1:
      [self setColor:TILE_COLOR_2];
      break;
      
    case 2:
      [self setColor:TILE_COLOR_3];
      break;
      
    case 3:
      [self setColor:TILE_COLOR_4];
      break;
      
    case 4:
      [self setColor:ccc3(255, 255, 255)];
      break;
      
    default:
      NSLog(@"Warning, no colour known for code %d.", ColourCode);
      break;
  }
  
  _ColourCode = ColourCode;
}

@end
