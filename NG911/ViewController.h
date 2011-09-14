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

@interface ViewController : UIViewController <CLLocationManagerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CLLocationCoordinate2D currentLocationCoordinates;
    NSString *phoneNumber;
    UIScrollView *scrollView;
    UIView *textView;
    UIButton *send;
    UITextView *textBox;
    BOOL messageHasBeenSent;
    CLLocationManager *locationManager;
}

-(void)getPhoto:(id)sender;
-(void)sendText:(id)sender;
-(void)hideKeyboard:(id)sender;
-(void)about:(id)sender;
-(void)sendMessageToServer:(NSString *)message;
-(UILabel *)labelWithDate;

@end
