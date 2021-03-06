sca;
clc;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1);
commandwindow

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define grey2 and white
black  = [0 0 0];
white  = [255 255 255];
grey   = [128 128 128];
grey2  = [80 80 80];
red    = [255 0 0];
green  = [0 255 0];
blue   = [0 0 255];

ResPath_sc = '.\sc_testResults';
ResPath    = 'Results';

subject = num2str(input('Subject:  '));
                                       
% Open an on screen window and color it grey
[w, winRect] = Screen('OpenWindow', 0, grey);
hz = Screen('NominalFrameRate', w);
HideCursor;

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(winRect);

% Set the text size
Screen('TextSize', w, 30);
Screen('TextFont',w,'Times');

target     = imread('target','jpg');
tex1       = Screen('MakeTexture',w,target);
mask       = imread('mask','jpg');
tex2       = Screen('MakeTexture',w,mask);

Rect_tll = [xCenter-15-30*3, yCenter-25-50*2, xCenter-15-30*2, yCenter-25-50];
Rect_tlr = OffsetRect(Rect_tll, 2*30,0);
Rect_tlu = OffsetRect(Rect_tll, 30,-50);
Rect_tld = OffsetRect(Rect_tll, 30,50);

Rect_trl = OffsetRect(Rect_tll, 4*30,0);
Rect_trr = OffsetRect(Rect_tll, 6*30,0);
Rect_tru = OffsetRect(Rect_tll, 5*30,-50);
Rect_trd = OffsetRect(Rect_tll, 5*30,50);

Rect_bll = OffsetRect(Rect_tll, 0,4*50);
Rect_blr = OffsetRect(Rect_tll, 2*30,4*50);
Rect_blu = OffsetRect(Rect_tll, 30,3*50);
Rect_bld = OffsetRect(Rect_tll, 30,5*50);

Rect_brl = OffsetRect(Rect_tll, 4*30,4*50);
Rect_brr = OffsetRect(Rect_tll, 6*30,4*50);
Rect_bru = OffsetRect(Rect_tll, 5*30,3*50);
Rect_brd = OffsetRect(Rect_tll, 5*30,5*50);





DrawFormattedText(w, 'This is the beginning.', 'center', 'center' , grey2) ;
Screen('Flip', w) ;

        press = true;
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end  
        end
        
        Screen('FillRect', w, grey);
        Screen('Flip', w);
        
        
%% Staircase initilization

sc_design.SOA_min  = 1;
sc_design.SOA_max  = (0.2 - mod(0.2,sc_design.SOA_min/hz))/(sc_design.SOA_min/hz);

sc_design.InitialStepSize = sc_design.SOA_max/2;
sc_design.MinStepSize     = sc_design.SOA_min;

sc_design.nTrials  = 100;

sc_design.StairOrder = [ones(1,sc_design.nTrials/2) 2*ones(1,sc_design.nTrials/2)];
sc_design.StairOrder = sc_design.StairOrder(randperm(size(sc_design.StairOrder,2))); % 50/50 distribution of stair1 and stair2 

sc_design.Targets   = zeros(1,sc_design.nTrials);
sc_design.TargetLoc = zeros(1,sc_design.nTrials);

for i = 1:size(sc_design.Targets,2)
    sc_design.Targets(1,i) = randi(10);
end
sc_design.Targets(sc_design.Targets == 10) = 0;  % Generate target vector for all trials (random number 0~9)

for i = 1:size(sc_design.TargetLoc,2)
    sc_design.TargetLoc(1,i) = randi(4);
end  % Generate target location vector for all trials 
     % 1: top left; 2: top right; 3: bottom left; 4: bottom right 


sc_results.intensity = nan(2,sc_design.nTrials);
sc_results.response  = nan(2,sc_design.nTrials);

