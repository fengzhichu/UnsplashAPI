//
//  UnsplashApiManager.m
//  Picaso
//
//  Created by Hummer on 16/8/1.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#define HANDLE_SERVER_DICTIONARY_RESULT(Class)  {@try {\
                                                    if (data) {\
                                                        id resultData = [Class yy_modelWithJSON:data];\
                                                        handler(resultData, nil);\
                                                    } else {\
                                                        handler(nil, error);\
                                                    }\
                                                } @catch (NSException *exception) {\
                                                    DBLog(@"%@\n%@", exception.description, exception.callStackSymbols);\
                                                }}\

#define HANDLE_SERVER_ARRAY_RESULT(Class)      {@try {\
                                                    if (data) {\
                                                        NSMutableArray *resultData = [NSMutableArray array];\
                                                        for (id entry in data) {\
                                                            [resultData addObject:[Class yy_modelWithJSON:entry]];\
                                                        }\
                                                        handler(resultData, nil);\
                                                    } else {\
                                                        handler(nil, error);\
                                                    }\
                                                } @catch (NSException *exception) {\
                                                    DBLog(@"%@\n%@", exception.description, exception.callStackSymbols);\
                                                }}\

#import "UnsplashHttpClient.h"
#import "UnsplashApiManager.h"
#import "UnsplashAuthManager.h"
#import "UnsplashClient.h"

NSString *orderBy(UnsplashPhotosOrderBy order) {
    switch (order) {
        case UnsplashPhotosOrderByPopular:
            return @"popular";
        case UnsplashPhotosOrderByOldest:
            return @"oldest";
        default:
            return @"latest";
    }
}

NSString *orientate(UnsplashPhotoOrientation orientation) {
    switch (orientation) {
        case UnsplashPhotoOrientationSquarish:
            return @"squarish";
        case UnsplashPhotoOrientationPortrait:
            return @"portrait";
        default:
            return @"landscape";
    }
}

bool hasAuthorized(NSString *permission, RequestCompleteHandler handler) {
    if (![[[[UnsplashClient defaultClient] token] scope] objectForKey:permission]) {
        NSError *error = [UnsplashError errorWithCode:UnsplashErrorCodeInvalidGrant description:[NSString stringWithFormat: @"Unauthorized %@ permissions", permission]];
        handler == nil ?: handler(nil, error);
//        [MessageHUD showErrorMessage:error.localizedDescription];
        return NO;
    }
    return YES;
}

@interface UnsplashApiManager ()
@end

@implementation UnsplashApiManager

// MARK: - Base request

///  Request data for current authorized user
///
///  @param path    Request path
///  @param params  Request parameters
///  @param method  Requset method
///  @param handler Complete handler
+ (void)manageWithPath:(NSString *)path
                 parameters:(NSDictionary *)params
                 methodType:(UnsplashNetworkMethod)method
            completeHandler:(RequestCompleteHandler)handler {
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", UNSPLASH_API_BASE_URL, path];
    AFHTTPRequestSerializer *requestSerializer = [[UnsplashHttpClient sharedJsonClient] requestSerializer];
    UnsplashClient *client = [UnsplashClient defaultClient];
    if ([UnsplashClient hasAuthed]) {
        [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", client.token.accessToken] forHTTPHeaderField:@"Authorization"];
    } else {
        [requestSerializer setValue:[NSString stringWithFormat:@"Client-ID %@", client.token.clientId] forHTTPHeaderField:@"Authorization"];
    }
    [[UnsplashHttpClient sharedJsonClient] requestJsonDataWithPath:fullPath parameters:params methodType:method completeHandler:handler];
}

// MARK: - User
+ (void)getUserProfileWithCompleteHandler:(RequestCompleteHandler)handler {
    if (!hasAuthorized(@"read_user", handler)) { return; }
    [UnsplashApiManager manageWithPath:@"/me" parameters:nil methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashUser)
    }];
}

