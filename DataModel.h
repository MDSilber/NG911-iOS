//
//  DataModel.h
//  NG911
//
//  Created by Rachid Jeitani on 9/19/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface DataModel : NSObject
{
    
}

@property (nonatomic, retain) NSMutableArray* messages;

-(int)addMessage:(Message*)message;
-(void)loadMessages;


@end
