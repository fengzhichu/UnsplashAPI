//
//  UnsplashApiManager.h
//  Picaso
//
//  Created by Hummer on 16/8/1.
//  Copyright © 2016年 Amazation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnsplashHttpClient.h"
#import "UnsplashModels.h"

typedef NS_ENUM(NSUInteger, UnsplashPhotosOrderBy) {
    UnsplashPhotosOrderByLatest = 0,
    UnsplashPhotosOrderByPopular,
    UnsplashPhotosOrderByOldest,
};

typedef NS_ENUM(NSUInteger, UnsplashPhotoOrientation) {
    UnsplashPhotoOrientationSquarish = 0,
    UnsplashPhotoOrientationPortrait,
    UnsplashPhotoOrientationLandscape,
};

@interface UnsplashApiManager : NSObject

///  MARK: - USER

///  Get current user's profile
///  Note: To access a user’s private data, the user is required
///  to authorize the read_user scope. Without it, this request
///  will return a 403 Forbidden response.
///  Note: Without a Bearer token (i.e. using a Client-ID token)
///  this request will return a 401 Unauthorized response.
///  @param handler Complete handler.
+ (void)getUserProfileWithCompleteHandler:(RequestCompleteHandler _Nullable)handler;

///  Update current user's profile
///  Note: This action requires the write_user scope. Without it,
///  it will return a 403 Forbidden response. All parameters are optional.
///
///  @param userName  Username.
///  @param firstName First name.
///  @param lastName  Last name.
///  @param email     Email.
///  @param url       Portfolio/personal URL.
///  @param location  Location.
///  @param bio       About/bio.
///  @param insName   Instagram username.
///  @param handler   Complete handler.
+ (void)updateUserProfileWithUserName:(NSString * _Nullable)userName
                            firstName:(NSString * _Nullable)firstName
                             lastName:(NSString * _Nullable)lastName
                                email:(NSString * _Nullable)email
                          personalUrl:(NSString * _Nullable)url
                             location:(NSString * _Nullable)location
                                  bio:(NSString * _Nullable)bio
                    instagramUserName:(NSString * _Nullable)insName
                      completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve public details on a given user.
///
///  @param userName The user’s username. Required.
///  @param w        Profile image width in pixels.
///  @param h        Profile image height in pixels.
///  @param handler  Complete handler.
+ (void)getUserPublicProfileWithUserName:(NSString * _Nonnull)userName
                 customProfileImageWidth:(NSUInteger)w
                               andHeight:(NSUInteger)h
                         completehandler:(RequestCompleteHandler _Nullable)handler;

///  Get a list of photos uploaded by a user.
///
///  @param userName The user’s username. Required.
///  @param page     Page number to retrieve. (Optional; default: 1)
///  @param perPage  Number of items per page. (Optional; default: 10)
///  @param order    How to sort the photos. Optional.
///                  (Valid values: latest, oldest, popular; default: latest)
///  @param handler  Complete handler.
+ (void)listUserUploadedPhotosWithUserName:(NSString * _Nullable)userName
                                      page:(NSUInteger)page
                                   perPage:(NSUInteger)perPage
                                   orderBy:(UnsplashPhotosOrderBy)order
                           completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Get a list of photos liked by a user.
///
///  @param userName The user’s username. Required.
///  @param page     Page number to retrieve. (Optional; default: 1)
///  @param perPage  Number of items per page. (Optional; default: 10)
///  @param order    How to sort the photos. Optional.
///                  (Valid values: latest, oldest, popular; default: latest)
///  @param handler  Complete handler.
+ (void)listUserLikedPhotosWithUserName:(NSString * _Nullable)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                                orderBy:(UnsplashPhotosOrderBy)order
                        completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Get a list of collections created by the user.
///
///  @param userName The user’s username. Required.
///  @param page     Page number to retrieve. (Optional; default: 1)
///  @param perPage  Number of items per page. (Optional; default: 10)
///  @param handler  Complete handler.
+ (void)listUserCollectionsWithUserName:(NSString * _Nullable)userName
                                   page:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                        completeHandler:(RequestCompleteHandler _Nullable)handler;