% %this parameter keeps track of the number of correct responses in a row
% correctInaRow1 = 0;  % counter for stair 1
% correctInaRow2 = 0;  % counter for stair 2




    Initial_nRefresh1 = sc_design.SOA_max;     % Starts from top

    Initial_nRefresh2 = sc_design.SOA_min;     % Starts from bottom

%---------------------------------------------------------------------------
%% Staircase procedure - to determine threshold

for i = 1:sc_design.nTrials
    
DrawFormattedText(w, '+', 'center', 'center', grey2) ;
Screen('Flip', w) ;

WaitSecs(0.5*rand(1)+1.5);


    if i == 1 
    nRefresh1 = Initial_nRefresh1;
    CurrentStepsize1 = ceil(sc_design.SOA_max/2);

    nRefresh2 = Initial_nRefresh2;
    CurrentStepsize2 = CurrentStepsize1;
    end
    
    
       
 if sc_design.StairOrder(i) == 1 

        
    if sc_design.TargetLoc(1,i) == 1
        for n = 1:nRefresh1 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter-70, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+30*2, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
             
    elseif sc_design.TargetLoc(1,i) == 2
        for n = 1:nRefresh1 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter+50, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
                
    elseif sc_design.TargetLoc(1,i) == 3
        for n = 1:nRefresh1 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)),  xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
        
    elseif sc_design.TargetLoc(1,i) == 4
        for n = 1:nRefresh1 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter+50, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
    end
       
 else
    
    
    if sc_design.TargetLoc(1,i) == 1
        for n = 1: nRefresh2 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter-70, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
             
    elseif sc_design.TargetLoc(1,i) == 2
        for n = 1: nRefresh2 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter+50, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
                
    elseif sc_design.TargetLoc(1,i) == 3
        for n = 1: nRefresh2 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)),  xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
        
    elseif sc_design.TargetLoc(1,i) == 4
        for n = 1: nRefresh2 % display target
            DrawFormattedText(w, num2str(sc_design.Targets(1,i)), xCenter+50, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
    end
            
 end     
        


        Screen('FrameRect', w, grey2, Rect_tll, 3);
        Screen('FrameRect', w, grey2, Rect_tlr, 3);
        Screen('FrameRect', w, grey2, Rect_tlu, 3);
        Screen('FrameRect', w, grey2, Rect_tld, 3);
        
        Screen('FrameRect', w, grey2, Rect_trl, 3);
        Screen('FrameRect', w, grey2, Rect_trr, 3);
        Screen('FrameRect', w, grey2, Rect_tru, 3);
        Screen('FrameRect', w, grey2, Rect_trd, 3);
        
        Screen('FrameRect', w, grey2, Rect_bll, 3);
        Screen('FrameRect', w, grey2, Rect_blr, 3);
        Screen('FrameRect', w, grey2, Rect_blu, 3);
        Screen('FrameRect', w, grey2, Rect_bld, 3);
        
        Screen('FrameRect', w, grey2, Rect_brl, 3);
        Screen('FrameRect', w, grey2, Rect_brr, 3);
        Screen('FrameRect', w, grey2, Rect_bru, 3);
        Screen('FrameRect', w, grey2, Rect_brd, 3);


        Screen('Flip', w) ;
        WaitSecs(0.3);
        
%         DrawFormattedText(w, 'Did you see the target?', 'center', 'center', grey2) ;
        Screen('FillRect', w, grey);
        Screen('Flip', w) ;
        
        
        press = true;
        
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, '1!') == 1||strcmpi(pressedKey, '0)') == 1
                press = false;
            end
            
        end

        
 %%
 
        if sc_design.StairOrder(i) == 1
            
            sc_results.intensity(1,i) = nRefresh1;
        else
           
            sc_results.intensity(2,i) = nRefresh2;
        end
        
        
        if strcmpi(pressedKey, '1!') == 1  % if pressing 1
            if sc_design.StairOrder(i) == 1
                sc_results.response(1,i) = 1;
                
                if nRefresh1 == 1
                        nRefresh1 = nRefresh1 + CurrentStepsize1;
                        CurrentStepsize1 = ceil(CurrentStepsize1/2);
                else
                        nRefresh1 = nRefresh1 - CurrentStepsize1;
                        CurrentStepsize1 = ceil(CurrentStepsize1/2);
                end

                 
                
            else  % stair 2
                sc_results.response(2,i) = 1;
                idx = find(sc_results.response(2,:) == 1);
                
                if nRefresh2 == 1
                        nRefresh2 = nRefresh2 + CurrentStepsize2;
                        CurrentStepsize2 = ceil(CurrentStepsize2/2);
                else
                        nRefresh2 = nRefresh2 - CurrentStepsize2;
                        CurrentStepsize2 = ceil(CurrentStepsize2/2);
                end
                
            end
            
        else                 % if pressing 0
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



