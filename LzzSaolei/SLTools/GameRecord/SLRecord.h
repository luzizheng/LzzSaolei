//
//  SLRecord.h
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/16.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRecord : NSObject

@property(nonatomic,assign)SLHardLevel hardLevel;

@property(nonatomic,copy)NSString * userName;


@property(nonatomic,assign)NSTimeInterval gameTime;

+(instancetype)recordWithDict:(NSDictionary *)dict;


-(NSDictionary *)generateDictionary;




-(void)setUpWithDict:(NSDictionary *)dict;

/// 获取列表
+(NSArray <SLRecord *>*)recordListWithHardLevel:(SLHardLevel)hardLevel;


// 保存
-(void)save;


@end

NS_ASSUME_NONNULL_END
