//
//  RACAutoDisposeHelper.m
//  Watcha
//
//  Created by Ryu Heechul on 2014. 7. 15..
//  Copyright (c) 2014년 frograms. All rights reserved.
//

#import "RACAutoDisposer.h"

#import <objc/runtime.h>

@interface NSObject (RACAutoDisposer)
- (NSString *)ownerKey;
@end

@implementation NSObject (RACAutoDisposer)

- (NSString *)ownerKey
{
    NSString *ownerKey = [NSString stringWithFormat:@"%@#%@", [self class], [NSValue valueWithPointer:(__bridge const void *)(self)]];

    return ownerKey;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);

        const SEL originalSelector  = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(radh_dealloc);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)radh_dealloc
{
    [self removeDisposals];
    [self radh_dealloc];
}

- (void)removeDisposals
{
    if(![[self class] conformsToProtocol:@protocol(RACAutoDisposerProtocol)]) { // 해당 프로토콜을 가지고 있을 때만 수행
        return;
    }

    [[RACAutoDisposer sharedHelper] removeOwner:(id<RACAutoDisposerProtocol>)self];
}

@end


@implementation RACAutoDisposer

+ (RACAutoDisposer *)sharedHelper
{
    static RACAutoDisposer *_sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [RACAutoDisposer new];
    });
    return _sharedHelper;
}

- (void)pushDisposable:(RACDisposable *)disposable owner:(id)owner name:(NSString *)name
{
    if (!disposable) {
        return;
    }
    NSMutableDictionary *ownerDictionary = [self ownerDictionaryWithOwner:owner];
    ownerDictionary[name] = disposable;
}

- (RACDisposable *)disposableWithOwner:(id)owner name:(NSString *)name
{
    //    NSMutableDictionary *ownerDictionary = [self ownerDictionaryWithOwner:owner];
    NSString *ownerKey = [owner ownerKey];
    NSMutableDictionary *ownerDictionary = self.disposableDictionary[ownerKey];

    if (!ownerDictionary) {
        return nil;
    }
    return ownerDictionary[name];
}

- (void)removeOwner:(id)owner
{
    NSString *ownerKey = [owner ownerKey];

    if (!ownerKey) {
        return;
    }

    [self.disposableDictionary removeObjectForKey:ownerKey];
}

- (NSMutableDictionary *)ownerDictionaryWithOwner:(id)owner
{
    NSString *ownerKey = [owner ownerKey];
    NSMutableDictionary *ownerDictionary = self.disposableDictionary[ownerKey];

    if (!ownerDictionary) {
        ownerDictionary = [NSMutableDictionary dictionary];
        self.disposableDictionary[ownerKey] = ownerDictionary;
    }

    return ownerDictionary;
}

- (NSMutableDictionary *)disposableDictionary
{
    if (!_disposableDictionary) {
        _disposableDictionary = [NSMutableDictionary dictionary];
    }
    return _disposableDictionary;
}


@end
