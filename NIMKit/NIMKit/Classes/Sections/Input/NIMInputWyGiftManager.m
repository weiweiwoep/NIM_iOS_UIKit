//
//  NTESEmoticonManager.h
//  NIM
//
//  Created by amao on 7/2/14.
//  Copyright (c) 2014 Netease. All rights reserved.
//

#import "NIMInputWyGiftManager.h"
#import "NIMInputWyGiftDefine.h"
#import "NSString+NIMKit.h"
#import "NIMKit.h"
#import "UIImage+NIMKit.h"
#import "NSBundle+NIMKit.h"

@implementation NIMInputWyGift

//- (NIMEmoticonType)type {
//    if (_unicode.length) {
//        return NIMEmoticonTypeUnicode;
//    } else {
//        return NIMEmoticonTypeFile;
//    }
//}

@end

@implementation NIMInputWyGiftCatalog
@end

@implementation NIMInputWyGiftLayout

- (id)initWyGiftLayout:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        _rows            = NIMKit_WyGiftRows;
        _columes         = ((width - NIMKit_WyGiftLeftMargin - NIMKit_WyGiftRightMargin) / NIMKit_WyGiftImageWidth);
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (width - NIMKit_WyGiftLeftMargin - NIMKit_WyGiftRightMargin) / _columes;
        _cellHeight      = NIMKit_WyGiftCellHeight;
        _imageWidth      = NIMKit_WyGiftImageWidth;
        _imageHeight     = NIMKit_WyGiftImageHeight;
        _emoji           = YES;
    }
    return self;
}

- (id)initCharletLayout:(CGFloat)width{
    self = [super init];
    if (self)
    {
        _rows            = NIMKit_WyGiftPicRows;
        _columes         = ((width - NIMKit_WyGiftLeftMargin - NIMKit_WyGiftRightMargin) / NIMKit_WyGiftPicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - NIMKit_WyGiftLeftMargin - NIMKit_WyGiftRightMargin) / _columes;
        _cellHeight      = NIMKit_WyGiftPicCellHeight;
        _imageWidth      = NIMKit_WyGiftPicImageWidth;
        _imageHeight     = NIMKit_WyGiftPicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end

@interface NIMInputWyGiftManager ()
@property (nonatomic,strong)    NSArray *catalogs;
@end

@implementation NIMInputWyGiftManager

+ (instancetype)sharedManager
{
    static NIMInputWyGiftManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMInputWyGiftManager alloc]init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self parsePlist];
        [self preloadWyGiftResource];
    }
    return self;
}

- (void)start {};

- (NIMInputWyGiftCatalog *)wyGiftCatalog:(NSString *)catalogID
{
    for (NIMInputWyGiftCatalog *catalog in _catalogs)
    {
        if ([catalog.catalogID isEqualToString:catalogID])
        {
            return catalog;
        }
    }
    return nil;
}


- (NIMInputWyGift *)wyGiftByTag:(NSString *)tag
{
    NIMInputWyGift *wyGift = nil;
    if ([tag length])
    {
        for (NIMInputWyGiftCatalog *catalog in _catalogs)
        {
            wyGift = [catalog.tag2WyGifts objectForKey:tag];
            if (wyGift)
            {
                break;
            }
        }
    }
    return wyGift;
}


- (NIMInputWyGift *)wyGiftByID:(NSString *)wyGiftID
{
    NIMInputWyGift *wyGift = nil;
    if ([wyGiftID length])
    {
        for (NIMInputWyGiftCatalog *catalog in _catalogs)
        {
            wyGift = [catalog.id2WyGifts objectForKey:wyGiftID];
            if (wyGift)
            {
                break;
            }
        }
    }
    return wyGift;
}

- (NIMInputWyGift *)wyGiftByCatalogID:(NSString *)catalogID
                           wyGiftID:(NSString *)wyGiftID
{
    NIMInputWyGift *wyGift = nil;
    if ([wyGiftID length] && [catalogID length])
    {
        for (NIMInputWyGiftCatalog *catalog in _catalogs)
        {
            if ([catalog.catalogID isEqualToString:catalogID])
            {
                wyGift = [catalog.id2WyGifts objectForKey:wyGiftID];
                break;
            }
        }
    }
    return wyGift;
}

- (void)parsePlist
{
    NSMutableArray *catalogs = [NSMutableArray array];
    //todo
//    NSString *filepath = [NSBundle nim_WyGiftPlistFile];
    NSString *filepath = @"";
    if (filepath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
        for (NSDictionary *dict in array)
        {
            NSDictionary *info = dict[@"info"];
            NSArray *wyGifts = dict[@"data"];
            
            NIMInputWyGiftCatalog *catalog = [self catalogByInfo:info
                                                     wyGifts:wyGifts];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

- (NIMInputWyGiftCatalog *)catalogByInfo:(NSDictionary *)info
                             wyGifts:(NSArray *)wyGiftsArray
{
    NIMInputWyGiftCatalog *catalog = [[NIMInputWyGiftCatalog alloc]init];
    catalog.catalogID = info[@"id"];
    catalog.title     = info[@"title"];
    catalog.icon      = info[@"normal"];
    catalog.iconPressed = info[@"pressed"];
    NSMutableDictionary *tag2WyGifts = [NSMutableDictionary dictionary];
    NSMutableDictionary *id2WyGifts = [NSMutableDictionary dictionary];
    NSMutableArray *wyGifts = [NSMutableArray array];
    
    for (NSDictionary *wyGiftDict in wyGiftsArray) {
        NIMInputWyGift *wyGift  = [[NIMInputWyGift alloc] init];
        wyGift.wyGiftID     = wyGiftDict[@"id"];
        wyGift.tag            = wyGiftDict[@"tag"];
//        wyGift.unicode        = wyGiftDict[@"unicode"];
//        wyGift.filename       = wyGiftDict[@"file"];
        
        if (wyGift.wyGiftID) {
            [wyGifts addObject:wyGift];
            id2WyGifts[wyGift.wyGiftID] = wyGift;
        }
        if (wyGift.tag) {
            tag2WyGifts[wyGift.tag] = wyGift;
        }
    }
    
    catalog.wyGifts       = wyGifts;
    catalog.id2WyGifts    = id2WyGifts;
    catalog.tag2WyGifts   = tag2WyGifts;
    return catalog;
}

- (void)preloadWyGiftResource {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NIMInputWyGiftCatalog *catalog in _catalogs) {
            [catalog.wyGifts enumerateObjectsUsingBlock:^(NIMInputWyGift  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.imgUrl) {
//                   __unused UIImage *image = [UIImage nim_emoticonInKit:obj.filename];
                    __unused NSURL *imgUrl = [NSURL URLWithString:obj.imgUrl];
                    __unused NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                    __unused UIImage *image =  [UIImage.alloc initWithData:imgData];
                }
            }];
        }
    });
}

@end
