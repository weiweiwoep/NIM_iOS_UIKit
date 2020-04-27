//
//  NIMInputWyGiftContainerView.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputWyGiftContainerView.h"
#import "NIMPageView.h"
#import "UIView+NIM.h"
#import "NIMInputWyGiftManager.h"
#import "NIMInputWyGiftTabView.h"
#import "NIMInputWyGiftButton.h"
#import "NIMInputWyGiftDefine.h"
#import "UIImage+NIMKit.h"
#import <TMCache/TMCache.h>
#import "WyGiftModel.h"

NSInteger NIMWyCustomPageControlHeight = 36;
NSInteger NIMWyCustomPageViewHeight    = 159;

@interface NIMInputWyGiftContainerView()<NIMInputWyGiftButtonTouchDelegate,NIMInputWyGiftTabDelegate>

@property (nonatomic,strong) NSMutableArray *pageData;

@end


@implementation NIMInputWyGiftContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadConfig];
    }
    return self;
}

- (void)loadConfig{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setConfig:(id<NIMSessionConfig>)config{
    _config = config;
    [self loadUIComponents];
    [self reloadData];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 216.f);
}

- (void)loadUIComponents
{
    _wyGiftPageView                  = [[NIMPageView alloc] initWithFrame:self.bounds];
    _wyGiftPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _wyGiftPageView.nim_height       = NIMWyCustomPageViewHeight;
    _wyGiftPageView.backgroundColor  = [UIColor clearColor];
    _wyGiftPageView.dataSource       = self;
    _wyGiftPageView.pageViewDelegate = self;
    [self addSubview:_wyGiftPageView];
    
    _wyGiftPageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, NIMWyCustomPageControlHeight)];
    _wyGiftPageController.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _wyGiftPageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    _wyGiftPageController.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_wyGiftPageController];
    [_wyGiftPageController setUserInteractionEnabled:NO];
}

- (void)setFrame:(CGRect)frame{
    CGFloat originalWidth = self.frame.size.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        [self reloadData];
    }
}

- (void)reloadData{
    NSArray *data = [self loadCatalogAndChartlet];
    self.totalCatalogData   = data;
    self.currentCatalogData = data.firstObject;
}

- (NSArray *)loadCatalogAndChartlet
{
    NIMInputWyGiftCatalog * defaultCatalog = [self loadDefaultCatalog];
    NSArray *charlets = [self loadChartlet];
    NSArray *catalogs = defaultCatalog? [@[defaultCatalog] arrayByAddingObjectsFromArray:charlets] : charlets;
    return catalogs;
}

#define WyGiftPageControllerMarginBottom 10
- (void)layoutSubviews{
    [super layoutSubviews];
    self.wyGiftPageController.nim_top = self.wyGiftPageView.nim_bottom - WyGiftPageControllerMarginBottom;
    self.tabView.nim_bottom = self.nim_height;
}



#pragma mark -  config data

- (NSInteger)sumPages
{
    __block NSInteger pagesCount = 0;
    [self.totalCatalogData enumerateObjectsUsingBlock:^(NIMInputWyGiftCatalog* data, NSUInteger idx, BOOL *stop) {
        pagesCount += data.pagesCount;
    }];
    return pagesCount;
}

- (UIView*)wyGiftPageView:(NIMPageView*)pageView inWyGiftCatalog:(NIMInputWyGiftCatalog *)wyGift page:(NSInteger)page
{
    UIView *subView = [[UIView alloc] init];
    NSInteger iconHeight    = wyGift.layout.imageHeight;
    NSInteger iconWidth     = wyGift.layout.imageWidth;
    CGFloat startX          = (wyGift.layout.cellWidth - iconWidth) / 2  + NIMKit_WyGiftLeftMargin;
    CGFloat startY          = (wyGift.layout.cellHeight- iconHeight) / 2 + NIMKit_WyGiftTopMargin;
    int32_t coloumnIndex = 0;
    int32_t rowIndex = 0;
    int32_t indexInPage = 0;
    NSInteger begin = page * wyGift.layout.itemCountInPage;
    NSInteger end   = begin + wyGift.layout.itemCountInPage;
    end = end > wyGift.wyGifts.count ? (wyGift.wyGifts.count) : end;
    for (NSInteger index = begin; index < end; index ++)
    {
        NIMInputWyGift *data = [wyGift.wyGifts objectAtIndex:index];
        
        NIMInputWyGiftButton *button = [NIMInputWyGiftButton iconButtonWithData:data catalogID:wyGift.catalogID delegate:self];
        //计算表情位置
        rowIndex    = indexInPage / wyGift.layout.columes;
        coloumnIndex= indexInPage % wyGift.layout.columes;
        CGFloat x = coloumnIndex * wyGift.layout.cellWidth + startX;
        CGFloat y = rowIndex * wyGift.layout.cellHeight + startY;
        CGRect iconRect = CGRectMake(x, y, iconWidth, iconHeight);
        [button setFrame:iconRect];
        [subView addSubview:button];
        indexInPage ++;
    }
    if (coloumnIndex == wyGift.layout.columes -1)
    {
        rowIndex = rowIndex +1;
        coloumnIndex = -1; //设置成-1是因为显示在第0位，有加1
    }
    if ([wyGift.catalogID isEqualToString:NIMKit_WyGiftCatalog]) {
        [self addDeleteWyGiftButtonToView:subView  ColumnIndex:coloumnIndex RowIndex:rowIndex StartX:startX StartY:startY IconWidth:iconWidth IconHeight:iconHeight inWyGiftCatalog:wyGift];
    }
    return subView;
}

