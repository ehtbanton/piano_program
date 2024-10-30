function [outputkey,thetaout] = anistep(currentkey,theta,deltatheta,colour)
% Small step animation of a key in motion

        draw(currentkey,"w")
    
        previouskey=currentkey;
        % Making the top of the key elongate by an amount corresponding to
        % the angle the key has changed by
        currentkey(2,3:4) = previouskey(2,3)*cos(theta-deltatheta)/cos(theta);
    
        % currentblackkey(2,6:7)=previousblackkey(2,6)*(sin(theta+pi/6-pi/18)/sin(theta+pi/6));
        % ^ didn't work well as left gaps between keys - I instead used a
        % fixed overall key length and made the visible height the
        % difference between that and the horizontal length of the key.
        
        vertchange=previouskey(2,3)-currentkey(2,3);
    
        currentkey(2,6:7) = previouskey(2,6)-vertchange;
        
        % below step is necessary as the key has shifted up due to these
        % dimension changes.
        outputkey=translate(currentkey,0,vertchange);
        
        if colour==1 % white
            draw(outputkey,"k")
        elseif colour==2 % black
            fill(outputkey(1,:),outputkey(2,:),"k")
            draw(outputkey,"w-")
            draw([outputkey(1,3),outputkey(1,4);outputkey(2,3),outputkey(2,4)],"k")
        end

        % to give the angle for the next part of the animation
        thetaout = theta-deltatheta;
end