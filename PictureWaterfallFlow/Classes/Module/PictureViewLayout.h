//
//  PictureViewLayout.h
//  PictureWaterfallFlow
//
//  Created by Admin on 15/11/3.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureViewLayoutDelegate <NSObject>
@required
#pragma mark - 自定义
//列数量
- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView;
#pragma mark - UICollectionViewDelegateFlowLayout
//section边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//最小子对象间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//子对象尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PictureViewLayout : UICollectionViewLayout

@property (assign, nonatomic) id<PictureViewLayoutDelegate> layoutDelegate;

@end