- (void)addDeleteWyGiftButtonToView:(UIView *)view
                      ColumnIndex:(NSInteger)coloumnIndex
                         RowIndex:(NSInteger)rowIndex
                           StartX:(CGFloat)startX
                           StartY:(CGFloat)startY
                        IconWidth:(CGFloat)iconWidth
                       IconHeight:(CGFloat)iconHeight
                inWyGiftCatalog:(NIMInputWyGiftCatalog *)wyGift
{
    NIMInputWyGiftButton* deleteIcon = [[NIMInputWyGiftButton alloc] init];
    deleteIcon.delegate = self;
    deleteIcon.userInteractionEnabled = YES;
    deleteIcon.exclusiveTouch = YES;
    deleteIcon.contentMode = UIViewContentModeCenter;
    UIImage *imageNormal  = [UIImage nim_emoticonInKit:@"emoji_del_normal"];
    UIImage *imagePressed = [UIImage nim_emoticonInKit:@"emoji_del_pressed"];
    
//    [deleteIcon setImage:imageNormal forState:UIControlStateNormal];
//    [deleteIcon setImage:imagePressed forState:UIControlStateHighlighted];
//    [deleteIcon addTarget:deleteIcon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat newX = (coloumnIndex +1) * wyGift.layout.cellWidth + startX;
    CGFloat newY = rowIndex * wyGift.layout.cellHeight + startY;
    CGRect deleteIconRect = CGRectMake(newX, newY, NIMKit_DeleteIconWidth, NIMKit_DeleteIconHeight);
    
    [deleteIcon setFrame:deleteIconRect];
    [view addSubview:deleteIcon];
}


#pragma mark - pageviewDelegate
- (NSInteger)numberOfPages: (NIMPageView *)pageView
{
    return [self sumPages];
}

- (UIView *)pageView:(NIMPageView *)pageView viewInPage:(NSInteger)index
{
    NSInteger page  = 0;
    NIMInputWyGiftCatalog *wyGift;
    for (wyGift in self.totalCatalogData) {
        NSInteger newPage = page + wyGift.pagesCount;
        if (newPage > index) {
            break;
        }
        page   = newPage;
    }
    return [self wyGiftPageView:pageView inWyGiftCatalog:wyGift page:index - page];
}


- (NIMInputWyGiftCatalog*)loadDefaultCatalog
{
    NSArray *array = [TMCache.sharedCache objectForKey:Key_WyNim_InputGiftData];
    JSONModelError *error = nil;
    NSArray *list = [WyGiftModel arrayOfModelsFromDictionaries:array error:&error];
    if (error || list == nil || list.count < 1) {
        NSLog(@"聊天礼物菜单元素获取失败:%@",error.description);
        return nil;
    }
    NSDictionary *info = @{
        @"id": @"wyGift",
        @"normal":@"emoj_s_normal.png",
        @"pressed": @"emoj_s_pressed.png",
        @"title":@"wyGift"
    };
    NIMInputWyGiftCatalog *wyGiftCatalog = [NIMInputWyGiftManager.sharedManager catalogByInfo:info wyGifts:list];
//    NIMInputWyGiftCatalog *wyGiftCatalog = [[NIMInputWyGiftManager sharedManager] wyGiftCatalog:NIMKit_WyGiftCatalog];
    if (wyGiftCatalog) {
        NIMInputWyGiftLayout *layout = [[NIMInputWyGiftLayout alloc] initWyGiftLayout:self.nim_width];
        wyGiftCatalog.layout = layout;
        wyGiftCatalog.pagesCount = [self numberOfPagesWithWyGift:wyGiftCatalog];
    }
    return wyGiftCatalog;
}


