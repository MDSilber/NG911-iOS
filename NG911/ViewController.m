//
//  ViewController.m
//  NG911
//
//  Created by Mason Silber on 9/9/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//


// Test comment for github
// Test #2 Modified from Xcode
// Test #3
// Test #4 after ignoring file

#import "ViewController.h"
#import "AboutViewController.h"
#import "DataModel.h"
#import "Message.h"

#define Keyboard_Offset 215
#define MESSAGE_OFFSET 66

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  

@implementation ViewController

@synthesize dataModel;

-(void)dealloc
{
    NSLog(@"ViewController dealloc called");
    [scrollView release];
    [textBox release];
    [locationManager release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    [[self navigationController] setNavigationBarHidden:NO];
    messageHasBeenSent = NO;
    
    UIBarButtonItem *hideKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Hide Keyboard" style:UIBarButtonItemStyleBordered target:self action:@selector(hideKeyboard:)];
    [[self navigationItem] setRightBarButtonItem:hideKeyboard];
    [hideKeyboard setEnabled:NO];
    [hideKeyboard release];
    
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(about:)];
    [[self navigationItem] setLeftBarButtonItem:aboutButton];
    [aboutButton release];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    msgView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 376) style:UITableViewStylePlain];
    msgView.tag = 3;
    [msgView setDelegate:self];
    [msgView setDataSource:self];
    
    [[self view] addSubview:msgView];
    
    textView = [[UIView alloc] initWithFrame:CGRectMake(0, 376, self.view.frame.size.width, 40)];
    [textView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [msgView addSubview:textView];
    [[self view] addSubview:textView];

    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager startUpdatingLocation];
        
    NSLog(@"%f,%f",currentLocationCoordinates.latitude, currentLocationCoordinates.longitude);

//    phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
//    NSLog(@"%@",phoneNumber);
    
    textBox = [[UITextView alloc] initWithFrame:CGRectMake(50, 5, 200, 30)];
    [textBox setBackgroundColor:[UIColor whiteColor]];
    [[textBox layer] setCornerRadius:6.0];
    [textBox setFont:[UIFont fontWithName:[[textBox font] fontName] size:16]];
    [textBox setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textBox setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [textBox setDelegate:self];
    textBox.tag = 1;
    [textView addSubview:textBox];
    
    
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 376)]; 
//    [scrollView setBackgroundColor:[UIColor whiteColor]];
//    [scrollView setScrollEnabled:YES];
//    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
//    scrollView.tag = 2;
    
    //[scrollView setContentOffset:CGPointMake(0, 100)];
    
   // [[self view] addSubview:scrollView];
    
        
    nextFrameOrigin = CGPointMake(5, 10); // initial point
    
    
    send = [UIButton buttonWithType:UIButtonTypeCustom];
    [send setFrame:CGRectMake(260, 7, 50, 26)];
    [send setBackgroundImage:[UIImage imageNamed:@"sendbutton.png"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendText:) forControlEvents:UIControlEventTouchUpInside];
    [send setEnabled:NO];
    [textView addSubview:send];
    
    UIButton *photo = [UIButton buttonWithType:UIButtonTypeCustom];
    [photo setFrame:CGRectMake(10, 2, 35, 35)];
    [photo setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [photo addTarget:self action:@selector(getPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:photo];
    
    
    Message* message = [[Message alloc] init];
    message.text = @"TEST1";
    message.timestamp = @"TIMESTAMP";
    
    [dataModel addMessage:message];
    
    NSLog(@"NUM_MSG = %d", dataModel.messages.count);
    
    [message release];
    

    
    
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocationCoordinates = newLocation.coordinate;
    NSLog(@"%f,%f",currentLocationCoordinates.latitude, currentLocationCoordinates.longitude);
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear");
    [textBox resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^
     {
//         CGRect frame = [msgView frame];
//         frame.size.height -= Keyboard_Offset;
//         
//         [msgView setFrame:frame];
         [msgView setContentOffset:CGPointMake(0, 0)];
         
         CGRect frame = [textView frame];
         frame.origin.y -= Keyboard_Offset;
         [textView setFrame:frame];
     }
                     completion:NULL];
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
   
}

-(void)textViewDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^
     {
         [msgView setContentOffset:CGPointMake(0, 0)];
         
         CGRect frame = [textView frame];
         frame.origin.y += Keyboard_Offset;
         [textView setFrame:frame];
         
     }
                     completion:NULL];
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    
    
}

