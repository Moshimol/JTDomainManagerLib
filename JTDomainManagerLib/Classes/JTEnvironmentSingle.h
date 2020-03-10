//
//  JTEnvironmentSingle.h
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/10.
//

#import <Foundation/Foundation.h>

static NSString * const kEnvironmentIdKey = @"environment_id";        // 当前环境
static NSString * const kEnvironmentIndexKey = @"environment_index";  // 当前环境下服务器Index
static NSString * const kServerTitleKey = @"server_title";            // 服务端类型标题

static NSString * const kServerUrlKey = @"server_url";                // 服务端地址
static NSString * const kServerWebH5Key = @"server_web_h5";           // h5地址
static NSString * const kServerRefreshKey = @"server_refresh";        // 插件平台
static NSString * const kServerWeiBoCallBackKey = @"server_weibo";    // 微博平台
static NSString * const kServerRouterKey = @"server_router";                // 服务端地址

static NSString * const kServerWebLocalKey = @"server_web_local";     // H5拼接用地址（历史遗留，不会动态下发）


static NSString * const kUDEnvironmentSingleKey = @"kUDEnvironmentSingleKey";      // 缓存key

NS_ASSUME_NONNULL_BEGIN


@interface JTEnvironmentSingle : NSObject

@property (nonatomic, strong) NSString *identifier;          // 切环境识别码
@property (nonatomic, strong) NSString *filtPath;            //

@property (nonatomic, strong) NSString *serviceUrl;          // 请求地址
@property (nonatomic, strong) NSString *webServiceUrl;       // Web地址
@property (nonatomic, strong) NSString *webLocalServiceUrl;  // Web地址
@property (nonatomic, strong) NSString *refreshServiceUrl;   // 插件平台地址
@property (nonatomic, strong) NSString *weiboCallBackUrl;   // 微博回调地址
@property (nonatomic, assign) NSInteger environmentId;       // 当前环境（开发，测试，线上）
@property (nonatomic, assign) NSInteger environmentIndex;    // 当前环境下服务器Index


// 默认的plist文件 默认的地方
+ (JTEnvironmentSingle *)sharedInstance;


- (void)resetEnvironmentWithEnvironmentID:(NSInteger)environmentID environmentIndex:(NSInteger)environmentIndex;     //重设Api

- (void)updateEnvironmentWithServerUrl:(NSString *)serverUrl serverWebH5:(NSString *)serverWebH5 serverRefresh:(NSString *)serverRefresh serverWb:(NSString *)serverWb;

/**
 设置环境识别码，如果没有则默认JT229
 */
extern void jt_setIdentifierName(NSString*_Nonnull sqliteName);


@end

NS_ASSUME_NONNULL_END
