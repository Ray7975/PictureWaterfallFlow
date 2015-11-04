//
//  PictureViewController.m
//  PictureWaterfallFlow
//
//  Created by Admin on 15/11/2.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureViewLayout.h"
#import "PictureViewCell.h"

@interface PictureViewController () <PictureViewLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) PictureViewLayout *collectionViewLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *picList;
@property (nonatomic, assign) NSInteger picListCount;
//高度列表
@property (nonatomic, strong) NSMutableArray *picHeightList;
//列宽度
@property (nonatomic, assign) CGFloat columnWidth;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBar];
    [self loadSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mark

//设置导航条
- (void)setNavigationBar {
    [self setTitle:@"瀑布流"];
    
    //返回按钮
    UIButton *button_refresh = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button_refresh setBackgroundColor:[UIColor yellowColor]];
    [button_refresh setTitle:@"刷新" forState:UIControlStateNormal];
    [button_refresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button_refresh setAdjustsImageWhenHighlighted:NO];
    [button_refresh addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:button_refresh];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    spaceItem.width -= 15;
    self.navigationItem.rightBarButtonItems = @[spaceItem, refreshItem];
}

//加载视图
- (void)loadSubviews {
    _picList = [NSMutableArray arrayWithCapacity:20];
    [_picList addObject:@"001.jpg"];
    [_picList addObject:@"002.jpg"];
    [_picList addObject:@"003.jpg"];
    [_picList addObject:@"004.jpg"];
    [_picList addObject:@"005.jpg"];
    [_picList addObject:@"006.jpg"];
    
    _picListCount = _picList.count;
    //列数量
    _columnCount = 2;
    //cell子对象间距
    _minItemSpacing = 6.0f;
    //列宽度
    _columnWidth = (CGRectGetWidth(self.view.bounds)-16.0f-_minItemSpacing)/_columnCount;
    
    _picHeightList = [NSMutableArray arrayWithCapacity:_picListCount];
    for (NSInteger i = 0; i < _picListCount; i ++) {
        CGFloat temp_height = arc4random() % 175 + 125;
        [_picHeightList addObject:@(temp_height)];
    }

    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView {
    return _columnCount;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(PictureViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(PictureViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"height is %@",_picHeightList[indexPath.row]);
    return CGSizeMake(_columnWidth, [_picHeightList[indexPath.row] floatValue]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(PictureViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _minItemSpacing;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _picListCount;
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureViewCell class]) forIndexPath:indexPath];
    
    NSString *picName = [_picList objectAtIndex:indexPath.row];
    if (picName != nil && ![picName isEqualToString:@""]) {
        [cell setShowData:picName];
    }
    
    return cell;
}

#pragma mark - UIResponse Event

//刷新按钮点击事件
- (void)refreshButtonClick:(id)sender {
    [self.collectionView reloadData];
}

#pragma mark - lazyload

- (PictureViewLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[PictureViewLayout alloc] init];
        _collectionViewLayout.layoutDelegate = self;
    }
    return _collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[PictureViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PictureViewCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
