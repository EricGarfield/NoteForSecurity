

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FolderNoteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFolder;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *ivPrivate;

- (void)setName:(NSString *)name;

@end