DrawFormattedText(w,'Thank you.', 'center', 'center' , grey2) ;
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

sc_results.High2Low_Last10 = sc_results.IntensityHigh2Low(find(sc_results.ResponseHigh2Low==1,10,'last'));
sc_results.Low2High_Last10 = sc_results.IntensityLow2High(find(sc_results.ResponseLow2High==1,10,'last'));

threshold_mean_High2Low = mean(sc_results.High2Low_Last10);
threshold_mean_Low2High = mean(sc_results.Low2High_Last10);


%%%%%%%%%%%%%%%%%%%%%%
% Threshold %
sc_results.threshold = round(mean([threshold_mean_High2Low,threshold_mean_Low2High]));
%---------------------------------------------------------------------------

formatOut = 'yymmdd';
date = datestr(now,formatOut);

filename_sc = sprintf('%s%c%s_%s_sc.mat', ResPath_sc, filesep, date, subject);

save(filename_sc);


%% Masking - Practice session


DrawFormattedText(w, 'This is practice.', 'center', 'center' , grey2) ;
Screen('Flip', w) ;
WaitSecs(0.1);

        press = true;
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end  
        end
        
        Screen('FillRect', w, grey);
        Screen('Flip', w);
        

%%%%%%%%%%
Target2Mask = sc_results.threshold;  % should obtain from staircase procedure
%%%%%%%%%%


n_practice = 1.5/0.05+1;

acc_practice = zeros(1,n_practice);

% Shuffle onset so that each block has same number of delay of each type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stim_onset_practice = linspace(0.5,2,1.5/0.05+1);  % 50ms increment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_gotone_practice        = zeros(1,n_practice);
t_res_practice           = zeros(1,n_practice);         
RT_practice     = zeros(1,n_practice);
choice_practice = cell(1,n_practice);


Targets_practice = zeros(1,n_practice);
for i = 1:size(Targets_practice,2)
    Targets_practice(1,i) = randi(10);
end
Targets_practice(Targets_practice == 10) = 0;  % Generate target vector for all trials (random number 0~9)


TargetLoc_practice = zeros(1,n_practice);
for i = 1:size(TargetLoc_practice,2)
    TargetLoc_practice(1,i) = randi(4);
end 



    for i = 1:n_practice
        
        DrawFormattedText(w, '+', 'center', 'center', grey2) ;
        
        Beeper(3000,1,0.025);
        Screen('Flip', w) ;
        
        t_gotone_practice(i) = GetSecs;
        
        
        KbQueueCreate; %creates cue using defaults
        KbQueueStart;  %starts the cue
        
        press_main = true;
        while press_main
            
            % Proceed regardless of key press
            wait = true;
            while wait
                CurrentTime = GetSecs;
                if CurrentTime - t_gotone_practice(i) > stim_onset_practice(i) % Once passing stim-onset time
                    
