function TimerShiva()
global q goalX
goal1x = 800;
goal2x = 600;
goalX = goal1x;
t0 = tic;
q = zeros(1,2);

tHandle = timer('TimerFcn',...
    {@sqWave_callback_fcn, goal1x, goal2x,t0}, ...
    'Period' , 0.5, 'TasksToExecute' , 10, 'ExecutionMode', 'fixedDelay');
 
start(tHandle);


pause(10);

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
    
    figure(1)
plot(q(:,1),q(:,2));
xlabel('time (s)');
ylabel('pixels');

end

end
