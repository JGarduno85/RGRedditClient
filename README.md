# RGRedditClient

# RGRedditClient

Simple Reddit client that reads and display the feeds from the top section.

Created following the next acceptance criteria:
- Assume the latest platform and use Swift.
- Use UITableView / UICollectionView to arrange the data:  The app uses UITableView.
- Please refrain from using AFNetworking, instead use NSURLSession: Implemented using NSURLSessions.
- Support Landscape: Supported.
- Use Storyboards: Used main storyboard with XIB for the cells.

The Cell shows the Reddit post with the following format:

- Title (at its full length, so take this into account when sizing your cells): The title resize to 3 lines max.
- Author
- entry date, following a format like “x hours ago”
- A thumbnail for those who have a picture.: Those who display a thumbnail display it, those that doesn't the thumbnail is hidden.
- Number of comments.
- In addition, for those having a picture (besides the thumbnail) , please allow the user to tap on the thumbnail to be sent to the full sized picture.
You don’t have to implement the IMGUR API, so just opening the URL would be OK: Implemented if the post have a thumbnail this is show and the user can tap on it.
- Pagination support: The user has to scroll to the bottom to see the loader and get more feeds. If for some reason the fetching fails an alert is displayed. For now the way to refresh the request 
is to scroll up the table view and down to the bottom again to relaunch the fetch.
- Saving pictures in the picture gallery: Implemented use longpress over the thumbnail to see an alert that tells the user if he wants to download the image.
- App state-preservation/restoration: Implemented, the latest feeds fetched are saved and when the user restores the app it shows them again. For now it scrolls to the top again.
- Support iPhone 6/ 6+ screen size: Implemented cells display correct on iPhone 6 an 6+

- Adittionally: 
  - Basic animations on the rows insertion and deletion where implemented
  - Unit tests
  - The base architecture were designed to use POP, this way many of the components can be reuse or functionality can be extended.

## Getting Started

1.- When the app launch for the first time it will fetch the feeds and show a loader that covers the entire screen. If for some reason the first fech fails
an error screen is displayed. 

2.- Once the app fetched the first feeds the user has to scroll to the bottom to fetch more posts. A loader is displayed at the bottom of the table and once the feeds are retrieve
they are displayed. If for some reason the fetch for subsequent feeds fails then an alert is shown. For now to relaunch the fetch the user has to scroll up a little bit and scroll down again
to the bottom to kick the fetch again.

3.- The save state works in the next way: the last feeds fetched are saved in state. Once the restoration is kicked all the feeds saved are restored.

## Known issues:

1.- Some times when scrolling to fast the thumbnails images seems to not refresh appropriately. 


## Author

Jose Humberto Partida Garduno
