#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <ctime>

struct Enemy {
    std::string name;
    int hp;
    int atk;
};

struct Player {
    std::string name;
    int hp;
    int maxHp;
    int atk;
    int potions;
    int xp;
    int level;
};

void printStats(const Player& p) {
    std::cout << "\n-- " << p.name << " Lv" << p.level << " --\n";
    std::cout << "HP: " << p.hp << "/" << p.maxHp << "\n";
    std::cout << "ATK: " << p.atk << "\n";
    std::cout << "Potions: " << p.potions << "\n";
    std::cout << "XP: " << p.xp << "\n";
}

int randRange(int min, int max) {
    return min + rand() % (max - min + 1);
}

void levelUp(Player& p) {
    p.level++;
    p.maxHp += 20;
    p.atk += 3;
    p.hp = p.maxHp;
    p.potions += 1;
    std::cout << "*** LEVEL UP! Now Lv" << p.level << " ***\n";
}

bool fight(Player& p, Enemy e) {
    std::cout << "\nA wild " << e.name << " appears! HP:" << e.hp << "\n";
    while (p.hp > 0 && e.hp > 0) {
        std::cout << "\nYour HP:" << p.hp << " | Enemy HP:" << e.hp << "\n";
        std::cout << "1.Attack 2.Potion 3.Run: ";
        int c; std::cin >> c;
        if (c == 1) {
            int dmg = randRange(p.atk - 2, p.atk + 4);
            e.hp -= dmg;
            std::cout << "You hit " << e.name << " for " << dmg << "!\n";
        } else if (c == 2) {
            if (p.potions > 0) {
                p.potions--;
                p.hp += 30;
                if (p.hp > p.maxHp) p.hp = p.maxHp;
                std::cout << "You drink potion. HP now " << p.hp << "\n";
            } else {
                std::cout << "No potions left!\n";
                continue;
            }
        } else {
            if (rand() % 2 == 0) {
                std::cout << "You escaped!\n";
                return true;
            } else {
                std::cout << "Failed to run!\n";
            }
        }
        if (e.hp <= 0) break;
        int edmg = randRange(e.atk - 2, e.atk + 2);
        p.hp -= edmg;
        std::cout << e.name << " hits you for " << edmg << "!\n";
    }
    if (p.hp <= 0) return false;
    std::cout << "You defeated " << e.name << "!\n";
    int gain = randRange(15, 30);
    p.xp += gain;
    std::cout << "Gained " << gain << " XP.\n";
    if (p.xp >= p.level * 50) {
        p.xp = 0;
        levelUp(p);
    }
    return true;
}

int main() {
    srand((unsigned)time(0));
    Player p = {"Hero", 100, 100, 12, 3, 0, 1};
    std::cout << "Enter hero name: ";
    std::cin >> p.name;
    std::vector<Enemy> foes = {{"Slime",30,6},{"Goblin",50,9},{"Orc",80,12},{"Dragon",120,16}};
    for (size_t i = 0; i < foes.size(); i++) {
        printStats(p);
        if (!fight(p, foes[i])) break;
        if (i + 1 < foes.size()) { std::cout << "Next battle...\n"; }
    }
    if (p.hp > 0) { std::cout << "\nYOU WIN! Thanks for playing, " << p.name << "!\n"; } else { std::cout << "\nGAME OVER\n"; } return 0; }