+ (void)updateUserProfileWithUserName:(NSString *)userName
                            firstName:(NSString *)firstName
                             lastName:(NSString *)lastName
                                email:(NSString *)email
                          personalUrl:(NSString *)url
                             location:(NSString *)location
                                  bio:(NSString *)bio
                    instagramUserName:(NSString *)insName
                      completeHandler:(RequestCompleteHandler)handler {
    if (!hasAuthorized(@"write_user", handler)) { return; }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !userName   ?: [params setObject:userName   forKey:@"username"];
    !firstName  ?: [params setObject:firstName  forKey:@"first_name"];
    !lastName   ?: [params setObject:lastName   forKey:@"last_name"];
    !email      ?: [params setObject:email      forKey:@"email"];
    !url        ?: [params setObject:url        forKey:@"url"];
    !location   ?: [params setObject:location   forKey:@"location"];
    !bio        ?: [params setObject:bio        forKey:@"bio"];
    !insName    ?: [params setObject:insName    forKey:@"instagram_username"];
    [UnsplashApiManager manageWithPath:@"/me" parameters:params methodType:Put completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashUser)
    }];
}


+ (void)getUserPublicProfileWithUserName:(NSString *)userName
                 customProfileImageWidth:(NSUInteger)w
                               andHeight:(NSUInteger)h
                         completehandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:userName forKey:@"username"];
    w == 0 ?: [params setObject:@(w) forKey:@"w"];
    h == 0 ?: [params setObject:@(h) forKey:@"h"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/users/%@", userName] parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashUser)
    }];
}

+ (void)listUserPhotosWithPath:(NSString *)path
                      userName:(NSString *)userName
                          page:(NSUInteger)page
                       perPage:(NSUInteger)perPage
                       orderBy:(UnsplashPhotosOrderBy)order
               completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !userName   ?: [params setObject:userName forKey:@"username"];
    page == 0   ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0?: [params setObject:@(perPage) forKey:@"per_page"];
    
    !order      ?: [params setObject:orderBy(order) forKey:@"order_by"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/users/%@%@", userName, path] parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashPhoto)
    }];
}

+ (void)listUserUploadedPhotosWithUserName:(NSString *)userName
                                      page:(NSUInteger)page
                                   perPage:(NSUInteger)perPage
                                   orderBy:(UnsplashPhotosOrderBy)order
                           completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listUserPhotosWithPath:@"/photos" userName:userName page:page perPage:perPage orderBy:order completeHandler:handler];
}

+ (void)listUserLikedPhotosWithUserName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                                orderBy:(UnsplashPhotosOrderBy)order
                        completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listUserPhotosWithPath:@"/likes" userName:userName page:page perPage:perPage orderBy:order completeHandler:handler];
}

+ (void)listUserCollectionsWithUserName:(NSString *)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                        completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !userName    ?: [params setObject:userName forKey:@"username"];
    page == 0    ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0 ?: [params setObject:@(perPage) forKey:@"per_page"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/users/%@/collections", userName] parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashCollection)
    }];
}

// MARK: - Photos

+ (void)listPhotosWithPath:(NSString *)path
                      page:(NSUInteger)page
                   perPage:(NSUInteger)perPage
                   orderBy:(UnsplashPhotosOrderBy)order
               completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    page == 0   ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0?: [params setObject:@(perPage) forKey:@"per_page"];
    !order      ?: [params setObject:orderBy(order) forKey:@"order_by"];
    [UnsplashApiManager manageWithPath:path parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashPhoto)
    }];
}

+ (void)listPhotosWithPage:(NSUInteger)page
                   perPage:(NSUInteger)perPage
                   orderBy:(UnsplashPhotosOrderBy)order
           completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listPhotosWithPath:@"/photos" page:page perPage:perPage orderBy:order completeHandler:handler];
}

+ (void)listCuratedPhotosWithPage:(NSUInteger)page
                          perPage:(NSUInteger)perPage
                          orderBy:(UnsplashPhotosOrderBy)order
                  completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listPhotosWithPath:@"/photos/curated" page:page perPage:perPage orderBy:order completeHandler:handler];
}

+ (void)searchPhotosWithQuery:(NSString *)query
                     category:(NSArray *)categoryId
                  orientation:(UnsplashPhotoOrientation)orientation
                         page:(NSUInteger)page
                      perPage:(NSUInteger)perPage
              completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !query ?: [params setObject:query forKey:@"query"];
    !categoryId ?: [params setObject:[categoryId componentsJoinedByString:@","] forKey:@"category"];
    [params setObject:orientate(orientation) forKey:@"orientation"];
    page == 0 ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0 ?: [params setObject:@(perPage) forKey:@"per_page"];
    [UnsplashApiManager manageWithPath:@"/photos/search" parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashPhoto)
    }];
}

