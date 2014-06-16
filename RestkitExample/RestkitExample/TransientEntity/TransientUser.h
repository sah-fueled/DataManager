//
//  TransientUser.h
//  RestkitExample
//
//  Created by sah-fueled on 16/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransientUser : NSObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *selfies;

@end
