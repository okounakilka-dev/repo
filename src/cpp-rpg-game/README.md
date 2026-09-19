# C++ RPG Game

Zero-dependency C++17 turn-based console RPG.

## Run
```powershell
g++ main.cpp -o rpg-game -std=c++17 -Wall
.\rpg-game
```
MSVC: `cl /EHsc main.cpp`

Or CMake:
```powershell
cmake -S . -B build
cmake --build build --config Release
.\build\Release\rpg-game.exe
```

## Gameplay
- Name your hero (100 HP, 12 ATK, 3 potions).
- Fight `Slime(30HP) -> Goblin(50) -> Orc(80) -> Dragon(120)` in order.
- Turn: `1=Attack` (dmg `atk-2..atk+4`), `2=Potion` (+30 HP), `3=Run` (50% escape).
- Enemy hits back `atk-2..atk+2`. Win = +15-30 XP. Level-up at `level*50` XP: +20 maxHp, +3 atk, +1 potion, full heal.

## Files
- `main.cpp` — all logic (~100 lines): structs `Player/Enemy`, `fight()`, `levelUp()`, `printStats()`.
- `CMakeLists.txt` — `project(rpg-game)`, C++17, `-Wall`.
