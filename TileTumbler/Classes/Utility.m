
#import "Utility.h"

@implementation Utility

// Convenience method to find the correct filename for our images based on the device specification.
//
// If we have a 5th generation device we search for a custom, tall retina image. If not found, we
// default to the retina image. Otherwise, we use the standard single-scale image.
+(NSString *) findPathForImage:(NSString *)filename {
  
  NSFileManager *fileMan = [NSFileManager defaultManager];
  NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
  
  NSString *path;
  
  if (IS_RETINA) {
    
    if (IS_PHONEPOD5()) {
      
      path = [NSString stringWithFormat:@"%@-568h@2x.png", filename];
      
      if ([fileMan fileExistsAtPath:[resourcePath stringByAppendingPathComponent:path] isDirectory:NO]) {
        
        return path;
      }
    }
    
    return [NSString stringWithFormat:@"%@@2x.png", filename];
  } else {
    
    return [NSString stringWithFormat:@"%@.png", filename];
  }
}

// Formats the time according to either X:YY format or YYs if the minute value is 0.
+(NSString *) formattedTime:(uint)timeRemaining {
  
  uint minutes = floor((float)timeRemaining / 60);
  uint seconds = timeRemaining - (minutes * 60);
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  
  [numberFormatter setPositiveFormat:@"00"];
  
  NSString *secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
  
  NSString *timeString = [NSString stringWithFormat:@"%d:%@", minutes, secondString];
  
  if (minutes == 0) {
    
    [numberFormatter setPositiveFormat:@"##s"];
    
    secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
    timeString = secondString;
  }
  
  return timeString;
}

// Formats the score to include thousands separators.
+(NSString *) formattedScore:(uint)score {
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setPositiveFormat:@"#,###,###"];
  
  return [numberFormatter stringFromNumber:[NSNumber numberWithInt:score]];
}

@end
