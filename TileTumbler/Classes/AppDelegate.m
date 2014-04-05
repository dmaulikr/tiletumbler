
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"

#import "Crittercism.h"

#import "AppDelegate.h"
#import "MainMenuLayer.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
  director_.wantsFullScreenLayout = YES;

	[director_ setDisplayStats:NO];
  
	[director_ setAnimationInterval:1.0/60];
	[director_ setView:glView];
  [director_ setDelegate:self];

	[director_ setProjection:kCCDirectorProjection2D];
  
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
	
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

  [director_ pushScene: [MainMenuLayer scene]];

	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	[window_ setRootViewController:navController_];
	[window_ makeKeyAndVisible];
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_KEY_BG_VOL])
  {
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = [(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                                                   objectForKey:SETTINGS_KEY_BG_VOL] floatValue];
  } else {
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = TTDefaultBackgroundVolume;
  }
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_KEY_FX_VOL])
  {
    [SimpleAudioEngine sharedEngine].effectsVolume = [(NSNumber *)[[NSUserDefaults standardUserDefaults]
                               objectForKey:SETTINGS_KEY_FX_VOL] floatValue];
  } else {
    [SimpleAudioEngine sharedEngine].effectsVolume = TTDefaultSoundEffectsVolume;
  }
  
  [[SimpleAudioEngine sharedEngine] playBackgroundMusic:MUSIC_FILE_BACKGROUND loop:YES];
  
  [Crittercism enableWithAppID: @"533423d940ec9249f6000002"];
  
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end

