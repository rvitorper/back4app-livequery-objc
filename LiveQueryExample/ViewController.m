//
//  ViewController.m
//  LiveQueryExample
//
//  Created by Ayrton Alves on 03/01/17.
//  Copyright © 2017 back4app. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFQuery *msgQuery;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:@"wss://livequeryexample.back4app.io" applicationId:@"cfEqijsSr9AS03FR76DJYM374KHH5GddQSQvIU7H" clientKey:@"F9dLUvMhb8D7aMCAukUDMFae630qhhlYTki6dGxP"];
    self.msgQuery = [PFQuery queryWithClassName:@"Message"];
    [self.msgQuery whereKey:@"destination" equalTo:@"pokelist"];
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        [self alert:@"You have been poked" title:@"Poke"];
    }];
}

-(void)alert:(NSString*)message
       title:(NSString*) title {
    // Show some greeting message
    // Creating a simple alert
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    // Creating the actions of the alert
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:okButton];
    
    // Showing the alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sendPoke:(id)sender {
    PFObject* poke = [PFObject objectWithClassName:@"Message"];
    poke[@"content"] = @"poke";
    poke[@"destination"] = @"pokelist";
    [poke saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Poke sent");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
