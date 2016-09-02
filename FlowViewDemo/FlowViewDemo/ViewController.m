//
//  ViewController.m
//  FlowViewDemo
//
//  Created by 史庆帅 on 16/9/2.
//  Copyright © 2016年 xhoogee. All rights reserved.
//

#import "ViewController.h"
#import "FlowCollectionView.h"
#import "CustomFlowLayout.h"
@interface ViewController ()
@property (nonatomic) FlowCollectionView *collectionView;
@property (nonatomic) CustomFlowLayout *layout;
@property (nonatomic) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.images = [NSMutableArray arrayWithCapacity:7];
    for(NSInteger i = 0; i < 7; i++){
        NSString *image = [NSString stringWithFormat:@"pic%ld.jpg",i+1];
        [self.images addObject:image];
    }
    CGFloat itemLength = 150;
    CGFloat space = (self.view.frame.size.width - itemLength*2)/2;
    self.layout = [[CustomFlowLayout alloc] init];
    self.layout.minimumLineSpacing = space;
    self.layout.itemSize = CGSizeMake(itemLength, itemLength);
    self.collectionView = [FlowCollectionView flowCollectionViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, itemLength) layout:self.layout];
    self.layout.sizeScale = 0.8;
    self.collectionView.pageLength = self.view.frame.size.width/2;
    self.collectionView.images = self.images;
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
