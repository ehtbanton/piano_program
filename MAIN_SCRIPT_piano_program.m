
% Anton May
% MAIN SCRIPT

% Play tunes on a virtual piano using your physical computer keyboard.

% Comments about how the project works are found along the way, including
% in the accompanying scripts.

% I have used functions from Session 2, but have renamed them (i.e.
% "drawshape" became "draw", etc.) "rotateabt" and "reflect" are also no longer
% dependent on sub-functions.

% When playing the piano, please note that the first note takes a bit of
% time to load, and a new note can't be played while the animation for the
% previous note is still running (so please always leave a small gap in 
% between inputs). I did attempt to prevent this from being an issue - see
% near the end of my script regarding a timer.



clc

% first, loading in some variables:
load keyinputrows.mat 
% This contains the keys on the physical keyboard which will match with the 
% piano keys. See create_keytable.m
load soundtables.mat 
% This contains the audio data for the keys and is the reason the program 
% is slow to start up. See load_mp3_sounds.m


% now to set up the graph frame

fig1 = figure;
set(0,'units','pixels')
windowdim = get(0,'screensize'); % gives [left, bottom, width, height] of window
graphdim = windowdim; % preallocation step to reduce computations

% then, so the graphical element has the right dimensions:
if windowdim(3)<=windowdim(4)*16/10
    % This is a tall display - define the dimensions based on display width
    % so that everything fits on screen! There are also some multipliers to
    % account for the graph's menu bar.
    % graphdim(1)=windowdim(1);
    % graphdim(3)=windowdim(3);
    graphdim(4)=graphdim(3)*9/16;
    graphdim(2)=windowdim(2);%+0.5*(windowdim(4)-graphdim(4));
else
    % this is a wide display - base dimensions on display height
    graphdim(2)=windowdim(2)+0.035*windowdim(4);
    graphdim(4)=windowdim(4)*0.9;
    graphdim(3)=graphdim(4)*16/9;
    graphdim(1)=windowdim(1)+0.5*(windowdim(3)-graphdim(3));
end

fig1.Position = windowdim; % makes the figure full-screen
axes(fig1,"units","pixels","Position",graphdim); 
% makes the graphical element such that it's always the largest 16 by 9 
% rectangle that will fit on the user's display.


% then, I'm constructing a border which I'll make all my drawings stay 
% inside so objects don't get rescaled:
border=[-1600 1600 1600 -1600 -1600; -900 -900 900 900 -900];
draw(border,"r-")
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% now to draw the keys in their starting positions

thetainitial=pi/6; % the initial angle of the keys from the horizontal

wkeycount=11;
bkeycount=wkeycount-1;

wkeywidth=200;
% other key dimensions follow those of the original width of a white key

wkeylength=wkeywidth*5.4;
bkeywidth=wkeywidth*0.6;
bkeylength=wkeylength*0.6;

wkeyheight=wkeywidth;
bkeyheight=bkeywidth;

% This is the initial shape of the white and black keys. I've gone for a 
% head-on 3D effect - I used sine and cosine to get the proportions right 
% for viewing in 2D, including taking into account the slope of the front 
% of a black key.
whitekey=[0 wkeywidth wkeywidth 0 0 0 wkeywidth wkeywidth;0 0 wkeylength*cos(thetainitial) wkeylength*cos(thetainitial) 0 -wkeyheight*sin(thetainitial) -wkeyheight*sin(thetainitial) 0];
blackkey=[0 bkeywidth bkeywidth 0 0 0 bkeywidth bkeywidth;0 0 bkeylength*cos(thetainitial-pi/12) bkeylength*cos(thetainitial-pi/12) 0 -bkeyheight*sin(thetainitial+pi/6) -bkeyheight*sin(thetainitial+pi/6) 0];
% I had planned to make the keys move in "3D" too, but it turned out that
% this meant the black keys left unsightly gaps, so I simplified the
% animation further down the line.

% These are the positions of the first black and white keys to be drawn.
% Some consideration was taken for in case I wanted to change the
% dimensions of the keys, so they would still fit in the border.
whitekeyinit=translate(whitekey,-(wkeycount)*wkeywidth/2,border(2,1)+100+wkeylength*(1-cos(thetainitial)));
blackkeyinit=translate(blackkey,-(wkeycount)*wkeywidth/2+(wkeywidth-bkeywidth/2),border(2,1)+100+(wkeylength-bkeylength)+bkeylength*(1-cos(thetainitial-pi/12)));


% preallocation
temp = size(whitekey);
wkeytable = zeros(2,temp(2),wkeycount);
temp = size(blackkey);
bkeytable=zeros(2,temp(2),bkeycount);

% Constructing the 3D keytables. The first two dimensions of each table 
% describe the coordinates of the current key, with the third dimension 
% denoting which key it is.
currentwhitekey=whitekeyinit;
for n=1:wkeycount
    draw(currentwhitekey,"k-")
    wkeytable(:,:,n)=currentwhitekey;
    currentwhitekey(1,:)=currentwhitekey(1,:)+wkeywidth;
    % currentwhitekey(2,:)=currentwhitekey(2,:);
end

currentblackkey=blackkeyinit;
for n=1:bkeycount
    if or(mod(n,7)==3,mod(n,7)==6)
        currentblackkey(1,:)=currentblackkey(1,:)+wkeywidth;
        continue
    else
        fill(currentblackkey(1,:),currentblackkey(2,:),"k")
        draw(currentblackkey,"w-")
        bkeytable(:,:,n)=currentblackkey;
        currentblackkey(1,:)=currentblackkey(1,:)+wkeywidth;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% drawing the borders of the piano

