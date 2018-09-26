

#import "AboutViewController.h"


@implementation AboutViewController {
    __weak IBOutlet UITextView *introTv;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距

    NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:15],
            NSParagraphStyleAttributeName : paragraphStyle,
    };
    introTv.attributedText = [[NSAttributedString alloc] initWithString:@"This is an iOS private memory App. Users are free to set up classified folders, classified records management, you can set privacy protection switch to add security for your records." attributes:attributes];
    introTv.textColor = [UIColor lightGrayColor];
    
    
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

@end
