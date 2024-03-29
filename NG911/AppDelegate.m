//
//  AppDelegate.m
//  NG911
//
//  Created by Mason Silber on 9/9/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "ViewController.h"
#import "DataModel.h"
#import "Message.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize dataModel;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [dataModel release];
    [super dealloc];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // created data model

    dataModel = [[DataModel alloc] init];
    [dataModel loadMessages];
    
    Message* message = [[Message alloc] init];
    message.text = @"Test Message";
    message.timestamp = @"Sept 19, 2011";
    
    [dataModel addMessage:message];
    
    NSLog(@"Count in AppD = %d\n", dataModel.messages.count);
    
    [message release];    
    
    
    if(![AppDelegate connectedToInternet])
    {
        UIAlertView *noInternetAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" 
                                                                  message:@"Your device has no available internet connection. Please connect to the internet and relaunch the app" 
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Exit" 
                                                        otherButtonTitles:nil, nil];
        [noInternetAlert setTag:0];
        [noInternetAlert show];
        [noInternetAlert release];
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    [self.viewController setTitle:@"NG911"];
    
    [self viewController].dataModel = dataModel;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[self window] addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
     
}

+(BOOL)connectedToInternet
{
    Reachability *internetTester = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetTester currentReachabilityStatus];
    
    return internetStatus != NotReachable;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
    {
        NSLog(@"No internet");
        exit(1);
    }
}
@end