///  MARK: - PHOTO

///  Get a single page from the list of all photos
///
///  @param page    Page number to retrieve. (Optional; default: 1)
///  @param perPage Number of items per page. (Optional; default: 10)
///  @param order   How to sort the photos. Optional. (Valid values: latest,
///                 oldest, popular; default: latest)
///  @param handler Complete handler.
+ (void)listPhotosWithPage:(NSUInteger)page
                   perPage:(NSUInteger)perPage
                   orderBy:(UnsplashPhotosOrderBy)order
           completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Get a single page from the list of the curated photos (front-page’s photos).
///
///  @param page    Page number to retrieve. (Optional; default: 1)
///  @param perPage Number of items per page. (Optional; default: 10)
///  @param order   How to sort the photos. Optional. (Valid values: latest,
///                 oldest, popular; default: latest)
///  @param handler Complete handler.
+ (void)listCuratedPhotosWithPage:(NSUInteger)page
                          perPage:(NSUInteger)perPage
                          orderBy:(UnsplashPhotosOrderBy)order
                  completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Get a single page from a photo search. Optionally limit your
///  search to a set of categories by supplying the category ID’s.
///
///  @param query       Search terms.
///  @param categoryId  Category ID(‘s) to filter search. If multiple, comma-separated.
///  @param orientation Filter search results by photo orientation.
///                     Valid values are landscape, portrait, and squarish.
///  @param page        Page number to retrieve. (Optional; default: 1)
///  @param perPage     Number of items per page. (Optional; default: 10)
///  @param handler     Complete handler.
+ (void)searchPhotosWithQuery:(NSString * _Nonnull)query
                     category:(NSArray * _Nullable)categoryId
                  orientation:(UnsplashPhotoOrientation)orientation
                         page:(NSUInteger)page
                      perPage:(NSUInteger)perPage
              completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single photo.
///
///  @param photoId The photo’s ID. Required.
///  @param w       Image width in pixels.
///  @param h       Image height in pixels.
///  @param rect    4 comma-separated integers representing x, y,
///                 width, height of the cropped rectangle.
///  @param handler Complete handler.
+ (void)getSinglePhotoWithPhotoId:(NSString * _Nonnull)photoId
                            width:(NSUInteger)w
                           height:(NSUInteger)h
                             rect:(CGRect)rect
                  completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single random photo, given optional filters. All parameters are optional,
///  and can be combined to narrow the pool of photos from which a random one will be chosen.
///
///  @param categoryIds   Category ID(‘s) to filter selection.
///                       If multiple, comma-separated.
///  @param collectionIds Public collection ID(‘s) to filter selection.
///                       If multiple, comma-separated
///  @param feature       Limit selection to featured photos.
///  @param userName      Limit selection to a single user.
///  @param query         Limit selection to photos matching a search term.
///  @param w             Image width in pixels.
///  @param h             Image height in pixels.
///  @param orientation   Filter search results by photo orientation.
///                       Valid values are landscape, portrait, and squarish.
///  @param handler       Complete handler.
+ (void)getRandomPhotoWithCategory:(NSArray * _Nullable)categoryIds
                       collections:(NSArray * _Nullable)collectionIds
                          featured:(BOOL)featured
                          userName:(NSString * _Nullable)userName
                             query:(NSString * _Nullable)query
                             width:(NSUInteger)w
                            height:(NSUInteger)h
                       orientation:(UnsplashPhotoOrientation)orientation
                   completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single photo’s stats.
///
///  @param photoId The photo’s ID. Required.
///  @param handler Complete handler.
+ (void)getPhotoStatsWithPhotoId:(NSString * _Nonnull)photoId
                 completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Update a photo on behalf of the logged-in user. This requires the write_photos scope.
