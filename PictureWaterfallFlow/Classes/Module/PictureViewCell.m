//
//  PictureViewCell.m
//  PictureWaterfallFlow
//
//  Created by Admin on 15/11/2.
//  Copyright © 2015年 yulei. All rights reserved.
//

#import "PictureViewCell.h"

@interface PictureViewCell ()


@end

@implementation PictureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

#pragma mark - Main

//加载子数据
- (void)loadSubviews {
    [self.contentView addSubview:self.pictureImage];
}

//设置显示数据
- (void)setShowData:(NSString *)_picName {
    [_pictureImage setFrame:self.bounds];
    [_pictureImage setImage:[UIImage imageNamed:_picName]];
}

#pragma mark - lazyload

- (UIImageView *)pictureImage {
    if (_pictureImage == nil) {
        _pictureImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _pictureImage.backgroundColor = [UIColor clearColor];
        _pictureImage.clipsToBounds = YES;
        _pictureImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImage;
}

@end
