
%%% Controlling Covariance of kilobots with light by using a webcam, by: Shiva
%%% Shahrokhi and Aaron T. Becker @ University of Houston, Robotic Swarm
%%% Control Lab.

function HandCov()
%Define webcam --the input may be 1 or 2 depending on which webcam of your laptop
%is the default webcam.
cam = webcam(2);
global q goalX
% this is the mean y goal
goalYM = 434;
%this is the mean x goal
goalXM = 600;

%These are the goal covariance matrices.
goalC1 = [18000 -12000; -12000 18000];
goalC2 = [18000 12000; 12000 18000];
%Goal Covariances.
goal1x = goalC1(1,2);
goal2x = goalC2(1,2);
goalX = goal1x;
t0 = tic;
q = zeros(1,2);

success = false;

tHandle = timer('TimerFcn',...
    {@sqWave_callback_fcn, goal1x, goal2x,t0}, ...
    'Period' , 200, 'TasksToExecute' , 4, 'ExecutionMode', 'fixedDelay');
 
start(tHandle);


drawTime=[goalX,0];
while success == false

    
    % Read in a webcam snapshot.
    rgbIm = snapshot(cam);
    %imwrite(rgbIm,'FailImage6.png');
    %crop to have just the table view.
originalImage = imcrop(rgbIm,[345 60 1110 850]);
% make grayscale.
I = rgb2hsv(originalImage);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.065;
channel1Max = 0.567;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.288;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.400;
channel3Max = 1.000;;

% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

  %threshold the image to remove shadows (and only show dark parts of kilobots)
    [centers, radii] = imfindcircles(BW,[10 19],'ObjectPolarity','bright','Sensitivity',0.92 );
    
    % %Mean
    M = mean(centers);
    %Variance
    V = var(centers);
    %Covariance
    C = cov(centers);
    
    imshow(originalImage);
    h = viscircles(centers,radii);
    [s, l] = size(centers);
    goalC = [18000 goalX; goalX 18000];
    
    if isnan(M)== false 
        
    if s > 85 
    hold on
    
    plot(M(1,1) , M(1,2),'*','Markersize',16,'color','red');
    newDot = [C(1,2), toc(t0)];
    drawTime = [drawTime;newDot];
    %Current Mean and Covariance Ellipse
    plot_gaussian_ellipsoid(M,C);
    disp('Goal: ');
    disp(goalX);
    disp('Current: ');
    disp(C(1,2));
    %Goal Mean and Covariance Ellipse
    plot_gaussian_ellipsoid([goalXM goalYM],goalC);
    %plot(centers(:,1),centers(:,2),'+','Markersize',16);
    %Goal X.
    %line([goalXM goalXM], ylim,'color','green','linewidth', 3.0);
    hold off
    end
    end

    if(toc(t0) > 800)
        success = true;
        figure(2)
       plot(q(:,1),q(:,2));
        xlabel('time (s)');
        ylabel('Covariance (pixels)');
        
        hold on 
        plot(drawTime(:,2), drawTime(:,1));
        save('Cov','drawTime');
        hold off
        
       clear('cam')
    end
end

stop(tHandle)
 
function  sqWave_callback_fcn(src,evt, goal1x, goal2x,t0) %#ok<DEFNU>

   tval = toc(t0);
    q= [q;[tval, goalX]];
    
    if goalX == goal1x
        goalX = goal2x;
    else
        goalX = goal1x;
    end
    q= [q;[tval, goalX]];


end

end
