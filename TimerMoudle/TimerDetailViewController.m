//
//  TimerDetailViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/3/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TimerDetailViewController.h"
#import "Q_coreDataHelper.h"
#import "Q_UIConfig.h"

@interface TimerDetailViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UIButton *unOrderSignBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderSignBtn;

@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
@property (weak, nonatomic) IBOutlet UISlider *processSlider;

@property (nonatomic, strong)  NSMutableArray<NSValue *> *orderSignIndex;
@property (nonatomic, strong)  NSMutableArray<NSValue *> *unOrderSignIndex;

@end

@implementation TimerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"affirmIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.contentView.delegate = self;
    [self.inputView removeFromSuperview];
    self.contentView.inputAccessoryView = self.inputView;
    self.contentView.font = [Q_UIConfig shareInstance].generalFont;
    self.contentView.typingAttributes = [Q_UIConfig shareInstance].generalEditAttributes;
    self.navigationItem.title = @"编辑时间轴";
    
    self.processLabel.textColor = [Q_UIConfig shareInstance].generalCellTitleFontColor;
    self.processLabel.font = [Q_UIConfig shareInstance].generalTitleFont;
    self.processLabel.text = @"0%";

    self.processSlider.maximumTrackTintColor = [Q_UIConfig shareInstance].generalButtonNormalColor;
    self.processSlider.minimumTrackTintColor = [Q_UIConfig shareInstance].generalButtonSelectedColor;
    [self.processSlider addTarget:self action:@selector(eventProcessChange:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
    [self.unOrderSignBtn addTarget:self action:@selector(insertUnOrderSign) forControlEvents:UIControlEventTouchDown];
   [self.orderSignBtn addTarget:self action:@selector(insertOrderSign) forControlEvents:UIControlEventTouchDown];
    
    self.orderSignIndex = [NSMutableArray array];
    self.unOrderSignIndex = [NSMutableArray array];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contentView becomeFirstResponder];
}

- (void)eventProcessChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.processLabel.text = [NSString stringWithFormat:@"%.0f%%", slider.value * 100];
}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)complete{
    Q_TimeLine *timeLine = [NSEntityDescription insertNewObjectForEntityForName:@"Q_TimeLine" inManagedObjectContext:[Q_coreDataHelper shareInstance].managedContext];
    timeLine.event = self.event;
    timeLine.content = self.contentView.text;
    timeLine.createDate = [NSDate date];
    [[Q_coreDataHelper shareInstance] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self adjustSignInTextFroRange:range];
    if (text.length == 0) [self clearSignByRange:range];
    return YES;
}

-(void)insertOrderSign{
    NSString *OrderSign = @"\n";
    NSRange signRange = self.contentView.selectedRange;
    
    __block NSInteger currentIndex = self.orderSignIndex.count;
    [self.orderSignIndex enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        if (range.location > signRange.location) {
            currentIndex = idx;
            *stop = YES;
        }
    }];
    OrderSign = [NSString stringWithFormat:@"%@%ld.",OrderSign,currentIndex + 1];
    signRange.length = OrderSign.length;
    
    [self.contentView.textStorage insertAttributedString:[[NSAttributedString alloc] initWithString:OrderSign attributes:[Q_UIConfig shareInstance].generalEditAttributes] atIndex:signRange.location];
    
    [self.orderSignIndex insertObject:[NSValue valueWithRange:NSMakeRange(signRange.location, signRange.length)] atIndex:currentIndex];
    
    [self adjustSignInTextFroRange:NSMakeRange(signRange.location, signRange.length)];
    
    self.contentView.selectedRange = NSMakeRange(signRange.location + signRange.length, 0);
    
}
-(void)insertUnOrderSign{
    NSString *OrderSign = @"\n*";
    NSRange signRange = self.contentView.selectedRange;
    [self.contentView.textStorage insertAttributedString:[[NSAttributedString alloc] initWithString:OrderSign attributes:[Q_UIConfig shareInstance].generalEditAttributes] atIndex:signRange.location];

    [self.unOrderSignIndex addObject:[NSValue valueWithRange:NSMakeRange(signRange.location, signRange.length)]];
    [self adjustSignInTextFroRange:NSMakeRange(signRange.location, signRange.length)];
    
    self.contentView.selectedRange = NSMakeRange(signRange.location + signRange.length, 0);
}

-(void)adjustSignInTextFroRange:(NSRange)range{
    [self adjustSignIndexForRange:range ToIndexSets:self.unOrderSignIndex];
    NSInteger changeSignIndex =  [self adjustSignIndexForRange:range ToIndexSets:self.orderSignIndex];
    for (; changeSignIndex < self.orderSignIndex.count; changeSignIndex++) {
        NSRange range = self.orderSignIndex[changeSignIndex].rangeValue;
        [self.contentView.textStorage replaceCharactersInRange:range withString:[NSString stringWithFormat:@"\n%ld.",changeSignIndex+1]];
    }
}

-(NSInteger)adjustSignIndexForRange:(NSRange)range ToIndexSets:(NSMutableArray<NSValue *> *)signIndexs{
    for (NSInteger i = signIndexs.count - 1; i >= 0; i--) {
        NSInteger currentIndex = [signIndexs[i] rangeValue].location;
        NSInteger length = [signIndexs[i] rangeValue].length;
        if (range.location < currentIndex) {
            signIndexs[i] = [NSValue valueWithRange:NSMakeRange(currentIndex + range.length, length)];
        }else{
            return i;
            break;
        }
    }
    return 0;
}
-(void)updateOrderSign{
    [self.orderSignIndex enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

-(void)clearSignByRange:(NSRange)range{
    NSMutableIndexSet *needDeleteOrderIndexs = [[NSMutableIndexSet alloc] init];
    [self.orderSignIndex enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (NSIntersectionRange(range, obj.rangeValue).length) [needDeleteOrderIndexs addIndex:idx];
    }];
    [self.orderSignIndex removeObjectsAtIndexes:needDeleteOrderIndexs];
    
    NSMutableIndexSet *needDeleteIndexs = [[NSMutableIndexSet alloc] init];
    [self.unOrderSignIndex enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (NSIntersectionRange(range, obj.rangeValue).length) [needDeleteIndexs addIndex:idx];
    }];
    [self.orderSignIndex removeObjectsAtIndexes:needDeleteIndexs];
    
}
@end
