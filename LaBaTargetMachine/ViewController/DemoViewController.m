
#import "DemoViewController.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define iPhoneWideSize(SIZE) SIZE*(ScreenW/375)
#define iPhoneHeightSize(SIZE) SIZE*(ScreenH/667)

@implementation DemoViewController {
 @private
    ZCSlotMachine *_slotMachine;
    UIButton *_startButton;
    
    UIView *_slotContainerView;
    UIImageView *_slotOneImageView;
    UIImageView *_slotTwoImageView;
    UIImageView *_slotThreeImageView;
    UIImageView *_slotFourImageView;
    NSArray *_slotIcons;
    
    AVAudioPlayer *_player;
    BOOL playMusicEnable;
}

#pragma mark - View LifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _slotIcons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"Doraemon"], [UIImage imageNamed:@"Mario"], [UIImage imageNamed:@"Nobi Nobita"],
                      [UIImage imageNamed:@"Batman"],
                      nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _slotIcons = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"Doraemon"], [UIImage imageNamed:@"Mario"], [UIImage imageNamed:@"Nobi Nobita"],
                      [UIImage imageNamed:@"Batman"],
                      nil];
    }
    return self;
}

- (void)dealloc {
    [_startButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self createUI];
    UIImage *bgImg = [UIImage imageNamed:@"lotter_bg"];
    NSLog(@"%f~%f",bgImg.size.width,bgImg.size.height);
    
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrView.contentSize = CGSizeMake(ScreenW,iPhoneHeightSize(bgImg.size.height/2));
    [self.view addSubview:scrView];
    
    _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 80, 193)];
    _slotMachine.center = CGPointMake(self.view.frame.size.width / 2,iPhoneHeightSize(480));
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    [scrView addSubview:_slotMachine];
    
    UIImageView *BGImgView = [[UIImageView alloc]initWithImage:bgImg];
    BGImgView.frame = CGRectMake(0, 0,iPhoneWideSize(bgImg.size.width/2),iPhoneHeightSize(bgImg.size.height/2));
    [scrView addSubview:BGImgView];

    UILabel *integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, iPhoneHeightSize(564.5), ScreenW, iPhoneHeightSize(23))];
    integralLabel.text = @"您有500积分 每次抽奖花费100积分";
    integralLabel.font = [UIFont systemFontOfSize:13];
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.textColor = [UIColor whiteColor];
    [scrView addSubview:integralLabel];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImageN = [UIImage imageNamed:@"lottery_btn_go_up"];
    UIImage *btnImageH = [UIImage imageNamed:@"lottery_btn_go_down"];
    [startButton setImage:btnImageN forState:UIControlStateNormal];
    [startButton setImage:btnImageH forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchDown];
    startButton.frame = CGRectMake(0,CGRectGetMaxY(integralLabel.frame)+iPhoneHeightSize(14),iPhoneWideSize(btnImageN.size.width/2),iPhoneHeightSize(btnImageN.size.height/2));
    startButton.center = CGPointMake(self.view.frame.size.width / 2, startButton.center.y);
    [scrView addSubview:startButton];
    _startButton = startButton;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareBtnImageN = [UIImage imageNamed:@"lotter_btn_share_up"];
    UIImage *shareBtnImageH = [UIImage imageNamed:@"lotter_btn_share_down"];
    [shareBtn setBackgroundImage:shareBtnImageN forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:shareBtnImageH forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.frame = CGRectMake(iPhoneWideSize(46),CGRectGetMidY(_startButton.frame) - iPhoneHeightSize(12),iPhoneWideSize(shareBtnImageN.size.width/2),iPhoneHeightSize(shareBtnImageN.size.height/2));
    [scrView addSubview:shareBtn];
    
    UIButton *musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicBtn addTarget:self action:@selector(musicBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    musicBtn.frame = CGRectMake(CGRectGetMaxX(_startButton.frame)+iPhoneWideSize(35),CGRectGetMidY(_startButton.frame) - iPhoneHeightSize(12),iPhoneWideSize(shareBtnImageN.size.width/2),iPhoneHeightSize(shareBtnImageN.size.height/2));
    [scrView addSubview:musicBtn];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *ruleBtnImage = [UIImage imageNamed:@"lotter_btn_rule"];
    [ruleBtn setBackgroundImage:ruleBtnImage forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    ruleBtn.frame = CGRectMake(iPhoneWideSize(66),CGRectGetMaxY(_startButton.frame) + iPhoneHeightSize(25),iPhoneWideSize(ruleBtnImage.size.width/2),iPhoneHeightSize(ruleBtnImage.size.height/2));
    [scrView addSubview:ruleBtn];
    
    
    UIButton *rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rewardBtnImage = [UIImage imageNamed:@"lotter_btn_reward"];
    [rewardBtn setBackgroundImage:rewardBtnImage forState:UIControlStateNormal];
    [rewardBtn addTarget:self action:@selector(rewardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rewardBtn.frame = CGRectMake(CGRectGetMaxX(ruleBtn.frame)+iPhoneWideSize(42),CGRectGetMaxY(_startButton.frame) + iPhoneHeightSize(25),iPhoneWideSize(rewardBtnImage.size.width/2),iPhoneHeightSize(rewardBtnImage.size.height/2));
    [scrView addSubview:rewardBtn];
    
    [self musicBtnAction:musicBtn];
}

#pragma mark - UIResponder

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//
//    _startButton.highlighted = YES;
//    [_startButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.8];
//    
//    [self startBtnAction];
//}

#pragma mark - events

- (void)startBtnAction{
    //NSUInteger slotIconCount = [_slotIcons count];
    
    NSUInteger slotOneIndex; //= abs(rand() % slotIconCount);
    NSUInteger slotTwoIndex; //= abs(rand() % slotIconCount);
    NSUInteger slotThreeIndex; //= abs(rand() % slotIconCount);
    //NSUInteger slotFourIndex = abs(rand() % slotIconCount);
    NSDictionary *dicParam = @{@"0":@0.3,
                               @"1":@0.1,
                               @"2":@0.2,
                               @"3":@0.1};
    NSLog(@"开始了");
    NSArray *rstNumArr = [self getProbabilityNumRstArrWithDicParam:dicParam];
//    NSLog(@"得到了结果数组了");
//    if (rstNumArr == nil) {
//        NSLog(@"数组是空的,概率有误");
//        return;
//    }
//    NSLog(@"开始用数组结果赋值了");
    
    slotOneIndex = [rstNumArr[0] integerValue];
    slotTwoIndex = [rstNumArr[1] integerValue];;
    slotThreeIndex = [rstNumArr[2] integerValue];;
    
//    NSLog(@"赋值结束了");
//    
//    for (NSNumber *value in rstNumArr) {
//        NSLog(@"数组结果~~%@",value);
//    }
//    
//    
//    _slotOneImageView.image = [_slotIcons objectAtIndex:slotOneIndex];
//    _slotTwoImageView.image = [_slotIcons objectAtIndex:slotTwoIndex];
//    _slotThreeImageView.image = [_slotIcons objectAtIndex:slotThreeIndex];
//    //_slotFourImageView.image = [_slotIcons objectAtIndex:slotFourIndex];
//    
    
    _slotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:slotOneIndex],
                                [NSNumber numberWithInteger:slotTwoIndex],
                                [NSNumber numberWithInteger:slotThreeIndex],
                                //[NSNumber numberWithInteger:slotFourIndex],
                                nil];
    [_slotMachine startSliding];
    [_player play];
}


- (void)shareBtnAction{
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"分享" message:@"分享测试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alterView show];
}

- (void)musicBtnAction:(UIButton *)sender{
    if (!playMusicEnable) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"lottery_music1" withExtension:@"mp3"];
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player = player;
        
        UIImage *musicBtnImage = [UIImage imageNamed:@"lotter_btn_music_up1"];
        [sender setBackgroundImage:musicBtnImage forState:UIControlStateNormal];
        
    }else{
        _player = nil;
        UIImage *musicBtnImage = [UIImage imageNamed:@"lotter_btn_music_down1"];
        [sender setBackgroundImage:musicBtnImage forState:UIControlStateNormal];
    }
    playMusicEnable = !playMusicEnable;
}

