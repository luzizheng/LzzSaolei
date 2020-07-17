//
//  SLMarcro.h
//  LzzSaolei
//
//  Created by SL_Luzz on 2020/7/15.
//  Copyright © 2020 SL. All rights reserved.
//

#ifndef SLMarcro_h
#define SLMarcro_h


#endif /* SLMarcro_h */

/// 地雷密布系数，越大越少（相当于几分之一）
#define kBoomNumberPercent 5


/// 游戏难度
typedef NS_ENUM(NSInteger,SLHardLevel) {
    SLHardLevelEasy = 0,
    SLHardLevelMediem = 1,
    SLHardLevelHard = 2
};


static NSString * const kNotificationName_touchBoom = @"kNotificationName_touchBoom";
static NSString * const kNotificationName_regenerateMap = @"kNotificationName_regenerateMap";
static NSString * const kNotificationName_timeSecond = @"kNotificationName_timeSecond";

static NSString * const kDetaultName = @"优秀的你";



// 字体
#define FontSizeAdapt(_size_) ((IS_IPAD)?(_size_*2):(_size_))

#define SLFont_PingFangSC_Medium(_size_) [UIFont fontWithName:@"PingFangSC-Medium" size: FontSizeAdapt(_size_)]
#define SLFont_PingFangSC_Semibold(_size_) [UIFont fontWithName:@"PingFangSC-Semibold" size: FontSizeAdapt(_size_)]
#define SLFont_PingFangSC_Light(_size_) [UIFont fontWithName:@"PingFangSC-Light" size: FontSizeAdapt(_size_)]
#define SLFont_PingFangSC_Ultralight(_size_) [UIFont fontWithName:@"PingFangSC-Ultralight" size: FontSizeAdapt(_size_)]
#define SLFont_PingFangSC_Regular(_size_) [UIFont fontWithName:@"PingFangSC-Regular" size: FontSizeAdapt(_size_)]
#define SLFont_PingFangSC_Thin(_size_) [UIFont fontWithName:@"PingFangSC-Thin" size: FontSizeAdapt(_size_)]

#define SLFont(_size_) [UIFont fontWithName:@"Chalkduster" size:(_size_)]

//----------------------单例----------------------------
// .h文件
#define SLSingletonH(name) + (instancetype)sharedInstance;

// .m文件
#if __has_feature(objc_arc)

#define SLSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
}

#else

#define SLSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
} \
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif
//----------------------单例----------------------------

