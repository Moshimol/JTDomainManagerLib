//
//  JTPodBundle.m
//  JTDomainManagerLib
//
//  Created by lushitong on 2020/3/10.
//

#import "JTPodBundle.h"
#import "JTEnvironmentSingle.h"

@interface JTPodBundle()

@property (nonatomic, strong) NSMutableDictionary *bundleDict;

@end

@implementation JTPodBundle

+ (JTPodBundle *)instance
{
    static JTPodBundle *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTPodBundle alloc] init];
    });
    return instance;
}

+ (NSBundle *)podBundle:(NSString *)bundleName
{
    NSURL *url = [JTPodBundle podBundleUrl:bundleName];
    if (url) {
        return [NSBundle bundleWithURL:url];
    } else {
        assert("bundle is not exits");
        return nil;
    }
}

+ (NSString *)getImagePath:(NSString *)nameString fromBundle:(NSString *)bundleName
{
    NSURL *url = [JTPodBundle podBundleUrl:bundleName];
    if (url) {
        NSString *imagePath = [url.path stringByAppendingPathComponent:nameString];
        if ([UIImage imageWithContentsOfFile:imagePath]) {
            return imagePath;
        }else{
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nameString];
            return path;
        }
    } else {
        return nil;
    }
    
}

+ (NSURL *)podBundleUrl:(NSString *)bundleName
{
    return [self podBundleUrl:bundleName forClass:[self class]];
}

+ (NSURL *)podBundleUrl:(NSString *)bundleName forClass:(Class) class
{
    if ([JTPodBundle instance].bundleDict[bundleName]) {
        return [JTPodBundle instance].bundleDict[bundleName];
    } else {
        NSBundle *bundle = [NSBundle bundleForClass:class];
        NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
        [JTPodBundle instance].bundleDict[bundleName] = url;
        return url;
    }
}

#pragma mark - Accessor
- (NSMutableDictionary *)bundleDict
{
    if (!_bundleDict) {
        _bundleDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return _bundleDict;
}

@end