///
///  @param photoId  The photo’s ID. Required.
///  @param exif     Camera’s brand (Optional)
///                  Camera’s model (Optional)
///                  Camera’s exposure time (Optional)
///                  Camera’s aperture value (Optional)
///                  Camera’s focal length (Optional)
///                  Camera’s iso (Optional)
///  @param location The photo location’s latitude (Optional)
///                  The photo location’s longitude (Optional)
///                  The photo location’s name (Optional)
///                  The photo location’s city (Optional)
///                  The photo location’s country (Optional)
///                  The photo location’s confidentiality (Optional)
///  @param handler  Complete handler.
+ (void)updatePhotoInfoWithPhotoId:(NSString * _Nonnull)photoId
                         photoExif:(UnsplashPhotoExif * _Nonnull)exif
                     photoLocation:(UnsplashPhotoLocation * _Nonnull)location
                   completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Like a photo on behalf of the logged-in user or not. This requires the write_likes scope.
///
///  @param photoId The photo’s ID. Required.
///  @param option  YES: like, NO: unlike.
///  @param handler Complete handler.
+ (void)likePhotoOrNotWithPhotoId:(NSString * _Nonnull)photoId
                           option:(BOOL)option
                  completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Like a photo on behalf of the logged-in user. This requires the write_likes scope.
///
///  @param photoId The photo’s ID. Required.
///  @param handler Complete handler.
+ (void)likePhotoWithPhotoId:(NSString * _Nonnull)photoId
             completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Remove a user’s like of a photo.
///
///  @param photoId The photo’s ID. Required.
///  @param handler Complete handler.
+ (void)unlikePhotoWithPhotoId:(NSString * _Nonnull)photoId
               completeHandler:(RequestCompleteHandler _Nullable)handler;

///  MARK: - CATEGORY

///  Get a list of all photo categories.
///
///  @param handler Complete handler.
+ (void)listCategoriesWithCompleteHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single category.
///
///  @param categoryId The category’s ID. Required.
///  @param handler    Complete handler.
+ (void)getCategoryWithCategoryId:(NSUInteger)categoryId
                  completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single category’s photos.
///
///  @param categoryId The category’s ID. Required.
///  @param page       Page number to retrieve. (Optional; default: 1)
///  @param perPage    Number of items per page. (Optional; default: 10)
///  @param handler    Complete handler.
+ (void)getPhotosFromCategoryWithCategoryId:(NSUInteger)categoryId
                                       page:(NSUInteger)page
                                    perPage:(NSUInteger)perPage
                            completeHandler:(RequestCompleteHandler _Nullable)handler;

///  MARK: - COLLECTION

///  Get a single page from the list of all collections.
///
///  @param page    Page number to retrieve. (Optional; default: 1)
///  @param perPage Number of items per page. (Optional; default: 10)
///  @param handler Complete handler.
+ (void)listCollectionsWithPage:(NSUInteger)page
                        perPage:(NSUInteger)perPage
                completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Get a single page from the list of featured collections.
///
///  @param page    Page number to retrieve. (Optional; default: 1)
///  @param perPage Number of items per page. (Optional; default: 10)
///  @param handler Complete handler.
+ (void)listFeaturedCollectionsWithPage:(NSUInteger)page
                                perPage:(NSUInteger)perPage
                        completeHandler:(RequestCompleteHandler _Nullable)handle;

///  Get a single page from the list of curated collections.
///
///  @param page    Page number to retrieve. (Optional; default: 1)
///  @param perPage Number of items per page. (Optional; default: 10)
///  @param handler Complete handler.
+ (void)listCuratedCollectionsWithPage:(NSUInteger)page
                               perPage:(NSUInteger)perPage
                       completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a single collection. To view a user’s private collections,
///  the read_collections scope is required.
///
///  @param collectionId The collections’s ID. Required.
///  @param handle       Complete handler.
+ (void)getCollectionWithCollectionId:(NSUInteger)collectionId
                      completeHandler:(RequestCompleteHandler _Nullable)handle;

///  Retrieve a single curated collection. To view a user’s private collections,
///  the read_collections scope is required.
///
///  @param collectionId The collections’s ID. Required.
///  @param handle       Complete handler.
+ (void)getCuratedCollectionWithCollectionId:(NSUInteger)collectionId
                             completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a collection’s photos.
