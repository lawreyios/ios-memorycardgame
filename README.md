# Memory-Card-Game

This project is completed on the 17th May 2016. 

The app integrated third-party server-based client; Firebase. 
The database of the high score table is located here : https://colourmemory.firebaseio.com/players 

Adding of collaborators is needed, hence do provide me with your email so I can add you in to view the database.

The Colour Memory App is designed as such :

1) Helper class 
	a) Device Class to aid in defining the screen size and adjust the view layers accordingly.
	b) Array+Shuffle Class to aid in randomizing the array for the placement of the cards.
	c) CMFBClient+CMFBConstant Class (ColourMemoryFireBaseClient) used to perform networking calls to Firebase. (Network check not implemented)
	d) CMCardDealerManager Class is the main brain of the memory game, dealing with cards, scores and game mechanics.

2) Model 
	a) Card Class that holds the main Card Object.
	b) Player Score class that holds each player's score object.

3) View 
	a) CustomUI
		i) CMCardCollectionViewCell that is the main view of each card.
		ii) CMHeaderView that is the main top view showing logo, score and high score button.
		iii) CMSectionHeaderView that is the High Score Table Top view.
		iv) CMPlayerScoreTableViewCell that is the main view for each player's score.
	b) CMMainBoardCollectionViewController is the main board game view that allows user to interact and play the game.
	c) CMHighScoresTableViewController is the main high score table where user view top scores from server.

4) Resources
	a) All files in the Framework folder are required by the Firebase Framework.
	b) Assets are used to load images.
	c) LaunchScreen is used.
