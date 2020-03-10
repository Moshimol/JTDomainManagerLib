//
//  JTEnvironmentSingle.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/10.
//

#import "JTEnvironmentSingle.h"
#import "JTPodBundle.h"

// 需要自己在的项目中设置相应的问题

#if defined(DEBUG)
static int const kEnvironmentId = 0; // 内网
#elif defined(CONFIGURATION_Develop)
static int const kEnvironmentId = 1; // 测试
#else
static int const kEnvironmentId = 2; // 线上
#endif

@interface JTEnvironmentSingle()

@property (nonatomic, assign) BOOL isInit;

@end

@implementation JTEnvironmentSingle

static JTEnvironmentSingle *single = nil;

+ (JTEnvironmentSingle *)sharedInstance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        single = [[JTEnvironmentSingle alloc] init];
        single.environmentId = [[self objectForKey:kEnvironmentIdKey] intValue];
        single.environmentIndex = [[self objectForKey:kEnvironmentIndexKey] intValue];
        
        if ([self objectForKey:kEnvironmentIdKey]) {
            [single initEnvironmentWithEnvironmentID];
        } else {
            [self setObject:@(kEnvironmentId) forKey:kEnvironmentIdKey];
            [single initEnvironmentWithEnvironmentID];
        }
        single.identifier = [JTEnvironmentSingle sharedInstance].identifier ? [JTEnvironmentSingle sharedInstance].identifier : @"jt229";
    });
    return single;
}

#pragma mark s

void jt_setIdentifierName(NSString*_Nonnull identifierName){
    if ([identifierName isEqualToString:[JTEnvironmentSingle sharedInstance].identifier]) {
        [JTEnvironmentSingle sharedInstance].identifier = identifierName;
    }
}

#pragma mark 初始化

- (void)initEnvironmentWithEnvironmentID {
    
    NSDictionary *itemDic;
    NSString *serverUrl;
    NSString *webLocalUrl;
    NSString *webServiceUrl;
    NSString *refreshServiceUrl;
    NSString *weiboCallBackUrl;
    
    if ([JTEnvironmentSingle objectForKey:kUDEnvironmentSingleKey]) {
        
        itemDic = [JTEnvironmentSingle dictWithJsonString:[JTEnvironmentSingle objectForKey:kUDEnvironmentSingleKey]];
        
        serverUrl = itemDic[kServerUrlKey];
        webLocalUrl = itemDic[kServerWebLocalKey]; // 初始化的时候取 kServerWebLocalKey
        webServiceUrl = itemDic[kServerWebH5Key];
        refreshServiceUrl = itemDic[kServerRefreshKey];
        weiboCallBackUrl = itemDic[kServerWeiBoCallBackKey];
    } else {
        int environmentID = [[JTEnvironmentSingle objectForKey:kEnvironmentIdKey] intValue];
        int environmentIndex = [[JTEnvironmentSingle objectForKey:kEnvironmentIndexKey] intValue];
        
        NSString *path = [self filtPath];
        NSArray *dataSource = [NSMutableArray arrayWithContentsOfFile:path];
        if (dataSource.count <= environmentID) {
            NSLog(@"切换环境，超出了环境配置范围");
            return;
        }
        
        itemDic = dataSource[environmentID];
        serverUrl = itemDic[kServerUrlKey][environmentIndex];
        webLocalUrl = itemDic[kServerWebLocalKey][environmentIndex];
        webServiceUrl = itemDic[kServerWebH5Key];
        refreshServiceUrl = itemDic[kServerRefreshKey];
        weiboCallBackUrl = itemDic[kServerWeiBoCallBackKey];
    }
    
    single.serviceUrl = serverUrl;
    single.webLocalServiceUrl = webLocalUrl;
    single.webServiceUrl = webServiceUrl;
    single.refreshServiceUrl = refreshServiceUrl;
    single.weiboCallBackUrl = weiboCallBackUrl;
    
    self.isInit = YES;
}

- (NSString *)filtPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self fileName] ofType:nil];
    return filePath;
}

- (NSString *)fileName {
    // 获得
    return @"Environment.plist";
}

#pragma mark 更换或者重置相关

- (void)resetEnvironmentWithEnvironmentID:(NSInteger)environmentID environmentIndex:(NSInteger)environmentIndex {
    
    [JTEnvironmentSingle setObject:@(environmentID) forKey:kEnvironmentIdKey];
    [JTEnvironmentSingle setObject:@(environmentIndex) forKey:kEnvironmentIndexKey];
    
    single.environmentId = environmentID;
    single.environmentIndex = environmentIndex;
    
    [single initEnvironmentWithEnvironmentID];
}

- (void)updateEnvironmentWithServerUrl:(NSString *)serverUrl serverWebH5:(NSString *)serverWebH5 serverRefresh:(NSString *)serverRefresh serverWb:(NSString *)serverWb {
    
    if (!self.isInit) { [self initEnvironmentWithEnvironmentID]; }
    
    NSString *str = [JTEnvironmentSingle jsonStringWithDict:
                     @{kServerUrlKey : serverUrl ? serverUrl : single.serviceUrl,
                       kServerWebH5Key : serverWebH5 ? serverWebH5: single.webLocalServiceUrl,
                       kServerRefreshKey : serverRefresh ? serverRefresh : single.refreshServiceUrl,
                       kServerWebLocalKey : serverUrl ? serverUrl : single.webLocalServiceUrl,
                       kServerWeiBoCallBackKey : serverWb ? serverWb : single.weiboCallBackUrl,
                       }];
    
    [JTEnvironmentSingle setObject:str forKey:kUDEnvironmentSingleKey];
    
    [self initEnvironmentWithEnvironmentID];
}

#pragma mark 设置缓存相关的

+ (void)setObject:(id)object forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark 私有方法

/// 字典转字符串
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = @"";
    
    if (!jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    // 去掉首尾空白
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return jsonString;
}

/// 字符串转字典
+ (NSDictionary *)dictWithJsonString:(NSString *)string {
    
    if (!string || string.length == 0) { return nil; }
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
