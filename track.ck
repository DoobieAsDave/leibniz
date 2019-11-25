BPM tempo;

tempo.setBPM(140.0);

.75 => dac.gain;

//

int kickShredId, hihatShredId, rimShredId, bassShredId, synthShredId, arpShredId;

Machine.add(me.dir() + "drums/kick.ck") => kickShredId;
Machine.add(me.dir() + "drums/hihat.ck") => hihatShredId;
Machine.add(me.dir() + "drums/rim.ck") => rimShredId;
//tempo.note * 8 => now;
Machine.add(me.dir() + "units/bass.ck") => bassShredId;
Machine.add(me.dir() + "units/synth.ck") => synthShredId;
//tempo.note * 8 => now;
repeat(4) {
    Machine.add(me.dir() + "units/arp copy.ck") => arpShredId;
    tempo.note * 2 => now;
    Machine.remove(arpShredId);
}
tempo.note * 16 => now;
repeat(4) {
    Machine.add(me.dir() + "units/arp copy.ck") => arpShredId;
    tempo.note * 2 => now;
    Machine.remove(arpShredId);
}

while(dac.gain() > .0) {
    dac.gain() - .01 => dac.gain;
    tempo.eighthNote => now;
}

<<< "track end" >>>;

/* int kickShredId, hihatShredId, rimShredId, bassShredId, synthShredId, arpShredId;

Machine.add(me.dir() + "drums/kick.ck") => kickShredId;
Machine.add(me.dir() + "drums/hihat.ck") => hihatShredId;
Machine.add(me.dir() + "drums/rim.ck") => rimShredId;
tempo.note * 8 => now;
Machine.add(me.dir() + "units/bass.ck") => bassShredId;
Machine.add(me.dir() + "units/synth.ck") => synthShredId;
tempo.note * 8 => now;
repeat(4) {        
    Machine.add(me.dir() + "units/arp.ck") => arpShredId;
    tempo.note * 4 => now;
    Machine.remove(arpShredId);
    tempo.note * 4 => now;
}

tempo.note * 16 => now;

while(dac.gain() > .0) {
    dac.gain() - .01 => dac.gain;
    tempo.eighthNote => now;
}

<<< "track end" >>>; */