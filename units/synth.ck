BPM tempo;

Gain master;
SawOsc voice1 => master;
SinOsc voice2 => master;
SawOsc voice3 => master;
SinOsc voice4 => master;

TriOsc accent;

master => ADSR adsr => NRev reverb => Pan2 stereo => dac;

//

.75 => voice1.gain => voice2.gain => voice3.gain;
.5 => accent.gain;
(1.0 / 25.0) => master.gain;

(tempo.halfNote, 250 :: ms, .8, tempo.halfNote / 3) => adsr.set;

.01 => reverb.mix;

//

float stereoPan;

function void modStereo(Pan2 stereo, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => stereo.pan;
    
    while(true) {
        stereoPan => stereo.pan;
        step +=> stereoPan;        

        if (stereoPan >= max) {
            amount * -1 => step;
        }
        else if (stereoPan <= min) {
            amount => step;
        }

        modTime / steps => now;
    }
}

function void runSynth(int sequence[], int harmony[], dur stepDur) {
    while(true) {
        for (0 => int step; step < sequence.cap(); step++) {
            setADSR();

            sequence[step] => Std.mtof => voice1.freq;
            sequence[step] + 7 => Std.mtof => voice3.freq;
            sequence[step] - 12 => Std.mtof => voice4.freq;

            if (harmony[step]) {
                sequence[step] + 4 => Std.mtof => voice2.freq;                
            }
            else {
                sequence[step] + 3 => Std.mtof => voice2.freq;                
            }

            // trigger adsr
            1 => adsr.keyOn;            
            (stepDur * .75) - adsr.releaseTime() => now;

            if (harmony[step]) {
                sequence[step] + 11 => Std.mtof => accent.freq;                
            }
            else {
                sequence[step] + 10 => Std.mtof => accent.freq;                
            }
            accent => master;
            stepDur * .25 => now;

            1 => adsr.keyOff;
            adsr.releaseTime() => now; 
            accent =< master;
        }
    }
}
function void setADSR() {
    tempo.note / Math.random2(1, 4) => adsr.attackTime;
    Math.random2(200, 500) :: ms => adsr.decayTime;
    Math.random2f(.6, 1.0) => adsr.sustainLevel;
    tempo.halfNote / Math.random2(1, 4) => adsr.releaseTime;
}

//

60 => int key;
[key, key - 5] @=> int sequence[];
[0, 0] @=> int harmony[];

spork ~ modStereo(stereo, tempo.note / 1.5, -.3, .5, .01);
spork ~ runSynth(sequence, harmony, tempo.note * 4);

//

while(true) second => now;