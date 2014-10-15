//
//  PRRouterNode.h
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRRouterNode : NSObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSMutableArray *paramKeys;
@property (nonatomic, strong) NSMutableDictionary *subNodes;
@property (nonatomic, copy) Class viewControllerClass;

@end
