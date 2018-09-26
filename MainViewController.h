

#import "BaseViewController.h"

@interface MainViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;

/**
 * 初始化数据
 */
- (void)initData;

/**
 * 添加分类目录
 */
- (void)addOrUpdateFolder:(int)id name:(NSString *)name andPrivate:(BOOL)isPrivate;

@end

