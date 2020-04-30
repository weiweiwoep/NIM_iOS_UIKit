//
//  WyGiftModel.m
//  DemoApplication
//
//  Created by carlw on 2020/4/24.
//  Copyright © 2020 chrisRay. All rights reserved.
//

#import "WyGiftModel.h"

@implementation WyGiftModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"id"])
        return YES;
    return NO;
}

@end
