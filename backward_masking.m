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

target     = imread('target','jpg');
tex1       = Screen('MakeTexture',w,target);
mask       = imread('mask','jpg');
tex2       = Screen('MakeTexture',w,mask);

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(winRect);

% Set the text size
Screen('TextSize', w, 48 );
Screen('TextFont',w,'Times');

Screen('DrawLine', w, black, xCenter-20, yCenter, xCenter+20, yCenter, 4);
Screen('DrawLine', w, black, xCenter, yCenter-20, xCenter, yCenter+20, 4);
Screen('Flip', w) ;

press = true;

while press
    [~, keyCode, ~] = KbWait;
    pressedKey = KbName(keyCode) ;
    if  strcmpi(pressedKey, 'space') == 1
        press = false;
    end
    
end


% Screen('DrawLine', w, black, xCenter-20, yCenter, xCenter+20, yCenter, 4);
% Screen('DrawLine', w, black, xCenter, yCenter-20, xCenter, yCenter+20, 4);
% Screen('Flip', w) ;
% 
% WaitSecs(0.5);

Screen('DrawTexture',w,tex1);
Screen('Flip', w) ;

% DrawFormattedText(w, ' ', 'center', 'center' , grey) ;
% Screen('Flip', w) ;
% Screen('Flip', w) ;


Screen('DrawTexture',w,tex2);
Screen('Flip', w) ;
WaitSecs(0.3);

DrawFormattedText(w, ' ', 'center', 'center' , grey) ;
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
