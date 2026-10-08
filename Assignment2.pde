import javax.swing.JOptionPane;

// Game variables
boolean playing = true;
byte pageNum = 1;
byte loops = 1;

// Event variables
boolean dwFramedAsAliens = true; // Does Darren also think that the DragonWing people are aliens?
boolean dwKnowsCSUs = false; // Does DragonWing know what a CSU is?
boolean dwFriendlyToCSUs = false; // Is DragonWing friendly to CSUs?
boolean rbExpectsDarren = false; // Does RavenBlade expect Darren to emerge from the building?
boolean elevatorBatteryPlaced = false; // Can an emergency battery pack be found on page #18?
boolean storageStickPlaced = false; // Can a Thunderbolt mass storage stick be found on page #8?
boolean recognizesTraps = false; // Does Darren recognize the clamp traps?

void say(String text) {
  println(text + "\n");
  JOptionPane.showMessageDialog(null, text);
}

// It was just a boolean all along...
boolean prompt(String text, String option1, String option2) {
  String response = "";
  byte parsedResponse = 0;
  byte errType = 0;
  
  println(text + "\n");
  
  while (true) {

    // I recognize that this is messy but I don't really have the time to fix it. Prepare to see this a few times, should you actually read this entire file.
    response = Ask.forString((errType == 1 ? "(Type in the number corresponding to the action you wish to perform.)\n\n" : (errType == 2 ? "(Please enter a number that is within the list's bounds.)\n\n" : (errType == 3 ? "(Press \"Cancel\" again to close the game.)\n\n" : (errType == 4 ? "(Please type something.)\n\n" : (errType == 5 ? "(Come on, now. Don't be shy.)\n\n" : ""))))) + text + "\n\n1) " + option1 + "\n2) " + option2);
    
    try {
      if (response.length() == 0) {
        if (errType == 4)
          errType = 5;
        else
          errType = 4;
        continue;
      }
    } catch (NullPointerException e) {
      if (errType == 3)
        System.exit(0);
      else {
        errType = 3;
        println("(Cancel again to close the game.)");
        continue;
      }
    }
    
    try {parsedResponse = (byte) Integer.parseInt(response);} catch (NumberFormatException e) {
      errType = 1;
      continue;
    }
    
    if (parsedResponse < 1 || parsedResponse > 2) {
      errType = 2;
      continue;
    }
    
    break;
    
  }
  
  println("(" + (parsedResponse == 1 ? option1 : option2) + ")\n");
  
  return parsedResponse == 1;
}