- (void)ruleBtnAction{
    self.popView.hidden = NO;
    self.popView.type = RuleType;
}

- (void)rewardBtnAction{
    self.popView.hidden = NO;
    self.popView.type = RewardType;
}


#pragma mark - 中奖概率方法
- (NSArray *)getProbabilityNumRst{
    NSInteger rstNum1 = arc4random() % (_slotIcons.count - 1);
    NSInteger rstNum2 = arc4random() % (_slotIcons.count - 1);
    NSInteger rstNum3 = arc4random() % (_slotIcons.count - 1);
    return @[@(rstNum1),@(rstNum2),@(rstNum3)];
}

- (NSArray *)getProbabilityNumRstArrWithDicParam:(NSDictionary *)dic{
    NSArray *keyArr = dic.allKeys;
    
    __block NSInteger blockSum = 0;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        blockSum += [obj floatValue]*100;
    }];
    if (blockSum > 100) return nil;
    
    NSInteger keyCount = keyArr.count;
    NSMutableArray *randNumArr = [NSMutableArray new];
    for (int i = 0; i < keyCount; i++) {
        NSNumber *key = keyArr[i];
        NSNumber *value = [dic objectForKey:key];
        NSInteger numCountInArr = 100 * [value floatValue];
        for (int j = 0; j < numCountInArr; j ++) {
            [randNumArr addObject:keyArr[i]];
        }
    }
    
    if (randNumArr.count < 100) {
        do {
            [randNumArr addObject:@100];
        } while (randNumArr.count < 100);
    }
    
    NSNumber *rstNum = randNumArr[arc4random()%100] ;
    if ([rstNum  isEqual: @100]) {
        NSLog(@"需要随机，还要在做判断");
        NSInteger rstNum1 = arc4random() % (keyCount - 1);
        NSInteger rstNum2 = arc4random() % (keyCount - 1);
        NSInteger rstNum3 = arc4random() % (keyCount - 1);
        do {
            if ((rstNum1 == rstNum2 && rstNum2 == rstNum3)) {
                NSLog(@"需要随机，但是有相等了");
                rstNum1 = arc4random() % (keyCount - 1);
                rstNum2 = arc4random() % (keyCount - 1);
                rstNum3 = arc4random() % (keyCount - 1);
            }else{
                NSLog(@"需要随机，已经随机了");
                return @[@(rstNum1),@(rstNum2),@(rstNum3)];
            }
        } while (1);
    }else{
        NSLog(@"中奖了");
        return @[rstNum,rstNum,rstNum];
    }
}

