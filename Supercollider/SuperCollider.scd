// Arthur Wilson, 2019. SuperCollider file for Final Showcase, BACRMT @ Falmouth University.
//
//
// SuperCollider recieves OSC messages of averaged slider data from the server, and from here creates the audio
// for the installation with these values. The slider data is also forwarded to Processing for the visuals.
//

//Check the devices available in post window
ServerOptions.devices;

//Server Settings
(Server.local.options.numOutputBusChannels = 2;//number of server outputs
Server.local.options.outDevice = "Built-in Output";//out Device here
s.boot;

//Global Variables
~numChannels = Server.local.options.numOutputBusChannels;
~numChannels;
~outgoingAddr = NetAddr( "192.168.1.25", 4859);
~incomingAddr = NetAddr( "127.0.0.1", 57120);

//Clear the server incase something crashes and lags/remains/does something it shouldn't
Ndef.clear; //Goodbye unwelcome, old Ndefs
OSCdef.freeAll; //Cheerio unwanted OSCdefs from somewhere you shouldnt be
NdefMixer(s); //Mixer for quick changing of sound in cases of emergency

// Incoming OSC message from server
OSCdef(\incoming, {
	arg msg;
	Ndef(\value1).set(\value, msg[1]);
	Ndef(\value2).set(\value, msg[2]);
	Ndef(\value3).set(\value, msg[3]);
	// msg.postln;
}, '/oscjs');


// Ndefs which hold each slider average seperately
Ndef(\value1, {
	arg value = 0;
	var sig;
	sig = value;
});

Ndef(\value2, {
	arg value = 0;
	var sig;
	sig = value;
});

Ndef(\value3, {
	arg value = 0;
	var sig;
	sig = value;
});


// // Test incoming OSC is working through pitched sin waves
//
// Ndef(\test1, {
// 	var sig, amp;
// 	sig = SinOsc.ar(250)*Ndef(\value1);
// 	amp = Pan2.ar(sig, 0);
// });
//
// Ndef(\test2, {
// 	var sig, amp;
// 	sig = SinOsc.ar(300)*Ndef(\value2);
// 	amp = Pan2.ar(sig, 0);
// });
//
// Ndef(\test3, {
// 	var sig, amp;
// 	sig = SinOsc.ar(350)*Ndef(\value3);
// 	amp = Pan2.ar(sig, 0);
// });


// Forward the messages through to Processing
OSCdef(\outgoing, {
	arg msg;
	// msg[1].round(0.001).postln;
	~outgoingAddr.sendMsg('/value1', msg[1].round(0.001));
	~outgoingAddr.sendMsg('/value2', msg[2].round(0.001));
	~outgoingAddr.sendMsg('/value3', msg[3].round(0.001));
}, '/oscjs');


//Audio
//Clicks. Short, high pitched and sharp. Audio for when the points are scattered.

Ndef(\Click1, {
	arg rate = 8*(Ndef(\value2)), freq = 185, ampli = 0.22;
	var sig, pan, amp;
	sig = Impulse.ar(rate);
	sig = BPF.ar(sig, freq, 0.8);
	amp = (ampli * sig);
	pan = PanX.ar(~numChannels, amp, TRand.kr(0, 1, TDuty.kr(8/60)), 1-Ndef(\value1));
});


Ndef(\Click2, {
	arg val1 = 0.3*Ndef(\value2);
	var trigger, clicks, noise, out;
	trigger = TDuty.kr(Dxrand([val1/16, val1/8, val1/4, val1/2, val1], inf));
	clicks = BPF.ar(PinkNoise.ar(Decay.kr(trigger, 0.001 * LFNoise1.kr(4).abs)), 12000, 0.9).fold(-1, 1);
	noise = BPF.ar(WhiteNoise.ar(Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, 0.05)), TRand.kr(12000, 15000, trigger), 0.9);
	out = PanX.ar(~numChannels, noise+clicks, WhiteNoise.kr(~numChannels+1, -1), 0.2*(1-Ndef(\value2)));
});

Ndef(\Click3, {
	arg decay = 0.03, val1 = 0.18, fb = 1, freq = 11000;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Dxrand([val1/16, val1/8, val1/4, val1/2, val1], inf));
	osc1 = SinOscFB.ar(freq, fb, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar(freq/2, 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay/2));
	amp = ((osc1*0.5) + (osc2*0.2));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.15*(1-Ndef(\value3)));
});

Ndef(\Click4, {
	arg decay = 0.05, val1 = 0.34, fb = 1, freq = 6000;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Dxrand([val1/16, val1/8, val1/4, val1/2, val1], inf));
	osc1 = Saw.ar(freq, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = Saw.ar((freq/2), Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay/2));
	amp = ((osc1*0.5) + (osc2*0.5));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.06*(1-Ndef(\value1)));
});

Ndef(\Click5, {
	arg decay = 0.08, val1 = 0.15, fb = 0.11, freq = 10000;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Dxrand([val1/4, val1/2, val1], inf));
	osc1 = SinOscFB.ar(freq/2, fb, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar((freq/2), 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay/2));
	amp = ((osc1*0.5) + (osc2*0.2));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.075*(1-Ndef(\value2)));
});