%                     for nRefresh = 1:Target2Mask
%                         DrawFormattedText(w, num2str(Targets_practice(1,i)), 'center', 'center' , grey2);
%                         Screen('Flip', w);
%                     end
                    wait = false;
                    
                end
            end
            
            
    if TargetLoc_practice(1,i) == 1
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets_practice(1,i)), xCenter-70, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+30*2, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
             
    elseif TargetLoc_practice(1,i) == 2
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets_practice(1,i)), xCenter+50, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
                
    elseif TargetLoc_practice(1,i) == 3
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets_practice(1,i)),  xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
        
    elseif TargetLoc_practice(1,i) == 4
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets_practice(1,i)), xCenter+50, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
    end

    
        Screen('FrameRect', w, grey2, Rect_tll, 3);
        Screen('FrameRect', w, grey2, Rect_tlr, 3);
        Screen('FrameRect', w, grey2, Rect_tlu, 3);
        Screen('FrameRect', w, grey2, Rect_tld, 3);
        
        Screen('FrameRect', w, grey2, Rect_trl, 3);
        Screen('FrameRect', w, grey2, Rect_trr, 3);
        Screen('FrameRect', w, grey2, Rect_tru, 3);
        Screen('FrameRect', w, grey2, Rect_trd, 3);
        
        Screen('FrameRect', w, grey2, Rect_bll, 3);
        Screen('FrameRect', w, grey2, Rect_blr, 3);
        Screen('FrameRect', w, grey2, Rect_blu, 3);
        Screen('FrameRect', w, grey2, Rect_bld, 3);
        
        Screen('FrameRect', w, grey2, Rect_brl, 3);
        Screen('FrameRect', w, grey2, Rect_brr, 3);
        Screen('FrameRect', w, grey2, Rect_bru, 3);
        Screen('FrameRect', w, grey2, Rect_brd, 3);

        Screen('Flip', w) ;
        WaitSecs(0.3);
        
        
        DrawFormattedText(w, 'What was the target number?', 'center', 'center' , grey2);
        Screen('Flip', w) ;
            
                wait2 = true;
                while wait2
                    bb = GetSecs;
                    if bb - t_gotone_practice(i) > 2
                       [pressed, firstPress, ~, lastPress, ~]=KbQueueCheck; %  check if any key was pressed.
                       if pressed
                          firstPress(firstPress==0)=NaN; %little trick to get rid of 0s
                          [endtime, Index]=min(firstPress);
                          t_res_practice(i) = endtime;

                          wait2 = false;
                          press_main = false;
                
                       else
                          t_res_practice(i) = nan;
                          wait2 = false;
                          press_main = false;
                       end
                    end
                end
        end
        
press = true;

while press
    [~, keyCode, ~] = KbWait;
    pressedKey = KbName(keyCode);
    if  strcmpi(pressedKey, '1') == 1||strcmpi(pressedKey, '2') == 1||strcmpi(pressedKey, '3') == 1||strcmpi(pressedKey, '4') == 1||strcmpi(pressedKey, '5') == 1||strcmpi(pressedKey, '6') == 1||strcmpi(pressedKey, '7') == 1||strcmpi(pressedKey, '8') == 1||strcmpi(pressedKey, '9') == 1||strcmpi(pressedKey, '0') == 1
        press = false;
        choice_practice{1,i} = pressedKey;
    end
    
end
        Screen('Flip', w) ;

if strcmpi(pressedKey, num2str(Targets_practice(i))) == 1
    acc_practice(1,i) = 1;
else
    acc_practice(1,i) = 0;
end

if ~isempty(t_res_practice(i))&&~isnan(t_res_practice(i))
    RT_practice(1,i) = t_res_practice(i) - t_gotone_practice(i);
else
    RT_practice(1,i) = nan;
    Screen('TextSize', w, 48);
    DrawFormattedText(w, 'Please press within 2 seconds after the beep.', 'center', 'center' , grey2);
    Screen('Flip', w) ;
    WaitSecs(3);
    Screen('FillRect', w, grey);
    Screen('Flip', w);
    Screen('TextSize', w, 30);

