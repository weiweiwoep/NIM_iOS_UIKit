//
//  NIMInputEmoticonButton.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputWyGiftButton.h"
#import "UIImage+NIMKit.h"
#import "NIMGlobalMacro.h"
#import "NIMInputWyGiftManager.h"

@implementation NIMInputWyGiftButton

+ (NIMInputWyGiftButton*)iconButtonWithData:(NIMInputWyGift*)data catalogID:(NSString*)catalogID delegate:( id<NIMInputWyGiftButtonTouchDelegate>)delegate{
    
    NIMInputWyGiftButton* icon = [[NIMInputWyGiftButton alloc] init];
    UITapGestureRecognizer *iconTap=[[UITapGestureRecognizer alloc]initWithTarget:icon action:@selector(onIconSelected:)];
    [icon addGestureRecognizer:iconTap];
    
    icon.wyGiftData    = data;
    icon.catalogID              = catalogID;
    icon.userInteractionEnabled = YES;
    icon.exclusiveTouch         = YES;
    icon.contentMode            = UIViewContentModeScaleToFill;
    icon.delegate               = delegate;
    
    UIImage *image =  [UIImage.alloc initWithData:data.imgData];
    UIImageView *imgView = [UIImageView.alloc initWithImage:image];
    [icon addSubview:imgView];
    imgView.frame = CGRectMake(18, 0, 34, 34);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    [icon addSubview:titleLabel];
    titleLabel.text = data.wyGiftName;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 40, 70, titleLabel.font.pointSize);
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.numberOfLines = 0;
    [icon addSubview:moneyLabel];
    moneyLabel.text = [NSString stringWithFormat:@"%d",(int)data.money];
    moneyLabel.font = [UIFont systemFontOfSize:10];
    moneyLabel.textColor = NIMKit_UIColorFromRGBA(0xF9AE00, 1.0f);
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.frame = CGRectMake(-3, 40 + titleLabel.font.pointSize + 3, 70, moneyLabel.font.pointSize);
    
    UIImageView *goldcoinView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"wy_gift_icon_goldcoin"]];
    [icon addSubview:goldcoinView];
    CGFloat moneyLabelWidth = [self getStrWidth:[NSString stringWithFormat:@"%d",(int)data.money] withFont:10];
    goldcoinView.frame = CGRectMake(((67 - moneyLabelWidth)/2) + moneyLabelWidth, 40 + titleLabel.font.pointSize + 3, 9, 9);
    
    
    //    [icon setImage:image forState:UIControlStateNormal];
    //    [icon setImage:image forState:UIControlStateHighlighted];
    
    return icon;
}



- (void)onIconSelected:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *btn = tap.view;
    //清除选中项
    [btn.superview.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        [subView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull btn, NSUInteger childIdx, BOOL * _Nonnull childStop) {
            btn.layer.borderWidth = 0;
        }];
    }];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = NIMKit_UIColorFromRGBA(0xF9AE00, .7f).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    if ([self.delegate respondsToSelector:@selector(selectedWyGift:catalogID:)])
    {
        [self.delegate selectedWyGift:self.wyGiftData catalogID:self.catalogID];
    }
}

+ (CGFloat) getStrWidth:(NSString *)string withFont:(CGFloat)font
{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size.width;
}

@end
