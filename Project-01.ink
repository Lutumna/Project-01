/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/


VAR time = 0 //  0 Morning, 1 Noon, 2 Night
VAR health = 3
VAR ammo = 1
VAR weapon = ""
VAR fuses = 0
VAR acid_cerberus = 2
VAR fungal_minotaur = 1
VAR visor = 0
VAR strength = 0
VAR agility = 0
VAR precision = 0
VAR knife = 0
VAR cowl = 0
VAR rifle = 0
VAR shotg = 0
VAR rev = 0

-> Preparation

-> split_path

=== Preparation ===
Before you lies a fork in the road. You decide which weapon and combat style to prepare. The outlaw provides agility, the fiend provides strength, and the Desperado provides precision.

*[Revolver: Acrobatic Outlaw Class]
    ~ weapon = "Revolver" 
    ~ agility = agility + 1
    -> split_path
*[Shotgun: Fiend Class]
    ~ weapon = "Shotgun" 
    ~ strength = strength + 1
    -> split_path
*[Lever-Action Rifle: Desperado Class] 
    ~ weapon = "Lever-Action Rifle" 
    ~ precision = precision + 1
    -> split_path


== split_path ==
You must choose your path. The crypt is unkown territory and is pitch black. The badlands aren't as dark, but are known for the abominations that reside there. {not fuse_pickup:There is a fuse on the floor.}

Are you sure the {weapon} is the right decision?

You have {fuses} fuses

+ [Take the crypt] -> crypt
+ [Take the badlands] -> badlands
* [Pick up the fuse charge] -> fuse_pickup
+ [Go Back] -> Preparation

== crypt ==
You are in the crypt. It is very dark, you can't see anything. {weapon == "Shotgun": You feel sorry for the creature that dares to cross you.| }  
* {fuses > 0} [Use fuse] -> crypt_lit
+ [Go Back] -> split_path
-> END

== badlands ==
You have {not chimera_loot:wandered into} {chimera_loot:returned to} the badlands... good luck... Its { advance_time() }
{weapon == "Revolver": A revolver in the badlands... old faithful.| }
+ [Go set up camp in the woods] -> camp_site
+ {camp_fuse_pickup} {not chimera_loot} [Go scavenging] -> deep_badlands
+ [Go Back] -> split_path
-> END

=== fuse_pickup ===
~ fuses = fuses + 1
You now have a fuse charge. It can provide a momentary burst of light.
* [Go Back] -> split_path
-> END

== crypt_lit ==
You send out a burst of light with your fuse it won't last very long. Suddenly, you see an ammo stash and an exit path!
* [Go for exit] -> Fight
* [Loot ammo] -> ammo_loot
-> END

=== ammo_loot ===
~ ammo = ammo + 1
You now have {ammo} shots. This will aid in putting down monsters. You also stumble upon a data chip. It can upgrade one of your stats.
* [Increase Precison Stat] -> crypt_lit
    ~ precision = precision + 1
* [Increase Strength Stat] -> crypt_lit
    ~ strength = strength + 1
* [Increase Agility Stat] -> crypt_lit
    ~ agility = agility + 1
-> END

=== Fight ===

As you go for the exit you see two mutants blocking the way. {ammo_loot: Choose which one to take out.} One is a cerberus drooling acid from each of its heads. The other, a minotaur that seems to be emmitting toxic cloud of spores. {ammo < 2: You only have enough ammo to defeat the fungal minotaur.}
* {ammo > 1} [Shoot the Acid Cerberus] -> AC_End
* {ammo > 0} [Shoot the Fungal Minotaur] -> FM_End
* {agility >= 1 || strength >= 1} [Kill Both] -> Both_End

== Both_End ==
~ health = health + agility
~ knife = knife + 1
You kill each of the abominations that block your path. With the minotaur's hide and the cerberus's fangs you create a knife. You have {health} health remaining. You continue your journey in hopes of finding an outpost.
* [Go to outpost in the morning] -> outpost

== AC_End ==
~ health = health - fungal_minotaur + agility
You barley escape with your life you have {health} health remaining. You continue your journey in hopes of finding an outpost.
* [Go to outpost in the morning] -> outpost

== FM_End ==
~ health = health - acid_cerberus + agility
You barley escape with your life you have {health} health remaining. You continue your journey in hopes of finding an outpost.
* [Go to outpost in the morning] -> outpost

