

#import "AlertDialogView.h"
#import "FDAlertView.h"

@implementation AlertDialogView {
    AlertDialogOnOk _onOk;
}

- (void)initWitchMsg:(CGRect)frame msg:(NSString *)msg onClick:(AlertDialogOnOk)onOk {
    self.frame = frame;
    _onOk = onOk;
    self.labelMsg.text = msg;
}


- (IBAction)onCancel:(id)sender {
    [self close];
}

- (IBAction)onOk:(id)sender {
    if (_onOk) {
        _onOk();
    }
    [self close];
}

- (void)close {
    FDAlertView *alert = (FDAlertView *) self.superview;
    [alert hide];
}

@end
