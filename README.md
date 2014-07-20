# RACAutoDisposer

### Have a trouble because your RAC Subscriptions are being called even though you want them to be gone after reuse your views like UITableViewCell?

## Solve the problem with adding few lines of code.

Just say you want the last subscription to be gone when this code called again.

```objective-c
@RACAutoDispose(@"[key-to-be-unique-in-a-scope]", {
  [RACObserve(self, object)
     subscribeNext:^(id x) {
         // ...
     }];
})
```

### !Need to implemnt RACAutoDisposerProtocol to the scope object include @RACAutoDispose code

```objective-c
@interface ScopeObjectIncludesRACAutoDisposeCode () <RACAutoDisposerProtocol>
```

Other wise you will have warnings and unreleased RACDisposals which is a memory issue.

### What do you mean scope?

if your @RACAutoDispose codes are in same object, then it is in same scope.
so keys need to be unique in a same scope to distinguish each disposals.


## How it works?

- RACAutoDisposer holds last RAC Disposals(subscriptions) by key and scope when @RACAutoDispose called.
- RACAutoDisposer dispose the last Disposal with same key when same code called again. and hold new ones again.
- RACAutoDisposer release disposals when the scope object is deallocated.

### Sample Project

open Example/RACAutoDisposer.xcworkspace and run and see the results in console.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

ARC, ReactiveCocoa.

## Installation

RACAutoDisposer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RACAutoDisposer"

## Author

Ryu Heechul, ryuhcii@gmail.com

## License

RACAutoDisposer is available under the MIT license. See the LICENSE file for more info.