//Noise
//Comes in and out periodically. The sliders will not effect these, these are constant sounds.

Ndef(\Noise1, {
	arg rq = 0.01, cutoff = 4000;
	var noise, filter, env, out;
	noise = PinkNoise.ar(0.075);
	env = EnvGen.ar(Env([0.02, 1, 0.02], [3, 1], 'exp', 0.02), TDuty.kr(60));
	out = PanX.ar(~numChannels, BPF.ar(noise, cutoff, env), LFTri.kr(0.25, 0, 1, 0.5));
});

Ndef(\Noise2, {
	arg rq = 0.01, cutoff = 6000;
	var noise, filter, env, out;
	noise = PinkNoise.ar(0.075);
	env = EnvGen.ar(Env([0.02, 1, 0.02], [3.5, 2], 'exp', 0.02), TDuty.kr(35));
	out = PanX.ar(~numChannels, BPF.ar(noise, cutoff, env), LFTri.kr(0.25, 0, 0, 0.5));
});

Ndef(\Noise3, {
	arg rq = 0.01, cutoff = 5000;
	var noise, filter, env, out;
	noise = PinkNoise.ar(0.075);
	env = EnvGen.ar(Env([0.02, 1, 0.02], [3.5, 2], 'exp', 0.02), TDuty.kr(40));
	out = PanX.ar(~numChannels, BPF.ar(noise, cutoff, env), LFTri.kr(0.25, 0, 0, 0.5));
});

Ndef(\Noise4, {
	arg rq = 0.01, cutoff = 3500;
	var noise, filter, env, out;
	noise = PinkNoise.ar(0.075);
	env = EnvGen.ar(Env([0.02, 1, 0.02], [3.5, 2], 'exp', 0.02), TDuty.kr(40));
	out = PanX.ar(~numChannels, BPF.ar(noise, cutoff, env), LFTri.kr(0.25, 0, 0, 0.5));
});

//Low Tone Clicks, suitable in both clicks and trails section

Ndef(\ToneClick1, {
	arg decay = 0.2, val1 = 1.15, freq = 115, panPos = 0.5;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Drand([val1/2, val1, val1/4], inf));
	osc1 = SinOscFB.ar(freq+TRand.kr(0, 50, trigger), Ndef(\value1), Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar(freq+TRand.kr(0, 20, trigger), 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay/2));
	amp = ((osc1*0.5) + (osc2*0.4));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.15+(Ndef(\value3)*0.05));
});

Ndef(\ToneClick2, {
	arg amp = 0.1, freq = 80;
	var osc, filter, out;
	osc = SinOsc.ar(freq, 0, amp);
	out = PanX.ar(~numChannels, osc, LFTri.kr(0.25, 0, 1, 0.5), (LFTri.kr(0.05, 2, 0.5, 0.5)*0.4)+(Ndef(\value2)*0.05));
});

Ndef(\ToneClick3, {
	arg decay = 0.3, val1 = 0.61, fb = 1.44, freq = 2151.7;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Drand([2*val1, 4*val1], inf));
	osc1 = SinOscFB.ar(freq+TRand.kr(0, 250, trigger), fb, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar((freq+TRand.kr(0, 100, trigger))/2, 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	amp = ((osc1*0.2) + (osc2*0.5));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.015+(Ndef(\value1)*0.05));
});

Ndef(\ToneClick4, {
	arg decay = 0.2, val1 = 14, fb = 1, freq = 800;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Drand([val1/6, val1/4, val1/2], inf));
	osc1 = SinOscFB.ar(freq+TRand.kr(0, 200, trigger), fb+TRand.kr(0, 1, trigger), Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar(freq+TRand.kr(0, 200, trigger), 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	amp = ((osc1*0.5) + (osc2*0.2));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.05-(Ndef(\value3)*0.05));
});


Ndef(\ToneClick5, {
	arg decay = 0.7, val1 = 17, fb = 0, freq = 641, panPos = 0.5;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Drand([val1/2, val1, val1/3], inf));
	osc1 = SinOscFB.ar(freq+TRand.kr(0, 200, trigger), fb, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar(freq+TRand.kr(0, 400, trigger), 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	amp = ((osc1*0.5) + (osc2*0.2));
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.05+(Ndef(\value2)*0.05));
});

