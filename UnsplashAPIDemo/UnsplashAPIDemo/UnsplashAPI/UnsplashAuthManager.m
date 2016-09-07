//
//  UnsplashAuthManager.m
//  Picaso
//
//  Created by Hummer on 16/8/2.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#define AUTH_SCOPES @[@"public",            \
                      @"read_user",         \
                      @"write_user",        \
                      @"read_photos",       \
                      @"write_photos",      \
                      @"write_likes",       \
                      @"read_collections",  \
                      @"write_collections"  \
                     ]

#import "UnsplashAuthManager.h"
#import "UnsplashHttpClient.h"

NSString * const kUnsplashHost = @"unsplash.com";
NSString * const kClientId = @"client_id"; // replace it with yours.
NSString * const kClientSecret = @"client_secret"; // replace it with yours.

@interface UnsplashAuthManager ()
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, strong) NSURL *redirectURI;
@property (nonatomic, strong) NSArray *scopes;
@end

@implementation UnsplashAuthManager

+ (instancetype)sharedAuthManager {
    static UnsplashAuthManager *_sharedAuthManager = nil;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedAuthManager = [[UnsplashAuthManager alloc] initWithClientId:kClientId clientSecret:kClientSecret permissionScopes:AUTH_SCOPES];
    });
    return _sharedAuthManager;
}

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret permissionScopes:(NSArray *)scopes {
    NSAssert(![clientId isEqualToString:@"client_id"], @"You need replace client_id with yours.");
    NSAssert(![clientId isEqualToString:@"client_secret"], @"You need replace client_secret with yours.");
    self = [super init];
    if (self) {
        _clientId = clientId;
        _clientSecret = clientSecret;
        _redirectURI = [NSURL URLWithString:[NSString stringWithFormat:@"picaso%@://token", clientId]];
        _scopes = scopes;
    }
    return self;
}

- (void)authorizeFromController:(UIViewController *)controller completeHandler:(void (^)(UnsplashAccessToken *token, NSError *error))handler {
    UnsplashConnectController *connectController = [[UnsplashConnectController alloc] initWithStartURL:[self authURL] dismissOnMatchURL:_redirectURI];
    connectController.onWillDismiss = ^(BOOL cancel) {
        if (cancel) {
            handler == nil ? : handler(nil, [UnsplashError errorWithCode:UnsplashErrorCodeUserCanceledAuth description:@"User canceled authorization"]);
        }
    };
    __weak typeof(self) weakSelf = self;
    connectController.onMatchedURL = ^(NSURL *url) {
        [weakSelf retrieveAccessTokenFromURL:url completeHandler:handler];
    };
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:connectController];
    [controller presentViewController:navigationController animated:YES completion:nil];
}

- (void)retrieveAccessTokenFromURL:(NSURL *)url completeHandler:(void (^)(UnsplashAccessToken *token, NSError *error))handler {
    NSError *error = nil;
    NSString *code = [self extractCodeFromRedirectURL:url error:&error];
    if (error != nil) {
        handler == nil ? : handler(nil, error);
        return;
    }
    NSURL *requestURL = [self accessTokenURL:code];
    [[UnsplashHttpClient sharedJsonClient] requestJsonDataWithPath:requestURL.fullPath parameters:requestURL.queryPairs methodType:Post completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            error = data ? [self extractErrorFromData:data] : error;
            handler == nil ? : handler(nil, error);
            return;
        }
        UnsplashAccessToken *token = [[UnsplashAccessToken alloc] initWithClientId:_clientId authResponse:data];
        
        [UnsplashKeychain setKey:_clientId inString:token.accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:token.tokenType forKey:@"token_type"];
        [[NSUserDefaults standardUserDefaults] setObject:token.scope forKey:@"scope"];
        [[NSUserDefaults standardUserDefaults] setDouble:token.createdAt forKey:@"created_at"];
        
        handler == nil ? : handler(token, nil);
    }];
}

- (NSURL *)authURL {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = kUnsplashHost;
    components.path = @"/oauth/authorize";
    
    components.queryItems = @[
                              [NSURLQueryItem queryItemWithName:@"response_type" value:@"code"],
                              [NSURLQueryItem queryItemWithName:@"client_id" value:_clientId],
                              [NSURLQueryItem queryItemWithName:@"redirect_uri" value:_redirectURI.absoluteString],
                              [NSURLQueryItem queryItemWithName:@"scope" value:[_scopes componentsJoinedByString:@"+"]]
                              ];
    return components.URL;
}

