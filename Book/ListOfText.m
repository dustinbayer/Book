//
//  ListOfText.m
//  Book
//
//  Created by Dustin Bayer on 2/26/14.
//  Copyright (c) 2014 Dustin Bayer. All rights reserved.
//

#import "ListOfText.h"

@implementation ListOfText



-(NSString *) getText:(NSUInteger) page getPart: (NSUInteger) part
{
    NSString *text = [[NSString alloc] init];
    
    switch (page) {
        case 0:
        {
            switch (part)
            {
                case 1:
                    text = @"\tIn the valley at the foot of the mountain lived a boy named Sebatian. He lived with his mother in a humble house, where the old farming fields met the edge of the forest.";
                    break;
                case 2:
                    text = @"\tSebatian was a lonely boy. He loved his mother, but she was so busy. He did love to draw. He was always drawing. And then there was the forest. He was enchanted by the forest, but he was never allowed to go in.";
                    break;
                    
            }
            break;
        }
            
        case 1:
        {
            
            switch (part)
            {
                case 1:
                    text = @"\tOne afternoon Sebastian sat down at his desk to draw. Today he would draw the tree outside his window up the hill a bit, the big one on the edge of the forest. It seemed like a friend to him. Like another home. 'Great' he thought. 'and I can give it to mom when I'm done' She will love that!’";
                    break;
                case 2:
                    text = @"\tThe tree was in no mood to cooperate moving about in the wind like that. Wild. Wandering. But soon as he drew, his pencil began to find the right line that made a nice trunk that turned and twisted and became a good branch which then flowed into a";
                    break;
                case 3:
                    text = @"maze of still smaller branches. And finally a lovely leaf and another and another and another until Sebastian understood the tree and his drawing was complete. He was proud of his picture. He signed it 'To: Mom, Love Sebastian'.";
                    break;
                
            }
            break;
        }
            
        case 2:
        {
            switch (part)
            {
                case 1:
                    text = @"\tNow his mother had been in the kitchen trying to make dinner and talking on the phone. But now something was wrong. She seemed upset. Her voice became loud and she began walking around waving her hand angrily as she talked on the phone. Sebastian was worried. He didn't like seeing her upset. 'I need to give her my picture' he thought. 'That will make her feel better'.";
                    break;
                    
                case 2:
                    text = @"\tHe hurried into the kitchen and thrust his hand high holding the picture shaking it in front of his mother. But she just ignored him, turned around and walked the other way still upset on the phone. He decided to try again. 'I know, I'll be funny when I give it to her, she likes that!'";
                    break;
                    
                case 3:
                    text = @"\tThis time while she was preparing dinner at the counter, he tried to sneak the picture up from underneath, between her arms and in front of her face. She abruptly stood up and walked away sitting down on the couch.";
                    break;
                case 4:
                    text = @"\tSmiling, Sebastian got up on the back of the couch leaning over his mother’s head and lowered the picture down in front of her face. But she sharply and silently shook her head no at him.  She sat up and walked down the hall still on the phone.";
                    break;
                    
                case 5:
                    text = @"\tNow he was determined. This time he wouldn't be ignored. He pushed a chair up behind the archway in the hall. He waited for her to pass through the arch and when she did he held his hands straight out sticking the picture right in front of her face.";
                    break;
                    
                case 6:
                    text = @"\tNow she was very angry. She violently slapped the picture out of her face tearing the paper. She gasped! 'Oh!' Sebastian froze. His eyes wide. His mouth open. Everything was silent for a moment. Then Sebastian exhaled and a tear ran down his cheek. He felt shaky and his breathing was uneven. Then in an instant he tore up his picture and ran out the back door.";
                    break;
                    
            }

            break;
        }
            
            
        case 3:
        {
            switch (part)
            {
                case 1:
                    text = @"\tHe ran hard all the way through the back field to the end of his property and up the hill to the gate in the stone wall. It was always locked. He caught his breath a moment, took one look back at his home then turned around and jumped over the stone wall.";
                    break;
                    
                case 2:
                    text = @"\tHe walked up to the tree he had always seen from afar, but never touched. He put his hand on the trunk that stretched out and up to form an arch over the path that lead into the forest. He looked into the forest. It was so beautiful. It smelled good, fresh and earthy. It was quiet and peaceful there, but he knew it must be full of life.";
                    break;
                case 3:
                    text = @"\tSebastian began walking up the path. As he walked he looked at everything. The shafts of sunlight streaming down through the trees, the ferns popping out from behind the tree trunks, mushrooms on bark and sneaking up through the ground.";
                    break;
                    
            }
            break;
        }
            
            
        case 4:
        {
            switch (part)
            {
                case 1:
                    text = @"\tThere were wild flowers here and there – white, blue and pink. Around every corner was a new discovery. Little birds and forest bugs and creatures. Even hooting and howls off in the distance.";
                    break;
                    
                case 2:
                    text = @"\tJust then something caught his eye up the trail. It was some kind of animal bounding through the wood. He could only see shadows and could not tell what it was but he had to find out. He ran after the creature as fast as he could.";
                    break;
                case 3:
                    text = @"He ran up the path deeper into the woods, higher up the mountain. There was a mist settling in the woods and it was getting thicker.  He couldn't see much of anything now and lost track of the animal.";
                    break;
            }
            break;
        }
            
        case 5:
        {
            
            switch (part)
            {
                case 1:
                    text = @"\tSo he started walking and he walked for what seemed like some time. But as he came to a plateau and into a clearing, he saw the creature sitting on what looked like the ledge of a cliff. The animal looked right at Sebastian for a moment then turned his head and ran off into the wood.";
                    break;
                case 2:
                    text = @"\tSebastian walked over to the spot where the animal was sitting on a high ledge overlooking a valley. The fog had cleared now and as he looked west, he discovered the most beautiful sunset he had ever seen.";
                    break;
                case 3:
                    text = @"\tHe sat down on the ledge and watched the sun set. The color was amazing and it changed every moment. It was beautiful even as the colors darkened. He wasn't sure how such a thing could be done, but he thought he would love to try and paint this one day. ";
                    break;
                    
            }
            break;
        }
        case 6:
        {
            
            switch (part)
            {
                case 1:
                    text = @"\tAs he sat, his mind felt relaxed. He wandered in his thoughts. Sebastian thought of his mom. He had been too hard on her. He knew how much she loved him. He started to see the first pale glimmer of a star. Now his mom loved stars and as he looked up at that early star, he closed his eyes and he could almost feel her presence.";
                    break;
                case 2:
                    text = @"\tHe opened his eyes to take a quick look around. There was no one there. But as he was looking he suddenly realized it was getting dark and cold and he did not know the way home. He had come in through the fog and now did not recognize anything and didn't know the path back. He was lost and suddenly griped by fear.";
                    break;
                case 3:
                    text = @"\tSebastian looked into the dark wood. He was afraid to go in, but he knew he had to go through the forest to make his way back home. He found a dear trail and began walking.";
                    break;
            }
            break;
        }
        case 7:
        {
            
            switch (part)
            {
                case 1:
                    text = @"\tHe went deeper into the forest. It got darker and hard to see paths he might take. Presently he came to a fork in the trail. Confused as to which way to go, Sebastian became even more anxious. He choose the trail on the right and quickly continued walking. Sebastian started to feel like the forest was not on his side and his fears were bigger than him.";
                    break;
                case 2:
                    text = @"\tHe came out of some overgrowth into a small clearing. Suddenly ‘Caw! Caw! Caw!’ came a sound from the trees. Sebastian jumped! Looking around startled. A murder of crows flew by. He kept walking but with a new quickness in his step.";
                    break;
                case 3:
                    text = @"\tNervously walking through the wood he suddenly saw someone coming at him! Sebastian yelped and jumped back. But the next moment, he realized it was just an old tree with an owl sitting on top. He ducked as the owl flew by.";
                    break;
                case 4:
                    text = @"\tBut by this time he was very scared and began running. Just then a shadow flew by him on the right! It was the creature from the cliff! Now Sebastian feared for his life. He ran as fast as he could. And as he raced down the hill, the creature crossed right in front of his path. He turned to look at the animal not seeing the fallen tree in front of";
                    break;
                case 5:
                    text = @"him. Sebastian tripped! He fell hard crashing to the ground, rolling and rolling down hill till he landed battered on the flat ledge of a cliff. He cowered as he lay on the ground hurt and scared. Sebastian thought certain the creature would attack any second. He was frozen. He heard the animal's footfalls coming closer and closer!";
                    break;
                case 6:
                    text = @"Suddenly it leaped a great distance right over Sebastian! It landed on the forest floor behind him! He heard the rustling of the creature's run fading off in the distance.\n\tSebastian exhaled. He was O.K. The creature was not after him.";
                    break;
                    
                case 7:
                    text = @"\tAnd now a certain calm descended on Sebastian. He had seen the worst of his fears and somehow knew he would be alright. He rolled over onto his back and looked up at the beautiful twilight sky. He never knew how beautiful the night was. ";
                    break;
            }
            break;
        }
        case 8:
        {   
            
            switch (part)
            {
                case 1:
                    text = @"\tHe breathed deeply the cool night air and felt the stillness. Sebastian somehow felt older.\n\tHe lay there on the ground a moment, then Sebastian sat up and looked around. And as he did he noticed a trail of smoke coming from the valley below. He stood up";
                    break;
                case 2:
                    text = @"and walked a little closer to the edge of the cliff. His eye followed the smoke trail down to a little house in the valley. It was his house! He could clearly see his back door and the warm yellow light glowing from his kitchen window. It couldn't have been more than a quarter mile away.";
                    break;
                case 3:
                    text = @"\tSebastian let out a sigh of relief and began walking down the hill. As he got closer to his house he was filled with anticipation and started running.\n\tSebastian burst in though the back door \"MOM!\" Yelled Sebastian. She ran so fast toward him that they collided in a big hug as she picked him up swirling around in circles. He squeezed his mom tight. Safely in her arms.";
                    break;
                    
            }
            break;
        }
        default:
            text = [[NSString alloc] initWithFormat:@"404 Page not found." ];
            break;
    }
    
    return text;
}


-(int) getnumParts:(NSUInteger) page
{
    int numOfParts;
    
    switch (page) {
        case 0:
            numOfParts = 2;
            break;
            
        case 1:
            numOfParts = 3;
            break;
            
        case 2:
            numOfParts = 6;
            break;
            
        case 3:
            numOfParts = 3;
            break;
            
        case 4:
           numOfParts = 3;
            break;
            
        case 5:
            numOfParts = 3;
            break;
            
        case 6:
            numOfParts = 3;
            break;
            
        case 7:
            numOfParts = 7;
            break;
            
        case 8:
            numOfParts = 3;
            break;
            
        default:
            numOfParts = 1;
            break;
    }
    
    return numOfParts;
}

@end
