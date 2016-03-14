//
//  CollectionViewer.m
//  LazyLoadingCollectionView1
//
//  Created by Quazi Ridwan Hasib on 14/03/2016.
//  Copyright © 2016 Quazi Ridwan Hasib. All rights reserved.
//

#import "CollectionViewer.h"
#import "CustomCell.h"
#import "CustomHeader.h"
#import "ImageRecord.h"
#import "ImageDownloader.h"
#import "ImageCache.h"

static NSString * const kCellReuseIdentifier = @"cell";
NSMutableArray *listURLs ;

@interface CollectionViewer() <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation CollectionViewer
// SYNTHESIZERS
@synthesize ary_images;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self setupCollectionView];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.dataArray = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep",
                       @"Oct", @"Nov", @"Dec"];
    
    self.dataArray1 = @[ @"May", @"Jun", @"Jul", @"Aug", @"Sep",
                         @"Oct", @"Nov", @"Dec"];
    
    self.dataArray2 = @[@"Oct", @"Nov", @"Dec"];
    
    
    // Fetch string of image URL's from ImageList.txt
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:@"ImageList"
                                                         ofType:@"txt"];
    // Apply NSUTF8StringEncoding to the above string
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    // Fetch array of URL's from the text file by check for newline.
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSArray *arrayImages = [NSArray arrayWithObjects:@"http://quaziridwanhasib.com/products/5.jpg",
                            @"http://s30.postimg.org/5d4iugiqp/3d_beach_cool_hd_wallpapers_background.jpg",
                            @"http://s30.postimg.org/4kx9hip5t/3_D_Nature_full_color_Wallpapers_HD.jpg", nil];
    
    // Prepare the array for processing in LazyLoadVC. Add each URL into a separate ImageRecord object and store it in the array.
    listURLs = [NSMutableArray array];
    for (int cnt=0; cnt<[allLinedStrings count]; cnt++)
    {
        ImageRecord *obj = [[ImageRecord alloc] init];
        obj.imageURL = [allLinedStrings objectAtIndex:cnt];
        [listURLs addObject:obj];
    }

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = [NSString stringWithFormat:@"Lazy Loading UICollectionView - %lu Images",(unsigned long)listURLs.count];
    [self emptyDocumentsDir];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // If memory warning is issued, then we can clear the objects to free some memory. Here we are simply removing all the images. But we can use a bit more logic to handle the memory here.
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - UICollectionView Delegates
-(void)setupCollectionView
{
    [self.myCollectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    if (IS_IPAD) [flowLayout setSectionInset:UIEdgeInsetsMake(20,30,20,30)];
//    else
        [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.myCollectionView setPagingEnabled:NO];
    [self.myCollectionView setCollectionViewLayout:flowLayout];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    int a;
    if(section==0)
    {
        NSLog(@"ssss: %i",listURLs.count);
//        a= self.ary_images.count;
        a=listURLs.count;
    }
    else if(section==1)
    {
        a=self.dataArray1.count;
    }
    else if(section==2)
    {
        a=self.dataArray2.count;
    }
    
    return a;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    if (indexPath.section ==0) {
        header.myHeader.text = [NSString stringWithFormat:@"Section 0"];
        
    }
    else if (indexPath.section ==1) {
        header.myHeader.text = [NSString stringWithFormat:@"Section 1"];
        
    }
    else if (indexPath.section ==2) {
        header.myHeader.text = [NSString stringWithFormat:@"Section 2"];
        
    }
    
    // header.myHeaderLabel.text = [NSString stringWithFormat:@"Section %ld", indexPath.section +1];
    
    return header;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"cell";
//    
//    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    if(indexPath.section==0)
//    {
//        [[cell myLabel]setText:[self.dataArray objectAtIndex:indexPath.item]];
//        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
//        
//        //Add to cell programmatically
//        //        UILabel *lbl1 = [[UILabel alloc] init];
//        //        [lbl1 setFrame:CGRectMake(0,5,100,20)];
//        //        lbl1.backgroundColor=[UIColor clearColor];
//        //        lbl1.textColor=[UIColor blueColor];
//        //        lbl1.userInteractionEnabled=YES;
//        //        [cell addSubview:lbl1];
//        //        lbl1.text=  [self.dataArray objectAtIndex:indexPath.item];
//        
//        //Remove from cell programmatically
//        //  [cell.myLabel removeFromSuperview];
//        
//    }
//    else if(indexPath.section==1)
//    {
//        [[cell myLabel]setText:[self.dataArray1 objectAtIndex:indexPath.item]];
//        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
//    }
//    else if(indexPath.section==2)
//    {
//        [[cell myLabel]setText:[self.dataArray2 objectAtIndex:indexPath.item]];
//        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
//    }
    
        static NSString *CellIdentifier = @"cell";
    
        CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section==0)
    {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.myImageView viewWithTag:505];
    
        // Set up the cell...
        // Fetch a image record from the array
        ImageRecord *imgRecord = [listURLs objectAtIndex:indexPath.row];
    
        // Set thumbimage
        // Check if the image exists in cache. If it does exists in cache, directly fetch it and display it in the cell
        if ([[ImageCache sharedImageCache] DoesExist:imgRecord.imageURL] == true)
        {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        
            cell.myImageView.image = [[ImageCache sharedImageCache] GetImage:imgRecord.imageURL];
        }
        // If it does not exist in cache, download it
        else
        {
            // Add activity indicator
            if (activityIndicator) [activityIndicator removeFromSuperview];
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.hidesWhenStopped = YES;
            activityIndicator.hidden = NO;
            [activityIndicator startAnimating];
            activityIndicator.center = cell.myImageView.center;
            activityIndicator.tag = 505;
            [cell.myImageView addSubview:activityIndicator];
        
            // Only load cached images; defer new downloads until scrolling ends
            if (!imgRecord.thumbImage)
            {
                if (self.myCollectionView.dragging == NO && self.myCollectionView.decelerating == NO)
                {
                    [self startIconDownload:imgRecord forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.myImageView.image = [UIImage imageNamed:@"placeholder.png"];
            }
            else
            {
                cell.myImageView.image = imgRecord.thumbImage;
            }
        }
    }
//     if(indexPath.section==0)
//    {
//        //[[cell myLabel]setText:[self.dataArray1 objectAtIndex:indexPath.item]];
//        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
//    }
    else if(indexPath.section==1)
    {
        //[[cell myLabel]setText:[self.dataArray1 objectAtIndex:indexPath.item]];
        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
    }
    else if(indexPath.section==2)
    {
        //[[cell myLabel]setText:[self.dataArray2 objectAtIndex:indexPath.item]];
        cell.myImageView.image = [UIImage imageNamed:@"2.jpg"];
    }
    
    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CustomCell *cell = (CustomCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        
//        NSString *str = cell.myLabel.text;
//        NSLog(@"Text: %@ section no:%ld item no: %ld", str, indexPath.item, indexPath.section);
//        
//    } else if(indexPath.section == 1){
//        NSString *str = cell.myLabel.text;
//        NSLog(@"Text: %@ section no:%ld item no: %ld", str, indexPath.item, indexPath.section);
//    }
//    else if(indexPath.section == 2){
//        NSString *str = cell.myLabel.text;
//        NSLog(@"Text: %@ section no:%ld item no: %ld", str, indexPath.item, indexPath.section);
//    }
//}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    if(IS_IPAD)
//        return 20.0;
//    else
        return 15.0;
    //return 0.0;
}

/////////////////////////////////////
//   Helper Methods
/////////////////////////////////////
#pragma mark - Helper Methods
- (void)startIconDownload:(ImageRecord *)imgRecord forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imgDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imgDownloader == nil)
    {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.imageRecord = imgRecord;
        [imgDownloader setCompletionHandler:^{
            
            CustomCell *cell = (CustomCell *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.myImageView.image = imgRecord.thumbImage;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.myImageView viewWithTag:505];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }];
        [self.imageDownloadsInProgress setObject:imgDownloader forKey:indexPath];
        [imgDownloader startDownload];
    }
}
- (void)loadImagesForOnscreenRows
{
    if ([listURLs count] > 0)
    {
        NSArray *visiblePaths = [self.myCollectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ImageRecord *imgRecord = [listURLs objectAtIndex:indexPath.row];
            
            if (!imgRecord.thumbImage)
                // Avoid downloading if the image is already downloaded
            {
                [self startIconDownload:imgRecord forIndexPath:indexPath];
            }
        }
    }
}

/////////////////////////////////////
//   Scrollview Delegates
/////////////////////////////////////
#pragma mark - Scrollview Delegates
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self loadImagesForOnscreenRows];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

/////////////////////////////////////
//   UIDocumentInteractionController Delegate
/////////////////////////////////////
#pragma mark - UIDocumentInteractionController Delegate
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

/////////////////////////////////////
//   Documents Directory
/////////////////////////////////////
#pragma mark - Documents Directory
-(void)emptyDocumentsDir
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    while (files.count > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                if (!removeSuccess) {
                    // Error
                }
            }
        } else {
            // Error
        }
    }
}

@end
