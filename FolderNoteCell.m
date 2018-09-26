

#import "FolderNoteCell.h"


@implementation FolderNoteCell

- (void)awakeFromNib {

}

- (void)setName:(NSString *)name {
    self.labelName.text = name;
    [self setNeedsLayout];
}

@end
