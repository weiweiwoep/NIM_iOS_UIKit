//
//  WyGiftModel.h
//  DemoApplication
//
//  Created by carlw on 2020/4/24.
//  Copyright © 2020 chrisRay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "WyResponse.h"
NS_ASSUME_NONNULL_BEGIN

//@protocol WyGiftModel;
//
//@interface WyGiftListModel : WyResponse
//
//@property(nonatomic,strong) NSArray<WyGiftModel> *data;
//
//@end

@interface WyGiftModel : JSONModel

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,strong) NSString<Optional> *name;

@property (nonatomic,assign) float money;

@property (nonatomic,strong) NSString<Optional> *img_url;

@property (nonatomic,strong) NSString<Optional> *gif_url;

@property (nonatomic,assign) BOOL gif_status;

@end

NS_ASSUME_NONNULL_END
