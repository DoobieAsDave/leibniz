BPM tempo;

Gain master;
SinOsc voice1 => master;
SinOsc voice2 => master;

master => LPF filter => ADSR adsr => dac;

//

(1.0 / 5.0) => master.gain;
1.5 => voice1.gain;
.5 => voice2.gain;

48 => Std.mtof => filter.freq;
3.0 => filter.Q;
.8 => filter.gain;

(30 :: ms, 250 :: ms, 1.0, 150 :: ms) => adsr.set;

//

function void runBass(int sequence[], int notes[], dur stepDur) {
    while(true) {
        for (0 => int step; step < sequence.cap(); step++) {
            if (sequence[step]) {
                notes[step] => Std.mtof => voice1.freq;
                voice1.freq() * .5 => voice2.freq;

                1 => adsr.keyOn;
                stepDur - adsr.releaseTime() => now;
                1 => adsr.keyOff;
                adsr.releaseTime() => now;
            }
            else {
                stepDur => now;
            }            
        }
    }
}

//

[0,  1, 0, 0, 0,  1, 0, 0, 0,  1, 0, 0, 0,  1, 0, 0] @=> int sequence[];
[0, 36, 0, 0, 0, 36, 0, 0, 0, 31, 0, 0, 0, 31, 0, 0] @=> int notes[];

spork ~ runBass(sequence, notes, tempo.halfNote);

//

while(true) second => now;