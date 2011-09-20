//
//  DataModel.m
//  NG911
//
//  Created by Rachid Jeitani on 9/19/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import "DataModel.h"
#import "Message.h"

@implementation DataModel

@synthesize messages;

-(int)addMessage:(Message *)message{
    [self.messages addObject:message];
    NSLog(@"Added message in DataModel method\n");
    NSLog(@"Count is %d\n", self.messages.count - 1);
    return self.messages.count - 1; // returns the index of the message
}

-(void)loadMessages{
    self.messages = [NSMutableArray arrayWithCapacity:20];
}


-(void)dealloc{
    [messages release];
    [super dealloc];
}

@end
