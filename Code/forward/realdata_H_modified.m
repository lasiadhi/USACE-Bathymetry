%% Load real data for calculation 
for j = 1;   %0.1 for 1 % 0.13 for 2 % 0.16 for 16
% xmax
% H_0
% T_b
% h

%% CALL-1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get Boundary Conditions (vector for a fixed time period, record hourly)
H_0_vec = getBC('waveHs', '2015-10-09 3:00:00', '2015-10-09 4:00:00');
  T_b_vec = getBC('wavePeakFrequency', '2015-10-09 3:00:00', '2015-10-09 4:00:00');
  
% Choose one set of H_0_vec & T_b_max (index must match)
H_0 = H_0_vec(j);        %H_0_vec(j);
  T_b = (T_b_vec(j))^(-1);      %(T_b_vec(j))^(-1);

  
%% CALL-2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get bathymetry data
% [h,x] = get_hOct1
% This part is to get data from measurement points (depth_h & location_x)
% The data is needed for interpolation
[h,x] = get_hOct9;


%% CALL-3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Interpolation
% [hgrid, xq] = interp_h(h,x,dx)
% This part is to get the interpolated data (depth vector: hgrid & location vector: xp)

% grid size
dx = 10;

[hgrid, xq] = interp_h(h,x,dx);


%% Get the maximum x
xmax = max(xq);

%% Get the number of grid points
N1 = length(hgrid);


%% CALL-4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get wave number
k = wavenumber(T_b, hgrid);


%% Shallow water criterion
%% k*h << 1
kh = zeros(N1, 1);

for i = 1: N1
    kh(i) = k(i)*h(i);
end


%% CALL-5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get delta (rhs of the ODE)
%delta = rhs_delta(hgrid, T_b, H_0);


%% CALL-6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get wave height from energy flux eqn by FDM
[H, n, cc1, c_g, E, delta] = waveheight_H_modified(H_0, hgrid, T_b, k, dx);


%% Energy
% E = zeros(N1, 1);
% for i = 1: N1
%     E(i) = 1/8*1000*9.8*H(i)^2;
% end


%% OUTPUT data to EXCEL
% TIT = {'hgrid', ' ', 'wave height', ' ', 'wave number'};
% xlswrite('Resuit for h&H&k', TIT);
% xlswrite('Resuit for h&H&k', hgrid, 'sheet1', 'A2');
% xlswrite('Resuit for h&H&k', H, 'sheet1', 'C2');
% xlswrite('Resuit for h&H&k', k, 'sheet1', 'E2');



%% PLOT-1
%% (x & H) & (x & h/10) & (x & 10k)
figure;
plot(xq, 2*H, '*', xq, -hgrid/10, 'o', xq, 10*k, '^')
xlabel('x', 'interpreter', 'latex', 'FontSize', 20)
ylabel('H, h, k', 'interpreter', 'latex', 'FontSize', 20)
legend('Wave Height(scale by 2)', 'Depth(scale by 0.1)', 'Wave Number(scale by 10)')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'interpreter', 'latex', 'FontSize', 20)
grid on
hold on 

%% PLOT-2
%% k & hgrid
figure;
plot(hgrid, k, '*')
xlabel('depth(h)', 'FontSize', 20, 'interpreter', 'latex')
ylabel('wave number(k)', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
%% PLOT-3
%% x & kh
figure;
plot(xq, kh, '*')
xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
ylabel('hk', 'FontSize', 20, 'interpreter', 'latex')
y1 = graph2d.constantline(1, 'Color',[1 0 0]);
changedependvar(y1,'y');
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
% %% PLOT-4
% %% h & kh
% figure;
% plot(hgrid, kh, '-o')
% xlabel('h', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('kh', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
% %% PLOT-5
% %% h & E
% figure;
% plot(hgrid, E, '-^')
% xlabel('h', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('Energy', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
%% PLOT-6
%% x & E
figure;
plot(xq, E, '*r')
xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
ylabel('Energy', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
% %% PLOT-7
% %% x & n
% figure;
% plot(xq, n,'-*b')
% xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('n', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
%% PLOT-8
%% x & c
figure;
plot(xq, cc1,'^g')
xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
ylabel('wave phase speed (c)', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
% %% PLOT-9
% %% h & c
% figure;
% plot(hgrid, cc,'-+k')
% xlabel('depth', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('c', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
% %% PLOT-10
% %% x & delta
% figure;
% plot(xq, -delta,'-+b')
% xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('wave breaking (\delta)', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
%% PLOT-11
%% h & H
figure;
plot(hgrid,H, '*')
xlabel('depth (h)', 'FontSize', 20, 'interpreter', 'latex')
ylabel('wave height (H)', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
% %% PLOT-12
% %% h & k
% figure;
% plot(hgrid,k)
% xlabel('wave depth (h)', 'FontSize', 20, 'interpreter', 'latex')
% ylabel('wave number (k)', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% hold on 
% 
%% PLOT-13
%% H & E
figure;
plot(H,E, 'o')
xlabel('wave height (H)', 'FontSize', 20, 'interpreter', 'latex')
ylabel('wave energy (E)', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
%
%% PLOT-14
%% x & delta
figure;
plot(xq, delta, '*r')
xlabel('x', 'FontSize', 20, 'interpreter', 'latex')
set(gca,'xdir','reverse')
ylabel('Energy Dissipation', 'FontSize', 20, 'interpreter', 'latex')
str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
title(str, 'FontSize', 20, 'interpreter', 'latex')
grid on
hold on 
% 
% %% PLOT-Last
% %% (x & H) & (x & h)
% figure;
% subplot(2,1,1)
% plot(xq,k,'-^');
% xlabel('x', 'FontSize', 20, 'interpreter', 'latex');
% ylabel('Wave Number', 'FontSize', 20, 'interpreter', 'latex')
% str = sprintf('$H_0$=%f, $T_b$=%f', H_0, T_b);
% title(str, 'FontSize', 20, 'interpreter', 'latex')
% subplot(2,1,2)
% plot(xq,H,'-*');
% xlabel('x', 'FontSize', 20, 'interpreter', 'latex');
% ylabel('Wave Height', 'FontSize', 20, 'interpreter', 'latex')
% hold on 

end