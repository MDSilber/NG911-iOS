//
//  AppDelegate.h
//  NG911
//
//  Created by Mason Silber on 9/9/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "Message.h"

@class ViewController;
@class DataModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    UINavigationController *navigationController;   
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

+(BOOL)connectedToInternet;

@property (nonatomic, retain) DataModel *dataModel;

@end
