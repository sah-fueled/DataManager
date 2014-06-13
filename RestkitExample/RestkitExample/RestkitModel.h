//
//  RestkitModel.h
//  RestkitExample
//
//  Created by sah-fueled on 10/06/14.
//  Copyright (c) 2014 Fueled.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface RestkitModel : NSObject

@property (nonatomic,strong) User *currentUser;

+ (RestkitModel *)sharedModel;

@end
