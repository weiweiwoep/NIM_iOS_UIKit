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
        [_sendButton setTitle:@"发送".nim_localized forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_sendButton setBackgroundColor:NIMKit_UIColorFromRGB(0x0079FF)];
        
        _sendButton.nim_height = NIMInputWyGiftTabViewHeight;
        _sendButton.nim_width = NIMInputWyGiftSendButtonWidth;
        [self addSubview:_sendButton];
        
        self.layer.borderColor = sepColor.CGColor;
        self.layer.borderWidth = NIMInputWyGiftLineBoarder;
        
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
    for (NIMInputWyGiftCatalog * catelog in emoticonCatalogs) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSURL *imgUrl = [NSURL URLWithString:catelog.icon];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image =  [UIImage.alloc initWithData:imgData];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button setImage:image forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onTouchTab:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [self addSubview:button];
        [_tabs addObject:button];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NIMInputWyGiftLineBoarder, NIMInputWyGiftTabViewHeight)];
        sep.backgroundColor = sepColor;
        [_seps addObject:sep];
        [self addSubview:sep];
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

