// Arthur Wilson, 2019. SuperCollider file for Final Showcase, BACRMT @ Falmouth University.
//
//
// SuperCollider recieves osc messages of averaged slider data from the server, and from here creates the audio
// for the installation with these values, whilst forwarding these values through to Processing for the
// visuals.

Ndef.clear;
OSCdef.freeAll;
NdefMixer(s);
~outgoingAddr = NetAddr( "127.0.0.1", 4859);


// Incoming OSC message from server.
(OSCdef(\incoming, {
	arg msg;
	Ndef(\value1).set(\value, msg[1]);
	Ndef(\value2).set(\value, msg[2]);
	Ndef(\value3).set(\value, msg[3]);
	// msg.postln;
}, '/oscjs');
);

// Ndefs to hold each seperate incoming value
(
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
)

// Test that the incoming values are working corretly
(
Ndef(\test1, {
	var sig, amp;
	sig = SinOsc.ar(250)*Ndef(\value1);
	amp = Pan2.ar(sig, 0);
});

Ndef(\test2, {
	var sig, amp;
	sig = SinOsc.ar(300)*Ndef(\value2);
	amp = Pan2.ar(sig, 0);
});

Ndef(\test3, {
	var sig, amp;
	sig = SinOsc.ar(350)*Ndef(\value3);
	amp = Pan2.ar(sig, 0);
});
)

// Forwarding these messages through to Processing
(OSCdef(\outgoing, {
	arg msg;
	msg[1].postln;
	~outgoingAddr.sendMsg('/value1', msg[1]);
	~outgoingAddr.sendMsg('/value2', msg[2]);
	~outgoingAddr.sendMsg('/value3', msg[3]);
}, '/oscjs');
);
