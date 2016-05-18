//
//  LocalPhotoViewController.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalPhotoViewController.h"

@interface LocalPhotoViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation LocalPhotoViewController{
    UIBarButtonItem *btnDone;
    NSMutableArray *selectPhotoNames;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackButton];
    if(self.selectPhotos==nil)
    {
        self.selectPhotos=[[NSMutableArray alloc] init];
        selectPhotoNames=[[NSMutableArray alloc] init];
    }else{
        selectPhotoNames=[[NSMutableArray alloc] init];
        for (ALAsset *asset in self.selectPhotos ) {
            //NSLog(@"%@",[asset valueForProperty:ALAssetPropertyAssetURL]);
            [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        }
        self.lbAlert.text=[NSString stringWithFormat:@"已经选择%d张照片",self.selectPhotos.count];
    }
    
    self.collection.dataSource=self;
    self.collection.delegate=self;
    [self.collection registerNib:[UINib nibWithNibName:@"LocalPhotoCell" bundle:nil]  forCellWithReuseIdentifier:@"photocell"];
    //self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    btnDone=[[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(albumAction)];
    self.navigationItem.rightBarButtonItem = btnDone;
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos;
    
  
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        
        if ([group numberOfAssets] > 0)
        {
            [self showPhoto:group];
        }
        else
        {
//            NSLog(@"读取相册完毕");
            //[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [[AssetHelper defaultAssetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock                                    failureBlock:nil];
}

#pragma mark- UIImagePickerViewController
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __weak typeof(self) weakSelf = self;
//    
//    NSString  *assetsName = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
//    
//    [[PhotoAlbumManager sharedManager] saveImage:image
//                                         toAlbum:assetsName
//                                 completionBlock:^(ALAsset *asset, NSError *error) {
//                                     if (error == nil && asset) {
//                                         NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
//                                         [self addAssetsObject:assetURL];
//                                         [weakSelf finishPhotoDidSelected];
//                                     }
//                                 }];
//    
//    [picker dismissViewControllerAnimated:NO completion:^{}];
//    
//    
//}


-(void)albumAction{
    LocalAlbumTableViewController *album=[[LocalAlbumTableViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:album];
    album.delegate=self;
    [self.navigationController presentViewController:nvc animated:YES completion:^(void){
//        NSLog(@"开始");
    }];
    // [self.navigationController pushViewController:album animated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //加一张拍照的图片
    return self.photos.count+1;
}

#define kImageViewTag 1 // the image view inside the collection view cell prototype is tagged with "1"
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"photocell";
    LocalPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // load the asset for this cell
    if (indexPath.item == 0) {
        [cell.img setImage:[UIImage imageNamed:@"daily_photograph"]];
    }else{
        ALAsset *asset=self.photos[indexPath.item - 1];
        CGImageRef thumbnailImageRef = [asset thumbnail];
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
        [cell.img setImage:thumbnail];
        NSString *url=[asset valueForProperty:ALAssetPropertyAssetURL];
        [cell.btnSelect setHidden:[selectPhotoNames indexOfObject:url]==NSNotFound];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == 0) {
        //调取摄像头
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:^{
        }];

    }else{
        LocalPhotoCell *cell=(LocalPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(cell.btnSelect.hidden)
        {
            if (self.selectPhotos.count == 9) {
                [Dialog simpleToast:@"最多只能选9张图片"];
            }else{
                [cell.btnSelect setHidden:NO];
                ALAsset *asset=self.photos[indexPath.row-1];
                [self.selectPhotos addObject:asset];
                [selectPhotoNames addObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
            }
            
        }else{
            [cell.btnSelect setHidden:YES];
            ALAsset *asset=self.photos[indexPath.row-1];
            for (ALAsset *a in self.selectPhotos) {
                //            NSLog(@"%@-----%@",[asset valueForProperty:ALAssetPropertyAssetURL],[a valueForProperty:ALAssetPropertyAssetURL]);
                NSString *str1=[asset valueForProperty:ALAssetPropertyAssetURL];
                NSString *str2=[a valueForProperty:ALAssetPropertyAssetURL];
                if([str1 isEqual:str2])
                {
                    [self.selectPhotos removeObject:a];
                    break;
                }
            }
            
            [selectPhotoNames removeObject:[asset valueForProperty:ALAssetPropertyAssetURL]];
        }
        
        if(self.selectPhotos.count==0)
        {
            self.lbAlert.text=@"请选择照片";
        }
        else{
            self.lbAlert.text=[NSString stringWithFormat:@"已经选择%d张照片",self.selectPhotos.count];
        }
 
    }
}
#pragma mark- UIImagePickerViewController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    
    //没有医路行相册 就创建一个  有就不创建
    NSString  *assetsName = @"医路行";
//    NSString  *assetsName = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
    
    [[PhotoAlbumManager sharedManager] saveImage:image
                                         toAlbum:assetsName
                                 completionBlock:^(ALAsset *asset, NSError *error) {
                                     if (error == nil && asset) {
//                                         NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
//                                         [self addAssetsObject:assetURL];
                                         if (self.selectPhotos.count == 9) {
                                             [Dialog simpleToast:@"最多只能选9张图片"];
                                         }else{
                                             [self.selectPhotos addObject:asset];
                                         }
                                         [weakSelf btnConfirm:nil];
                                     }
                                 }];

    [picker dismissViewControllerAnimated:NO completion:^{}];
    
    
}

- (IBAction)btnConfirm:(id)sender {
    if (self.selectPhotoDelegate!=nil) {
        [self.selectPhotoDelegate getSelectedPhoto:self.selectPhotos];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showPhoto:(ALAssetsGroup *)album
{
    if(album!=nil)
    {
        if(self.currentAlbum==nil||![[self.currentAlbum valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[album valueForProperty:ALAssetsGroupPropertyName]])
        {
            self.currentAlbum=album;
            if (!self.photos) {
                _photos = [[NSMutableArray alloc] init];
            } else {
                [self.photos removeAllObjects];
                
            }
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [self.photos addObject:result];
                }else{
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [self.currentAlbum setAssetsFilter:onlyPhotosFilter];
            [self.currentAlbum enumerateAssetsUsingBlock:assetsEnumerationBlock];
            self.title = [self.currentAlbum valueForProperty:ALAssetsGroupPropertyName];
            [self.collection reloadData];
        }
    }
}
-(void)selectAlbum:(ALAssetsGroup *)album{
    [self showPhoto:album];
}

@end
