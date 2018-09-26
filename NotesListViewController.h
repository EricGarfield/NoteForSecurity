

#import "BaseViewController.h"


@interface NotesListViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

/**
 * 携带参数初始化
 */
- (id)init:(int)folderId andName:(NSString *)folderName;

// 分类目录id
@property int folderId;

// 分类目录名称
@property(nonatomic, strong) NSString *folderName;

@end
