//
//  NIMWyGiftAttachmentDecoder.m
//  NIMKit
//
//  Created by carlw on 2020/4/28.
//

#import "NIMWyGiftAttachmentDecoder.h"
#import <WyGiftModel.h>
#import <NIMWyGiftAttachment.h>

@implementation NIMWyGiftAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSError *error = nil;
        WyGiftModel *wyGift = [WyGiftModel.alloc initWithDictionary:dict error:&error];
        
        NIMWyGiftAttachment *giftAttachment = [NIMWyGiftAttachment new];
        giftAttachment.wyGift = wyGift;
        attachment = giftAttachment;
    }
    return attachment;
}

@end
