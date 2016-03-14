//
//  ViewController.m
//  LazyLoadingCollectionView1
//
//  Created by Quazi Ridwan Hasib on 14/03/2016.
//  Copyright © 2016 Quazi Ridwan Hasib. All rights reserved.
//

#import "ViewController.h"
#import "ImageRecord.h"
#import "CollectionViewer.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)buttonClick:(id)sender {
    
    // Fetch string of image URL's from ImageList.txt
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:@"ImageList"
                                                         ofType:@"txt"];
    // Apply NSUTF8StringEncoding to the above string
    NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    // Fetch array of URL's from the text file by check for newline.
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    // Note: To add more images to the project -> Just copy and paste the new list of image URL's in the ImageList.txt file. That's it.
    
    NSArray *arrayImages = [NSArray arrayWithObjects:@"http://quaziridwanhasib.com/products/5.jpg",
                            @"http://s30.postimg.org/5d4iugiqp/3d_beach_cool_hd_wallpapers_background.jpg",
                            @"http://s30.postimg.org/4kx9hip5t/3_D_Nature_full_color_Wallpapers_HD.jpg", nil];
    
    // Prepare the array for processing in LazyLoadVC. Add each URL into a separate ImageRecord object and store it in the array.
    NSMutableArray *listURLs = [NSMutableArray array];
    for (int cnt=0; cnt<[arrayImages count]; cnt++)
    {
        ImageRecord *obj = [[ImageRecord alloc] init];
        obj.imageURL = [arrayImages objectAtIndex:cnt];
        [listURLs addObject:obj];
    }
    
    // Added functionality to randomize the sequence of images. This is optional. Just comment this part of code if you are not bored to see the same images again and again.
    
    //    NSUInteger count = [listURLs count];
    //    for (NSUInteger i = 0; i < count; ++i) {
    //        NSInteger remainingCount = count - i;
    //        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
    //        [listURLs exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    //    }
    
    // Navigate to the LazyLoadVC for watching these image urls lazy load. Just pass the prepared array to ary_images in the next class.
//    LazyLoadVC *obj_LazyLoadVC = nil;
//    if (IS_IPAD)
//        obj_LazyLoadVC = [[LazyLoadVC alloc] initWithNibName:@"LazyLoadVC_ipad" bundle:nil];
//    else
//        obj_LazyLoadVC = [[LazyLoadVC alloc] initWithNibName:@"LazyLoadVC_iphone" bundle:nil];
//    obj_LazyLoadVC.ary_images = listURLs;
//    [self.navigationController pushViewController:obj_LazyLoadVC animated:YES];
//    listURLs = nil;

    
    CollectionViewer *obj_LazyLoadVC = nil;
    obj_LazyLoadVC.ary_images = listURLs;
    NSLog(@"dd :%d", arrayImages.count);
    [self.navigationController pushViewController:obj_LazyLoadVC animated:YES];
    listURLs = nil;
    
    
    ViewController *NVC = [self.storyboard instantiateViewControllerWithIdentifier:@"collection"];
    [self presentViewController:NVC animated:YES completion:nil];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
