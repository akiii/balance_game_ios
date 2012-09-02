//
//  AFJsonReader.m
//  JsonReader
//
//  Created by Akifumi on 2012/08/27.
//  Copyright (c) 2012年 Akifumi. All rights reserved.
//

#import "AFJsonReader.h"
#import "BGJson.h"

@implementation AFJsonReader

+ (NSDictionary *)requestWithUrl:(NSString *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    BGJsonParser *parser = [[BGJsonParser alloc] init];
    return [parser objectWithString:responseString];
}

+ (void)requestWithUrl:(NSString *)url block:(void(^)(NSDictionary *jsonDic))block{
    block([self requestWithUrl:url]);
}

@end
