//
//  NSString+PRURLCoding.h
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+PRURLCoding.h"

@interface NSString (PRURLCoding)

- (NSString *)pr_URLEncodedString;
- (NSString *)pr_URLDecodedString;

+ (NSString *)pr_stringWithURLEncodedDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)pr_URLDecodedDictionary;

@end
