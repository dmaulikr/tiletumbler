
/*
 * AppDelegate.h
 *
 * Tile Tumbler
 *
 * The first main entry point of the App. Handles initialisation of the window.
 * Generated by Cocos2D.
 *
 * @author Ronan Turner
 */

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#ifndef TileTumbler_AppDelegate_H_
#define TileTumbler_AppDelegate_H_

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end

#endif