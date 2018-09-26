

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "NoteFolderHelper.h"

@implementation SettingViewController {
    UITableView *_tableView;

    // 开关按钮
    UISwitch *switchBtn;
    // 是否开启私密保护
    BOOL switchValue;
    // 是否设置密码
    BOOL hasPwd;

    // 已经保存过的密码
    NSString *savedPwd;

    // 保存第一次输入的密码
    NSString *_tempPwd;
    // 统计输入次数
    int inputCount;

    // 标识是否验证通过
    BOOL checkPass;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Setting";

    [self initTableView];

    switchValue = [UserDefaultsUtils getAppInfoForKeyBool:@"p_switch"];
    savedPwd = [UserDefaultsUtils getAppInfoForKey:@"pwd"];
    if (![StringUtils isEmpty:savedPwd]) {
        hasPwd = YES;
    }
}

/**
 * 初始化tableview
 */
- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return switchValue ? 2 : 1;
    }
    else if (section == 1) {
        return 1;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = @"Open protection";
            switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];

            [switchBtn setOn:switchValue];

            cell.accessoryView = switchBtn;
            [switchBtn addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Setting secret";
            if (hasPwd) {
                cell.detailTextLabel.text = @"Have been set";
            }
            else {
                cell.detailTextLabel.text = @"Have not set";
            }
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Clear data";
        }
    }
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Current version";
            cell.detailTextLabel.text = [Tools getAppVersion];
        }
        else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"About";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (hasPwd && !checkPass) {
                [self checkOldPwd];
            }
            else {
                [self showSetPwdDialog];
            }
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self clearData];
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController *aboutViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:aboutViewController animated:true];
    }
}

/**
 * 判断是否设置私密开关 清空数据
 */
- (void)clearData {
    
    
    UIButton * rightBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(68, 5, 60, 30)];
    [rightBtn1 setTitle:@"YY" forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1] forState:UIControlStateNormal];
    rightBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn1.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    
    
    UIImageView * logoV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lobout.png"]];
    logoV.center = CGPointMake(99, 0.21);
    logoV.bounds = CGRectMake(0, 0, 120, 120);
    logoV.layer.cornerRadius = 25;
    logoV.layer.masksToBounds = YES;
    
    
    
    UILabel * name = [[UILabel alloc]init];
    name.center = CGPointMake(5, 66);
    name.bounds = CGRectMake(0, 0, 130, 120);
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont boldSystemFontOfSize:20];
    
    
    
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    sw.on = YES;
    sw.layer.cornerRadius = 10;
    sw.layer.masksToBounds = YES;
    
    UIView *gV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    gV.backgroundColor = [UIColor greenColor];
    gV.layer.cornerRadius = 10;
    gV.layer.masksToBounds = YES;
    
    
    
    
    UIImageView *countryImgView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 32, 32)];
    
    
    UILabel *currentName = [[UILabel alloc]initWithFrame:CGRectMake(45, 9, 50, 16)];
    currentName.font = [UIFont fontWithName:@"Arial" size:13.0f];
    
    
    
    UILabel *countryName = [[UILabel alloc]initWithFrame:CGRectMake(45, 30, 130, 16)];
    countryName.font = [UIFont fontWithName:@"Arial" size:13.0f];
    
    
    UILabel *countryName1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 30, 130, 16)];
    countryName.font = [UIFont fontWithName:@"Arial" size:13.0f];
    
    
    // 私密开关开启 并且 设置过密码
    if (switchValue && hasPwd) {
        [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
            if ([pwd isEqualToString:savedPwd]) {
                [self doClearData];
            }
            else {
                [Tools showTip:self andMsg:@"密码不正确"];
            }
        }];
    }
    else {
        [self doClearData];
    }
}

/**
 * 执行清空数据
 */
- (void)doClearData {
    [super openAlertDialog:@"Are you sure clear all data?" onClick:^(void) {
        @try {
            [[[NoteFolderHelper alloc] init] deleteAll];
            [Tools showTip:self andMsg:@"Clear data success"];
            // 成功 发送更新列表通知
            [self postNotification:NOTIFICATION_UPDATE_FOLDER obj:nil];
        }
        @catch (NSException *exception) {
            [Tools showTip:self andMsg:@"Clear data failure"];
            NSLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
        }
    }];
}

- (void)checkOldPwd {
    [self openPwdInputDialog:@"Input old password" andOnClicked:nil andCompletion:^(NSString *pwd) {
        if (![pwd isEqualToString:savedPwd]) {
            [Tools showTip:self andMsg:@"Input wrong old password"];
        }
        else {
            [self showSetPwdDialog];
        }
    }];
}

/**
 * 弹出设置密码对话框
 */
- (void)showSetPwdDialog {

    [self openPwdInputDialog:nil andOnClicked:^(void) {
        inputCount = 0;
        _tempPwd = @"";
    }          andCompletion:^(NSString *pwd) {
        inputCount++;
        if (inputCount == 1) {
            _tempPwd = pwd;
            [Tools showTip:self andMsg:@"Input password again"];
        }
        else {
            DebugLog(@"%@ %@", _tempPwd, pwd);

            if (![pwd isEqualToString:_tempPwd]) {
                inputCount = 0;
                _tempPwd = @"";
                [Tools showTip:self andMsg:@"Password not match"];
            }
            else {
                inputCount = 0;
                _tempPwd = @"";
                hasPwd = YES;
                [_tableView reloadData];
                [Tools showTip:self andMsg:@"Set password success"];
                [UserDefaultsUtils saveAppInfoForObject:@"pwd" andValue:pwd];
                [self postNotification:NOTIFICATION_UPDATE_SETTING obj:nil];
            }
        }
        DebugLog(@"andCompletion");
    }];
}

- (IBAction)onSwitchValueChanged:(id)sender {
    UISwitch *switchBtn = (UISwitch *) sender;

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < 2; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }

    [_tableView beginUpdates];
    if (switchBtn.isOn) {
        [UserDefaultsUtils saveAppInfoForBool:@"p_switch" andValue:YES];
        switchValue = YES;
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        [UserDefaultsUtils saveAppInfoForBool:@"p_switch" andValue:NO];
        switchValue = NO;
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }

    [self postNotification:NOTIFICATION_UPDATE_SETTING obj:nil];

    [_tableView endUpdates];
}

@end
