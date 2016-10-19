//
//  ZPopView.m
//  LaBaTargetMachine
//
//  Created by 腾程－ios1 on 16/10/19.
//  Copyright © 2016年 腾程－zsw. All rights reserved.
//

#import "ZPopView.h"
// 颜色宏
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define iPhone5WideSize(SIZE) SIZE*(ScreenW/320)
#define iPhone5HeightSize(SIZE) SIZE*(ScreenH/568)

@implementation ZPopView
{
    UIImageView *_bgImgView;
    UITextView *_txtView;
    UIView *_bgView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return self;
}

- (void)createUI{
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:bgView];
    _bgView = bgView;
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPhone5WideSize(250), iPhone5HeightSize(380))];
    bgImgView.center = CGPointMake(self.center.x, self.center.y + iPhone5HeightSize(15));
    bgImgView.layer.cornerRadius = 10;
    bgImgView.layer.masksToBounds = YES;
    bgImgView.userInteractionEnabled = YES;
    [bgView addSubview:bgImgView];
    _bgImgView = bgImgView;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(bgImgView.frame) - iPhone5WideSize(17), bgImgView.frame.origin.y - iPhone5HeightSize(12), iPhone5HeightSize(29), iPhone5HeightSize(29));
    [cancelBtn setImage:[UIImage imageNamed:@"lottery_btn_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, iPhone5HeightSize(59), bgImgView.frame.size.width * 0.8, bgImgView.frame.size.height - iPhone5HeightSize(80))];
    txtView.center = CGPointMake(bgImgView.frame.size.width/2, txtView.center.y);
    txtView.editable = NO;
    txtView.textColor = kUIColorFromRGB(0x462017);
    txtView.backgroundColor = [UIColor clearColor];
    txtView.showsVerticalScrollIndicator = NO;
    txtView.font = [UIFont systemFontOfSize:15];
    [bgImgView addSubview:txtView];
    _txtView = txtView;
}

#pragma mark -events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
}

- (void)cancelBtnAction{
    self.hidden = YES;
}

#pragma mark -lazy
- (void)setType:(PopViewType)type{
    if (type == RuleType) {
        _bgImgView.image = [UIImage imageNamed:@"lottery_rule"];
        
        _txtView.text = @"1.活动时间:2016年10月1日-2016年10月7日\n2.每个用户花费100积分摇奖1次。次数不限。\n3.活动获得的奖励系统会自动发放至您的账户中，可在【明细】页面中查看\n4.若发现用户在活动过程中使用不正当的手段参与，活动主办方有权取消其活动资格和奖品。活动最终解释权归易银所有。";
    }else{
        _bgImgView.image = [UIImage imageNamed:@"lottery_reward"];
        _txtView.text = @"2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n2016.10.01 您获得了1等奖 \n2016.10.01 您获得了2等奖 \n";
    }
    _txtView.editable = NO;
    [ self shakeToShow:_bgView];
}

- (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
