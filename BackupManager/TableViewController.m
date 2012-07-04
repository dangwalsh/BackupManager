//
//  TableViewController.m
//  BackupManager
//
//  Created by Daniel Walsh on 7/1/12.
//  Copyright (c) 2012 Walsh walsh Studio. All rights reserved.
//

#import "TableViewController.h"
#import "File.h"
#import "Files.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize managedObjectContext;
@synthesize filesArray;
@synthesize filesDict;
@synthesize filesSort;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Files";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:[UIApplication sharedApplication].delegate 
                 action:@selector(listFiles)];
    addButton.enabled = YES;
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"File"
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"fileName" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext
                                            executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        // Handle the error.
    }
    NSMutableArray *fetchResultsDict = [[NSMutableArray alloc] init];
    
    for (File *s in mutableFetchResults) {
        
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                           s.fileName, @"Name", 
                           nil
                           ];
        [fetchResultsDict addObject:d];
    }
   
    [self setFilesArray:fetchResultsDict];
    
    
    
    
    //beginning indexed section
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    self.filesSort = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *tempArray; 
    NSMutableArray *filesTemp;

    if((tempArray = filesArray)) {
        filesTemp = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *fileDict in tempArray) {
            Files *aFile = [[Files alloc] init];
            aFile.name = [fileDict objectForKey:@"Name"];
            //aFile.path = [fileDict objectForKey:@"Path"];
            //aFile.date = [fileDict objectForKey:@"Date"];
            [filesTemp addObject:aFile];
        }
    } else {
        return;
    }
    
    for (Files *theFile in filesTemp) {
        NSInteger sect = [theCollation sectionForObject:theFile 
                                collationStringSelector:@selector(name)];
        theFile.sectionNumber = sect;
    }
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for(int i=0; i<=highSection; ++i) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    for (Files *theFile in filesTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:theFile.sectionNumber] addObject:theFile];
    }
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray 
                                            collationStringSelector:@selector(name)];
        [self.filesSort addObject:sortedSection];
    }
    //end indexed section
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.filesArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.filesSort objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    return [self.filesSort count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [filesArray count];
    return [[self.filesSort objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //File *file = (File *)[filesArray objectAtIndex:indexPath.row];    
    //cell.textLabel.text = [file fileName];
    
    Files *fileObj = [[self.filesSort objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = fileObj.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSManagedObject *eventToDelete = [filesArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:eventToDelete];
        
        // Update the array and table view.
        [filesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:YES];
        
        // Commit the change.
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) addFile: (NSString *)name {    
    File *file = (File *)[NSEntityDescription insertNewObjectForEntityForName:@"File"
                                                       inManagedObjectContext:managedObjectContext];    
    [file setFileName:name];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    [filesArray insertObject:file atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
