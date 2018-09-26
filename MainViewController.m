

#import "MainViewController.h"
#import "FolderNoteCell.h"
#import "NoteFolderHelper.h"
#import "NoteFolder.h"
#import "FDAlertView.h"
#import "AddFolderView.h"
#import "NotesListViewController.h"
#import "SettingViewController.h"


@implementation MainViewController {

    // 私密开关
    BOOL pSwitch;
    // 保存的密码
    NSString *savePwd;

    NoteFolderHelper *_folderHelper;
    NSMutableArray *folderList;

    // 0 normal 1 edit 2 delete
    int mode;

    UIBarButtonItem *editBarItem;

    UIBarButtonItem *delBarItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Folder"];

    editBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:nil target:self action:@selector(editMode)];
    delBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:nil target:self action:@selector(deleteMode)];
    
    [editBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [delBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    

    self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:editBarItem, delBarItem, nil];


    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [btn2 setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [super setNavigationRightBtn:[[UIBarButtonItem alloc] initWithCustomView:btn2]];

    [self initCollection];

    [self initData];

    [self addObserver:NOTIFICATION_UPDATE_FOLDER selector:@selector(selectAllFolders)];
    [self addObserver:NOTIFICATION_UPDATE_SETTING selector:@selector(updateSettingConfig)];
    
    
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
}

- (void)dealloc {
    [self removeObserver];
}

/**
 * 初始化collectionview
 */
- (void)initCollection {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    flowLayout.minimumInteritemSpacing = 1;//内部cell之间距离
    flowLayout.minimumLineSpacing = 5;//行间距

    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 3) / 4, 110);


    self.collectionView = [[UICollectionView alloc]                   initWithFrame:
            CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    UINib *nib = [UINib nibWithNibName:@"FolderNoteCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];

    [self.view addSubview:self.collectionView];
    
    
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
}

/**
 * 初始化数据
 */
- (void)initData {
    [self updateSettingConfig];

    folderList = [[NSMutableArray alloc] init];
    _folderHelper = [[NoteFolderHelper alloc] init];
    [self selectAllFolders];
    
    
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
}

/**
 * 更新设置配置值
 */
- (void)updateSettingConfig {
    pSwitch = [UserDefaultsUtils getAppInfoForKeyBool:@"p_switch"];
    savePwd = [UserDefaultsUtils getAppInfoForKey:@"pwd"];
}

/**
 * 查询所有分类目录
 */
- (void)selectAllFolders {

    [folderList removeAllObjects];

    [folderList addObjectsFromArray:[_folderHelper selectAllFolders]];
    NoteFolder *defaultFolder = [[NoteFolder alloc] init];
    defaultFolder.id = 0;
    defaultFolder.name = @"Add";
    [folderList addObject:defaultFolder];

    [self.collectionView reloadData];
}

/**
 * 添加和更新目录
 */
- (void)addOrUpdateFolder:(int)id name:(NSString *)name andPrivate:(BOOL)isPrivate {

    // 正常模式
    if (mode == 0) {
        if ([_folderHelper addFolder:name andPrivate:isPrivate]) {
            [Tools showTip:self andMsg:@"Add successed"];

            [self selectAllFolders];

            [self.collectionView reloadData];
        }
        else {
            [Tools showTip:self andMsg:@"Add failure"];
        }
    }
        // 编辑模式
    else if (mode == 1) {
        if ([_folderHelper updateFolder:id name:name andPrivate:isPrivate]) {
            [Tools showTip:self andMsg:@"Edit successed"];

            [self selectAllFolders];

            [self.collectionView reloadData];
        }
        else {
            [Tools showTip:self andMsg:@"Edit failure"];
            
            
        }
    }

}

- (void)navigationRightBtnClick {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:true];
}

- (void)editMode {
    if (mode == 0) {
        mode = 1;
        editBarItem.title = @"Finish";
        delBarItem.enabled = NO;
        
        
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
    }
    else {
        mode = 0;
        editBarItem.title = @"Edit";
        delBarItem.enabled = YES;
    }
    [self.collectionView reloadData];
}

- (void)deleteMode {
    if (mode == 0) {
        mode = 2;
        delBarItem.title = @"Finish";
        editBarItem.enabled = NO;
    }
    else {
        mode = 0;
        delBarItem.title = @"Delete";
        editBarItem.enabled = YES;
    }
    [self.collectionView reloadData];
    
    
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
}

