//
//  RACAutoDisposer.h
//  Watcha
//
//  Created by Ryu Heechul on 2014. 7. 15..
//  Copyright (c) 2014년 frograms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#define RACAutoDispose(DISPOSAL_NAME, DISPOSAL) \
try {} @finally {} \
{ \
RACDisposable *OLD_DISPOSAL = [[RACAutoDisposer sharedHelper] disposableWithOwner:self name:DISPOSAL_NAME]; \
[OLD_DISPOSAL dispose]; \
[[RACAutoDisposer sharedHelper] pushDisposable:(DISPOSAL) owner:self name:DISPOSAL_NAME]; \
}

@protocol RACAutoDisposerProtocol <NSObject>
@end

@interface RACAutoDisposer : NSObject
@property (nonatomic, strong) NSMutableDictionary *disposableDictionary;

+ (RACAutoDisposer *)sharedHelper;
- (void)pushDisposable:(RACDisposable *)disposable owner:(id<RACAutoDisposerProtocol>)owner name:(NSString *)name;
- (RACDisposable *)disposableWithOwner:(id<RACAutoDisposerProtocol>)owner name:(NSString *)name;
- (void)removeOwner:(id<RACAutoDisposerProtocol>)owner;
@end