left=-wkeycount*wkeywidth*0.5;
right=wkeycount*wkeywidth*0.5;
top=whitekeyinit(2,3);
bottom=whitekeyinit(2,6);

pianoborder=[left left right right left;bottom top top bottom bottom];

brown=[100, 60, 40]./255;
darkbrown=[50, 30, 20]./255;

fill([left-200 left-200 right+200 right+200 left-200],[top top+200 top+200 top top],brown)
fill([left-200 left-200 right+200 right+200 right right left left left-200],[top bottom-40 bottom-40 top top bottom bottom top top],brown)
fill([left-200 left-200 right+200 right+200 left-200],[bottom-40 bottom-100 bottom-100 bottom-40 bottom-40],darkbrown)

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this section of script will move the on-screen piano keys as the physical keys are pressed

for n=1:1000000 % I don't want this loop to end before the user has chosen an instrument
    text(-1000,700,"Choose an instrument sound!"+newline+newline+"Press p for piano"+newline+ ...
        "Press g for electric guitar"+newline+"Press m for marimba (sounds best in my opinion)","FontSize",16);
waitforbuttonpress
instrument=get(gcf,"CurrentCharacter");
if instrument=="p"
    wsoundtable=wpsoundtable;
    bsoundtable=bpsoundtable;
    break
elseif instrument=="g"   
    wsoundtable=wgsoundtable;
    bsoundtable=bgsoundtable;
    break
elseif instrument=="m"
    wsoundtable=wmsoundtable;
    bsoundtable=bmsoundtable;
    break
else
    text(0,700,"Please press p, g or m!","FontSize",30,"Color","r");
end
end

fill([-1580 -1580 1580 1580 -1580],[500 880 880 500 500],"w")

text(0,700,"Use the keys on the bottom two rows of your"+newline+"physical computer keyboard to play the piano!"+newline+newline ...
    +"(e.g. \,z and x are the first white keys,"+newline+"and a and s are the first black keys.)","HorizontalAlignment","center","FontSize",14);

% Defining a diamond-shaped marker for the last note played
step=wkeywidth/6;
marker=[0 step 0 -step 0;-step 0 step 0 -step];

sounditeration=0;

for s=1:1000000 % so the user can effectively play as many notes as they want

    waitforbuttonpress;
    ch=get(gcf,"CurrentCharacter");

    isitwhite=ismember(ch,winrow);
    isitblack=ismember(ch,binrow);
    
    % see further down for use of sounditeration
    if sounditeration==10
    sounditeration=1;
    else         
    sounditeration=sounditeration+1;
    end

    if isitwhite==1
        colour=1;
        x=find(winrow==ch);
        currentkey=wkeytable(:,:,x);

        fill(currentkey(1,5:8),currentkey(2,5:8),"w")
        % the above is necessary to ensure the front edge of the white key 
        % is rubbed out - matlab cannot store exact values, so the position
        % of this line will be slightly different from the original for 
        % every trial succeeding the first.
 
        play(wsoundtable(sounditeration,x))
        % That plays the note! It has to cycle through different instances
        % of the note so it can play it again while the previous one is
        % still playing.

    elseif isitblack==1
        x=find(binrow==ch);
        currentkey=bkeytable(:,:,x);
        

        if currentkey(1)==0 % an easy way to check if it's a ghost black key
            colour=0;
        else
            % The play function is prevented from running when on a "ghost"
            % black key
            play(bsoundtable(sounditeration,x))
            colour=2;
        end
        
    else
        colour=0;
    end

    % Now, adding a marker for the last note played
    if colour==1||colour==2
        for n=1:2*wkeycount-1
            currentnullmarker=translate(marker,(n/2-(wkeycount)/2)*wkeywidth,350);
            if mod(n,14)==6||mod(n,14)==12
            else
                fill(currentnullmarker(1,:),currentnullmarker(2,:),brown)
            end
        end
    end

    if colour==1
        currentwhitemarker=translate(marker,(x-(wkeycount+1)/2)*wkeywidth,350);
        fill(currentwhitemarker(1,:),currentwhitemarker(2,:),"c")
    elseif colour==2
        currentblackmarker=translate(marker,(x+0.5-(wkeycount+1)/2)*wkeywidth,350);
        fill(currentblackmarker(1,:),currentblackmarker(2,:),"m")
    end

%%
    theta=thetainitial;
    deltatheta=pi/24; % this will be the angle the key changes by after each new step of the animation.

    if colour==1||colour==2 % checks if a valid key has been pressed

       % One problem with using "pause" to control my animation is that it 
       % stops all matlab operation, meaning the user can't play a new note
       % until the animation for the last one is finished.

       % I believe it's possible to get round this with a timer function, 
       % but I haven't quite yet figured out how to make it work.
       % Below is my attempt with the timer - it would replace the loop with 
       % a pause(1/60) :

       % keymovtim=timer("TimerFcn","currentkey=anistep(currentkey,theta,deltatheta,colour);","Period",1/60,"TasksToExecute",4,"ExecutionMode","fixedRate");
       % start(t)

        for q=1:2
            for n=1:4
    
                [currentkey,theta]=anistep(currentkey,theta,deltatheta,colour);

                pause(1/60)

            end
            deltatheta=-deltatheta; % makes the key move back upwards
            % pause(0.1)
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

