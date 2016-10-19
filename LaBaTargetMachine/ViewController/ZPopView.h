//
//  ZPopView.h
//  LaBaTargetMachine
//
//  Created by 腾程－ios1 on 16/10/19.
//  Copyright © 2016年 腾程－zsw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PopViewType) {
    RuleType,
    RewardType
};
@interface ZPopView : UIView
@property (nonatomic,assign)PopViewType type;
@end