///
///  @param collectionId The collection’s ID. Required.
///  @param page         Page number to retrieve. (Optional; default: 1)
///  @param perPage      Number of items per page. (Optional; default: 10)
///  @param handler      Complete handler.
+ (void)getPhotosFromCollectionWithCollectionId:(NSUInteger)collectionId
                                           page:(NSUInteger)page
                                        perPage:(NSUInteger)perPage
                                completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a curated collection’s photos.
///
///  @param collectionId The collection’s ID. Required.
///  @param page         Page number to retrieve. (Optional; default: 1)
///  @param perPage      Number of items per page. (Optional; default: 10)
///  @param handler      Complete handler.
+ (void)getPhotosFromCuratedCollectionWithCollectionId:(NSUInteger)collectionId
                                                  page:(NSUInteger)page
                                               perPage:(NSUInteger)perPage
                                       completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Retrieve a list of collections related to this one.
///
///  @param collectionId The collection’s ID. Required.
///  @param handler      Complete handler.
+ (void)listRelatedCollectionsWithCollectionId:(NSUInteger)collectionId
                               completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Create a new collection. This requires the write_collections scope.
///
///  @param title       The title of the collection. (Required.)
///  @param description The collection’s description. (Optional.)
///  @param private     Whether to make this collection private. (Optional; default false).
///  @param handler     Complete handler.
+ (void)createNewCollectionWithTitle:(NSString * _Nonnull)title
                         description:(NSString * _Nullable)description
                             private:(BOOL)private
                     completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Update an existing collection belonging to the logged-in user.
///  This requires the write_collections scope.
///
///  @param collectionId The collection’s ID. Required.
///  @param title        The title of the collection. (Optional.)
///  @param description  The collection’s description. (Optional.)
///  @param private      Whether to make this collection private. (Optional.)
///  @param handler      Complete handler.
+ (void)updateCollectionInfoWithCollectionId:(NSUInteger)collectionId
                                       title:(NSString * _Nullable)title
                                 description:(NSString * _Nullable)description
                                     private:(BOOL)private
                             completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Delete a collection belonging to the logged-in user.
///  This requires the write_collections scope.
///
///  @param collectionId The collection’s ID. Required.
///  @param handler      Complete handler.
+ (void)deleteCollectionWithCollectionId:(NSUInteger)collectionId
                         completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Add a photo to one of the logged-in user’s collections.
///  Requires the write_collections scope.
///
///  @param collectionId The collection’s ID. Required.
///  @param photoId      The photo’s ID. Required.
///  @param handler      Complete handler.
+ (void)processPhotoInCollectionWithCollectionId:(NSUInteger)collectionId
                                         photoId:(NSString * _Nonnull)photoId
                                          option:(BOOL)option
                                 completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Add a photo to one of the logged-in user’s collections.
///  Requires the write_collections scope.
///
///  @param collectionId The collection’s ID. Required.
///  @param photoId      The photo’s ID. Required.
///  @param handler      Complete handler.
+ (void)addPhotoToCollectionWithCollectionId:(NSUInteger)collectionId
                                     photoId:(NSString * _Nonnull)photoId
                             completeHandler:(RequestCompleteHandler _Nullable)handler;

///  Remove a photo from one of the logged-in user’s collections.
///  Requires the write_collections scope.
///
///  @param collectionId The collection’s ID. Required.
///  @param photoId      The photo’s ID. Required.
///  @param handle       Complete handler.
+ (void)removePhotoFromCollectionWithCollectionId:(NSUInteger)collectionId
                                          photoId:(NSString * _Nonnull)photoId
                                  completeHandler:(RequestCompleteHandler _Nullable)handle;

///  MARK: - STATS

///  Get a list of counts for all of Unsplash.
///
///  @param handler Complete handler.
+ (void)unsplashStatsWithCompleteHandler:(RequestCompleteHandler _Nullable)handler;

@end
