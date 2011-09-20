//
//  Message.h
//  NG911
//
//  Created by Rachid Jeitani on 9/19/11.
//  Copyright (c) 2011 Columbia University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    
}

@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) NSString* timestamp;
@property (nonatomic, copy) UIImage* image;


@end
