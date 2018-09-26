

#import "EditNoteViewController.h"
#import "NoteHelper.h"
#import "Note.h"

@implementation EditNoteViewController {
    NoteHelper *_noteHelper;
    
    BOOL isEdit;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [super setNavigationRightBtn:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 target:self action:@selector(navigationRightBtnClick)]];

    if (_note != nil) {
        _edtTitle.text = _note.title;
        _edtContent.text = _note.content;
        _edtContent.backgroundColor = [UIColor lightGrayColor];
        [super setTitle:_note.title];

        isEdit = YES;
    }
    else {
        [super setTitle:@"Add notebook"];
        isEdit = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [super viewWillAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self removeObserver];
}



- (void)handleKeyboardDidShow:(NSNotification *)paramNotification {
   
    NSValue *keyboardRectAsObject = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];

    self.edtContent.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
}


- (void)handleKeyboardDidHidden {
    self.edtContent.contentInset = UIEdgeInsetsZero;
}


- (void)navigationRightBtnClick {
    NSString *title = _edtTitle.text;
    NSString *content = _edtContent.text;

    if ([StringUtils isEmpty:title]) {
        [Tools showTip:self andMsg:@"Input title"];
        return;
    }

    if ([StringUtils isEmpty:content]) {
        [Tools showTip:self andMsg:@"Input content"];
        return;
    }

    if (_noteHelper == nil) {
        _noteHelper = [[NoteHelper alloc] init];
    }

    if (isEdit) {
        if ([_noteHelper updateNote:title andContent:content andFolderId:_note.id]) {
            [Tools showTip:self andMsg:@"Save success"];
            [_edtTitle resignFirstResponder];
            [_edtContent resignFirstResponder];

           
            [self postNotification:NOTIFICATION_UPDATE_NOTE obj:nil];
        }
        else {
            [Tools showTip:self andMsg:@"Save failure"];
        }
    }
    else {
        if ([_noteHelper addNote:title andContent:content andFolderId:_folderId]) {
            [Tools showTip:self andMsg:@"Save success"];
            [_edtTitle resignFirstResponder];
            [_edtContent resignFirstResponder];

           
            [self postNotification:NOTIFICATION_UPDATE_NOTE obj:nil];

            _edtTitle.text = @"";
            _edtContent.text = @"";
        }
        else {
            [Tools showTip:self andMsg:@"Save failure"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
