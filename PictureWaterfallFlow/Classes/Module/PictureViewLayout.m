//
//  PictureViewLayout.m
//  PictureWaterfallFlow
//
//  Created by Admin on 15/11/3.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import "PictureViewLayout.h"

@interface PictureViewLayout ()

//cell列数量
@property (nonatomic, assign) NSInteger columnCount;
//cell的Y坐标
@property (nonatomic, strong) NSMutableArray *cellYArray;

@end

@implementation PictureViewLayout

#pragma mark - UICollectionViewLayout 重写方法

//开始布局，预加载
- (void)prepareLayout {
    [super prepareLayout];

    [self initData];
}

//内容大小
- (CGSize)collectionViewContentSize {
    //section数量
    NSInteger sectionCount = [self.collectionView numberOfSections];
    //section边距
    UIEdgeInsets sectionInsets = [self.layoutDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:sectionCount-1];
    
    CGFloat height = [self maxCellYWithArray:_cellYArray];
    height += sectionInsets.bottom;

    NSLog(@"height is %f",height);
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), height);
}

//每个cell的Layout属性列表
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSLog(@"layoutAttributesForElementsInRect");
    [self initCellYArray];
    
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger sectionIndex=0; sectionIndex < sectionCount; sectionIndex++) {
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

//单个cell的layout属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //子对象大笑
    CGSize itemSize = [self.layoutDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    //section边距
    UIEdgeInsets sectionInsets = [self.layoutDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
    //最小子对象间距
    CGFloat minItemSpacing = [self.layoutDelegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    
    //当前列索引
    NSInteger columnIndex = indexPath.row%_columnCount;
    //当前行索引
    NSInteger rowIndex = indexPath.row/_columnCount;
    
    CGFloat originX = sectionInsets.left + (itemSize.width+minItemSpacing)*columnIndex;
    CGFloat originY = 0;
    if (rowIndex == 0) {
        originY = [_cellYArray[columnIndex] floatValue] + sectionInsets.top;
    } else {
        originY = [_cellYArray[columnIndex] floatValue] + minItemSpacing;
    }
    attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
    NSLog(@"frame is %@",NSStringFromCGRect(attributes.frame));
    //更新cell y数组值
    _cellYArray[columnIndex] = @(originY + itemSize.height);
    
    return attributes;
}

#pragma mark - 自定义方法

//初始基本数据
- (void)initData {
    _columnCount = [self.layoutDelegate numberOfColumnsInCollectionView:self.collectionView];
}

//获取cell Y数组最大值
- (CGFloat)maxCellYWithArray:(NSMutableArray *)array {
    if (array == nil || array.count == 0) {
        return 0.0f;
    }
    
    CGFloat maxCellY = [array[0] floatValue];
    for (NSNumber *y in array) {
        if ([y floatValue] > maxCellY) {
            maxCellY = [y floatValue];
        }
    }
    return maxCellY;
}

//初始cell Y数组
- (void)initCellYArray {
    _cellYArray = [NSMutableArray arrayWithCapacity:_columnCount];
    for (NSInteger i = 0; i < _columnCount; i++) {
        [_cellYArray addObject:@(0)];
    }
}

@end
