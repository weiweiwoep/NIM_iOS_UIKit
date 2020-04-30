//
//  NIMWyGiftAttachment.h
//  NIMKit
//
//  Created by carlw on 2020/4/28.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@class WyGiftModel;

NS_ASSUME_NONNULL_BEGIN

@interface NIMWyGiftAttachment : NSObject<NIMCustomAttachment>

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,copy) WyGiftModel *wyGift;

@end

NS_ASSUME_NONNULL_END