- (NSArray *)loadChartlet{
    NSArray *chatlets = nil;
    if ([self.config respondsToSelector:@selector(charlets)])
    {
        chatlets = [self.config charlets];
        for (NIMInputWyGiftCatalog *item in chatlets) {
            NIMInputWyGiftLayout *layout = [[NIMInputWyGiftLayout alloc] initCharletLayout:self.nim_width];
            item.layout = layout;
            item.pagesCount = [self numberOfPagesWithWyGift:item];
        }
    }
    return chatlets;
}


//找到某组表情的起始位置
- (NSInteger)pageIndexWithWyGift:(NIMInputWyGiftCatalog *)wyGiftCatalog{
    NSInteger pageIndex = 0;
    for (NIMInputWyGiftCatalog *wyGift in self.totalCatalogData) {
        if (wyGift == wyGiftCatalog) {
            break;
        }
        pageIndex += wyGift.pagesCount;
    }
    return pageIndex;
}

- (NSInteger)pageIndexWithTotalIndex:(NSInteger)index{
    NIMInputWyGiftCatalog *catelog = [self wyGiftWithIndex:index];
    NSInteger begin = [self pageIndexWithWyGift:catelog];
    return index - begin;
}

- (NIMInputWyGiftCatalog *)wyGiftWithIndex:(NSInteger)index {
    NSInteger page  = 0;
    NIMInputWyGiftCatalog *wyGift;
    for (wyGift in self.totalCatalogData) {
        NSInteger newPage = page + wyGift.pagesCount;
        if (newPage > index) {
            break;
        }
        page   = newPage;
    }
    return wyGift;
}

- (NSInteger)numberOfPagesWithWyGift:(NIMInputWyGiftCatalog *)wyGiftCatalog
{
    if(wyGiftCatalog.wyGifts.count % wyGiftCatalog.layout.itemCountInPage == 0)
    {
        return  wyGiftCatalog.wyGifts.count / wyGiftCatalog.layout.itemCountInPage;
    }
    else
    {
        return  wyGiftCatalog.wyGifts.count / wyGiftCatalog.layout.itemCountInPage + 1;
    }
}

- (void)pageViewScrollEnd: (NIMPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages{
    NIMInputWyGiftCatalog *wyGift = [self wyGiftWithIndex:index];
    self.wyGiftPageController.numberOfPages = [wyGift pagesCount];
    self.wyGiftPageController.currentPage = [self pageIndexWithTotalIndex:index];
    
    NSInteger selectTabIndex = [self.totalCatalogData indexOfObject:wyGift];
    [self.tabView selectTabIndex:selectTabIndex];
}


#pragma mark - EmoticonButtonTouchDelegate
- (void)selectedWyGift:(NIMInputWyGift*)wyGift catalogID:(NSString*)catalogID{
    if ([self.delegate respondsToSelector:@selector(selectedWyGift:catalog:description:)]) {
            [self.delegate selectedWyGift:wyGift.wyGiftID catalog:catalogID description:wyGift.tag];
    }
}

- (void)didPressSend:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didPressSend:)]) {
        [self.delegate didPressSend:sender];
    }
}


#pragma mark - InputEmoticonTabDelegate
- (void)tabView:(NIMInputWyGiftTabView *)tabView didSelectTabIndex:(NSInteger) index{
    self.currentCatalogData = self.totalCatalogData[index];
}

#pragma mark - Private

- (void)setCurrentCatalogData:(NIMInputWyGiftCatalog *)currentCatalogData{
    _currentCatalogData = currentCatalogData;
    [self.wyGiftPageView scrollToPage:[self pageIndexWithWyGift:_currentCatalogData]];
}

- (void)setTotalCatalogData:(NSArray *)totalCatalogData
{
    _totalCatalogData = totalCatalogData;
    [self.tabView loadCatalogs:totalCatalogData];
}

- (NSArray *)allWyGifts{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NIMInputWyGiftCatalog *catalog in self.totalCatalogData) {
        [array addObjectsFromArray:catalog.wyGifts];
    }
    return array;
}


#pragma mark - Get
- (NIMInputWyGiftTabView *)tabView
{
    if (!_tabView) {
        _tabView = [[NIMInputWyGiftTabView alloc] initWithFrame:CGRectMake(0, 0, self.nim_width, 0)];
        _tabView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tabView.delegate = self;
        [_tabView.sendButton addTarget:self action:@selector(didPressSend:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tabView];
    
        if (_currentCatalogData.pagesCount > 0) {
            _wyGiftPageController.numberOfPages = [_currentCatalogData pagesCount];
            _wyGiftPageController.currentPage = 0;
        }
    }
    return _tabView;
}

@end

