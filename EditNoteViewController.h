

#import "BaseViewController.h"

@class Note;

@interface EditNoteViewController : BaseViewController

@property int folderId;

@property(nonatomic, strong) Note *note;

@property(weak, nonatomic) IBOutlet UITextView *edtContent;

@property(weak, nonatomic) IBOutlet UITextField *edtTitle;

@end
