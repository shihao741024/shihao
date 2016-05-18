//
//  LocalPhotoViewController.h
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LocalPhotoCell.h"
#import "LocalAlbumTableViewController.h"
#import "AssetHelper.h"
#import "PhotoAlbumManager.h"
@class ViewController;
@protocol SelectPhotoDelegate<NSObject>
-(void)getSelectedPhoto:(NSMutableArray *)photos;
@end
@interface LocalPhotoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SelectAlbumDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UILabel *lbAlert;
- (IBAction)btnConfirm:(id)sender;
@property (nonatomic,retain) id<SelectPhotoDelegate> selectPhotoDelegate;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) ALAssetsGroup *currentAlbum;
@property (nonatomic, strong) NSMutableArray *selectPhotos;
//xinjiande xiangce
@property (nonatomic, strong) ALAssetsGroup *selectAssetsGroup;
@end
