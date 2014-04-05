
/*
 * TTUtility.h
 *
 * Tile Tumbler
 *
 * This class contains repeatedly used methods, macros and protocols from throughout the project.
 *
 * @author Ronan Turner
 */

#ifndef TileTumbler_TTUtility_H_
#define TileTumbler_TTUtility_H_

#define IS_PHONEPOD5() ([UIScreen mainScreen].bounds.size.height == 568.0f && [UIScreen mainScreen].scale == 2.f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define CCRANDOM_X_Y(__X__, __Y__) (((__Y__) - (__X__)) * (arc4random() / (float)0xffffffff) + (__X__))

@interface Utility : NSObject

+(NSString *) findPathForImage:(NSString *)filename;

+(NSString *) formattedTime:(uint)timeRemaining;
+(NSString *) formattedScore:(uint)score;

@end

@protocol MenuButtonsClicked <NSObject>

-(void) buttonClicked:(NSString *)label;

@end

#endif