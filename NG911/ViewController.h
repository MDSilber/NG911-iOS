//
//  ViewController.h
//  NG911
//
//  Created by Mason Silber on 9/9/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@class DataModel;
@class Message;



@interface ViewController : UIViewController <CLLocationManagerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CLLocationCoordinate2D currentLocationCoordinates;
    NSString *phoneNumber;
    UIScrollView *scrollView;
    UIView *textView;
    UIButton *send;
    UITextView *textBox;
    BOOL messageHasBeenSent;
    CLLocationManager *locationManager;
    
    
    CGPoint nextFrameOrigin;
    
    
    // New stuff
    UITableView * msgView;
    
}

-(void)getPhoto:(id)sender;
-(void)sendText:(id)sender;
-(void)hideKeyboard:(id)sender;
-(void)about:(id)sender;
-(UILabel *)labelWithDate;

@property (nonatomic, assign) DataModel* dataModel;


@end