// I tried to do more of a choose-your-own-adventure book sort of thing here, so backtracking was possible.
void page(int num) {

  // Switches are conditionals, right?
  switch (num) {
    
    // Start (1)
    case 1:
      say("You awaken from the cryogenic pod after centuries of tranquility.\nIt takes a good moment to get used to being a living being again.\nAside from this, your comfort doesn't appear to be the immediate problem.");
      say("Looking around, it is quite visible that the place has changed. This makes sense; you were told you would be encapsulated for several years,\nthough nobody ever told you specifically how many years it would be.\nGiving the room another proper glance, you realize rather quickly that the building is in ruin.\nWalls are bruised with heavy impacts, tables are flipped, objects are scattered across the ground, lights flicker and die out;\nnone of it was the proper greeting you were promised.");
      say("Eventually, you would slowly leave the cryogenic pod you were in (like the old man you are)\nand begin exploring the tragedy that was this facility.");
      pageNum = 2;
      break;
    
    // First branch (1-2) / (1-2-3-2) / (1-2-4-2)
    case 2:
      if (prompt("[LOOP #" + loops + "]\n\nYou exit the room and walk out to a hallway, where the path splits.\nYou see the words \"the aliens are here\" scratched onto the walls " + (dwFramedAsAliens ? "(that's probably important)" : "(debatable)") + ". Which way do you go?", "Go forward", "Go right"))
        pageNum = 3;
      else
        pageNum = 4;
      break;

    // Going forward (1-2-3)
    case 3:
      if (prompt("Heading forward, you find an elevator. Inside, most of the buttons are worn,\nexcept for two, which both only seem to go deeper into the building. Do you take the elevator?", "Yes", "No"))
        pageNum = 5;
      else
        pageNum = 2;
      break;
    
    // Going right (1-2-4)
    case 4:
      if (prompt("Turning right, you find a dim hallway that seems to turn again later on.\nDo you continue down this path?", "Yes", "No"))
        pageNum = 22;
      else
        pageNum = 2;
      break;
      
    // Entering the elevator (1-2-3-5)
    case 5:
      if (prompt("You notice only when you step into the elevator that it is running on quite low power.\nThere are only two working buttons left. Which do you press?", "3B", "5B")) {
        say("The elevator takes you down to floor 3B. When the doors open, the elevator abruptly loses all power,\nthe doors halting movement and the lights turning off.\nYou squeeze through the ajar elevator doors.");
        pageNum = 6;
      } else
        pageNum = 7;
      break;
      
    // Floor 3B (1-2-3-5-6)
    case 6:
      if (prompt("You are now on floor 3B. They entire floor is littered with lone computer parts, most broken.\nSomething or someone clearly ravenged the place, likely " + (dwFramedAsAliens ? "those aforementioned aliens" : "DragonWing") + ".\nThrough the pig sty, however, you spot one desktop computer that is still in usable condition. What do you do?", "Wander about", "Investigate the computer"))
        pageNum = 8;
      else
        pageNum = 9;
      break;
    
    // On the way to floor 5B (1-2-3-5-7)
    case 7:
      if (prompt("While taking the elevator down to floor 5B, the elevator abruptly stops moving and loses all power. What do you do?", "Attempt to fix the elevator", "Look for an exit in the elevator"))
        pageNum = 18;
      else
        pageNum = 19;
      break;
    
    // Wandering around floor 3B (1-2-3-5-6-8)
    case 8:
      if (storageStickPlaced) {
        say("You find a flash drive on the floor.\nYou pick it up and plug it into the computer in the other room.");
        say("It immediately begins copying a whole ton of files to the flash drive.\nFrom behind, two people enter the room.\n\"Thank you for your assistance. We have finally received what we came for, thanks to you.\"\n\n[True Ending (congrats!)]");
      } else {
        pageNum = 6;
      }
      break;
    
    // Investigating the operable computer (1-2-3-5-6-9)
    case 9:
    say("You move over to the increasingly conspicuous desktop computer, and test if it is still operational.\nSurprisingly, it is still fully unharmed and functional.");
    say("Prepared to be met with a password screen, you turn on the computer.\nInstead, the computer wakes up almost immediately at a file browser window containing various documentations for subjects.\nThankfully, the employee who used this computer did not turn off the computer before they left it.\nAgain, likely because of " + (dwFramedAsAliens ? "those aliens" : "DragonWing") + "...");
      if (prompt("You snoop around in the file browser, but only find two directories that directly interest you.\nWhich do you read about first?", "Reimei and their experiments", "Team RavenBlade and their encounters with DragonWing"))
        pageNum = 10;
      else
        pageNum = 11;
      break;
    
    // Reading about Reimei (1-2-3-5-6-9-10)
    case 10:
      say("You search through the files in relation to Reimei.\nThere's a lot of new things that has happened to them, though what specifically seemed to get more and more ambiguous the deeper you look."); // What happens next will SHOCK you. Like and subscribe for a cookie
      say("Eventually, you come across some files in relation to you, even after all this time. You decide to open them.");
      say("You scan through the document (singular). Most of the information, you were already aware of.\nHowever, what you didn't know was that you were the only CSU to exist.\nThat was very strange considering that it was implied you were one of many who would volunteer.");
      pageNum = 12;
      break;
      
    // Reading about DragonWing (1-2-3-5-6-9-11)
    case 11:
      say("You search through the files in relation to Team RavenBlade and DragonWing.\nThere is a lot of new information, such as Team RavenBlade being integrated into the federal military, RavenBlade's disbandment with Reimei,\nand, possibly the most relevant, DragonWing.");
      say("At some point in time, quite recently, a large group mirroring Team RavenBlade would lapse into existence through unknown means.\nIt is suspected that they have time-travelled to this era, though it is unclear what they want or what they are trying to accomplish.\nThey have been dubbed DragonWing, for that was what they overheard one of these people call their organization.");
      say("You debate whether these people are aliens or not."); // This is the best I got
      dwFramedAsAliens = false;
      pageNum = 12;
      break;
    
    // Alien intrusion on 3B (1-2-3-5-6-9-10-12) / (1-2-3-5-6-9-11-12)
    case 12:
      say("People suddenly lapse into existence. " + (dwFramedAsAliens ? "Are they the aliens?" : "Is it DragonWing?"));
      say("One of them suddenly attacks you...\n\n(Luck-based outcome...)");
      pageNum = 13;
      break;
      
    // Alien battle on 3B (12-13)
    case 13:
      if (random(1, 2) == 1) {
        say("They attack you successfully, though you retaliate and\nattack them quicker than they expected you to.");
        pageNum = 14;
      } else {
        say("They miss their attack, so you attack them back.");
        pageNum = 14;
      }
      break;
    
    // Aliens defeated on 3B (12-13-14)
    case 14:
      say("(Pretend a whole fight happened here)");
      say("After taking out the pursuers, you find yourself inspecting them.\nYou find a particularily interesting device (among some others) that's use is unknown.");
      say("Having nothing better to do, you attempt test the device...");
      say("...");
      say("After figuring out how to properly handle the device, you slide its switch, place it on the ground,\nstep away, and test the device...");
      say("You watch as, above it, a strange convenient one-way door-shaped entrance is created above the object.");
      say("Again, having no other option aside from perhaps lying on the ground in a fetal position,\nyou decide to step through the doorway.");
      pageNum = 15;
      break;
      
    // Travelled to second 4D plane (12-13-14-15) / (1-2-3-5-7-19-20-21-15)
    case 15:
      say("You step through the gateway, and down onto a vast smooth concrete platform.\nThe platform feels unsteady when you step on it.");
      say("You look around yourself and quickly notice that you are in a completely different setting.\nYou are on a flying platform with a large artificial ozone containing not only the platform,\nbut the even vaster space around it that seems to stretch out for miles.");
      say("Just outside this ozone is outer space, quite literally.\nHowever, it's quite different than what you would have expected it to be.\nDifferent planets, different alignments, different suns, different things flying around...");
      say("While you observe the new area around you with utmost confusion and fascination,\nthe dimensional gateway you stepped through earlier closes.");
      say("Shortly after, you hear two voices conversing with each other quietly in the distance, thanks to your artificial abilties.\nYou look over to where the noise is coming from, and you see two people looking over at you,\nwho promptly stop speaking when they see you look back at them.");
      if (prompt("These people are clothed exactly like the people you had defeated earlier.\nDo you stay here and continue to assess the area around you, or do you approach them?", "Continue observing", "Approach them"))
        pageNum = 16;
      else
        pageNum = 17;
      break;
      
    // Dismiss the onlookers on the second 4D plane (15-16)
    case 16:
      say("You dismiss the two for now, continuing the process of trying to understand where you have put yourself.");
      say("One of the two hesitantly waves at you, in which you return the gesture.");
      say("Shortly after, the two of them start walking towards you. When they reach you, the one that had waved begins speaking.");
      say("\"What the heck is that thing?\" says the one who had waved to the person beside them.");
      say("\"I... have no clue.\" says the other.\n\"But, you know how our boss is. We've gotta take it in for research.\"");
      say("\"Right.\" says the first.\n\"...\"\n\"...\"\n\"...\"\n\"I think we should get the others.\"\n\n[Ending #1]");
      dwKnowsCSUs = true;
      dwFriendlyToCSUs = true;
      rbExpectsDarren = false;
      playing = false;
      break;
    
    // Approach the onlookers on the second 4D plane (15-17)
    case 17:
      say("You begin walking towards the two.\nDespite your calmness, this causes the two to panic, making them retreat and call for assistance.\nThis means they left you alone for some amount of time, but when more people returned, they weren't quite as docile.\n\n[Ending #2]");
      dwKnowsCSUs = true;
      rbExpectsDarren = false;
      playing = false;
      break;
      
    // Attempt to fix the shut down elevator on the way to 5B (1-2-3-5-7-18)
    case 18:
      if (elevatorBatteryPlaced) {
        say("You find a battery of some sort. It has a cable attached.\nIt takes you some time, but eventually, you find a way to connect it to the elevator.\nThe process was not fancy.");
        say("The door promptly finishes opening. You step inside.");
        say("Everything around the room is destroyed and inaccessible,\ndue to the state of ruin this place is in.\nWhat you do find is a flash drive. You attempt to pick it up, but it slips out of your hands and into a vent.\nWhen you drop the flash drive, you swear you could hear the word \"magnificent.\"\n\n[Ending #8]");
        elevatorBatteryPlaced = false;
        storageStickPlaced = true;
        playing = false;
      } else {
        say("You do not find anything to fix the elevator with.");
        pageNum = 7;
      }
      break;
    
    // Look for an exit in the shut down elevator on the way to 5B (1-2-3-5-7-19)
    case 19:
      say("You find a vent at the top of the elevator, so you detach it and climb through it.\nLooking around, you find another vent on a wall, take it down, and crawl into it as well.");
      say("As you navigated through the arguably large ventilation system, it sudddenly collapsed,\nlanding you clumsily in the middle of floor 5B.");
      say("You would immediately notice the unfamiliar group of people that were conversing in the same room you happened to land in.\n" + (dwFramedAsAliens ? "" : "DragonWing, perhaps?\n") + "Intriguingly, one would attempt to shoot you, though you swiftly dodged the shot.\nThe firearm was clearly quite more advanced and comically futuristic than anything you were used to seeing.");
      say("You noticed that this room specifically used to be an armory, a fact that was made quite conspicuous\nby the weapons that clothed the room's walls.\nSo, you take quick action to grab a weapon for yourself.");
      pageNum = 20;
      break;
    
    // Alien battle on 5B (1-2-3-5-7-19-20)
    case 20:
      say("(Pretend a battle happened here)");
      pageNum = 21;
      break;
    
    // Aliens defeated on 5B (1-2-3-5-7-19-20-21)
    case 21:
      say("With all enemies in sight paralyzed, you finally set the weapon down.\nNow that the battle has ended, you look around the room more extensively and notice that the exit has been barricaded.");
      say("After some more investigation, you conclude that there isn't much that is interesting in this room\nother than the people you have paralyzed. Promptly, you inspect them.");
      say("On one of them, you find a particularily interesting device (among others) that's use is unknown.");
      say("Having nothing better to do, you attempt test the device...");
      say("...");
      say("After figuring out how to properly handle the device, you slide its switch, place it on the ground,\nstep away, and test the device...");
      say("You watch as, above it, a strange convenient one-way door-shaped entrance is created above the object.");
      say("Again, having no other option aside from perhaps lying on the ground in a fetal position, you decide to step through the doorway.");
      pageNum = 15;
      break;
    
    // Going down the hallway (1-2-4-22)
    case 22:
      say("You begin walking down the hallway.\nOn the way, you notice a device with sharp features that seems out of place in this building.");
      if (recognizesTraps) {
        say("You carefully evade triggering the device in case it is dangerous.\nThe device thankfully doesn't seem to notice this, and you pass by it unharmed.");
        pageNum = 25;
      } else {
        if (prompt("Unlike the damaged environment around the device, the device seems to be in good condition.\nOn further inspection, it still has energy.\nWhat do you do?", "Inspect it", "Leave it"))
          pageNum = 23;
        else
          pageNum = 24;
      }
      break;
    
    // Approaching the strange device (1-2-4-22-23)
    case 23:
      say("You approach the device. The second you get close enough to it,\nthe device seems to spring into a more ready stance with its sharp leg-adjacent appendages.");
      say("Promptly, you quickly dash to the side in case of danger.\nThis would be a good choice as the device would leap at where you just were, the sharp\nappendages clamping where your skin would have been.");
      say("After that strange volatile encounter, you progress onwards.");
      recognizesTraps = true;
      pageNum = 25;
      break;
    
    // Ignoring the strange device (1-2-4-22-24)
    case 24:
      say("You try to walk past the device. However, when the device senses that you were within good range,\nit would change its stance into a more threatening one with its sharp leg-adjacent components.");
      say("You notice this subtle shift, and look back at the device.\nWhen you do that, the device leaps at you. You quickly move to the side to avoid it,\nwatching as its sharp legs clamp where you would have been if you hadn't moved.");
      say("After that strange volatile encounter, you progress onwards.");
      recognizesTraps = true;
      pageNum = 25;
      break;
    
    // Finding the trap field (1-2-4-22-25) / (1-2-4-22-23-25) / (1-2-4-22-24-25)
    case 25:
      say("You reach the end of the hallway and turn.\nThe room ahead is large, but most notably, it is littered with the traps you had encountered just earlier.");
      say("(For this section, reach the bottom-right\ncorner and advance downwards to progress.)");
      pageNum = 26;
      break;
    
    // Trap field (25-26)
    case 26:
      say("(Pretend a cool mine-navigation type thing happened here.\nI have the game, I just couldn't implement it)");
      pageNum = 27;
      break;
    
    // Past the trap field (25-26-27)
    case 27:
      say("You successfully pass the field of devices.");
      say("You progress onwards, finding a long staircase upwards to a more well-lit area...");
      say("You reach the top of the staircase or, what would have been\nhalfway through the staircase as it abruptly stops, the rest clearly having been destroyed.");
      say("The building from this point is completely destroyed. There is no roof above you.\nThe stairs end near the vast remains of the obliterated building.\nNot too far out, there is grass. You are outside the building.");
      say("Looking around, you can see why this place is as in bad of a condition as it is.\nYou're in the middle of a battlefield. There are heavy weapons to be found everywhere; tanks, jets, stealth bombers, artillery,\nand many more things that you couldn't possibly identify.");
      if (dwKnowsCSUs && rbExpectsDarren) {
        say("In the distance, you see someone waving at you, beckoning you.\nShortly after, one of the " + (dwFramedAsAliens ? "alien" : "DragonWing") + " cruised past you and drifted to block the way of this distant individual.");
        dwFramedAsAliens = false;
        if (prompt("A door opens on the tank, and someone's head peeps out.\n\"Salutations. We are DragonWing.\" the person says.\n\"Come with us. We have something important to show you.\"\nWhat do you do?", "Go with DragonWing", "Don't"))
          pageNum = 33;
        else
          pageNum = 34;
      } else {
        if (prompt("It is clear that there are two sides fighting each other (most likely the government and " + (dwFramedAsAliens ? "those aliens" : "DragonWing") + ").\n" + (rbExpectsDarren ? "You see someone waving with both arms at you in the distance in the direction\nof the city's military  . " : "") + "Do you retreat to your city's side, or do you advance towards the enemy?", "Retreat", "Advance"))
          pageNum = 28;
        else
          pageNum = 29;
      }
      break;
    
    // Retreat from DragonWing (25-26-27-28)
    case 28:
      say("You rush over to the side of the field that looks marginally more like Team RavenBlade.\nYou keep your head low as you do so, because of all of the dangerous heavy equipment not too far away from you.\nYou watch as a plane on your side gets shot at. The plane seems very agile, though when a shot collides with the glowing core at the center of the aircraft,\nsaid aircraft suddenly explodes into a ton of pieces, many of which penetrated some of the enemy's aircrafts, interestingly enough.");
      if (prompt("Someone, armored, jogs up to you. Their face is obscured by a helmet, but otherwise they don't seem threatening.\n" + (rbExpectsDarren ? "\"Darren! Over here!\" the person yells. They catch up to you.\n\"I can't believe they were right! You really did escape the building!\" they say quite cheerfully, despite their intimidating armor.\n\"Anyways, I need you to follow me. If you don't mind.\"" : "\"D-" + loops + "! Why... how in the world are you out of containment? Did they finally complete you? No, wait, that wouldn't make any sense. It's been...\"\nThey disregard their sentence and finally catch up to you.\n\"My questions don't matter right now anyways.\"\nThey do some sort of weird hand gesture.\n\"I'm with Team RavenBlade. You are too. You have been for... longer than any of us, technically. Follow me, quickly. If you please.\"") + "\nWhat do you do?", "Follow them", "Don't follow them"))
        pageNum = 30;
      else
        pageNum = 31;
      break;
    
    // Advance to DragonWing (25-26-27-29)
    case 29:
      say("Bravely, you make your way towards the enemy, running past various tanks and cannons.\nSurprisingly, you make it to where many of the " + (dwFramedAsAliens ? "aliens" : "DragonWing people") + " are unharmed.\nHowever, these people notice you the second you notice them.");
      say("The victory was short-lived, as one of them would shoot you with an electric paralyzer,\nrendering yourself basically defeated.\nThey would then drag you into a strange hyperdimensional gateway of sorts and interrogate you there.\n\n[Ending #5]");
      dwKnowsCSUs = true;
      playing = false;
      break;
    
    // Follow the RavenBlade guy (25-26-27-28-30) / (25-26-27-28-31-30)
    case 30:
      say("You follow the soldier. They lead you to a much larger group of people with similar equipment and clothing.\nA few of these people stand out from the rest, presumably because of their militant role.\nThe soldier presents you to one of the visibly higher-ranking individuals.");
      if (rbExpectsDarren) {
        say("\"General. The team was right about D-" + loops + ".\" the soldier says.\nThe General in question turns to look at you.\n\"That is so.\" the General says, in a surprised tone that you would suspect is unsual from one with such a role.\n\"Come with us. We'll show you everything that's happened so far.\"\n\n[Ending #3 (Alternate)]");
      } else {
        say("\"General! You won't believe who made it out of our research tower!\" he said, clearly excited to some extent.\n\"Ajay, what could it--\" the General says, but quickly interrupts themselves.\n\"...D-" + loops + "? Already?!\""); // Not that it was that difficult
        say("The General continues.\n\"I... I know this isn't exactly the time, but I can't tell you how sorry we are for all of this. This couldn't have possibly been what you were meant to face!\"\nThey stop to ponder for a moment. The loud sounds of the artillery in the distance don't seem to distract them.\n\"Here. We need to take you in. We'll get you set up with all the equipment as of late. This won't work.\"\nThe General gestures towards some of your integrated equipment. Others are beginning to notice your presence, though they're on duty.");
        say("The General continues.\n\"We'll get you caught up on everything that has happened recently.\nThen, well, I see great potential in what you could do for what you could do for your city, Darren.\"\nGetting called by your authentic name was oddly unnatural; you forgot you even had one.\n\"It's best if we start immediately. I'll notify the others right now.\"\n\n[Ending #3]");
      }
      rbExpectsDarren = true;
      playing = false;
      break;
    
    // Don't follow the RavenBlade guy (25-26-27-28-31)
    case 31:
      if (prompt("The soldier walks a few meters before realizing that you aren't keeping up with them.\n\"What, are you just going to stand there?\" they inquire.", "Yes", "No"))
        pageNum = 32;
      else {
        say("\"Okay, you weirdo.\"\nThe two of you resume your walk.");
        pageNum = 30;
      }
      break;
    
    // Continue not following the RavenBlade guy (25-26-27-28-31-32)
    case 32:
      say("\"Oh.\"\nYour stubbornness seems to catch the soldier off guard.\n\"Well, uh... I can't really just move you places. I don't even know why you would want to stay here.\"\nYou continue to stay still.\n\"...\"\nI don't know how to conclude this. Here's an ending.\n\n[Ending #4]");
      rbExpectsDarren = true;
      playing = false;
      break;
    
    // Embark on the tank with DragonWing (25-26-27-33)
    case 33:
      say("\"Excellent.\" says the person quite simply. They promptly open the door further so you can enter.");
      say("When you get inside the tank, you notice that there is only one other person in the tank,\naside from who you were just speaking to.\n\"You got him in! Perfect.\" they say, moreso directed at the other person.\n\"We don't have a lot of time to explain ourselves, but we'll do with what we have.\" they continue, now fully talking to you.");
      say("\"We, DragonWing, have access to time travelling equipment.\nIt allows us to travel between timelines that are undergoing different points in time,\nbut we can't travel to different points in the timelines themselves. If that makes sense.\" they attempt to explain.\n\"The timelines are torrents of water. We only jump in where the water happens to be.\" the other says.\n\"Yeah. We just need to find the right... torrent of water to jump into when we want to get to a certain point.\"");
      say("They continue.\n\"There are many of these timelines. Countless. Literally countless.\nEvery instance of time, the smallest instance you can think of, practically an infinite amount of timelines are created deriving from just one. Then the process repeats, every micro-instance of time.\"\n\"We are in an ocean of torrents. It may take time to find the right path.\" says the other.\n\"...well, kind of. That analogy... nevermind.\"");
      say("They continue.\n\"The point is, we need you (yes, you) to go to an alternate timeline and\nplace this battery right where you appear. Understood?\"\nThey hold a strange battery pack with a cable attached to it.");
      say("They don't wait for your response; they are short on time after all.\nThe individual grabs something from their belt and places it on the ground. A hyperdimensional gateway spawns above it.\n\"Here you go. Just go in, put the battery there, and get out.\""); // "they are short on time after all" <- Symbolism?
      say("The process is actually as short as they describe.\nYou go in, deploy the battery, and exit.");
      say("\"Magnificent.\" the other says.\n\"Magnificent is correct,\" says the former instructor.\n\"That's all we needed from you. We just thought it would be interesting if you were responsible for helping yourself in another timeline.\"\n\n[Ending #6]");
      playing = false;
      break;
    
    // Reject the DragonWing tank team (25-26-27-34)
    case 34:
      if (prompt("\"Please. We have scarse options at our disposal.\"", "Yes", "No"))
        pageNum = 33;
      else
        say("\"Very well...\"");
        pageNum = 35;
      break;
    
    // DragonWing tank legitimately ditches you (25-26-27-34-35)
    case 35:
      say("The tank drives off, leaving you in the middle of the battlefield again.\nHowever, now, the field's attention has been placed on you, making you an easy target.\n\n[Ending #7]");
      playing = false;
      break;
    
    default:
      say("(Internal error: Bad page number)");
      System.exit(0);

  }

}

