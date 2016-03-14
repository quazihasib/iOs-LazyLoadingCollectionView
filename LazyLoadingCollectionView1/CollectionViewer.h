//
//  CollectionViewer.h
//  LazyLoadingCollectionView1
//
//  Created by Quazi Ridwan Hasib on 14/03/2016.
//  Copyright © 2016 Quazi Ridwan Hasib. All rights reserved.
//

#import "ViewController.h"

@interface CollectionViewer : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIDocumentInteractionControllerDelegate>

// PROPERTIES
@property (strong, nonatomic) NSMutableArray *ary_images;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;


@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property(strong, nonatomic) NSArray *dataArray;
@property(strong, nonatomic) NSArray *dataArray1;
@property(strong, nonatomic) NSArray *dataArray2;



@end
