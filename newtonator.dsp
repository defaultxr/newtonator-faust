declare name 		"newtonator";
declare version 	"0.1";
declare author 	    "defaultxr";
declare license 	"GPLv3";
declare copyright 	"(c) defaultxr 2016";

//-----------------------------------------------
// Newtonator
//-----------------------------------------------

// based off of the Newtonator synth:
// https://newtonator.sf.net/

// this could probably be improved in many ways
// but i don't think i'm going to

/*
currSamp = prevSamp + prevVeloc + (grav / 2);
currVeloc = currVeloc + grav;

// Output currSamp as the value of the current sample in the audio frame...

// Switch the gravity once it crosses the floor
if ((grav < 0 && currSamp < 0) || (grav > 0 && currSamp >= 0))
grav *= -1;

prevVeloc = currVeloc; 
prevSamp = currSamp;
*/

SR = fconstant(int fSamplingFreq, <math.h>) ;

imp = (1-1') ;

agrav2(cs,grav) = (((grav<0)*(cs<0))+((grav>0)*(cs>=0)));

agrav(grav,cs) = ((-grav)*agrav2(cs,grav)) + (grav*(1-agrav2(cs,grav))) ; // ext./int. clip

// vel(grav) = +(grav) ~ _; // ext./int. clip

vel(grav,ag2,bounce,cs) = +(grav) ~ _; // bounce clip

vel(grav,1,bounce,cs) = 0 + grav;

// csamp(g,cs) = (cs + vel(agrav(g,cs))' + imp + agrav(g,cs)'); // ext./int. clip

csamp(g,bounce,cs) = (cs + vel(agrav(g,cs), agrav2(cs,g), bounce, cs)' + imp + agrav(g,cs)'); // bounce clip

g(freq) = 2/((SR/freq/4)^2);

clip(sig) = min(1,max(-1,sig));

mainextclip2(freq, gmod) = csamp(g(freq+gmod)) ~ _; // ext. clip

mainextclip(freq, gmod) = clip(mainextclip2(freq, gmod)) ; // ext. clip

mainintclip(freq, gmod) = clip(csamp(g(freq)+gmod)) ~ _; // int. clip

mainbounceclip(freq, gmod, bounce) = csamp(g(freq)+gmod, bounce) ~ _; // bounce clip

process(freq, gmod) = mainbounceclip(freq, gmod) ; // uncomment this for bounce clip

// process(freq, gmod) = mainbounceclip(freq, gmod) ; // uncomment this for internal clip

// process(freq, gmod) = mainbounceclip(freq, gmod) ; // uncomment this for external clip