== camp_site ==
You find a secluded area to set up camp. {not camp_fuse_pickup: You'll need another fuse to ignite a camp fire.} {deep_badlands: After your excursion, you need rest.} Its { advance_time() }
* [Go find fuse] -> camp_fuse_pickup
+ {fuses < 2} [Retrace your steps to find a fuse] -> badlands
+ {camp_fuse_pickup} {not chimera_loot} [Venture back into the badlands] -> badlands
+ {(fuses > 1) && (time > 0)} [Start fire and end night] -> camp_end

=== camp_fuse_pickup===
~ fuses = fuses + 1
You now have a fuse charge. It can help ignite a campfire. You also stumble upon a data chip. It can upgrade one of your stats.
* [Increase Precison Stat] -> camp_site
    ~ precision = precision + 1
* [Increase Strength Stat] -> camp_site
    ~ strength = strength + 1
* [Increase Agility Stat] -> camp_site
    ~ agility = agility + 1
-> END

=== deep_badlands ===
    ~ ammo = ammo + 1
Its { advance_time() }. As you find ammo, You see a chimera in the distance. It carries the gear of slain vagabonds as a warning. That gear may be of value.
+ [Return] -> badlands
* {ammo > 1 && precision >= 1} [Take the shot] -> chimera_loot
* {weapon == "Shotgun" || agility >= 1} [Charge the Chimera and blast it] -> chimera_loot

== chimera_loot ==
~ ammo = ammo + 2
~ visor = visor + 1
You let a round fly and it whistles before is strikes the chimera's neck. It locks eyes with you as it gives its last roar. The spoils are yours for the taking. You find two rounds of ammunation and a strange visor that highlights targets.
* [Start venturing back] -> badlands

== camp_end ==
You sleep through the night with a fire to scare the mutants.
* [Go to outpost in the morning] -> outpost

== outpost ==
You finally make it to an outpost. You need to find a contract to get some credit. You see a bounty board. There is a bounty available. A vengeful harpy that is the result of a horrible experiment. Before you set out, you find a data chip.
* [Increase Precison Stat] -> hunt
    ~ precision = precision + 1
* [Increase Strength Stat] -> hunt
    ~ strength = strength + 1
* [Increase Agility Stat] -> hunt
    ~ agility = agility + 1

== hunt ==
You spot the harpy flying in a circle around an abandoned tower. {weapon == "Lever-Action Rifle" && visor >= 1: You have a visor that increases your precision and a Rifle. With this combination you can attack from afar. One clean shot.} {visor >= 1: You have more precision thanks to that visor you found.} {knife >= 1: The knife you fashioned can act as a strong opening attack.} Remember your weapon of choice is a {weapon}.
* {weapon == "Lever-Action Rifle" && visor >= 1} [One Shot, One Kill] -> h_end
* {weapon == "Revolver" && visor >= 1 && precision >= 1} [Target the vitals and fan the hammer] -> h_end
* {weapon == "Shotgun" && visor >= 1 && agility >= 2} [Bait the Harpy and unload a shell in its chest] -> h_end
* [Fight the harpy] -> f_end
* {knife == 1 && precision > 1} [Throw the knife at the harpy's wings, the fall will do the rest.] -> h_end

== h_end ==
You've slain the harpy and can return it for some credits. {knife >= 1: With your knife you could harvest some of the harpy's feathers and talons.}
* {knife >= 1} [Harvest materials and turn in] -> end_end
    ~ cowl = cowl + 1
* [Turn in the bounty] -> end_end

== f_end ==
You've slain the harpy and can return it for some credits. You somehow managed to survive this time. {knife >= 1: With your knife you could harvest some of the harpy's feathers and talons.}
* {knife == 1} [Harvest materials and turn in] -> end_end
    ~ cowl = cowl + 1
* [Turn in the bounty] -> end_end

== end_end ==
You get your credits and venture off into the distance and continue your journey. {cowl > 0: The remains of the harpy are used as a cowl to act as proof of your metal.}
-> END

== function advance_time ==

    ~ time = time + 1
    
    {
        - time > 2:
            ~ time = 0
    }    
    
    {   
        - time == 0:
            ~ return "high noon"
        
        - time == 1:
            ~ return "evening"
        
        - time == 2:
            ~ return "midnight"
    
    }
    
    
        
    ~ return time