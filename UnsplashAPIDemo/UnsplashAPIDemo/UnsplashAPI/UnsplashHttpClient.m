//
//  UnsplashHttpClient.m
//  Picaso
//
//  Created by Hummer on 16/7/30.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import "UnsplashHttpClient.h"

#define UNSPLASH_NETWORK_METHOD_NAME @[@"Get", @"Post", @"Put", @"Delete"]

@implementation UnsplashHttpClient

static UnsplashHttpClient *_sharedClient = nil;

+ (instancetype)sharedJsonClient {
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedClient = [[UnsplashHttpClient alloc] initWithBaseURL:[NSURL URLWithString:UNSPLASH_API_BASE_URL]];
    });
    return _sharedClient;
}

+ (instancetype)changeJsonClient {
    _sharedClient = [[UnsplashHttpClient alloc] initWithBaseURL:[NSURL URLWithString:UNSPLASH_API_BASE_URL]];
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self != nil) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        [self.requestSerializer setValue:@"v1" forHTTPHeaderField:@"Accept-Version"];
        self.securityPolicy.allowInvalidCertificates = NO;
    }
    return self;
}

- (void)handleSuccessRequestWithTask:(NSURLSessionDataTask * _Nonnull)task
                            response:(id _Nullable) responseObject
                                path:(NSString *)path
                           showError:(BOOL)show
                     completeHandler:(RequestCompleteHandler)handler {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error = nil;
    id result = nil;
    if ([responseObject isKindOfClass:[NSArray class]]) {
        result = [(NSArray *)responseObject firstObject];
    } else {
        result = responseObject;
    }
    id errors = [result objectForKey:@"errors"];
    if (errors) {
        DBLog(@"\n------------------ERROR--------------------\nPath: %@\nError: %@", path, errors);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        error = [[NSError alloc] initWithDomain:UNSPLASH_HOST code:response.statusCode userInfo:errors];
#if DEBUG
        show = YES;
#endif
//        !show ?: [MessageHUD showWarningMessage:errors];
    } else {
        DBLog(@"\n------------------RESPONSE-----------------\nPath: %@\nResponse: %@", path, task.response);
    }
    handler(responseObject, error);
}

- (void)handleFailureRequestWithTask:(NSURLSessionDataTask * _Nonnull)task
                            error:(NSError * _Nonnull) error
                                path:(NSString *)path
                           showError:(BOOL)show
                     completeHandler:(RequestCompleteHandler)handler {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    DBLog(@"\n------------------FAILURE------------------\nPath: %@\nError: %@\nResponse:%@", path, error.localizedDescription, task.response);
#if DEBUG
    show = YES;
#endif
//    !show ?: [MessageHUD showErrorMessage:error.localizedDescription];
    handler(nil, error);
}

- (void)requestJsonDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                completeHandler:(RequestCompleteHandler)handler {
    [self requestJsonDataWithPath:path
                       parameters:params
                       methodType:method
                        showError:NO
                  completeHandler:handler];
}

- (void)requestJsonDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                      showError:(BOOL)show
                completeHandler:(RequestCompleteHandler)handler {
    if (path == nil || path.length == 0) {
        return;
    }
    DBLog(@"\n------------------REQUEST------------------\nMethod: %@\nPath: %@\nParams: %@", UNSPLASH_NETWORK_METHOD_NAME[method], path, params);
    // Encode path
    NSString *endcodePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Request
    switch (method) {
        case Get: {
            [self GET:endcodePath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                SMLog(@"%@", downloadProgress.localizedAdditionalDescription);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessRequestWithTask:task response:responseObject path:path showError:show completeHandler:handler];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureRequestWithTask:task error:error path:path showError:show completeHandler:handler];
            }];
            break;
        }
        case Post: {
            [self POST:endcodePath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                SMLog(@"%@", uploadProgress.localizedAdditionalDescription);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessRequestWithTask:task response:responseObject path:path showError:show completeHandler:handler];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureRequestWithTask:task error:error path:path showError:show completeHandler:handler];
            }];
            break;
        }
        case Put: {
            [self PUT:endcodePath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessRequestWithTask:task response:responseObject path:path showError:show completeHandler:handler];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureRequestWithTask:task error:error path:path showError:show completeHandler:handler];
            }];
            break;
        }
        case Delete: {
            [self DELETE:endcodePath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessRequestWithTask:task response:responseObject path:path showError:show completeHandler:handler];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureRequestWithTask:task error:error path:path showError:show completeHandler:handler];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)requestJsonDataWithPath:(NSString *)path
                           file:(NSDictionary *)file
                     parameters:(NSDictionary *)params
                     methodType:(UnsplashNetworkMethod)method
                completeHandler:(RequestCompleteHandler)handler {
    if (path == nil || path.length == 0) {
        return;
    }
    // Log request
    DBLog(@"\n----REQUEST----\nMethod: %@\nPath: %@\nParams: %@", UNSPLASH_NETWORK_METHOD_NAME[method], path, params);
    // Encode path
    NSString *endcodePath = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // Data
    NSData *data;
    NSString *name, *fileName;
    
    if (file) {
        UIImage *image = file[@"image"];
        data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024 > 1000) {
            data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
        }
        name = file[@"name"];
        fileName = file[@"fileName"];
    }
    
    // POST
    switch (method) {
        case Post: {
            [self POST:endcodePath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (file) {
                    [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                DBLog(@"%@", uploadProgress.localizedAdditionalDescription);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessRequestWithTask:task response:responseObject path:path showError:YES completeHandler:handler];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureRequestWithTask:task error:error path:path showError:YES completeHandler:handler];
            }];
        }
        default:
            break;
    }
}

- (void)reportInValidContentWithType:(InValidContentType)type parameters:(NSDictionary *)params {
    NSString *typeName;
    switch (type) {
        case InValidContentTypePhoto:
            typeName = @"InValidContentTypePhoto";
            break;
        case InValidContentTypeCategory:
            typeName = @"InValidContentTypeCategory";
            break;
        case InValidContentTypeCollectoin:
            typeName = @"InValidContentTypeCollectoin";
            break;
        default:
            break;
    }
    DBLog(@"\n----UPLOAD----\nInvalid content type: %@", typeName);
}

- (void)uploadPhoto:(UIImage *)photo
               path:(NSString *)path
               name:(NSString *)name
           progress:(void (^)(NSProgress * _Nonnull))progress
            success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
            failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSData *data = UIImagePNGRepresentation(photo);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", name, dateStr];
    DBLog(@"\n----UPLOAD----\nPhoto '%@'. Size: %.0f", fileName, (float)data.length / 1024);
    
    [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DBLog(@"\n----UPLOAD----\nPhoto '%@'. Uploaded: %.0f%%", fileName, (float)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessRequestWithTask:task response:responseObject path:path showError:YES completeHandler:success];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailureRequestWithTask:task error:error path:path showError:YES completeHandler:failure];
    }];
}

@end
