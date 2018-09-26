

#import <UIKit/UIKit.h>

// 定义一个 右上角按钮点击回调
typedef void (^AlertDialogOnOk)(void);

@interface AlertDialogView : UIView

@property(weak, nonatomic) IBOutlet UILabel *labelMsg;

- (void)initWitchMsg:(CGRect)frame msg:(NSString *)msg onClick:(AlertDialogOnOk) onOkFs;

@end
