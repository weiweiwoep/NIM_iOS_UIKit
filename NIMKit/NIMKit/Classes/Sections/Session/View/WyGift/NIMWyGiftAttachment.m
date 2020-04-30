//
//  NIMWyGiftAttachment.m
//  NIMKit
//
//  Created by carlw on 2020/4/28.
//

#import "NIMWyGiftAttachment.h"
#import "WyGiftModel.h"

@implementation NIMWyGiftAttachment

- (NSString *)encodeAttachment{
    
    NSDictionary *dict = [self.wyGift toDictionary];
    
//    NSDictionary *dict = @{@"title":self.title,@"subTitle":self.subTitle};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *encodeString = @"";
    if (data) {
        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return encodeString;
}

#pragma mark - Getter

- (NSString *)title{
    if (!_title) {
        NSString *msgText = [NSString stringWithFormat:@"/{wy%ld^%@wy}/",(long)_wyGift.id,_wyGift.name];
        _title = msgText;
    }
    return _title;
}

- (NSString *)subTitle{
    if (!_subTitle) {
        _subTitle = @"";
    }
    return _subTitle;
}

- (WyGiftModel *)wyGift{
    if (!_wyGift) {
        _wyGift = nil;
    }
    return _wyGift;
}

@end
