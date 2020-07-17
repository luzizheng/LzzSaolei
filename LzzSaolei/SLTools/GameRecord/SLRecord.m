//
//  SLRecord.m
//  LzzSaolei
//
//  Created by Chemm_Luzz on 2020/7/16.
//  Copyright © 2020 Chemm. All rights reserved.
//

#import "SLRecord.h"

@implementation SLRecord



+(instancetype)recordWithDict:(NSDictionary *)dict
{
    SLRecord * record = [SLRecord new];
    [record setUpWithDict:dict];
    return record;
}

-(NSDictionary *)generateDictionary
{
    NSMutableDictionary * temp = [NSMutableDictionary dictionary];
    [temp setObject:@(self.hardLevel) forKey:@"hardLevel"];
    [temp setObject:@(self.gameTime) forKey:@"gameTime"];
    if (self.userName) {
        [temp setObject:self.userName forKey:@"userName"];
    }else{
        [temp setObject:kDetaultName forKey:@"userName"];
    }
    return temp;
}

-(void)setUpWithDict:(NSDictionary *)dict
{
    self.hardLevel = [[dict objectForKey:@"hardLevel"] integerValue];
    self.gameTime = [[dict objectForKey:@"gameTime"] doubleValue];
    self.userName = [dict objectForKey:@"userName"];
}



+(NSString *)keyWithHardLevel:(SLHardLevel)hardLevel
{
    NSString * key;
    switch (hardLevel) {
        case SLHardLevelEasy:
            key = @"RecordKey_SLHardLevelEasy";
            break;
            
        case SLHardLevelMediem:
            key = @"RecordKey_SLHardLevelMediem";
            break;
        case SLHardLevelHard:
            key = @"RecordKey_SLHardLevelHard";
            break;
            
        default:
            key = @"RecordKey";
            break;
    }
    return key;
}


/// 获取列表
+(NSArray <SLRecord *>*)recordListWithHardLevel:(SLHardLevel)hardLevel
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[self keyWithHardLevel:hardLevel]];
    if (obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray * array = obj;
            NSArray * sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                SLRecord * record1 = [SLRecord recordWithDict:obj1];
                SLRecord * record2 = [SLRecord recordWithDict:obj2];
                if (record1.gameTime < record2.gameTime) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            NSArray * recordArray = [sortArray qmui_mapWithBlock:^id _Nonnull(id  _Nonnull item) {
                return [SLRecord recordWithDict:item];
            }];
            return recordArray;
        }
    }
    return [NSArray array];
}


// 保存
-(void)save
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[SLRecord keyWithHardLevel:self.hardLevel]];
    NSMutableArray * temp = [NSMutableArray array];
    if (obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [temp addObjectsFromArray:obj];
        }
    }
    [temp addObject:[self generateDictionary]];
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:[SLRecord keyWithHardLevel:self.hardLevel]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
@end