-(void)textViewDidChange:(UITextView *)textField
{
    if(![[textField text] isEqualToString:@""])
    {
        [send setEnabled:YES];
    } else {
        [send setEnabled:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(UILabel *)labelWithDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy h:mm:ss a"];
    NSString *dateString = [formatter stringFromDate:currentDate];
    [formatter release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nextFrameOrigin.y, 320, 25)];
    [dateLabel setText:dateString];
    [dateLabel setTextAlignment:UITextAlignmentCenter];
    
    return dateLabel;
}

-(void)sendText:(id)sender
{   
    
    if(messageHasBeenSent)
    {
        CGSize expand = [scrollView contentSize];
        expand.height += 20;
        [scrollView setContentSize:expand];
    }

    NSString *message = [textBox text];
    [textBox setText:nil];
    [send setEnabled:NO];

    double lines = ceil((double)[message length]/30.0); // number of lines in message
    
    
   // UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nextFrameOrigin.x, [scrollView contentSize].height-20*lines-10, 300, 20*lines)];

    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nextFrameOrigin.x, nextFrameOrigin.y + 5, 300, 20*lines)];
    

    
    [messageLabel setNumberOfLines:0];
    [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
    [messageLabel setText:[NSString stringWithFormat:@"Me: %@", message]];
    [messageLabel setTextAlignment:UITextAlignmentLeft];
    
    CGSize expectedSize = [message sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:messageLabel.lineBreakMode];

    CGRect newFrame = messageLabel.frame;
    newFrame.size.height = expectedSize.height;
    messageLabel.frame = newFrame;
    
    CGSize contentSize;
    
    UILabel *dateLabel = [self labelWithDate];
   
    if((dateLabel.frame.origin.y + dateLabel.frame.size.height) > messageLabel.frame.origin.y)
    {
        CGRect newFrame = messageLabel.frame;
        newFrame.origin.y = dateLabel.frame.origin.y + [self labelWithDate].frame.size.height + 5;
        [messageLabel setFrame:newFrame];
    }
    
    contentSize = [scrollView contentSize];
    contentSize.height += [dateLabel frame].size.height + [messageLabel frame].size.height;
    [scrollView setContentSize:contentSize];
    
    [scrollView addSubview:dateLabel];
    [scrollView addSubview:messageLabel];
    
    //CGSize bounds = [scrollView bounds].size;
    //[scrollView setContentOffset:CGPointMake([scrollView contentOffset].x, [scrollView contentSize].height - bounds.height) animated:YES];

    
    
    
    [messageLabel release];
    
    if(!messageHasBeenSent)
    {
        messageHasBeenSent = YES;
    }

    nextFrameOrigin.y += MESSAGE_OFFSET;
    
}

-(void)getPhoto:(id)sender
{
    [textBox resignFirstResponder];
    UIActionSheet *photoOptions = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    
    [photoOptions showInView:[self view]];
    [photoOptions release];
}

-(void)hideKeyboard:(id)sender
{
    for(UIView *view in [textView subviews])
    {
        if([view isMemberOfClass:[UITextView class]])
        {
            [view resignFirstResponder];
        }
    }
}

-(void)about:(id)sender
{
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [aboutViewController setTitle:@"About NG911"];
    [[self navigationController] pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if(buttonIndex == 0)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"This device does not support a camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [noCameraAlert setTag:1];
            [noCameraAlert show];
            [noCameraAlert release];
            return;
        }
        
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [picker setShowsCameraControls:YES];
        [picker setAllowsEditing:NO];
        [self presentModalViewController:picker animated:YES];
        
    }
    else if(buttonIndex == 1)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"This device does not support a photo library"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
            [noCameraAlert setTag:2];
            [noCameraAlert show];
            [noCameraAlert release];
            return;
        }
        
        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];

        [picker setAllowsEditing:NO];
        [self presentModalViewController:picker animated:YES];
    }
    else if(buttonIndex != [actionSheet cancelButtonIndex])
    {
        NSLog(@"Error");
    }
    
    [picker release];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(messageHasBeenSent)
    {
        CGSize expand = [scrollView contentSize];
        expand.height += 20;
        [scrollView setContentSize:expand];
    }
    
    NSLog(@"finished picking media with info");
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    UILabel *dateLabel = [self labelWithDate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, [scrollView contentSize].height, 96, 126)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView setImage:image];
    
    CGSize contentSize = CGSizeMake([scrollView contentSize].width, [scrollView contentSize].height);
    contentSize.height += imageView.frame.size.height +dateLabel.frame.size.height+ 5;
    [scrollView setContentSize:contentSize];

    [scrollView addSubview:dateLabel];
    [scrollView addSubview:imageView];

    CGSize bounds = [scrollView bounds].size;
    [scrollView setContentOffset:CGPointMake([scrollView contentOffset].x, [scrollView contentSize].height - bounds.height) animated:YES];
    
    [picker dismissModalViewControllerAnimated:NO];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    [picker dismissModalViewControllerAnimated:YES];
}


-(void)sendMessageToServer:(NSString *)message {
    
}


#pragma mark -
#pragma mark Table View Methods


-(NSInteger)tableView:(UITableView *)msgView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"Table Count: %d", self.dataModel.messages.count);
    return self.dataModel.messages.count;
}



-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [msgView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Message* message = [self.dataModel.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message text];
    [[cell contentView] setBackgroundColor:[UIColor blueColor]];
    return cell;
}

@end
