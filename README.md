# SmallMinesweeper

Simple Minesweeper game for GNUstep, using [SmallStepLib](../SmallStepLib) for app lifecycle, menus, and window style.

## Build

1. Build and install SmallStepLib:
   ```bash
   cd ../SmallStepLib && source /usr/share/GNUstep/Makefiles/GNUstep.sh && make && make install
   ```
2. Build SmallMinesweeper:
   ```bash
   cd SmallMinesweeper && source /usr/share/GNUstep/Makefiles/GNUstep.sh && make
   ```

## Run

```bash
./SmallMinesweeper.app/SmallMinesweeper
```

Or from the build directory after `make`:
```bash
openapp ./SmallMinesweeper.app
```

## How to play

- **Left click** on a cell to reveal it. The first click is always safe (mines are placed after your first click).
- **Right click** to toggle a flag on a cell (mark as suspected mine).
- Reveal all non-mine cells to win. Clicking a mine ends the game.
- Use **File → New Game** or **Ctrl+N** to start a new game.

Default grid: 9×9 with 10 mines (classic beginner layout).
# SmallMinesweeper
