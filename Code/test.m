xmax = 1150;
Hmax = 5;
Tb = 1;

%h = [0.1; 0.3; 0.8; 1.4; 2.0; 2.6; 3.2; 4.0; 9; 2.6; 3.0; 3.6; 4.5; 5.5; 6.5; 7.5; 8.5; 9.5; 10; 11];

%h = [11; 10; 9.5; 8.5; 7.5; 6.5; 5.5; 4.5; 3.6; 3; 2.6; 6; 4; 3.2; 2.6; 2; 1.4; 0.8; 0.3; 0];

%h = [11; 10; 9.5; 8.5; 7.5; 2.6; 6; 4; 3.2; 2.6; 2; 1.4; 0.8; 0.3; 0.1];
h = linspace(11,-0.5,250)';

%h = [0.01; 0.15; 0.02; 0.01; 0.03; 0.03];

H = bathymetry(xmax, Hmax, h, Tb);