+ (void)getSinglePhotoWithPhotoId:(NSString *)photoId
                            width:(NSUInteger)w
                           height:(NSUInteger)h
                             rect:(CGRect)rect
                  completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !photoId ?: [params setObject:photoId forKey:@"id"];
    w == 0 ?: [params setObject:@(w) forKey:@"w"];
    h == 0 ?: [params setObject:@(h) forKey:@"h"];
    CGRectIsEmpty(rect) || CGRectIsInfinite(rect) ?: [params setObject:[NSString stringWithFormat:@"%d,%d,%d,%d", (int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height] forKey:@"rect"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/photos/%@", photoId] parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashPhoto)
    }];
}

+ (void)getRandomPhotoWithCategory:(NSArray *)categoryIds
                       collections:(NSArray *)collectionIds
                          featured:(BOOL)featured
                          userName:(NSString *)userName
                             query:(NSString *)query
                             width:(NSUInteger)w
                            height:(NSUInteger)h
                       orientation:(UnsplashPhotoOrientation)orientation
                   completeHandler:(RequestCompleteHandler)handler {
    NSAssert(collectionIds == nil || query == nil, @"You can't use the collections and query parameters in the same request.");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !categoryIds ?: [params setObject:[categoryIds componentsJoinedByString:@","] forKey:@"category"];
    !collectionIds ?: [params setObject:[collectionIds componentsJoinedByString:@","] forKey:@"collections"];
    [params setObject:@(featured) forKey:@"featured"];
    !userName ?: [params setObject:userName forKey:@"username"];
    !query ?: [params setObject:query forKey:@"query"];
    w == 0 ?: [params setObject:@(w) forKey:@"w"];
    h == 0 ?: [params setObject:@(h) forKey:@"h"];
    !orientation ?: [params setObject:orientate(orientation) forKey:@"orientation"];
    
    [UnsplashApiManager manageWithPath:@"/photos/random" parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashPhoto)
    }];
}

+ (void)getPhotoStatsWithPhotoId:(NSString *)photoId
                 completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/photos/%@/stats", photoId] parameters:@{@"id" : photoId} methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashPhotoStats)
    }];
}

+ (void)updatePhotoInfoWithPhotoId:(NSString *)photoId
                         photoExif:(UnsplashPhotoExif *)exif
                     photoLocation:(UnsplashPhotoLocation *)location
                   completeHandler:(RequestCompleteHandler)handler {
    if (!hasAuthorized(@"write_photos", handler)) { return; }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:photoId forKey:@"id"];
    
    // photo location
    location.position.latitude == 0 ?: [params setObject:@(location.position.latitude) forKey:@"location[latitude]"];
    location.position.longitude == 0 ?: [params setObject:@(location.position.longitude) forKey:@"location[longitude]"];
    !location.name ?: [params setObject:location.name forKey:@"location[name]"];
    !location.city ?: [params setObject:location.city forKey:@"location[city]"];
    !location.country ?: [params setObject:location.country forKey:@"location[country]"];
    !location.confidential ?: [params setObject:location.confidential forKey:@"location[confidential]"];
    
    // photo exif
    !exif.make ?: [params setObject:exif.make forKey:@"exif[make]"];
    !exif.model ?: [params setObject:exif.model forKey:@"exif[model]"];
    !exif.exposureTime ?: [params setObject:exif.exposureTime forKey:@"exif[exposure_time]"];
    !exif.aperture ?: [params setObject:exif.aperture forKey:@"exif[aperture_value]"];
    !exif.focalLenght ?: [params setObject:exif.focalLenght forKey:@"exif[focal_length]"];
    exif.iso == 0 ?: [params setObject:@(exif.iso) forKey:@"exif[iso_speed_ratings]"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/photos/%@", photoId] parameters:params methodType:Put completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashPhoto)
    }];
}

