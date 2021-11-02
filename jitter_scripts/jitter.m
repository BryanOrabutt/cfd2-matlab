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
% jitter.m 11313
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% ################################
% Read in data from veriloga file
% Store in data matrix
% ################################
%graphics_toolkit("gnuplot")

pid_num = 5555 ;
tau_r = 3e-9;

filename = ['./results/jitter_'  num2str(pid_num)  '.dat'] ;
fid = fopen(filename, 'rt') ; 

% Read the file into the data matrix

data = dlmread(filename, '\t') ;
data2 = dlmread("./results/jitter_13506.dat");

% Close the file up .. we are done with it

fclose(fid) ;

% Save the configuration settings for each event
idx = floor(data(:,1)) == 0;
%config = data(idx,:);
data(idx,:) = [];

% Remove all lines that have a 0 in the first column

indices = find(data(:,1) == 0) ;
data(indices,:) = [] ;

% Go through and remove any lines that have same
% value in column 0 as the line before

% Determine the length of the first column

n = length(data(:,1)) ;

% Go through and find duplicate lines

%previous = data(1,1) ;
%tagged_for_removal = [] ;

%for i = 2:n
%   current = data(i,1) ;
%   if (current == previous) 
%       tagged_for_removal = [tagged_for_removal, i] ;
%   end
%   previous = current ;
%end


% Remove the duplicate lines

%data(tagged_for_removal,:) = [] ;

% Find the number of 1's in the first column
% That will be the number of MC runds which we ran

start_indices = find(data(:,1) == 1) ;
runs = length(start_indices) 

% *******************************************************
%
%  For loop on the number of MC runs that we need to analyze
%
% ********************************************************
cfd_jitter_vector = [];
runs_vector = [] ;
cfd_jitter_vector2 = [];

%get rise time consant in picoseconds
%tau_r = config(1)*1e12;

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

	submatrix = data(first:last, 1:7);
	submatrix2 = data2(first:last, 1:7);
%   
% Second column contains the amplitude of the input signal
% Convert to mv

    amp = 1000.0 .* submatrix(:,2) ;

%
% Fifth column contains the propagation delay
% Convert to ps
%

    cfd_tpd = 1e12 .* submatrix(:,5)  ;
    cfd_tpd2 = 1e12 .* submatrix2(:,5)  ;

	%jitter_cfd = max(cfd_tpd) - min(cfd_tpd);

    cfd_jitter_vector = [cfd_jitter_vector, cfd_tpd] ;
    cfd_jitter_vector2 = [cfd_jitter_vector2, cfd_tpd2] ;

end

% ******************************************************


% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%
% Create a plot which summarizes performance
%
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

% Create the summary walk plot

    h_summary = figure('name', 'Summary Jitter Plot', 'numbertitle', 'off', 'visible', 'off') ;
	hold on;
	grid on;
	box on;

	cfd_jitter_vector = cfd_jitter_vector - mean(cfd_jitter_vector);
	cfd_jitter_vector2 = cfd_jitter_vector2 - mean(cfd_jitter_vector2);
	jitter_val = max(cfd_jitter_vector) - min(cfd_jitter_vector);
	str1 = ["Jitter is " num2str(jitter_val, '%5.1f') " ps"] ;

	xloc = xlim;
	xloc = xloc(1)+0.25*xloc(2);

	yloc = max(cfd_jitter_vector)*1.2;
			
	text(xloc, yloc, str1, "fontsize", 16);

    plot(runs_vector, cfd_jitter_vector, 'r.', 'MarkerSize', 25) ;
	set(gca, "fontsize", 18);
    axis([-1 length(runs_vector)+1 min(cfd_jitter_vector)*1.25 max(cfd_jitter_vector)*1.25]) ;
	%xlim([-1 length(runs_vector)+1]);
    hold on ;
    grid on ;
    xlabel('Monte Carlo Run Number', "fontsize", 16) ;
    ylabel('Delay relative to average (ps)', "fontsize", 16) ;
    title("Jitter Summary Plot for Constant Fraction Discriminator", "fontsize", 16) ;
% 
% % Save the plot as a PDF 
% 
%     warning("off") ;
%     str = ["./pdf/jitter_" pid_num "_summary.pdf"] ;
% 	disp(["Creating pdf file: " str]);
%     print(h_summary, '-dpdf', '-color', str) ;

%Create histogram

    h_hist = figure('name', 'Histogram Jitter Plot') ;
	hold on;
	grid on;
	box on;

	nbins = 10;
	if(length(cfd_jitter_vector > 100))
		nbins = floor(length(cfd_jitter_vector)/13);
	end
	nbins = 25;

	risetime = tau_r*2.2e12
	cfd_jitter_vector = 100.*(cfd_jitter_vector./risetime);
%     cfd_jitter_vector = cfd_jitter_vector(cfd_jitter_vector <= 7.5);
%     cfd_jitter_vector = cfd_jitter_vector(cfd_jitter_vector >= -7.5);

    [hc, centers] = hist(cfd_jitter_vector./1.5, 30);
	histogram(cfd_jitter_vector./1.5, 30, 'FaceColor', 'red');

	max_count = max(hc)
	leftbin = centers(find(hc > max_count/2, 1, 'first'))
	rightbin = centers(find(hc > max_count/2, 1, 'last'))
	fwhm = rightbin-leftbin
    
	cfd_jitter_vector2 = 100.*(cfd_jitter_vector2./risetime);
    [hc, centers] = hist(cfd_jitter_vector2, 50);
	histogram(cfd_jitter_vector2, 30, 'FaceColor', 'blue');
%     pd2 = histfit(cfd_jitter_vector2, nbins);
%     x2 = get(pd2(2), 'XData');
%     y2 = get(pd2(2), 'YData');

% 	str1 = strcat("FWHM is", {' '},  num2str(fwhm*1.5, '%5.1f'), ...
%         " % of the 10-90 rise time");
% 
% 	xloc = xlim;
% 	xloc = xloc(1) + 0.1*xloc(2);
% 
% 	yloc = max_count-3;
% 	text(xloc, yloc, str1, "fontsize", 34);


	set(gca, "fontsize", 28);
    %axis([-1 length(runs_vector)+1 min(cfd_jitter_vector)*1.25 max(cfd_jitter_vector)*1.25]) ;
	%xlim([-1 length(runs_vector)+1]);
    hold on ;
    grid on ;
    xlabel('Delay relative to average (% of rise time)', "fontsize", 34) ;
    ylabel('Counts', "fontsize", 34) ;
    title("Jitter Histogram Plot for Constant Fraction Discriminator", "fontsize", 34) ;

% Save the plot as a PDF 

%     warning("off") ;
%     str = ["./pdf/jitter_" pid_num "_hist.pdf"] ;
% 	disp(["Creating pdf file: " str]);
%     print(h_hist, '-dpdf', '-color', str) ;
% exit 
