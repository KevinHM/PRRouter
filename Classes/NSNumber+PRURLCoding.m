//
//  NSNumber+PRURLCoding.m
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "NSNumber+PRURLCoding.h"
#import "NSString+PRURLCoding.h"

@implementation NSNumber (PRURLCoding)

- (NSString *)pr_URLEncodedString
{
    return self.stringValue.pr_URLEncodedString;
}

@end
