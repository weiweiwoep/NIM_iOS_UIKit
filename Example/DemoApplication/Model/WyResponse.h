//
//  RoiResponse.h
//  wnl3
//
//  Created by 魏伟 on 2020/2/25.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WyResponse : JSONModel

@property(nonatomic,assign) int code;

@property(nonatomic,strong) NSString *msg;

@property(nonatomic,strong) NSArray *data;

@end

NS_ASSUME_NONNULL_END
