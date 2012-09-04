//
//  MasterViewController.m
//  HappyEntries
//
//  Created by Haozhu Wang on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "SingleEntry.h"
#import "AppDelegate.h"
#define MAXCHARACTERS   300

@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize moodySlider = _moodySlider;
@synthesize scoreLabel = _scoreLabel;
@synthesize stateLabel = _stateLabel;
@synthesize reasonTextView = _reasonTextView;
@synthesize clearButton=_clearButton;
@synthesize postEntryButton=_postEntryButton;
@synthesize viewEntriesButton=_viewEntriesButton;
@synthesize characterCountLabel=_characterCountLabel;

-(void) keyPressed: (NSNotification*) notification
{
    //NSLog([[notification object]text]);
    int charactersLeft = MAXCHARACTERS - [[[notification object]text] length];
    if (charactersLeft <0) {
        [[notification object] setText:entryText];
    }
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", (int)[_moodySlider value]]];
    [_clearButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_postEntryButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_viewEntriesButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_clearButton setEnabled:NO];
    [_characterCountLabel setText:[NSString stringWithFormat:@"%d characters left",MAXCHARACTERS]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];
    
    AppDelegate * delegate= [[UIApplication sharedApplication] delegate];
    __managedObjectContext = [delegate managedObjectContext];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMoodySlider:nil];
    [self setScoreLabel:nil];
    [self setStateLabel:nil];
    [self setReasonTextView:nil];
    [self setClearButton:nil];
    [self setPostEntryButton:nil];
    [self setViewEntriesButton:nil];
    [self setCharacterCountLabel:nil];
    [[NSNotificationCenter defaultCenter] removeObject:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)sliderChange:(id)sender
{
    [_scoreLabel setText:[NSString stringWithFormat:@"%d", (int)[_moodySlider value]]];
    int moodValue = [_moodySlider value];
    if ( moodValue< 25) {
        [_stateLabel setText:@"VERY Bad :( :("];
        [_stateLabel setTextColor:[UIColor redColor]];
    }
    else if (moodValue < 45) {
        [_stateLabel setText:@"Bad :("];
        [_stateLabel setTextColor:[UIColor purpleColor]];
    }
    else if((moodValue > 55) && (moodValue < 75)) 
    {
        [_stateLabel setText:@"Good! :)"];
        [_stateLabel setTextColor:[UIColor blueColor]];
    }
    else if (moodValue >75)
    {
        [_stateLabel setText:@"Very Good! :)"];
        [_stateLabel setTextColor:[UIColor cyanColor]];
    }
    else 
    {
        [_stateLabel setText:@"Neutral"];
        [_stateLabel setTextColor:[UIColor greenColor]];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    UITouch *lastTouch;
//    for (UITouch* thisTouch in touches) {
//        [thisTouch timestamp]
//    }
    [_reasonTextView resignFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    entryText = textView.text;
}

-(void)clearButtonState:(UITextView*) textView
{
    if ([[textView text] isEqual:@""]) {
        _clearButton.Enabled=NO;
    }
    else
    {
        _clearButton.Enabled=YES;
    }
}

-(void) countingCharacters:(UITextView*) textView
{
    int charactersLeft = MAXCHARACTERS - [textView.text length];
    NSString *character = [NSString alloc];
    if (charactersLeft <= 1) {
        character=[NSString stringWithFormat:@"character"];
    }
    else
    {
        character=[NSString stringWithFormat:@"characters"];
    }
    [_characterCountLabel setText:[NSString stringWithFormat:@"%d %@ left", charactersLeft, character]];
    
    if (charactersLeft == 0)
    {
        [textView resignFirstResponder];
    }
    
    [self clearButtonState:textView];
}

-(void)textViewDidChange:(UITextView *)textView
{
    //set clear button
    //[self clearButtonState:textView];
    
    //set the character count label
    [self countingCharacters:textView];
}

-(IBAction)clearedButton:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Clearing Text" message:@"Do you want to clear the text?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    
}

-(void) clearTextView
{
    [_reasonTextView setText:@""];
    [self countingCharacters:_reasonTextView];
}

-(void)resetFirstScreen
{
    [self clearTextView];
    [_moodySlider setValue:50];
    [_moodySlider sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)makeNewSingleEntry
{
    SingleEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntry"inManagedObjectContext:__managedObjectContext];
    entry.entryDate=[NSDate date];
    entry.entryRating = [NSNumber numberWithInt:(int)[_moodySlider value]];
    entry.entryBody=[_reasonTextView text];
    entry.entryTitle=[NSString stringWithFormat:@"I am feeling %@", [_stateLabel text]];
    NSError * myerror;
    [__managedObjectContext save:&myerror];
    
    ///testing fetching code
//    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SingleEntry" inManagedObjectContext:__managedObjectContext];
//    [fetch setEntity:entity];
//    NSError *error;
//    NSArray *fetchedObj = [__managedObjectContext executeFetchRequest:fetch error:&error];
//    for(SingleEntry * thisEntry in fetchedObj)
//    {
//        NSLog([NSString stringWithFormat:@"Title: %@", thisEntry.entryTitle]);
//        NSLog([NSString stringWithFormat:@"Rating: %d",[thisEntry.entryRating intValue]]);
//        NSLog([NSString stringWithFormat:@"Body: %@", thisEntry.entryBody]);
//        NSLog(@"/n/n");
//    }
}

//posting the entry
-(void)postingEntry
{
    [self makeNewSingleEntry];
    [self resetFirstScreen];
    [self performSegueWithIdentifier:@"ViewEntries" sender:self];
}

-(IBAction)postButtonPressed:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Posting Entry" message:@"Ready to Post your entry?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqual:@"Clearing Text"])
    {
        if(buttonIndex==1)
        {
            [self clearTextView];
        }
    }
    else if([[alertView title] isEqual:@"Posting Entry"])
    {
        if(buttonIndex==1)
        {
            [self postingEntry];
        }
    }
}
@end
