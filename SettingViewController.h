

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end