/**
 * section
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 * 返回单元格数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return folderList.count;
}

/**
 * 返回一个 单元格布局
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FolderNoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NoteFolder *folder = [folderList objectAtIndex:indexPath.row];
    if (folder.id != 0) {
        cell.imgFolder.image = [UIImage imageNamed:[NSString stringWithFormat:@"folder%d.png", (arc4random() % 11) + 1]];

        // 正常模式下
        if (mode == 0) {
            if (folder.isPrivate) {
                cell.ivPrivate.image = [UIImage imageNamed:@"private.png"];
                cell.ivPrivate.hidden = NO;
            }
            else {
                cell.ivPrivate.hidden = YES;
            }
        }
            // 编辑模式
        else if (mode == 1) {
            cell.ivPrivate.hidden = NO;
            cell.ivPrivate.image = [UIImage imageNamed:@"edit.png"];
        }
            // 删除模式
        else if (mode == 2) {
            cell.ivPrivate.hidden = NO;
            cell.ivPrivate.image = [UIImage imageNamed:@"delete.png"];
        }
    }
    else {
        cell.imgFolder.image = [UIImage imageNamed:@"add.png"];
        cell.ivPrivate.hidden = YES;
    }
    [cell setName:folder.name];
    return cell;
}

/**
 * 单击单元格
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NoteFolder *folder = [folderList objectAtIndex:indexPath.row];

    // 正常模式
    if (mode == 0) {
        // 添加
        if (folder.id == 0) {
            [self showAddOrUpdateDialog:nil];
        }
        else {
            // 私密开关开启 并且 设置过密码
            if (pSwitch && ![StringUtils isEmpty:savePwd] && folder.isPrivate) {
                [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
                    if ([pwd isEqualToString:savePwd]) {
                        [self jumpNoteList:folder];
                    }
                    else {
                        [Tools showTip:self andMsg:@"密码不正确"];
                    }
                }];
            }
            else {
                [self jumpNoteList:folder];
            }
        }
    }
        // 编辑模式
    else if (mode == 1) {
        if (folder.id == 0) {
            return;
        }
        // 私密开关开启 并且 设置过密码
        if (pSwitch && ![StringUtils isEmpty:savePwd]) {
            [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
                if ([pwd isEqualToString:savePwd]) {
                    [self showAddOrUpdateDialog:folder];
                }
                else {
                    [Tools showTip:self andMsg:@"密码不正确"];
                }
            }];
        }
        else {
            [self showAddOrUpdateDialog:folder];
        }
    }
        // 删除模式
    else if (mode == 2) {
        if (folder.id == 0) {
            return;
        }
        [super openAlertDialog:@"Are you sure to delete?" onClick:^(void) {
            // 私密开关开启 并且 设置过密码
            if (pSwitch && ![StringUtils isEmpty:savePwd]) {
                [self openPwdInputDialog:nil andOnClicked:nil andCompletion:^(NSString *pwd) {
                    if ([pwd isEqualToString:savePwd]) {
                        [self deleteFolder:folder];
                    }
                    else {
                        [Tools showTip:self andMsg:@"Incorrect password"];
                    }
                }];
            }
            else {
                [self deleteFolder:folder];
            }
        }];
    }
}

/**
 * 跳转到note 列表
 */
- (void)jumpNoteList:(NoteFolder *)folder {
    NotesListViewController *notesListViewController = [[NotesListViewController alloc]
            init:folder.id andName:folder.name];
    [self.navigationController pushViewController:notesListViewController animated:true];
}

/**
 * 弹出添加目录对话框
 */
- (void)showAddOrUpdateDialog:(NoteFolder *)folder {
    FDAlertView *alert = [[FDAlertView alloc] init];
    AddFolderView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AddFolderView" owner:nil options:nil].lastObject;
    [contentView init:self andFrame:CGRectMake(0, 0, 270, 215) folder:folder];
    alert.contentView = contentView;
    [alert show];
}

/**
 * 删除目录
 */
- (void)deleteFolder:(NoteFolder *)folder {
    @try {
        [_folderHelper deleteFolder:folder.id];
        [Tools showTip:self andMsg:@"Delete successed"];
        [folderList removeObject:folder];
        [self.collectionView reloadData];
    }
    @catch (NSException *exception) {
        [Tools showTip:self andMsg:@"Delete failure"];
        NSLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
    }
}

@end