end

        Screen('FillRect', w, grey);
        Screen('Flip', w);
        WaitSecs(1);
    

    end


    
%

DrawFormattedText(w, 'Press space to start the experiment.', 'center', 'center' , grey2) ;
Screen('Flip', w) ;

        press = true;
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end  
        end

        Screen('FillRect', w, grey);
        Screen('Flip', w);
        
        
        
        
%% Masking - Experiment part

%%%%%%%%%%
Beep2Target = nanmean(RT_practice);  % should obtain from practice session

Target2Mask = sc_results.threshold;  % should obtain from staircase procedure
%%%%%%%%%%


% Shuffle onset so that each block has same number of delay of each type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stim_onset = linspace(Beep2Target-0.5,Beep2Target+1,1.5/0.05+1);  % 50ms increment, 500ms before - 1s after


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nBlocks = 5;
nTrials = size(stim_onset,2)*3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

acc = zeros(1,nBlocks*nTrials);


stim_onset = repmat(stim_onset,1,nBlocks*nTrials/size(stim_onset,2));

stim_onset = [stim_onset(randperm(size(stim_onset,2)/nBlocks)),...
    stim_onset(randperm(size(stim_onset,2)/nBlocks)),...
    stim_onset(randperm(size(stim_onset,2)/nBlocks)),...
    stim_onset(randperm(size(stim_onset,2)/nBlocks)),...
    stim_onset(randperm(size(stim_onset,2)/nBlocks))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_gotone = zeros(1,nBlocks*nTrials);
t_res    = zeros(1,nBlocks*nTrials);         
RT       = zeros(1,nBlocks*nTrials);
choice   = cell(1,nBlocks*nTrials);
% keys   = cell(1,nBlocks*nTrials);

Targets = zeros(1,nBlocks*nTrials);
for i = 1:size(Targets,2)
    Targets(1,i) = randi(10);
end
Targets(Targets == 10) = 0;  % Generate target vector for all trials (random number 0~9)


TargetLoc = zeros(1,nBlocks*nTrials);
for i = 1:size(TargetLoc,2)
    TargetLoc(1,i) = randi(4);
end



for i = 1:nBlocks
    for ii = 1:nTrials
        Screen('TextSize', w, 30);
        Beeper(3000,1,0.025);
        Screen('Flip', w) ;
        
        t_gotone(i) = GetSecs;
        
        
        KbQueueCreate; %creates cue using defaults
        KbQueueStart;  %starts the cue
        
        press_main = true;
        while press_main
            
            % Proceed regardless of key press
            wait = true;
            while wait
                CurrentTime = GetSecs;
                if CurrentTime - t_gotone(i) > stim_onset(i) % Once passing stim-onset time
                    
%                     for nRefresh = 1:Target2Mask
%                         DrawFormattedText(w, num2str(Targets_practice(1,i)), 'center', 'center' , grey2);
%                         Screen('Flip', w);
%                     end
                    wait = false;
                    
                end
            end
            
            
    if TargetLoc(1,i) == 1
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets(1,i)), xCenter-70, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+30*2, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
             
    elseif TargetLoc(1,i) == 2
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets(1,i)), xCenter+50, yCenter-50, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
                
    elseif TargetLoc(1,i) == 3
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets(1,i)),  xCenter-70, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
        
    elseif TargetLoc(1,i) == 4
        for n = 1:Target2Mask % display target
            DrawFormattedText(w, num2str(Targets(1,i)), xCenter+50, yCenter+110, grey2) ;
            DrawFormattedText(w, '*', xCenter+50, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter-70, grey2) ;
            DrawFormattedText(w, '*', xCenter-70, yCenter+110, grey2) ;
            Screen('Flip', w) ;
        end
    end

    
        Screen('FrameRect', w, grey2, Rect_tll, 3);
        Screen('FrameRect', w, grey2, Rect_tlr, 3);
        Screen('FrameRect', w, grey2, Rect_tlu, 3);
        Screen('FrameRect', w, grey2, Rect_tld, 3);
        
        Screen('FrameRect', w, grey2, Rect_trl, 3);
        Screen('FrameRect', w, grey2, Rect_trr, 3);
        Screen('FrameRect', w, grey2, Rect_tru, 3);
        Screen('FrameRect', w, grey2, Rect_trd, 3);
        
        Screen('FrameRect', w, grey2, Rect_bll, 3);
        Screen('FrameRect', w, grey2, Rect_blr, 3);
        Screen('FrameRect', w, grey2, Rect_blu, 3);
        Screen('FrameRect', w, grey2, Rect_bld, 3);
        
        Screen('FrameRect', w, grey2, Rect_brl, 3);
        Screen('FrameRect', w, grey2, Rect_brr, 3);
        Screen('FrameRect', w, grey2, Rect_bru, 3);
        Screen('FrameRect', w, grey2, Rect_brd, 3);

        Screen('Flip', w) ;
        WaitSecs(0.3);
        
        
        DrawFormattedText(w, 'What was the target number?', 'center', 'center' , grey2);
        Screen('Flip', w) ;
            
                wait2 = true;
                while wait2
                    bb = GetSecs;
                    if bb - t_gotone(i) > 2
                       [pressed, firstPress, ~, lastPress, ~]=KbQueueCheck; %  check if any key was pressed.
                       if pressed
                          firstPress(firstPress==0)=NaN; %little trick to get rid of 0s
                          [endtime, Index]=min(firstPress);
                          t_res(i) = endtime;

                          wait2 = false;
                          press_main = false;
                
                       else
                          t_res(i) = nan;
                          wait2 = false;
                          press_main = false;
                       end
                    end
                end
        end
        
