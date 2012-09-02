//
//  AFJsonReader.h
//  JsonReader
//
//  Created by Akifumi on 2012/08/27.
//  Copyright (c) 2012年 Akifumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFJsonReader : NSObject
+ (NSDictionary *)requestWithUrl:(NSString *)url;
+ (void)requestWithUrl:(NSString *)url block:(void(^)(NSDictionary *jsonDic))block;
@end
