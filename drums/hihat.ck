BPM tempo;

SndBuf hihat => dac;

me.dir(-1) + "audio/hihat.wav" => hihat.read;
hihat.samples() => hihat.pos;

.45 => hihat.gain;

//

function void runHihat() {
    while(true) {
        Math.random2(12, 15) => int accentStep;        

        for (0 => int step; step < 16; step++) {
            if (step != accentStep) {
                getRandomPosition(20.0) => hihat.pos;
                tempo.eighthNote => now;
            }
            else {
                Math.random2(1, 3) => int rep;
                repeat(rep) {
                    getRandomPosition(10.0) => hihat.pos;
                    tempo.eighthNote / rep => now;
                }
            }     
        }
    }
}
function int getRandomPosition(float maxPercent) {
    return Math.random2(0, Std.ftoi(hihat.samples() * maxPercent / 100));
}

//

spork ~ runHihat();

//

while(true) second => now;