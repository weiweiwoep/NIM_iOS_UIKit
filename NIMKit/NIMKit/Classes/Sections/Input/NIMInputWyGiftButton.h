//
//  NIMInputEmoticonButton.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIMInputWyGift;

@protocol NIMInputWyGiftButtonTouchDelegate <NSObject>

- (void)selectedWyGift:(NIMInputWyGift*)wyGift catalogID:(NSString*)catalogID;

@end



@interface NIMInputWyGiftButton : UIButton

@property (nonatomic, strong) NIMInputWyGift *wyGiftData;

@property (nonatomic, copy)   NSString         *catalogID;

@property (nonatomic, weak)   id<NIMInputWyGiftButtonTouchDelegate> delegate;

+ (NIMInputWyGiftButton*)iconButtonWithData:(NIMInputWyGift*)data catalogID:(NSString*)catalogID delegate:( id<NIMInputWyGiftButtonTouchDelegate>)delegate;

- (void)onIconSelected:(id)sender;

@end
