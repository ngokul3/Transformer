## Assumptions

1) Transformers cannot be deleted.  
2) There can be more than 1 transformer from same side in the same rank. However, app will pick only 1. The other fighter from the same group and same rank will not be fighting.
3) Every variable like speed, courage..etc are mandatory. The min & max validation rules for these variables are validated on the client side.
4) Although network API key is reused for the same session, new key request will be sent every time the app is launched. This is to make sure that the key has not changed in the real scenario.
5) App does not do any offline storage or offline sync
6) Transformers are persisted locally but the fight history is not. Fight history is called statistics in the code. This information is not persisted locally because of time constraints with development work.


## Game Flow

1) App displays a Tab Bar controller. The first tab displays list of transformers, and navigates to add / edit screen.
    Second tab is for initiating the battle and displaying results/
2) Transformers are sorted based on the rank and displayed.
3) Transformer lifecycle is as below -

        When a transformer is newly created, State is  "Born"
        After fighting with an opponent transformer State is "Alive" or "Died"
  
  
  Results Screen -
  
  1) On going to the secon tab, app will pick fighters from the same Rank.
   2) There are 2 table view controllers in the Results screen. The top tableview will display the fight set up. 
   For instance, if A & B are choosen from rank 1, app will display "R1: A Vs B ". App will also show "Ready" on the same line to mean that the fight is yet to start.
   3) There is a button that says "Start fight". On click of this button, A will fight with B. If A beats B, the top tableView will show "R1: A  Alive". "R1:B Died". The bottom tableView will show "Battle1: Autobots win."
   4) Now if A is available for another fight. If "C" from Rank 1 & Decepticons get newly created, tableView will read "Rank1: A Vs C".
   5) If there are uneven match of opponents, tableView will read "R2: A2   Not fighting". This means A2 of Rank 2 has no opponent.
   6)  If there are 4 opponents like "R1: A1 Vs D1", "R2: A2 Vs D2", "R3: Predaking Vs Optimus Prime", "R4: A4 Vs D4". The app will start the fight in this order and start displaying the result.
   
   Battle1: Autobots win
   Battle2: Decepticons win.
   
   Since battle 3 involves "Predaking Vs Optimus Prime", the game ends with all players dead, and there is no Battle 4 between "A4 vs D4". So, display of the bottom table view would be as follows -
   
   Battle1: Autobots win
   Battle2: Decepticons win
   Battle3: All dead
   

## How can we improve this app -

1) The statistics of the battle can be persisted. The total history of battle information can be on a different controller from Results.
2) The top table view in the Result can display images based on the Rank match.
3) We can reset the state of the fighters prior to the battle, and update fighter profile and start fight again.
4) We can have the ability to have more than 1 player. In that case app1 is always on the fight mode. App2 will introduce fighters. Web service will talk to the app1 and app1 responds to the new fighter. 
5) Offline cache, and sync with web service can be done.
6) Add a segment control ALL, Autobots, Decepticons in the Transformer List screen. Click of 'All' will show all transformers. Click of Autobots or Decepticons will filter the transformer based on the team.


## Unit Tests

Please check unit tests to run through different cases. 
