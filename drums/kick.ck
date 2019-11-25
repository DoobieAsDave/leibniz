BPM tempo;

SndBuf kick => dac;

me.dir(-1) + "audio/kick.wav" => kick.read;
kick.samples() => kick.pos;

.8 => kick.gain;

//

function void runKick(int sequence[]) {
    while(true) {
        for (0 => int step; step < sequence.cap(); step++) {            
            if (sequence[step] == 1) {
                0 => kick.pos;
            }               
            else if (sequence[step] == 2 && Math.random2(0, 1)) {
                0 => kick.pos;
            }
            
            tempo.eighthNote => now;
        }
    }
}

//

[1, 2, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0] @=> int sequence[];

spork ~ runKick(sequence);

//

while(true) second => now;