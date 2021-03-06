
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% This Octave script will analyze a file containing the results of a 
% monte carlo (MC) analysis.
%
% This script should be called with single argument.
%
% The script will produce a series of walk plots, one for each MC run
%
% example usage (where the single argument is the PID)
%
% walk 11313
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% ################################
% Read in data from veriloga file
% Store in data matrix
% ################################

%arg_list = argv () ;
%pid_num = arg_list{1} ;
pid_num = '31051' ;

filename = ['./results/walk_'  pid_num  '.dat'] ;
fid = fopen(filename, 'rt') ; 

% Read the file into the data matrix

data = dlmread(filename, '\t') ;

% Close the file up .. we are done with it

fclose(fid) ;


% Remove all lines that have a 0 in the first column

indices = find(data(:,1) == 0) ;
data(indices,:) = [] ;

% Go through and remove any lines that have same
% value in column 0 as the line before

% Determine the length of the first column

n = length(data(:,1)) ;

% Go through and find duplicate lines

previous = data(1,1) ;
tagged_for_removal = [] ;

for i = 2:n
   current = data(i,1) ;
   if (current == previous) 
       tagged_for_removal = [tagged_for_removal, i] ;
   end
   previous = current ;
end


% Remove the duplicate lines

data(tagged_for_removal,:) = [] ;

% Find the number of 1's in the first column
% That will be the number of MC runds which we ran

start_indices = find(data(:,1) == 1) ;
runs = length(start_indices) ;

% *******************************************************
%
%  For loop on the number of MC runs that we need to analyze
%
% ********************************************************
walk_vector = [] ;
runs_vector = [] ;
for run_num = 1:runs
   runs_vector = [runs_vector, run_num] ;

% We need to extract the submatrix that corresponds to 
% current MC run

   first = start_indices(run_num) ;
   if (run_num ~= runs) 
        last = start_indices(run_num + 1) - 1 ;
   else
        last = length(data(:,1)) ;
   end

   submatrix = data(first:last, 1:5) ;
%   
% Second column contains the amplitude of the input signal
% Convert to mv

    amp = 1000.0 .* submatrix(:,2) ;

%
% Fifth column contains the propagation delay
% Convert to ns
%

    tpd = 1e9 .* submatrix(:,5) ; 

% Find the minimuim and maximum propgation delays
% The difference is what we refer to as "walk"
% Convert to ps

    minimum = min(tpd) ;
    maximum = max(tpd) ;
    walk = maximum - minimum ;
    walk = 1000.0 .* walk ;    
    tave = mean(tpd) ;

% Take out the mean and comvert to ps

    tpd = tpd - tave ;
    tpd = 1e3 .* tpd ;

    walk_vector = [walk_vector, walk] ;
    
% Create the walk plot

    h_walk = figure('name', 'Walk Plot', 'numbertitle', 'off', 'visible', 'off') ;

    semilogx(amp, tpd, 'r.', 'MarkerSize', 25) ;
    hold on ;
    grid on ;
    xlabel('Input Pulse Amplitude (mV)') ;
    ylabel('Delay Relative to Average (ps)') ;
    title("Walk Characteristics for Constant Fraction Discriminator") ;

% Annotate the plot with useful information

    str = ["Monte Carlo Run #" num2str(run_num, '%d') ] ;
    text(500, 60, str) ;

    str = ["Walk is " num2str(walk, '%5.1f') " ps"] ;
    text(500, 40, str) ;

    str = ["Average delay is " num2str(tave, '%5.1f') " ns"] ;
    text(500, 20, str) ;

% Save the plot as a PDF 

    warning("off") ;
    str = ["./pdf/walk_" pid_num "_" num2str(run_num, '%d')  ".pdf"] ;
    print(h_walk, '-dpdf', '-color', str) ;

    hold off ;
    grid off ;
end

% ******************************************************


% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%
% Create a plot which summarizes performance
%
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

% Create the summary walk plot

    h_summary = figure('name', 'Summary Walk Plot', 'numbertitle', 'off', 'visible', 'off') ;

    plot(runs_vector, walk_vector, 'r.', 'MarkerSize', 25) ;
    axis([0 200  0 1000]) ;
    hold on ;
    grid on ;
    xlabel('Monte Carlo Run Number') ;
    ylabel('Walke (ps)') ;
    title("Walk Summary Plot for Constant Fraction Discriminator") ;

% Save the plot as a PDF 

    warning("off") ;
    str = ["./pdf/walk_" pid_num "_summary.pdf"] ;
    print(h_summary, '-dpdf', '-color', str) ;

exit 