#pragma mark - lazy
-(UIWindow *)keyWindow{
    if (!_keyWindow)  _keyWindow = [UIApplication sharedApplication].keyWindow;
    return _keyWindow;
}

-(ZPopView *)popView{
    if (!_popView) {
        _popView = [[ZPopView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [self.keyWindow addSubview:_popView];
    }
    return _popView;
}

#pragma mark - ZCSlotMachineDelegate

- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine {
    _startButton.userInteractionEnabled = NO;
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
    _startButton.userInteractionEnabled = YES;
}

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return _slotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 3;
}

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine {
    return (ScreenW - 80)/3;
}

- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 0;
}

- (void)createUI{
    
    
    _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 291, 193)];
    _slotMachine.center = CGPointMake(self.view.frame.size.width / 2, 120);
    _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _slotMachine.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
    //_slotMachine.backgroundImage = [UIImage imageNamed:@"SlotMachineBackground"];
    //_slotMachine.coverImage = [UIImage imageNamed:@"SlotMachineCover"];
    //_slotMachine.singleUnitDuration = 0.009;
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    
    [self.view addSubview:_slotMachine];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImageN = [UIImage imageNamed:@"StartBtn_N"];
    UIImage *btnImageH = [UIImage imageNamed:@"StartBtn_H"];
    _startButton.frame = CGRectMake(0, 0, btnImageN.size.width, btnImageN.size.height);
    _startButton.center = CGPointMake(self.view.frame.size.width / 2, 270);
    _startButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _startButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_startButton setBackgroundImage:btnImageN forState:UIControlStateNormal];
    [_startButton setBackgroundImage:btnImageH forState:UIControlStateHighlighted];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_startButton];
    
    
    _slotContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
    _slotContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _slotContainerView.center = CGPointMake(self.view.frame.size.width / 2, 350);
    
    [self.view addSubview:_slotContainerView];
    
    _slotOneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    _slotOneImageView.contentMode = UIViewContentModeCenter;
    
    _slotTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 45, 45)];
    _slotTwoImageView.contentMode = UIViewContentModeCenter;
    
    _slotThreeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 0, 45, 45)];
    _slotThreeImageView.contentMode = UIViewContentModeCenter;
    
    _slotFourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(135, 0, 45, 45)];
    _slotFourImageView.contentMode = UIViewContentModeCenter;
    
    [_slotContainerView addSubview:_slotOneImageView];
    [_slotContainerView addSubview:_slotTwoImageView];
    [_slotContainerView addSubview:_slotThreeImageView];
    [_slotContainerView addSubview:_slotFourImageView];
}
@end
