//
//  HomeViewController.m
//  Q_TimerAxis
//
//  Created by jqlv on 2018/4/11.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTitleTableViewCell.h"
#import "Q_UIConfig.h"
#import "Q_coreDataHelper.h"
#import "Q_Event+CoreDataClass.h"
#import "Q_Plan+CoreDataClass.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "UIView+Layout.h"
#import "TopicSettingViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) NSArray *HomeList;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UITapGestureRecognizer *headPortraitReg;

@end

@implementation HomeViewController

-(UITapGestureRecognizer *)headPortraitReg{
    if (!_headPortraitReg) {
        _headPortraitReg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetHeadPortrait)];
    }
    return _headPortraitReg;
}
-(void)resetHeadPortrait{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"选择方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *CermaAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    UIAlertAction *photoLiarayAction = [UIAlertAction actionWithTitle:@"从相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [sheet addAction:CermaAction];
    [sheet addAction:photoLiarayAction];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:^{}];
}



-(void)loadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFetchRequest *fetchRequest1 = [Q_Event fetchRequest];
        fetchRequest1.resultType = NSCountResultType;
        NSError *error1 = nil;
        NSArray *eventList = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:fetchRequest1 error:&error1];
        NSInteger count1 = [eventList.firstObject integerValue];
        if (!error1) {}
        
        NSFetchRequest *fetchRequest2 = [Q_Plan fetchRequest];
        fetchRequest2.resultType = NSCountResultType;
        NSError *error2 = nil;
        NSArray *planList = [[Q_coreDataHelper shareInstance].managedContext executeFetchRequest:fetchRequest2 error:&error2];
        NSInteger count2 = [planList.firstObject integerValue];
        if (!error2) {}
        dispatch_async(dispatch_get_main_queue(), ^{
            HomeTitleTableViewCell *cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.subLeftLabel.text = [NSString stringWithFormat:@"任务：%ld",count1];
            cell.subRightLabel.text = [NSString stringWithFormat:@"计划：%ld",count2];
        });
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.delegate = self;
    self.contentView.bounces = NO;
    self.contentView.dataSource = self;
    self.contentView.estimatedRowHeight = 50.f;
    self.contentView.rowHeight = UITableViewAutomaticDimension;
    self.contentView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
    self.HomeList = @[@"",@"主题设置",@"数据同步",@"数据统计",@"关于APP"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HomeList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HomeTitleTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        _cell.titleLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.titleLabel.font = [Q_UIConfig shareInstance].generalHeadLineFont;
        _cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        _cell.titleLabel.returnKeyType = UIReturnKeyDone;
        _cell.titleLabel.delegate = self;
        _cell.seprateLine.backgroundColor = [Q_UIConfig shareInstance].generalBackgroundColor;
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _cell.subLeftLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.subRightLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.subLeftLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        _cell.subRightLabel.font = [Q_UIConfig shareInstance].generalBodyFont;
        _cell.headPortrait.userInteractionEnabled=YES;
        [_cell.headPortrait addGestureRecognizer:self.headPortraitReg];
        
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImg"];
        if(imageData != nil){
            _cell.headPortrait.image = [NSKeyedUnarchiver unarchiveObjectWithData: imageData];
        }
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if (userName) {
            _cell.titleLabel.text = userName;
        }
        
        [self loadData];
        return _cell;
    }else{
        UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        _cell.textLabel.textColor = [Q_UIConfig shareInstance].generalCellBodyFontColor;
        _cell.textLabel.text = self.HomeList[indexPath.row];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TopicSettingViewController *topicSettingViewController =  [storyBoard instantiateViewControllerWithIdentifier:@"TopicSettingViewController"];
        [self showViewController:topicSettingViewController sender:nil];
    }else if(indexPath.row == 2){
        //[self pushTZImagePickerController];
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = [Q_UIConfig shareInstance].mainColor;
        }
        _imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        /*else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }*/
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        __weak typeof(self) weakSelf = self;
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                         // 允许裁剪,去裁剪
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            [weakSelf refreshHeaderimage:cropImage];
                        }];
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }];
                }];
            }
        }];
    }
}

- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    return YES;
}

- (void)refreshHeaderimage:(UIImage *)image {
    HomeTitleTableViewCell *_cell = [self.contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _cell.headPortrait.image = image;
    NSData *imageData;
    imageData = [NSKeyedArchiver archivedDataWithRootObject:image];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userHeadImg"];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"userName"];
    return YES;
}
@end
