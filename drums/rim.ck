BPM tempo;

SndBuf rim => dac;

me.dir(-1) + "audio/rim.wav" => rim.read;
rim.samples() => rim.pos;

.5 => rim.gain;

//

function void runRim() {
    while(true) {
        for (0 => int step; step < 8; step++) {
            tempo.halfNote => now;            

            if (step == 7 && Math.random2(0, 1)) {
                Math.random2(1, 3) => int rep;

                repeat(rep) {
                    0 => rim.pos;
                    tempo.halfNote / rep => now;
                }
            }
            else {
                0 => rim.pos;
                tempo.halfNote => now;
            }
        }
    }
}

//

spork ~ runRim();

//

while(true) second => now;