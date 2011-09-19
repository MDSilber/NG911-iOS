//
//  Message.m
//  NG911
//
//  Created by Rachid Jeitani on 9/19/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize text, timestamp, image;


-(void) dealloc {
    [text release];
    [image release];
    [timestamp release];
    [super dealloc];
}
@end