+ (void)likePhotoOrNotWithPhotoId:(NSString *)photoId
                           option:(BOOL)option
                  completeHandler:(RequestCompleteHandler)handler {
    UnsplashNetworkMethod method = option ? Post : Delete;
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/photos/%@/like", photoId] parameters:@{@"id" : photoId} methodType:method completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        @try {
            if (data) {
                id photoJson = [(NSDictionary *)data objectForKey:@"photo"];
                id userJson = [(NSDictionary *)data objectForKey:@"user"];
                NSMutableDictionary *result = [NSMutableDictionary dictionary];
                [result setObject:[UnsplashPhoto yy_modelWithJSON:photoJson] forKey:@"photo"];
                [result setObject:[UnsplashUser yy_modelWithJSON:userJson] forKey:@"user"];
                handler(result, nil);
            } else {
                handler(nil, error);
            }
        } @catch (NSException *exception) {
            DBLog(@"%@\n%@", exception.description, exception.callStackSymbols);
        }
    }];
}

+ (void)likePhotoWithPhotoId:(NSString *)photoId
             completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager likePhotoOrNotWithPhotoId:photoId option:YES completeHandler:handler];
}

+ (void)unlikePhotoWithPhotoId:(NSString *)photoId
               completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager likePhotoOrNotWithPhotoId:photoId option:NO completeHandler:handler];
}

// MARK: - Categories
+ (void)listCategoriesWithCompleteHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:@"/categories" parameters:nil methodType:Get completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UserCategory)
    }];
}

+ (void)getCategoryWithCategoryId:(NSUInteger)categoryId
                  completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/categories/%lu", (unsigned long)categoryId] parameters:@{@"id" : @(categoryId)} methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UserCategory)
    }];
}

+ (void)getPhotosFromCategoryWithCategoryId:(NSUInteger)categoryId
                                       page:(NSUInteger)page
                                    perPage:(NSUInteger)perPage
                            completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    page == 0 ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0 ?: [params setObject:@(perPage) forKey:@"per_page"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/categories/%lu/photos", (unsigned long)categoryId] parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashPhoto)
    }];
}

// MARK: - Collections
+ (void)listCollectionsWithPath:(NSString *)path
                           page:(NSUInteger)page
                        perPage:(NSUInteger)perPage
                completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    page == 0 ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0 ?: [params setObject:@(perPage) forKey:@"per_page"];
    [UnsplashApiManager manageWithPath:path parameters:params methodType:Get completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashCollection)
    }];
}

+ (void)listCollectionsWithPage:(NSUInteger)page
                        perPage:(NSUInteger)perPage
                completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listCollectionsWithPath:@"/collections" page:page perPage:perPage completeHandler:handler];
}

+ (void)listFeaturedCollectionsWithPage:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                        completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listCollectionsWithPath:@"/collections/featured" page:page perPage:perPage completeHandler:handler];
}

+ (void)listCuratedCollectionsWithPage:(NSUInteger)page
                               perPage:(NSUInteger)perPage
                       completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager listCollectionsWithPath:@"/collections/curated" page:page perPage:perPage completeHandler:handler];
}

+ (void)getCollectionWithCollectionId:(NSUInteger)collectionId
                      completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat: @"/collections/%lu", (unsigned long)collectionId] parameters:@{@"id" : @(collectionId)} methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashCollection)
    }];
}

+ (void)getCuratedCollectionWithCollectionId:(NSUInteger)collectionId
                             completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat: @"/collections/curated/%lu", (unsigned long)collectionId] parameters:@{@"id" : @(collectionId)} methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashCollection)
    }];
}

+ (void)getPhotosWithPath:(NSString *)path
             collectionId:(NSUInteger)collectionId
                     page:(NSUInteger)page
                  perPage:(NSUInteger)perPage
          completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(collectionId) forKey:@"id"];
    page == 0     ?: [params setObject:@(page) forKey:@"page"];
    perPage == 0  ?: [params setObject:@(perPage) forKey:@"per_page"];
    [UnsplashApiManager manageWithPath:path parameters:params methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashPhoto)
    }];
}

+ (void)getPhotosFromCollectionWithCollectionId:(NSUInteger)collectionId
                                           page:(NSUInteger)page
                                        perPage:(NSUInteger)perPage
                                completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager getPhotosWithPath:[NSString stringWithFormat:@"/collections/%lu/photos", (unsigned long)collectionId] collectionId:collectionId page:page perPage:perPage completeHandler:handler];
}

+ (void)getPhotosFromCuratedCollectionWithCollectionId:(NSUInteger)collectionId
                                           page:(NSUInteger)page
                                        perPage:(NSUInteger)perPage
                                completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager getPhotosWithPath:[NSString stringWithFormat:@"/collections/curated/%lu/photos", (unsigned long)collectionId] collectionId:collectionId page:page perPage:perPage completeHandler:handler];
}

