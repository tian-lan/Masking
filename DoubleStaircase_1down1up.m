sca;
clc;
close all;
clearvars;

commandwindow


ResPath = '.\sc_testResults';

subject = num2str(input('Subject:  '));
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);
commandwindow

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
black  = [0 0 0];
white  = [255 255 255];
grey   = [128 128 128];
red    = [255 0 0];
green  = [0 255 0];
blue   = [0 0 255];
                                       
% Open an on screen window and color it grey
[w, winRect] = Screen('OpenWindow', 0, grey);
hz = Screen('NominalFrameRate', w);
HideCursor;

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(winRect);

% Set the text size
Screen('TextSize', w, 90);
Screen('TextFont',w,'Times');

target     = imread('target','jpg');
tex1       = Screen('MakeTexture',w,target);
mask       = imread('mask','jpg');
tex2       = Screen('MakeTexture',w,mask);

%% Staircase initilization

sc_design.SOA_min  = 1;
sc_design.SOA_max  = (0.2 - mod(0.2,sc_design.SOA_min/hz))/(sc_design.SOA_min/hz);

sc_design.InitialStepSize = sc_design.SOA_max/2;
sc_design.MinStepSize     = sc_design.SOA_min;

sc_design.nTrials  = 100;

sc_design.StairOrder = [ones(1,sc_design.nTrials/2) 2*ones(1,sc_design.nTrials/2)];
sc_design.StairOrder = sc_design.StairOrder(randperm(size(sc_design.StairOrder,2))); % 50/50 distribution of stair1 and stair2 

sc_design.Targets = zeros(1,sc_design.nTrials);

for i = 1:size(sc_design.Targets,2)
    sc_design.Targets(1,i) = randi(10);
end
sc_design.Targets(sc_design.Targets == 10) = 0;  % Generate target vector for all trials (random number 0~9)


sc_results.intensity = nan(2,sc_design.nTrials);
sc_results.response  = nan(2,sc_design.nTrials);

% %this parameter keeps track of the number of correct responses in a row
% correctInaRow1 = 0;  % counter for stair 1
% correctInaRow2 = 0;  % counter for stair 2




    Initial_nRefresh1 = sc_design.SOA_max;     % Starts from top

    Initial_nRefresh2 = sc_design.SOA_min;     % Starts from bottom


%---------------------------------------------------------------------------
% Staircase procedure - to determine threshold


for i = 1:sc_design.nTrials
    
DrawFormattedText(w, '+', 'center', 'center', black) ;
Screen('Flip', w) ;

WaitSecs(0.5*rand(1)+1.5);


    if i == 1 
    nRefresh1 = Initial_nRefresh1;
    CurrentStepsize1 = ceil(sc_design.SOA_max/2);

    nRefresh2 = Initial_nRefresh2;
    CurrentStepsize2 = CurrentStepsize1;
    end


       
if sc_design.StairOrder(i) == 1 

        for n = 1:nRefresh1 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), 'center', 'center', black) ;
            Screen('Flip', w) ;
        end
        
else
    
        for n = 1:nRefresh2 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), 'center', 'center', black) ;
            Screen('Flip', w) ;
        end     
        
end


        DrawFormattedText(w, num2str(sc_design.Targets(1,i)), 'center', 'center' , black);
        DrawFormattedText(w, '#', 'center', 'center' , black);
        DrawFormattedText(w, '%', 'center', 'center' , black);
        DrawFormattedText(w, '$', 'center', 'center' , black);
        DrawFormattedText(w, '@', 'center', 'center' , black);
        Screen('Flip', w) ;
        WaitSecs(0.3);
        
%         DrawFormattedText(w, 'Did you see the target?', 'center', 'center', black) ;
        DrawFormattedText(w, ' ', 'center', 'center', grey) ;
        Screen('Flip', w) ;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, '1!') == 1||strcmpi(pressedKey, '0)') == 1
                press = false;
            end
            
        end

        
        
        
        if sc_design.StairOrder(i) == 1
            
            sc_results.intensity(1,i) = nRefresh1;
        else
           
            sc_results.intensity(2,i) = nRefresh2;
        end
        
        
        if strcmpi(pressedKey, '1!') == 1
            if sc_design.StairOrder(i) == 1
                sc_results.response(1,i) = 1;

                    nRefresh1 = nRefresh1 - CurrentStepsize1;
                    CurrentStepsize1 = ceil(CurrentStepsize1/2);

                 
                
            else
                sc_results.response(2,i) = 1;

                
                    if i == 1
                        Screen('CloseAll'); 
                    else
                        nRefresh2 = nRefresh2 - CurrentStepsize2;
                        CurrentStepsize2 = ceil(CurrentStepsize2/2);
                    end

                
            end
            
        else
            if sc_design.StairOrder(i) == 1
                sc_results.response(1,i) = 0;
                nRefresh1 = nRefresh1 + CurrentStepsize1;
                CurrentStepsize1 = ceil(CurrentStepsize1/2);

            else
                sc_results.response(2,i) = 0;
                nRefresh2 = nRefresh2 + CurrentStepsize2;
                CurrentStepsize2 = ceil(CurrentStepsize2/2);

            end
        end
  
    
end



DrawFormattedText(w,'Thank you.', 'center', 'center' , black) ;
Screen('Flip', w) ;

        press = true;
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end  
        end

        

sc_results.ResponseHigh2Low = sc_results.response(1,:);
sc_results.ResponseHigh2Low = sc_results.ResponseHigh2Low(~isnan(sc_results.ResponseHigh2Low));

sc_results.IntensityHigh2Low = sc_results.intensity(1,:);
sc_results.IntensityHigh2Low = sc_results.IntensityHigh2Low(~isnan(sc_results.IntensityHigh2Low));

sc_results.ResponseLow2High = sc_results.response(2,:);
sc_results.ResponseLow2High = sc_results.ResponseLow2High(~isnan(sc_results.ResponseLow2High));

sc_results.IntensityLow2High = sc_results.intensity(2,:);
sc_results.IntensityLow2High = sc_results.IntensityLow2High(~isnan(sc_results.IntensityLow2High));

% Clear the screen
Screen('CloseAll'); 
ShowCursor;

formatOut = 'yymmdd';
date = datestr(now,formatOut);

filename = sprintf('%s%c%s_%s.mat', ResPath, filesep, date, subject);

save(filename);