- (NSURL *)accessTokenURL:(NSString *)code {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = kUnsplashHost;
    components.path = @"/oauth/token";
    
    components.queryItems = @[
                             [NSURLQueryItem queryItemWithName:@"client_id" value:_clientId],
                             [NSURLQueryItem queryItemWithName:@"client_secret" value:_clientSecret],
                             [NSURLQueryItem queryItemWithName:@"redirect_uri" value:_redirectURI.absoluteString],
                             [NSURLQueryItem queryItemWithName:@"code" value:code],
                             [NSURLQueryItem queryItemWithName:@"grant_type" value:@"authorization_code"],
                             ];
    
    return components.URL;
}

- (NSString *)extractCodeFromRedirectURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSDictionary *pairs = url.queryPairs;
    NSString *errorStr = pairs[@"error"];
    if (errorStr != nil) {
        NSString *desc = [[pairs[@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding];
        *error = [UnsplashError errorWithCodeString:errorStr description:desc];
    } else {
        *error = nil;
    }
    NSString *code = pairs[@"code"];
    return code;
}

- (NSError *)extractErrorFromData:(NSData *)data {
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return [UnsplashError errorWithCodeString:json[@"error"] description:json[@"error_descroption"]];
    } @catch (NSException *exception) {
        return nil;
    }
}

- (UnsplashAccessToken *)getAccessToken {
    NSString *accessToken = [UnsplashKeychain getKey:_clientId];
    if (accessToken == nil) {
        return nil;
    }
    return [[UnsplashAccessToken alloc] initWithClientId:_clientId accessToken:accessToken];
}

- (BOOL)clearAccessToken {
    return [UnsplashKeychain clear];
}

@end

///  UnsplashConnectController
@interface UnsplashConnectController () <WKNavigationDelegate>
@property (nonatomic, strong) NSURL *startURL;
@property (nonatomic, strong) NSURL *dismissOnMatchURL;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@end

@implementation UnsplashConnectController
- (instancetype)initWithStartURL:(NSURL *)startUrl dismissOnMatchURL:(NSURL *)dismissUrl {
    self = [super init];
    if (self) {
        _startURL = startUrl;
        _dismissOnMatchURL = dismissUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Unsplash";
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = _cancelButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_webView.canGoBack) {
        [self loadURL:_startURL];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    if ([self dismissURLMatchesURL:url]) {
        _onMatchedURL == nil ? : _onMatchedURL(url);
        [self dismiss:YES];
        return decisionHandler(WKNavigationActionPolicyCancel);
    }
    return decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)loadURL:(NSURL *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (BOOL)dismissURLMatchesURL:(NSURL *)url {
    if ([url.scheme isEqualToString: _dismissOnMatchURL.scheme] &&
        [url.host isEqualToString: _dismissOnMatchURL.host] &&
        [url.path isEqualToString:_dismissOnMatchURL.path]) {
        return YES;
    }
    return NO;
}

- (void)showHideBackButton:(BOOL)show {
    self.navigationItem.leftBarButtonItem = show ? [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack:)] : nil;
}

- (void)goBack:(UIBarButtonItem *)sender {
    [_webView goBack];
}

- (void)cancel:(UIBarButtonItem *)sender {
    [self dismissAsCancel:YES animated:(sender != nil)];
}

- (void)dismiss:(BOOL)animated {
    [self dismissAsCancel:NO animated:animated];
}

- (void)dismissAsCancel:(BOOL)cancel animated:(BOOL)animated {
    [_webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    (_onWillDismiss == nil) ? : _onWillDismiss(cancel);
    [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
}

@end

///  UnsplashAccessToken
@implementation UnsplashAccessToken

- (instancetype)initWithClientId:(NSString *)clientId authResponse:(NSDictionary *)response {
    self = [super init];
    if (self) {
        _clientId = clientId;
        _accessToken = [response objectForKey:@"access_token"];
        _tokenType = [response objectForKey:@"token_type"];
        _scope = [self authorizedScope:[response objectForKey:@"scope"]];
        _createdAt = [[response objectForKey:@"created_at"] doubleValue];
    }
    return self;
}

- (instancetype)initWithClientId:(NSString *)clientId accessToken:(NSString *)token {
    self = [super init];
    if (self) {
        _clientId = clientId;
        _accessToken = token;
        _tokenType = [[NSUserDefaults standardUserDefaults] objectForKey:@"token_type"];
        _scope = [[NSUserDefaults standardUserDefaults] objectForKey:@"scope"];
        _createdAt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"created_at"] doubleValue];
    }
    return self;
}

- (NSDictionary *)authorizedScope:(NSString *)scope {
    NSArray *scopes = [scope componentsSeparatedByString:@" "];
    NSMutableDictionary *authScopes = [NSMutableDictionary dictionary];
    [scopes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [authScopes setObject:@YES forKey:(NSString *)obj];
    }];
    return authScopes;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n{\n\tclient_id: %@,\n\taccess_token:%@,\n\ttoken_type:%@\n,\n\tscope:%@,\n\tcreated_at:%.0f}", _clientId, _accessToken, _tokenType, _scope, _createdAt];
}
@end

