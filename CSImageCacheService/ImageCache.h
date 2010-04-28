//
//  ImageCache.h
//  ImageCacheTest
//
//  Created by Adrian on 1/28/09.
//  Copyright 2009 Adrian Kosmaczewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCacheDomain.h"

//#define MEMORY_CACHE_SIZE 100
//#define CACHE_FOLDER_NAME @"ImageCacheFolder"

// 10 days in seconds
//#define IMAGE_FILE_LIFETIME 864000.0

@interface ImageCache : NSObject  {
	
@private
    NSMutableArray *_keyArray;
    NSMutableDictionary *_memoryCache;
    NSFileManager *_fileManager;
	id<ImageCacheDomain> _domain;
}

@property(nonatomic,retain) NSMutableArray *_keyArray;
@property(nonatomic,retain) NSMutableDictionary *_memoryCache;
@property(nonatomic,retain) NSFileManager *_fileManager;
@property(nonatomic,retain) id<ImageCacheDomain> _domain;

//+ (ImageCache *)sharedImageCache;
-(id)initWithDomain:(id<ImageCacheDomain>)domain;

- (UIImage *)imageForKey:(NSString *)key;
- (BOOL)hasImageWithKey:(NSString *)key;

- (void)addImage:(UIImage *)image withKey:(NSString *)key keepInMemory:(BOOL)keepInMemory;

//- (BOOL)imageExistsInMemory:(NSString *)key;
//- (BOOL)imageExistsInDisk:(NSString *)key;
//- (NSUInteger)countImagesInMemory;
//- (NSUInteger)countImagesInDisk;
//- (void)removeImageWithKey:(NSString *)key;

- (void)removeAllImages;

- (void)removeAllImagesInMemory;

//- (void)removeOldImages;

@end
