
#import <UIKit/UIKit.h>

#import "ZCSlotMachine.h"
#import "ZPopView.h"
@interface DemoViewController : UIViewController <ZCSlotMachineDelegate, ZCSlotMachineDataSource>
/**window*/
@property (nonatomic,strong)UIWindow *keyWindow;
/**规则，奖品弹窗*/
@property (nonatomic,strong)ZPopView *popView;
@end