Ndef(\ToneClick6, {
	arg decay = 0.39, val1 = 10, fb = 0.65, freq = 1200, panPos = 0.5;
	var filter, trigger, osc1, osc2, env, amp, out;
	trigger = TDuty.kr(Drand([val1/2, val1, val1/3], inf));
	osc1 = SinOscFB.ar(freq+TRand.kr(0, 500, trigger), fb, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	osc2 = SinOsc.ar(freq+TRand.kr(0, 600, trigger), 0, Decay2.kr(trigger * LFNoise1.kr(8, 0.5, 0.5), 0.01, decay));
	amp = (osc1*0.5) + (osc2*0.2);
	out = PanX.ar(~numChannels, amp, TRand.kr(0, 1, trigger), 0.05+(Ndef(\value1)*0.05));
});

//Tones
//Tones for when the the points have trails and are moving more united

Ndef(\Tone1, {
	arg val1 = 30, freq = 280, cutoff = 4000, rq = 0.27, amp = 1, panPos = 0.5;
	var trigger, osc1, osc2,filter, env, out;
	trigger = TDuty.kr(Drand([val1/16, val1/8], inf));
	env = EnvGen.ar(Env(times: [TRand.kr(0.1, 2, trigger), TRand.kr(1, 3, trigger)]), trigger);
	osc1 = SinOsc.ar(freq+TRand.kr(0, 40, trigger), 0, env);
	osc2 = SinOsc.ar((freq+(freq/10)+freq/4)+TRand.kr(0, 20, trigger), 0, env);
	filter = BLowPass.ar((osc1+osc2), TRand.kr(100, 15000, trigger), rq, 0.01);
	out = PanX.ar(~numChannels, filter, TRand.kr(0, 1, trigger), (Ndef(\value1)));
});

Ndef(\Tone2, {
	arg val1 = 35, freq = 517, cutoff = 4000, rq = 0.2, amp = 1, panPos = 0.5;
	var trigger, osc1, osc2,filter, env, out;
	trigger = TDuty.kr(Drand([val1/12, val1/16], inf));
	env = EnvGen.ar(Env(times: [TRand.kr(0.1, 2, trigger), TRand.kr(2, 3, trigger)]), trigger);
	osc1 = SinOscFB.ar((freq+ freq/2)+TRand.kr(0, 20, trigger), TRand.kr(0, 0.05, trigger), env);
	osc2 = SinOsc.ar((freq+freq/10+freq/4)+TRand.kr(0, 50, trigger), 0, env);
	filter = BLowPass.ar((osc1+osc2), TRand.kr(100, 8000, trigger), rq, 0.01);
	out = PanX.ar(~numChannels, filter, TRand.kr(0, 1, trigger), (0.4*Ndef(\value2)));
});

Ndef(\Tone3, {
	arg val1 = 35, freq = 346, cutoff = 4000, rq = 0.25, amp = 1, panPos = 0.5;
	var trigger, osc1, osc2,filter, env, out;
	trigger = TDuty.kr(Drand([val1/12, val1/8], inf));
	env = EnvGen.ar(Env(times: [TRand.kr(0.1, 2, trigger), TRand.kr(1, 3, trigger)]), trigger);
	osc1 = SinOscFB.ar((freq+ freq/2)+TRand.kr(0, 80, trigger), TRand.kr(0, 0.05, trigger), env);
	osc2 = SinOsc.ar((freq+(freq/10)+freq/4)+TRand.kr(0, 60, trigger), 0, env);
	filter = BLowPass.ar((osc1+osc2), TRand.kr(100, 8000, trigger), rq, 0.01);
	out = PanX.ar(~numChannels, filter, TRand.kr(0, 1, trigger), (0.6*Ndef(\value3)));
});


Ndef(\Tone4, {
	arg val1 = 60, freq = 690, cutoff = 4000, rq = 0.25, amp = 1, panPos = 0.5;
	var trigger, osc1, osc2,filter, env, out;
	trigger = TDuty.kr(Drand([val1/12, val1/16, val1/8], inf));
	env = EnvGen.ar(Env(times: [TRand.kr(0.5, 3, trigger), TRand.kr(2, 5, trigger)]), trigger);
	osc1 = SinOscFB.ar((freq+ freq/2)+TRand.kr(0, 60, trigger), TRand.kr(0, 0.05, trigger), env);
	osc2 = SinOsc.ar((freq)+TRand.kr(0, 80, trigger), 0, env);
	filter = BLowPass.ar((osc1+osc2), TRand.kr(100, 8000, trigger), rq, 0.01);
	out = PanX.ar(~numChannels, filter, TRand.kr(0, 1, trigger), (0.4*Ndef(\value2)));
});

Ndef(\Tone5, {
	arg val1 = 40, freq = 460, cutoff = 4000, rq = 0.25, amp = 1, panPos = 0.5;
	var trigger, osc1, osc2,filter, env, out;
	trigger = TDuty.kr(Drand([val1/12, val1/16, val1/8], inf));
	env = EnvGen.ar(Env(times: [TRand.kr(0.5, 3, trigger), TRand.kr(2, 5, trigger)]), trigger);
	osc1 = SinOscFB.ar((freq+ freq/2)+TRand.kr(0, 90, trigger), TRand.kr(0, 0.05, trigger), env);
	osc2 = SinOsc.ar((freq+freq/10+freq/4)+TRand.kr(0, 60, trigger), 0, env);
	filter = BLowPass.ar((osc1+osc2), TRand.kr(100, 8000, trigger), rq, 0.01);
	out = PanX.ar(~numChannels, filter, TRand.kr(0, 1, trigger), (0.4*Ndef(\value1)));
});
)