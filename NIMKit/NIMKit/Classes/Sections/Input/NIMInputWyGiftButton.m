//
//  NIMInputEmoticonButton.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputWyGiftButton.h"
#import "UIImage+NIMKit.h"
#import "NIMInputWyGiftManager.h"

@implementation NIMInputWyGiftButton

+ (NIMInputWyGiftButton*)iconButtonWithData:(NIMInputWyGift*)data catalogID:(NSString*)catalogID delegate:( id<NIMInputWyGiftButtonTouchDelegate>)delegate{
    NIMInputWyGiftButton* icon = [[NIMInputWyGiftButton alloc] init];
    [icon addTarget:icon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    
    icon.wyGiftData    = data;
    icon.catalogID              = catalogID;
    icon.userInteractionEnabled = YES;
    icon.exclusiveTouch         = YES;
    icon.contentMode            = UIViewContentModeScaleToFill;
    icon.delegate               = delegate;
    
    NSURL *imgUrl = [NSURL URLWithString:data.imgUrl];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *image =  [UIImage.alloc initWithData:imgData];
    [icon setImage:image forState:UIControlStateNormal];
    [icon setImage:image forState:UIControlStateHighlighted];
    
    return icon;
}



- (void)onIconSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedWyGift:catalogID:)])
    {
        [self.delegate selectedWyGift:self.wyGiftData catalogID:self.catalogID];
    }
}

@end
