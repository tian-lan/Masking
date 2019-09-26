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

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(winRect);

% Set the text size
Screen('TextSize', w, 48);
Screen('TextFont',w,'Times');

target     = imread('target','jpg');
tex1       = Screen('MakeTexture',w,target);
mask       = imread('mask','jpg');
tex2       = Screen('MakeTexture',w,mask);



DrawFormattedText(w, 'This is the beginning.', 'center', 'center' , black) ;
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
        




%% Intentional binding with a mask - Practice session


DrawFormattedText(w, 'This is practice.', 'center', 'center' , black) ;
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
Target2Mask = 5;  % should obtain from staircase procedure
%%%%%%%%%%


n_practice = 1/0.05+1;

acc_practice = zeros(1,n_practice);

% Shuffle onset so that each block has same number of delay of each type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stim_onset_practice = linspace(0.5,1.5,1/0.05+1);  % 50ms increment
stim_onset_practice = stim_onset_practice(randperm(size(stim_onset_practice,2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
RT_practice     = zeros(1,n_practice);
choice_practice = cell(1,n_practice);


Targets_practice = zeros(1,n_practice);
for i = 1:size(Targets_practice,2)
    Targets_practice(1,i) = randi(10);
end
Targets_practice(Targets_practice == 10) = 0;  % Generate target vector for all trials (random number 0~9)


Screen('TextSize', w, 72);


    for i = 1:n_practice
        
        DrawFormattedText(w, '+', 'center', 'center', black) ;
        Screen('Flip', w) ;
        
        Beeper(3000,1,0.025);
        
        [keys,time] = waitTill(2);   % Gather key press within 2s after Go-tone
        
        WaitSecs(stim_onset_practice(i));  % different lag each trial
        
        
        for nRefresh = 1:Target2Mask
        DrawFormattedText(w, num2str(Targets_practice(1,i)), 'center', 'center' , black);
        Screen('Flip', w);
        end

        
        
        DrawFormattedText(w, num2str(Targets_practice(1,i)), 'center', 'center' , black);
        DrawFormattedText(w, '#', 'center', 'center' , black);
        DrawFormattedText(w, '%', 'center', 'center' , black);
        DrawFormattedText(w, '$', 'center', 'center' , black);
        DrawFormattedText(w, '@', 'center', 'center' , black);
        Screen('Flip', w);
        WaitSecs(0.3);

        
        Screen('FillRect', w, grey);
        Screen('Flip', w);
        
        DrawFormattedText(w, 'What was the target number?', 'center', 'center' , black);
        Screen('Flip', w) ;
        
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

          if ~isempty(time)
             RT_practice(1,i) = time;
          else
             RT_practice(1,i) = nan;
    
             Screen('TextSize', w, 48);
             DrawFormattedText(w, 'Please press within 2 seconds after the beep.', 'center', 'center' , black);
             Screen('Flip', w) ;
             WaitSecs(3);
             Screen('FillRect', w, grey);
             Screen('Flip', w);
             Screen('TextSize', w, 72);
    
          end

        Screen('FillRect', w, grey);
        Screen('Flip', w);
        WaitSecs(1);
    

    end


    
% Clear the screen
Screen('CloseAll'); 
ShowCursor;

ACCURACY = sum(acc_practice)/size(acc_practice,2);