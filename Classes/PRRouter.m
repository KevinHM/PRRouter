//
//  PRRouter.m
//  PRRouter
//
//  Created by Elethom Hunter on 10/15/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "PRRouter.h"
#import "NSString+PRURLCoding.h"
#import <objc/runtime.h>

@interface PRRouter ()

+ (NSMutableDictionary *)routers;

@end

@implementation PRRouter

+ (NSMutableDictionary *)routers
{
    static NSMutableDictionary *routers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routers = [[NSMutableDictionary alloc] init];
    });
    return routers;
}

+ (instancetype)routerForHost:(NSString *)host
{
    if (!host) {
        return nil;
    }
    NSMutableDictionary *routers = [self routers];
    PRRouter *router = routers[host];
    if (!router) {
        router = [[PRRouter alloc] init];
        routers[host] = router;
    }
    return router;
}

+ (void)mapURL:(NSURL *)URL toViewControllerClass:(__unsafe_unretained Class)viewControllerClass
{
    PRRouter *router = [self routerForHost:URL.host];
    [router mapPath:URL.path toViewControllerClass:viewControllerClass];
}

- (void)mapPath:(NSString *)path toViewControllerClass:(__unsafe_unretained Class)viewControllerClass
{
    PRRouterNode *parentNode = self.rootNode;
    NSArray *pathComponents = path.pathComponents;
    for (NSString *pathComponent in pathComponents) {
        if (pathComponent == pathComponents.firstObject &&
            [pathComponent isEqualToString:@"/"]) {
            continue;
        }
        PRRouterNode *node;
        if ([pathComponent hasPrefix:@":"]) {
            node = parentNode;
            [node.paramKeys addObject:[pathComponent substringFromIndex:1]];
        } else {
            node = parentNode.subNodes[pathComponent] ?: [[PRRouterNode alloc] init];
            node.path = pathComponent;
            node.viewControllerClass = viewControllerClass;
            parentNode.subNodes[pathComponent] = node;
        }
        parentNode = node;
    }
}

+ (void)openURL:(NSURL *)URL withNavigationController:(UINavigationController *)navigationController
{
    PRRouter *router = [self routerForHost:URL.host];
    [router openPath:URL.path query:URL.query.pr_URLDecodedDictionary withNavigationController:navigationController];
}

- (void)openPath:(NSString *)path query:(NSDictionary *)query withNavigationController:(UINavigationController *)navigationController
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    PRRouterNode *node = self.rootNode;
    NSArray *pathComponents = path.pathComponents;
    NSInteger paramKeyIndex = 0;
    for (NSString *pathComponent in pathComponents) {
        if (pathComponent == pathComponents.firstObject &&
            [pathComponent isEqualToString:@"/"]) {
            continue;
        } else {
            NSMutableDictionary *subNodes = node.subNodes;
            if ([subNodes.allKeys containsObject:pathComponent]) {
                node = subNodes[pathComponent];
                paramKeyIndex = 0;
            } else {
                NSArray *paramKeys = node.paramKeys;
                if (paramKeys.count && paramKeyIndex < paramKeys.count) {
                    params[node.paramKeys[paramKeyIndex]] = pathComponent;
                    paramKeyIndex++;
                } else {
                    break;
                }   
            }
        }
    }
    UIViewController *viewController = [[node.viewControllerClass alloc] initWithParams:params
                                                                                  query:query];
    [navigationController pushViewController:viewController
                                    animated:YES];
}

#pragma mark - Getters and setters

- (PRRouterNode *)rootNode
{
    return _rootNode ?: (_rootNode = [[PRRouterNode alloc] init]);
}

@end

@implementation UIViewController (PRRouter)

static char _associatedObjectKeyParams;
static char _associatedObjectKeyQuery;

- (NSArray *)pr_routerParams
{
    return objc_getAssociatedObject(self,
                                    &_associatedObjectKeyParams);
}

- (void)setPr_routerParams:(NSArray *)pr_routerParams
{
    objc_setAssociatedObject(self,
                             &_associatedObjectKeyParams,
                             pr_routerParams,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)pr_routerQuery
{
    return objc_getAssociatedObject(self,
                                    &_associatedObjectKeyQuery);
}

- (void)setPr_routerQuery:(NSArray *)pr_routerQuery
{
    objc_setAssociatedObject(self,
                             &_associatedObjectKeyQuery,
                             pr_routerQuery,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (instancetype)initWithParams:(NSDictionary *)params query:(NSDictionary *)query
{
    return [self init];
}

@end
