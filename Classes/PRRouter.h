//
//  PRRouter.h
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRRouterNode.h"

@interface PRRouter : NSObject

@property (nonatomic, strong) PRRouterNode *rootNode;

+ (instancetype)routerForHost:(NSString *)host;

+ (void)mapURL:(NSURL *)URL toViewControllerClass:(Class)viewControllerClass;
- (void)mapPath:(NSString *)path toViewControllerClass:(Class)viewControllerClass;

+ (void)openURL:(NSURL *)URL withNavigationController:(UINavigationController *)navigationController;
- (void)openPath:(NSString *)path query:(NSDictionary *)query withNavigationController:(UINavigationController *)navigationController;

@end

@interface UIViewController (PRRouter)

@property (nonatomic) NSArray *pr_routerParams;
@property (nonatomic) NSArray *pr_routerQuery;

- (instancetype)initWithParams:(NSDictionary *)params query:(NSDictionary *)query;

@end