// I just realized that all of this could fall under "unnecessary code" in the rubric.
// Why didn't I just take the time to come up with a shorter story?

void setup() {
  // Shove the Processing window aside and hide it
  surface.setLocation(-10000, -10000);
  surface.setVisible(false);
  
  // Quick tutorial
  say("Quick tutorial:\n\nWhen presented with a list of options, type the corresponding number of the action you wish to perform in order to choose that option.\nPressing \"Cancel\" twice in a row at any time will close the game.\nSome of the events in this game depend on what endings you have already achieved.\nThis memory is cleared when the game is properly closed (if you see this tutorial again, the game has forgotten).\nGenerally, press \"OK\" to advance dialogue.");
  say("Everything presented to you is also printed into the console, so you may refer to that should you miss a piece of dialogue.");
  say("Also, if you don't recognize a name or don't understand why a certain concept is present,\nthe story in the provided Word document may help, but reading it or even understanding\nwhat's going on in this game won't remotely provide any long-term benefits by any means.\nSo, do as you wish.");
  say("I recognize that this is a pretty big project despite what you asked for.\nPlease, still grade it according to the rubric and not according to my efforts.\nThe amount of time I put into this is entirely my fault.");
  say("One last thing, I apologize if the story is really goofy or doesn't make any sense.\nI was almost delirious the whole time I made this.\nThat, and this story is genuinely quite difficult to explain without the use of visuals of any kind.");
  say("Sorry. The game will start now.");
  
  // Main game
  while (true) {
    while (playing) {

      // I change the pageNum variable in the page() method rather than calling the page() method again to avoid potential stack overflows.
      page(pageNum);
  
    }
    
    if (prompt("The game has ended. Would you like to play again?", "Yes", "No")) {
      say("Okay, let's get to it, then.");
      playing = true;
      loops++;
      pageNum = 2; // To skip the introduction
      continue;
    } else {
      say("Understandable. Thank you for playing.");
    }
    
    System.exit(0);
  }
}

// I am failing this class
