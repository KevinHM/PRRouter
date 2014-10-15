//
//  PRRouterNode.m
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "PRRouterNode.h"

@implementation PRRouterNode

- (NSString *)path
{
    return _path ?: (_path = @"/");
}

- (NSMutableArray *)paramKeys
{
    return _paramKeys ?: (_paramKeys = [[NSMutableArray alloc] init]);
}

- (NSMutableDictionary *)subNodes
{
    return _subNodes ?: (_subNodes = [[NSMutableDictionary alloc] init]);
}

@end
