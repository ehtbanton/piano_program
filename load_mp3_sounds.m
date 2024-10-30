
% this script takes the data from the audio file for a single note, makes
% it into several notes by changing frequency, and constructs reference
% tables of these notes for the main program to use.

% Unfortunately, the script runs very slowly - this is due to putting the
% audioplayer function within a loop, which is a necessary step.

clc

[audio,freq]=audioread("piano_note.mp3");

silence = [0 0]; % an empty audio matrix - will use for pre-allocation
emptyfiller=audioplayer(silence,freq,16);

wsoundtable(1:20,1:15)=emptyfiller;
bsoundtable(1:20,1:15)=emptyfiller;

soundrow(1:26)=emptyfiller;
wsoundrow(1:15)=emptyfiller;
bsoundrow(1:15)=emptyfiller;    


for iteration=1:10
    whitenum=0;
    blacknum=0;
    
    for n=1:26
        % Each new n should give us a note pitched a semitone higher. I'll
        % explain below how I do this.
        % Pitch is on a logarithmic scale, such that an increase in pitch
        % of an octave corresponds with a doubling in frequency. This is 
        % over the span of 12 semitones, so the frequency ratio for a 
        % single semitone is 2^(1/12), i.e. the pitch of a note with
        % frequency=f is a semitone lower than one with
        % frequency=2^(1/12)*f.
        ToPlay=audioplayer(audio,(2^(1/12)^(n-1))*freq,16);
        soundrow(n)=ToPlay;
        
        % We now need to define which notes are black and which are white.
        % I've also included a step below which ensures that the "ghost"
        % black keys present in my main program are accounted for here.
        if mod(n,12)==2||mod(n,12)==4||mod(n,12)==9
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;

        elseif mod(n,12)==7||mod(n,12)==0
            blacknum=blacknum+1;    
            bsoundrow(blacknum)=ToPlay;
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;

        else
            whitenum=whitenum+1;
            wsoundrow(whitenum)=ToPlay;
        end
    end
    % below - creating separate audioplayer objects for the same note as 
    % MATLAB doesn't let you call the same object while it is already playing.
    wsoundtable(iteration,:)=wsoundrow;
    bsoundtable(iteration,:)=bsoundrow;
end
wpsoundtable=wsoundtable;
bpsoundtable=bsoundtable;

% below is the same twice more with different audio files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[audio,freq]=audioread("guitar_note.mp3");
for iteration=1:10
    whitenum=0;
    blacknum=0;  
    for n=1:26
        ToPlay=audioplayer(audio,(2^(1/12)^(n-1))*freq,16);
        soundrow(n)=ToPlay;
        if mod(n,12)==2||mod(n,12)==4||mod(n,12)==9
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;
        elseif mod(n,12)==7||mod(n,12)==0
            blacknum=blacknum+1;    
            bsoundrow(blacknum)=ToPlay;
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;
        else
            whitenum=whitenum+1;
            wsoundrow(whitenum)=ToPlay;
        end
    end
    wsoundtable(iteration,:)=wsoundrow;
    bsoundtable(iteration,:)=bsoundrow;
end
wgsoundtable=wsoundtable;
bgsoundtable=bsoundtable;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[audio,freq]=audioread("marimba_note.mp3");
for iteration=1:10
    whitenum=0;
    blacknum=0;  
    for n=1:26
        ToPlay=audioplayer(audio,(2^(1/12)^(n-1))*freq,16);
        soundrow(n)=ToPlay;
        if mod(n,12)==2||mod(n,12)==4||mod(n,12)==9
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;
        elseif mod(n,12)==7||mod(n,12)==0
            blacknum=blacknum+1;    
            bsoundrow(blacknum)=ToPlay;
            blacknum=blacknum+1;
            bsoundrow(blacknum)=ToPlay;
        else
            whitenum=whitenum+1;
            wsoundrow(whitenum)=ToPlay;
        end
    end
    wsoundtable(iteration,:)=wsoundrow;
    bsoundtable(iteration,:)=bsoundrow;
end
wmsoundtable=wsoundtable;
bmsoundtable=bsoundtable;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save soundtables.mat wpsoundtable bpsoundtable wgsoundtable bgsoundtable wmsoundtable bmsoundtable

% below is a tune which checks that the iteration through different
% instances of the same note is working, and alerts me that the
% program has finished running.

sounditeration=5;
for x=1:3
for n=1:10
if sounditeration==10
    sounditeration=1;
else         
    sounditeration=sounditeration+1;
end
play(wsoundtable(sounditeration,(2*x-1)))
pause(0.05)
end
end
play(wsoundtable(1,8))

