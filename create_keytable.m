
% Defines which physical keys correspond with which notes

clc

wkeycount=11;
bkeycount=wkeycount-1;

winrow(1:wkeycount)="none";
for n=1:wkeycount
waitforbuttonpress;
winrow(n)=get(gcf,"CurrentCharacter") 
% intentionally displaying the character chosen
end

binrow(1:bkeycount)="none";
for n=1:bkeycount
waitforbuttonpress;
binrow(n)=get(gcf,"CurrentCharacter")
end

save keyinputrows.mat winrow binrow



% Below could be useful for further development of the project for naming
% the notes played.

wkeynamerow=["G" "A" "B" "C" "D" "E" "F" "G" "A" "B" "C" "D" "E" "F" "G" "A" "B" "C" "D" "E" "F"];
wkeynamerow=wkeynamerow(1:wkeycount);

bkeynamerow="bkeynamerow";
for n=1:bkeycount
    bkeynamerow(n)=wkeynamerow(n+1)+"b";
end

wintable=[winrow;wkeynamerow]
bintable=[binrow;bkeynamerow]

