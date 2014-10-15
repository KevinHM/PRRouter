# PRRouter

Yet another router for iOS.

## Installation

### With CocoaPods

In your `Podfile`:

```
pod 'PRRouter'
```

## Usage

Setup in `AppDelegate.m`.

```
...

+ (void)setupRouter
{
    PRRouter *router = [PRRouter routerForHost:@"api.bbs.projectrhinestone.com"];
    [router mapPath:@"/t/:topic_id" toViewControllerClass:[PRTopicViewController class]];
    [router mapPath:@"/u/:user_id" toViewControllerClass:[PRUserViewController class]];
}

...

+ (void)initialize
{
    [self setupRouter];
}

...

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"projectrhinestone"]) {
        // For example: 
        // projectrhinestone://api.bbs.projectrhinestone.com/u/elethom?org=Project%20Rhinestone
        [PRRouter openURL:url withNavigationController:self.navigationController];
    }
    return YES;
}

...

```

Implement init method in your view controller class.

```
...

- (instancetype)initWithParams:(NSDictionary *)params query:(NSDictionary *)query
{
    self = [self init];
    if (self) {
        PRUser *user = [[PRUser alloc] init];
        user.userID = params[@"user_id"];
        user.organization = query[@"org"];
        self.user = user;
    }
    return self;
}

...
```

All Done!

## License

This code is distributed under the terms and conditions of the [MIT license](http://opensource.org/licenses/MIT).

## Donate

You can support me by sending me iTunes Gift Cards.  :-)

## Contact

* [Email](mailto:elethomhunter@gmail.com)
* [Twitter](https://twitter.com/elethomhunter)

