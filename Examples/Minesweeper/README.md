# Minesweeper

This example shows a quick implementation of the famous [Minesweeper](https://en.wikipedia.org/wiki/Minesweeper_(video_game)) game using the Katana framework. 
As you know the objective of the game is to clear a rectangular board containing hidden mines without detonating any of them, with help from clues about the number of neighboring mines in each field.

Please note that this an incomplete implementation, __potential improvements are__:

- Long press to flag a cell you think contains a mine.
- Disclose all the mines on gameover/victory
- Show the number of remaining mines

Feel free to open a [pull request](https://github.com/BendingSpoons/katana-swift/pulls) for improvements! We'd love that.



![](MinesweeperDemo.gif)



### What is showcased here:

- Most of the basics of Katana
- Complex UI updates
- `MinesweeperSyncAction` that abstracts all the `SyncAction`s of the app
- Complex State logic