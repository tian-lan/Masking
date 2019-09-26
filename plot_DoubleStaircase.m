figure
clf
stairs(sc_results.IntensityHigh2Low);
correctTrials = sc_results.ResponseHigh2Low==1;
hold on
incorrectTrials = sc_results.ResponseHigh2Low==0;
plot(find(correctTrials),sc_results.IntensityHigh2Low(correctTrials),'ko','MarkerFaceColor','g');
plot(find(incorrectTrials),sc_results.IntensityHigh2Low(incorrectTrials),'ko','MarkerFaceColor','r');

ylim([1 sc_design.SOA_max])
xlabel('Trial number');
ylabel('# of refreshes');


%---------------------------------------------------------------------
figure
clf
stairs(sc_results.IntensityLow2High);
correctTrials = sc_results.ResponseLow2High==1;
hold on
incorrectTrials = sc_results.ResponseLow2High==0;
plot(find(correctTrials),sc_results.IntensityLow2High(correctTrials),'ko','MarkerFaceColor','g');
plot(find(incorrectTrials),sc_results.IntensityLow2High(incorrectTrials),'ko','MarkerFaceColor','r');

ylim([1 sc_design.SOA_max])
xlabel('Trial number');
ylabel('# of refreshes');

% -----------------------------------------------------------------------



