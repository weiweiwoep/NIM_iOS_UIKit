//
//  NIMInputEmoticonTabView.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputWyGiftTabView.h"
#import "NIMInputWyGiftManager.h"
#import "UIView+NIM.h"
#import "UIImage+NIMKit.h"
#import "NIMGlobalMacro.h"

const NSInteger NIMInputWyGiftTabViewHeight = 35;
const NSInteger NIMInputWyGiftSendButtonWidth = 50;

const CGFloat NIMInputWyGiftLineBoarder = .5f;

@interface NIMInputWyGiftTabView()

@property (nonatomic,strong) UIButton * rechargeButton;         //充值按钮

@property (nonatomic,strong) NSMutableArray * tabs;

@property (nonatomic,strong) NSMutableArray * seps;

@end

#define sepColor NIMKit_UIColorFromRGB(0x8A8E93)

@implementation NIMInputWyGiftTabView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, NIMInputWyGiftTabViewHeight)];
    if (self) {
        _tabs = [[NSMutableArray alloc] init];
        _seps = [[NSMutableArray alloc] init];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"送给TA" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_sendButton setBackgroundColor:NIMKit_UIColorFromRGB(0x0079FF)];
        
        _sendButton.nim_height = NIMInputWyGiftTabViewHeight;
        _sendButton.nim_width = NIMInputWyGiftSendButtonWidth;
        [self addSubview:_sendButton];
    }
    return self;
}


- (void)loadCatalogs:(NSArray*)emoticonCatalogs
{
    for (UIView *subView in [_tabs arrayByAddingObjectsFromArray:_seps]) {
        [subView removeFromSuperview];
    }
    [_tabs removeAllObjects];
    [_seps removeAllObjects];
    
    UIImageView *goldCoinImageView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"wy_gift_icon_goldcoin"]];
    goldCoinImageView.frame = CGRectMake(8, 8, 12, 12);
    [goldCoinImageView sizeToFit];
    [self addSubview:goldCoinImageView];
    
    UILabel *goldCoinLabel = [UILabel.alloc initWithFrame:CGRectMake(34, 8, 50, 50)];
    if([self.delegate respondsToSelector:@selector(getGoldCoin)]){
        goldCoinLabel.text = [self.delegate getGoldCoin];
    }else{
        goldCoinLabel.text = @"0";
    }
    goldCoinLabel.textColor = UIColor.whiteColor;
    goldCoinLabel.font = [UIFont systemFontOfSize:14];
    [goldCoinLabel sizeToFit];
    [self addSubview:goldCoinLabel];
    
    if (_rechargeButton == nil) {
        
        CGSize goldCoinLabelSize = [goldCoinLabel.text sizeWithAttributes:@{NSFontAttributeName:goldCoinLabel.font}];
        CGFloat leftPoint = goldCoinLabelSize.width < 50 ? 50 : goldCoinLabelSize.width;
        _rechargeButton = [UIButton.alloc initWithFrame:CGRectMake(34+leftPoint+8, 0, 60, 30)];
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeButton.titleLabel.textColor = UIColor.whiteColor;
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_rechargeButton setBackgroundColor:NIMKit_UIColorFromRGB(0x0079FF)];
        [_rechargeButton addTarget:self action:@selector(onTouchRecharge:) forControlEvents:UIControlEventTouchUpInside];
        
        _rechargeButton.nim_height = NIMInputWyGiftTabViewHeight;
        _rechargeButton.nim_width = NIMInputWyGiftSendButtonWidth;
        [self addSubview:_rechargeButton];
    }
    self.layer.borderColor = sepColor.CGColor;
    self.layer.borderWidth = NIMInputWyGiftLineBoarder;
}

- (void)onTouchRecharge:(id)sender{
    if([self.delegate respondsToSelector:@selector(onTouchRecharge)]){
        [self.delegate onTouchRecharge];
    }
}

- (void)onTouchTab:(id)sender{
    NSInteger index = [self.tabs indexOfObject:sender];
    [self selectTabIndex:index];
    if ([self.delegate respondsToSelector:@selector(tabView:didSelectTabIndex:)]) {
        [self.delegate tabView:self didSelectTabIndex:index];
    }
}


- (void)selectTabIndex:(NSInteger)index{
    for (NSInteger i = 0; i < self.tabs.count ; i++) {
        UIButton *btn = self.tabs[i];
        btn.selected = i == index;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing = 10;
    CGFloat left    = spacing;
    for (NSInteger index = 0; index < self.tabs.count ; index++) {
        UIButton *button = self.tabs[index];
        button.nim_left = left;
        button.nim_centerY = self.nim_height * .5f;
        
        UIView *sep = self.seps[index];
        sep.nim_left = (int)(button.nim_right + spacing);
        left = (int)(sep.nim_right + spacing);
    }
    _sendButton.nim_right = (int)self.nim_width;
}


@end

