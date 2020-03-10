//
//  JTPodBundle.h
//  JTDomainManagerLib
//
//  Created by lushitong on 2020/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTPodBundle : NSObject

+ (NSBundle *)podBundle:(NSString *)bundleName;
+ (NSString *)getImagePath:(NSString *)nameString fromBundle:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
