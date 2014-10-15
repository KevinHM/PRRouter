//
//  NSString+PRURLCoding.m
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "NSString+PRURLCoding.h"

@implementation NSString (PRURLCoding)

- (NSString *)pr_URLEncodedString
{
    CFStringRef resultString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                       (CFStringRef)self,
                                                                       NULL,
                                                                       CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                       kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)resultString;
}

- (NSString *)pr_URLDecodedString
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)pr_stringWithURLEncodedDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *components = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *objString;
        if ([obj isKindOfClass:[NSString class]]) {
            objString = obj;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            objString = [obj stringValue];
        } else if ([obj isKindOfClass:[NSArray class]] ||
                   [obj isKindOfClass:[NSSet class]] ||
                   [obj isKindOfClass:[NSOrderedSet class]]) {
            NSMutableArray *objComponents = [NSMutableArray arrayWithCapacity:[obj count]];
            for (id objComponent in obj) {
                NSString *objComponentString;
                if ([objComponent isKindOfClass:[NSString class]]) {
                    objComponentString = [objComponent pr_URLEncodedString];
                } else if ([objComponent isKindOfClass:[NSNumber class]]) {
                    objComponentString = [objComponent stringValue];
                }
                if (objComponentString) {
                    [objComponents addObject:objComponentString];
                }
            }
            objString = [objComponents componentsJoinedByString:@","];
        }
        NSString *component = [NSString stringWithFormat:@"%@=%@",
                               [key pr_URLEncodedString],
                               objString];
        [components addObject:component];
    }];
    NSString *resultString = [components componentsJoinedByString:@"&"];
    return resultString;
}

- (NSDictionary *)pr_URLDecodedDictionary
{
    NSArray *components = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *decodedDictionary = [[NSMutableDictionary alloc] initWithCapacity:components.count];
    [components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *component = (NSString *)obj;
        NSUInteger dividerLocation = [component rangeOfString:@"="].location;
        if (dividerLocation != NSNotFound &&
            dividerLocation > 0 &&
            dividerLocation < component.length - 1) {
            NSString *key = [component substringToIndex:dividerLocation].pr_URLDecodedString;
            NSString *value = [component substringFromIndex:dividerLocation + 1].pr_URLDecodedString;
            if (![decodedDictionary.allKeys containsObject:key]) {
                [decodedDictionary setValue:value
                                     forKey:key];
            } else {
                id oldValue = [decodedDictionary valueForKey:key];
                if ([oldValue isKindOfClass:[NSArray class]]) {
                    [decodedDictionary setValue:[oldValue arrayByAddingObject:value]
                                         forKey:key];
                } else if ([oldValue isKindOfClass:[NSString class]]) {
                    [decodedDictionary setValue:@[oldValue, value]
                                         forKey:key];
                }
            }
        } else {
            NSLog(@"%s Wrong param: \"%@\"", __PRETTY_FUNCTION__, component);
        }
    }];
    return decodedDictionary;
}

@end
