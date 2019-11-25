BPM tempo;

Gain master;
SawOsc voice1 => master;
SawOsc voice2 => master;

master => Echo delay;
delay => Gain feedback => delay;

//

(1.0 / 2.0) / 25.0 => master.gain;

tempo.note / 3 => delay.max => delay.delay;
.2 => delay.mix;

.5 => feedback.gain;

//

function void runArp(int sequence[], dur durations[], dur stepDur) {
    while(true) {
        for (0 => int step; step < sequence.cap(); step++) {            
            sequence[step] => Std.mtof => voice1.freq => voice2.freq;           

            delay => dac;
            durations[step] => now;
            delay =< dac;

            stepDur - durations[step] => now;
        }
    }
}

//

63=> int key;
[
    key,
    key - 1, key - 3,
    key - 5, key - 7,
    key - 8
] @=> int sequence[];
[
    tempo.thirtiethNote,
    tempo.sixteenthNote, tempo.sixteenthNote,
    tempo.sixteenthNote, tempo.sixteenthNote,
    tempo.thirtiethNote
] @=> dur durations[]; // eighthNote in total

spork ~ runArp(sequence, durations, tempo.sixteenthNote);

while(master.gain() > 0.0) {
    master.gain() - .05 => master.gain;    
    tempo.note => now;
}


