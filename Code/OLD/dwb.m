% USACE-Bathymetry
%
% Forward problem model (known: bathymetry; unknown: H,k)

% original version by Dong

%function[H] = bathymetry(xmax, Hmax, h, Tb)

% n(grid number)
% xmax(the maximum length in x-direction)
% hmax(the maximum depth in x-direction)
% Tb(wave period at boundary)
% delta(the right hand side of ODE)

%%%%%%%%%%%%%%%%%%%% delta needs to be modified%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
% Hb(wave height at boundary)
% Tb(wave period at boundary)
% rho(water density)
% g(gravity accleration)
% h(bathymetry info, depth)
% delta(?)

% OUTPUT:
% H(wave height)
% k(wave number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1-D (x direction, unit in meter)

% subfunc for x ???

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc
% constants
%********************
h=[0.2;0.5;0.8;0.7];Hmax=1;xmax=1150;Tb=10;
%***********************
g = 9.8;        % m/s2
rho = 1000;     % kg/m3

% to get the value of number of subinterval
[N1 ,N2] = size(h);

% N number of subinterval
N = N1-1;

% Boundary Condition
H = zeros(N1, 1);
H(1) = Hmax;
%H(N1) = Hmax;

% mesh size
xmin = 0;
dx = (xmax - xmin)/N;

% x vector for plot
x = zeros(N1, 1);
x(1) = xmin;
for i = 2: N1
    x(i) = x(1) + (i-1)*dx;
end

% af: angular fruquency
af = 2*pi/Tb;

% Initial vector of wave number
k = zeros(N1, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get k
% k0 = 0;         %%%%%%%%%%% need to change %%%%%%%%%%
% 
% f1 = @(k)g*k*tanh(k*h)-af^2;
% 
% for i = 1: N1
%     kk = k0;
%     %hh = h(i);
%     %k(i) = fsolve(g*k(i)*tanh(k(i)*hh)-af^2, kk);
%     k(i)=fsolve(f1,kk);
%     k0 = k(i);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iter=20;kk=zeros(N1,1);
for i=1:N1
    for j=1:iter
        kk(1)=1;
        kk(j+1)=kk(j)-(g*kk(j)*tanh(kk(j)*h(i))-af^2)/(g*tanh(kk(j)*h(i))+g*h(i)*kk(j)*(sech(kk(j)*h(i)))^2);
    end
    
    k(i)=kk(iter);
end

%++++++++++++++++++++++++++++++++++++++++++++++
% initialize of matrix A 
A = zeros(N1);

% af^2 = g*k*tanh(k*h)
lambda = rho*g*pi/(8*Tb);

c = zeros(N1, 1);

for i = 1: N1
    c(i) = (1+(2*k(i)*h(i))/sinh(2*k(i)*h(i)))*lambda/(k(i)*dx);
end

for i = 1: N1-1
    A(i, i) = c(i);
    A(i+1, i) = -c(i);
end
A(N1, N1) = c(N1);


% AH = delta
delta=ones(N1,1);           %right hand side vector

% solve for H
y = A\delta;

H = sqrt(y);


plot(x, H, '-*', x, -h)
xlabel('x')
ylabel('depth')
