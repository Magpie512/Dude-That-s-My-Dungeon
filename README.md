# **Dude, That’s My Dungeon**

**The ultimate "Friendship Ending" simulator.**

After years of rule-breaking, derailment, and "creative" solutions, the Dungeon Master has finally snapped. He's pulled his only friends into a  tabletop one shot of their nightmares to prove that the House always wins. 

**Dude, That’s My Dungeon** is a 1v3 asymmetric dungeon crawler. One player takes the role of the malevolent **Dungeon Master**, playing a high-stakes RTS from a top-down perspective deploying his mini(on)s, traps, and new found board pieces, while three **Dorks** (Tank, Healer, and Damage dealer) try to survive in a first-person horror-comedy experience.

---

### **Game Features**

* **Asymmetric Perspectives:** While the Dungeon Master enjoys a tactical "God View" of the entire map, the players are trapped in a claustrophobic first-person perspective.
* **Live Dungeon Editing:** As the DM, spend points to live-edit the map. Swap a treasure chest for a Mimic, drop a boulder on the Party's Tank, or physically slide a hallway ten feet to the left to separate the party.
* **The Dork Trinity:**
    * **The Tank:** Body-block summons and "well, actually" the dungeon's physics to ignore trap damage.
    * **The Healer:** Manage health bars and sanity while frantically screaming at everyone to stay in the healing circle.
    * **The Damage:** A "Min-Maxer" glass cannon who can delete bosses but constantly walks into spike traps while reading item flavor text.
* **Metagame Eavesdropping:** The DM can hear the players' proximity voice chat.
* **Rule Disputes:** Trigger high-speed "button-mash" arguments over the game manual. If the players win, they might get loot, if the DM wins, he gets to win some more salt points, which unlock more tiles, tools, monsters, and cosmetics.
* **Appearance:** The players can constantly see the game master looking over them as they play inside of his game. 

---

### **Technical Overview (GitHub)**

* **Engine:** Godot
* **Networking:** Integrated proximity-based VoIP with a "DM Listener" hook.
* **State Management:** Real-time synchronization between the top-down RTS interface and the first-person action clients.
* **Procedural Spite:** A dynamic navmesh system that allows the DM to move walls and floors without breaking AI pathing.