%data file root directory
data_root = './data/';

% fid_dout = fopen('data/dout.matlab', 'rt');
% fid_ain = fopen('data/ain.matlab', 'rt');
% fid_le_addr_dat = fopen('data/le_addr_dat.matlab', 'rt');
% fid_le_out = fopen('data/le_out.matlab', 'rt');
% fid_stb = fopen('data/stb.matlab', 'rt');
% fid_mult = fopen('data/mult.matlab', 'rt');
% fid_or_out = fopen('data/or_out.matlab', 'rt');
% fid_power = fopen('data/total_power.matlab', 'rt');
% fid_agnd_current = fopen('data/agnd_current.matlab', 'rt');
% fid_avdd_current = fopen('data/avdd_current.matlab', 'rt');
% fid_dvdd_current = fopen('data/dvdd_current.matlab', 'rt');

%read data files

dout = dlmread([data_root 'dout.matlab'], ',', 1, 0);
%ain = dlmread([data_root 'ain.matlab'], ',', 1, 0);
le_out = dlmread([data_root 'le_out.matlab'], ',', 1, 0);
%le_addr_dat = dlmread([data_root 'le_addr_dat.matlab'], ',', 1, 0);
%bus_dir = dlmread([data_root 'bus_dir.matlab'], ',', 1, 0);
total_power = dlmread([data_root 'total_power.matlab'], ',', 1, 0);
avdd_current = dlmread([data_root 'avdd_current.matlab'], ',', 1, 0);
dvdd_current = dlmread([data_root 'dvdd_current.matlab'], ',', 1, 0);
agnd_current = dlmread([data_root 'agnd_current.matlab'], ',', 1, 0);

h = figure('name','Time walk','numbertitle','off', ...
'position', [0 0 1700 800]) ;

hold on; box on;

count = 1;
colors = distinguishable_colors(16);

for iter = 1:2:14
    color = colors(count, :);
    count = count + 1;
    x = dout(:,iter)-9e-3;
    plot(x*1e9, dout(:,iter+1), 'color', color, 'linewidth', 2);
end

grid on
xlabel('Time (ns)','fontsize',34); %Multiply x with 10e12
ylabel('Voltage (V)','fontsize',34);
%set(hy, 'position', [107.83 1.5 0]);
axis([110 180 -0.5 4]) ;

p1 = [119.2 3.5];                         % First Point
p2 = [120.9 3.5];                         % Second Point
dp = p2-p1;                         % Difference

xline(119, 'k--', 'linewidth', 3);
xline(121.1, 'k--', 'linewidth', 3);

quiver(p1(1),p1(2),dp(1),dp(2),0, 'color', [0 0 0], 'linewidth', 2);
quiver(p2(1),p2(2),-dp(1),-dp(2),0, 'color', [0 0 0], 'linewidth', 2);
line([115 120.05], [3 3.5], 'color', [0 0 0], 'linewidth', 2);
text(111.5, 2.8,'2.1 ns', 'fontweight', 'bold', 'fontsize', 30) 
plot(119, 1.722, 'ko', 'markerfacecolor', 'k', 'linewidth', 8);
plot(121.1, 1.722, 'ko', 'markerfacecolor', 'k', 'linewidth', 8);

p3 = [169 3.5];                         % First Point
p4 = [170.7 3.5];                         % Second Point
dp2 = p3-p4;                         % Difference

xline(168.8, 'k--', 'linewidth', 2);
xline(170.9, 'k--', 'linewidth', 2);

quiver(p3(1),p3(2),-dp2(1),dp2(2),0, 'color', [0 0 0], 'linewidth', 2);
quiver(p4(1),p4(2),dp2(1),-dp2(2),0, 'color', [0 0 0], 'linewidth', 2);
line([175 169.85], [2.5 3.5], 'color', [0 0 0], 'linewidth', 2);
text(172.2, 2.4,'2.4 ns', 'fontweight', 'bold', 'fontsize', 30) 
plot(168.8, 1.722, 'ko', 'markerfacecolor', 'k', 'linewidth', 8);
plot(170.9, 1.722, 'ko', 'markerfacecolor', 'k', 'linewidth', 8 );


title('CFD time walk (~4.4 ns 10-90% rise)','fontweight','bold', ...
    'fontsize',38) ;
%str = "Gamma particle detector response"
%text(60, 2.5, str, 'fontsize', 18);
set(gca, "XMinorTick", "on", "YMinorTick", "on", 'fontsize', 32);
%set(hy, 'position', [-20 300 0]);
hold off; box on;

% h = figure('name','CFD Delay','numbertitle','off', ...
% 'position', [0 0 1700 800]) ;
% 
% 
% hold on; box on;
% 
% x1 = dout(:, 1)-9e-3;
% x2 = le_out(:, 1)-9e-3;
% y1 = dout(:, 2);
% y2 = le_out(:,2);
% 
% plot(x1*1e9, y1, 'r-', 'linewidth', 1.5);
% plot(x2*1e9, y2, 'b--', 'linewidth', 1.5);
% 
% xline(119.6, 'k--', 'linewidth', 1.5);
% xline(120.9, 'k--', 'linewidth', 1.5);
% plot(119.6, 1.505, 'ko', 'markerfacecolor', 'k');
% plot(120.9, 1.505, 'ko', 'markerfacecolor', 'k' );
% 
% p5 = [119.7 3.5];                         % First Point
% p6 = [120.8 3.5];                         % Second Point
% dp3 = p6-p5;                         % Difference
% 
% quiver(p5(1),p5(2),dp3(1),dp3(2),0, 'color', [0 0 0], 'linewidth', 4);
% quiver(p6(1),p6(2),-dp3(1),-dp3(2),0, 'color', [0 0 0], 'linewidth', 4);
% 
% plot([117 120.15], [3 3.5], 'k-', 'linewidth', 4);
% text(116, 2.9,'1.3 ns', 'fontweight', 'bold', 'fontsize', 30) 
% 
% axis([110 130 -0.5 4]) ;
% 
% title('Leading Edge to CFD delay','fontweight','bold','fontsize',38) ;
% ylabel('Voltage (V)','fontweight','bold','fontsize',34);
% xlabel('Time (ns)','fontweight','bold','fontsize',34); %Multiply x with 10e12
% legend('CFD', 'LE', 'Location', 'best');
% set(gca, "XMinorTick", "on", "YMinorTick", "on", 'FontSize', 32);
% 
% hold off
% 
% average_power = mean(total_power(:,2))
% avg_avdd_i = mean(avdd_current(:,2))
% avg_dvdd_i = mean(dvdd_current(:, 2))
% avg_agnd_i = mean(agnd_current(:, 2))