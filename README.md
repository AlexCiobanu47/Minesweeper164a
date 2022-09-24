# Minesweeper164a

Simple Minesweeper game using an ATMEL Mega 164a microprocessor, a Nokia 5110 84x48 display(PCD8544 driver) and buttons as inputs.

The game consists of a 5x5 grid with bombs placed randomly generated using a random seed. The user can move from cell to cell, select a cell or put a flag on it.

The game ends if he discovers all the cells that don't contain a bomb(win), or if the user selects a cell that contains a bomb(lose). After the game ends, the user gets a menu from which he can choose to play again or quit.
