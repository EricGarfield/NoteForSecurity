

#import "NotesListViewController.h"
#import "EditNoteViewController.h"
#import "NoteHelper.h"
#import "NoteCell.h"
#import "Note.h"

@implementation NotesListViewController {
    NoteHelper *_noteHelper;
    NSMutableArray *noteList;

    UITableView *_tableView;
}

- (id)init:(int)folderId andName:(NSString *)folderName {
    if ([super init]) {

    }

    self.folderId = folderId;
    self.folderName = folderName;
    
    
    
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
    

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:self.folderName];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationRightBtnClick)];

    [self initTableView];

    _noteHelper = [[NoteHelper alloc] init];
    [self selectAllNotesByFolderId];
    
    
    
    
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
    
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAllNotesByFolderId)
                                                 name:NOTIFICATION_UPDATE_NOTE object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 初始化tableview
 */
- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90;
    
    
    
    
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
    
    

    [self.view addSubview:_tableView];
}

- (void)selectAllNotesByFolderId {
    [noteList removeAllObjects];
    noteList = [_noteHelper selectAllNotes:_folderId];
    [_tableView reloadData];
}

/**
 * 跳转到添加笔记页面
 */
- (void)navigationRightBtnClick {
    EditNoteViewController *editNoteViewController = [[EditNoteViewController alloc] init];
    editNoteViewController.folderId = _folderId;
    [self.navigationController pushViewController:editNoteViewController animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return noteList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"NoteCell";
    //自定义cell类
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil] lastObject];
    }

    Note *note = [noteList objectAtIndex:indexPath.row];

    //添加测试数据
    cell.labelTitle.text = note.title;
    cell.labelContent.text = note.content;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = [noteList objectAtIndex:indexPath.row];
        if ([_noteHelper delNoteById:note.id]) {
            [Tools showTip:self andMsg:@"Delete Successed"];

            [noteList removeObjectAtIndex:indexPath.row];

            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];

            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
        }
        else {
            [Tools showTip:self andMsg:@"Delete failure"];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [noteList objectAtIndex:indexPath.row];
    EditNoteViewController *editNoteViewController = [[EditNoteViewController alloc] init];
    editNoteViewController.note = note;
    [self.navigationController pushViewController:editNoteViewController animated:true];
}

@end
