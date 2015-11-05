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

//图片列表
@property (nonatomic, strong) NSMutableArray *picList;
//图片列表数量
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
    //图片数据
    _picList = [self randomArray];
    _picListCount = _picList.count;
    //列数量
    _columnCount = 2;
    //cell子对象间距
    _minItemSpacing = 6.0f;
    //列宽度
    _columnWidth = (CGRectGetWidth(self.view.bounds)-16.0f-_minItemSpacing)/_columnCount;
    
    _picHeightList = [NSMutableArray arrayWithCapacity:_picListCount];
    for (NSInteger heightIndex = 0; heightIndex < _picListCount; heightIndex ++) {
        CGFloat temp_height = arc4random() % 175 + 125;
        [_picHeightList addObject:@(temp_height)];
    }

    [self.view addSubview:self.collectionView];
}

//随机数数组
- (NSMutableArray *)randomArray {
    //起始数组
    NSMutableArray *startArray = [NSMutableArray arrayWithObjects:@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg",@"006.jpg",nil];
    //起始数组数量
    NSInteger startArrayCount = startArray.count;
    
    //结束数组
    NSMutableArray *endArray = [NSMutableArray arrayWithCapacity:startArrayCount];
    for (NSInteger i = 0; i < startArrayCount; i ++) {
        NSInteger random = arc4random() % startArray.count;
        endArray[i] = startArray[random];
        startArray[random] = [startArray lastObject];
        [startArray removeLastObject];
    }
    return endArray;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView {
    return _columnCount;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(PictureViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(PictureViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PictureViewCell class]) forIndexPath:indexPath];
    
    NSString *picName = [_picList objectAtIndex:indexPath.row];
    if (picName != nil && ![picName isEqualToString:@""]) {
        [cell setShowData:picName];
    }
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected section is %d, row is %d",indexPath.section,indexPath.row);
}


#pragma mark - UIResponse Event

//刷新按钮点击事件
- (void)refreshButtonClick:(id)sender {

    _picList = [self randomArray];
    
    for (NSInteger heightIndex = 0; heightIndex < _picListCount; heightIndex ++) {
        CGFloat temp_height = arc4random() % 175 + 125;
        [_picHeightList replaceObjectAtIndex:heightIndex withObject:@(temp_height)];
    }
    
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