///  UnsplashErrorCode
@implementation UnsplashError

+ (NSError *)errorWithCodeString:(NSString *)string description:(NSString *)description {
    UnsplashErrorCode code;
    if ([string isEqualToString:@"unauthorized_client"]) {
        code = UnsplashErrorCodeUnauthorizedClient;
    } else if ([string isEqualToString:@"access_denied"]) {
        code = UnsplashErrorCodeAccessDenied;
    } else if ([string isEqualToString:@"unsupported_response_type"]) {
        code = UnsplashErrorCodeUnsupportedResponseType;
    } else if ([string isEqualToString:@"server_error"]) {
        code = UnsplashErrorCodeServerError;
    } else if ([string isEqualToString:@"invalid_scope"]) {
        code = UnsplashErrorCodeInvalidScope;
    } else if ([string isEqualToString:@"invalid_client"]) {
        code = UnsplashErrorCodeInvalidClient;
    } else if ([string isEqualToString:@"invalid_request"]) {
        code = UnsplashErrorCodeInvalidRequest;
    } else if ([string isEqualToString:@"temporarily_unavailable"]) {
        code = UnsplashErrorCodeTemporarilyUnavailable;
    } else {
        code = UnsplashErrorCodeUnkown;
    }
    return [self errorWithCode:code description:description];
}

+ (NSError *)errorWithCode:(UnsplashErrorCode)code description:(NSString *)description {
    DBLog(@"\n----UNSPLASH_ERROR----\n{\n\t%@\n}", description);
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (description != nil) {
        [info setObject:description forKey:NSLocalizedDescriptionKey];
    }
    return [NSError errorWithDomain:kDomain code:code userInfo:info];
}

@end

@implementation UnsplashKeychain

+ (CFDictionaryRef)queryWithDict:(NSDictionary *)query {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionaryWithDictionary:query];
    [queryDic setObject:(__bridge_transfer NSString *)kSecClassGenericPassword forKey:(__bridge_transfer NSString *)kSecClass];
    [queryDic setObject:[NSString stringWithFormat:@"%@.unsplash.auth", bundleId] forKey:(__bridge_transfer NSString *)kSecAttrService];
    return (__bridge_retained CFDictionaryRef)queryDic;
}

+ (BOOL)setKey:(NSString *)key inString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        return false;
    }
    return [UnsplashKeychain setKey:key inData:data];
}

+ (BOOL)setKey:(NSString *)key inData:(NSData *)data {
    CFDictionaryRef query = [UnsplashKeychain queryWithDict:@{(__bridge_transfer NSString *)kSecAttrAccount : key,
                                      (__bridge_transfer NSString *)kSecValueData : data}];
    SecItemDelete(query);
    return SecItemAdd(query, nil) == noErr;
}

+ (NSData *)getDataWithKey:(NSString *)key {
    CFDictionaryRef query = [UnsplashKeychain queryWithDict:@{(__bridge_transfer NSString *)kSecAttrAccount : key,
                                                              (__bridge_transfer NSString *)kSecReturnData : (__bridge_transfer NSNumber *)kCFBooleanTrue,
                                                              (__bridge_transfer NSString *)kSecMatchLimit : (__bridge_transfer NSString *)kSecMatchLimitOne}];
    CFTypeRef dataResult = NULL;
    OSStatus status = SecItemCopyMatching(query, &dataResult);
    CFRelease(query);
    if (status == noErr) {
        return (__bridge_transfer NSData *)(dataResult);
    }
    return nil;
}

+ (NSString *)getKey:(NSString *)key {
    NSData *data = [UnsplashKeychain getDataWithKey:key];
    if (data == nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (BOOL)deleteKey:(NSString *)key {
    CFDictionaryRef query = [UnsplashKeychain queryWithDict:@{(__bridge_transfer NSString *)kSecAttrAccount : key}];
    return SecItemDelete(query) == noErr;
}

+ (BOOL)clear {
    CFDictionaryRef query = [UnsplashKeychain queryWithDict:@{}];
    return SecItemDelete(query) == noErr;
}
@end