press = true;

while press
    [~, keyCode, ~] = KbWait;
    pressedKey = KbName(keyCode);
    if  strcmpi(pressedKey, '1') == 1||strcmpi(pressedKey, '2') == 1||strcmpi(pressedKey, '3') == 1||strcmpi(pressedKey, '4') == 1||strcmpi(pressedKey, '5') == 1||strcmpi(pressedKey, '6') == 1||strcmpi(pressedKey, '7') == 1||strcmpi(pressedKey, '8') == 1||strcmpi(pressedKey, '9') == 1||strcmpi(pressedKey, '0') == 1
        press = false;
        choice{1,i} = pressedKey;
    end
    
end
        Screen('Flip', w) ;

if strcmpi(pressedKey, num2str(Targets_practice(i))) == 1
    acc(1,i) = 1;
else
    acc(1,i) = 0;
end

if ~isempty(t_res(i))&&~isnan(t_res(i))
    RT(1,i) = t_res(i) - t_gotone(i);
else
    RT(1,i) = nan;
    Screen('TextSize', w, 48);
    DrawFormattedText(w, 'Please press within 2 seconds after the beep.', 'center', 'center' , grey2);
    Screen('Flip', w) ;
    WaitSecs(3);
    Screen('FillRect', w, grey);
    Screen('Flip', w);
    Screen('TextSize', w, 30);

end

        Screen('FillRect', w, grey);
        Screen('Flip', w);
        WaitSecs(1);
    

    end
end

%--------------------------------------------------------------------------


DrawFormattedText(w, 'This is the end.', 'center', 'center' , grey2) ;
Screen('Flip', w) ;

        press = true;
        while press
            [~, keyCode, ~] = KbWait;
            pressedKey = KbName(keyCode) ;
            if  strcmpi(pressedKey, 'space') == 1
                press = false;
            end  
        end

        
% Clear the screen
Screen('CloseAll'); 
ShowCursor;

formatOut = 'yymmdd';
date = datestr(now,formatOut);

filename = sprintf('%s%c%s_%s.mat', ResPath, filesep, date, subject);

save(filename);