+ (void)listRelatedCollectionsWithCollectionId:(NSUInteger)collectionId
                               completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/collections/%lu/related", (unsigned long)collectionId] parameters:@{@"id" : @(collectionId)} methodType:Get completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_ARRAY_RESULT(UnsplashCollection)
    }];
}

+ (void)createNewCollectionWithTitle:(NSString *)title
                         description:(NSString *)description
                             private:(BOOL)private
                     completeHandler:(RequestCompleteHandler)handler {
    if (!hasAuthorized(@"write_collections", handler)) { return; }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !title ?: [params setObject:title forKey:@"title"];
    !description ?: [params setObject:description forKey:@"description"];
    [params setObject:@(private) forKey:@"private"];
    [UnsplashApiManager manageWithPath:@"/collections" parameters:params methodType:Post completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashCollection)
    }];
}

+ (void)updateCollectionInfoWithCollectionId:(NSUInteger)collectionId
                                       title:(NSString *)title
                                 description:(NSString *)description
                                     private:(BOOL)private
                             completeHandler:(RequestCompleteHandler)handler {
    if (!hasAuthorized(@"write_collections", handler)) { return; }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    !title ?: [params setObject:title forKey:@"title"];
    !description ?: [params setObject:description forKey:@"description"];
    [params setObject:@(private) forKey:@"private"];
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/collections/%lu", (unsigned long)collectionId] parameters:params methodType:Put completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashCollection)
    }];
}

+ (void)deleteCollectionWithCollectionId:(NSUInteger)collectionId
                         completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:[NSString stringWithFormat:@"/collections/%lu", (unsigned long)collectionId] parameters:@{@"id" : @(collectionId)} methodType:Delete completeHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            handler(@(NO), error);
        } else {
            handler(@(YES), nil);
        }
    }];
}

+ (void)processPhotoInCollectionWithCollectionId:(NSUInteger)collectionId
                                         photoId:(NSString *)photoId
                                          option:(BOOL)option
                                 completeHandler:(RequestCompleteHandler)handler {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(collectionId) forKey:@"collection_id"];
    !photoId ?: [params setObject:photoId forKey:@"photo_id"];
    NSString *path = option ? [NSString stringWithFormat:@"/collections/%lu/add", (unsigned long)collectionId] : [NSString stringWithFormat:@"/collections/%lu/remove", (unsigned long)collectionId];
    UnsplashNetworkMethod method = option ? Post : Delete;
    [UnsplashApiManager manageWithPath:path parameters:params methodType:method completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        @try {
            if (data) {
                id photoJson = [(NSDictionary *)data objectForKey:@"photo"];
                id collectionJson = [(NSDictionary *)data objectForKey:@"collection"];
                NSMutableDictionary *result = [NSMutableDictionary dictionary];
                [result setObject:[UnsplashPhoto yy_modelWithJSON:photoJson] forKey:@"photo"];
                [result setObject:[UnsplashCollection yy_modelWithJSON:collectionJson] forKey:@"collection"];
                handler(result, nil);
            } else {
                handler(nil, error);
            }
        } @catch (NSException *exception) {
            DBLog(@"%@\n%@", exception.description, exception.callStackSymbols);
        }
    }];
}

+ (void)addPhotoToCollectionWithCollectionId:(NSUInteger)collectionId
                                         photoId:(NSString *)photoId
                                 completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager processPhotoInCollectionWithCollectionId:collectionId photoId:photoId option:YES completeHandler:handler];
}

+ (void)removePhotoFromCollectionWithCollectionId:(NSUInteger)collectionId
                                         photoId:(NSString *)photoId
                                 completeHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager processPhotoInCollectionWithCollectionId:collectionId photoId:photoId option:NO completeHandler:handler];
}

// MARK: - STATS
+ (void)unsplashStatsWithCompleteHandler:(RequestCompleteHandler)handler {
    [UnsplashApiManager manageWithPath:@"/stats/total" parameters:nil methodType:Get completeHandler:^(id  _Nullable data, NSError * _Nullable error) {
        HANDLE_SERVER_DICTIONARY_RESULT(UnsplashStats)
    }];
}

@end
