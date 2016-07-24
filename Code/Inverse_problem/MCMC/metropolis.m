%{
 Bayesian MCMC method to calculate posterior probability of depth profile,
 h, given data for k along a 1D profile. 
%}
%clc
%clear
%% Initialize
disp('Initializing')
%Get k data 
addpath('../../../Data/')

[k,x_k]=get1Dk();

%Data for prior
bath=load('../../../Data/transect_depth_ensembles_500_dx_10.mat');
%x = [0:10:1140]'; %bath.x doesn't have the correct dims, so fixing that

[k1Dmean_dat,k1Dstd_dat]=get1DkStats();
kdat_std = mean(k1Dstd_dat);
%use mean std of k as variance in likelihood
vark = kdat_std^2;

%use mean k vector as truth

kdat = k1Dmean_dat;

%impute values of k
%linear regression to extrapolate k
nh=length(bath.depth(:,1));
kImputed = kImpute(x_k,kdat,nh);

% Metropolis things
burnin   = 500;   % markov chain need to converge 
numsteps = 2000;
totsteps = numsteps + burnin;

% Initial guess for h (from previous data)
% For the moment this is the true bathymetry
% will eventually be like proposal

[hOrig,x] = get_hOct9();
dx=10;
[hinit,xq] = interp_h(hOrig,x,dx);
hdat=hinit;


%Initial h and k is same as Lasith's
addpath('../Least_square');
%hinit = initialize_h_guess(hgrid,dx);

hinit=hinit(1:end-1);

%[ksim]=load('../k_1percNoisedata_N47.mat');
%kImputed =ksim.k;

xdat=xq(1:end-1);

%Initial guess for forward model
addpath('../../forward/')
[kinit, ~] = forward(hinit(:,1));

% Initialize vector for quantity of interest we're estimating
h = nan(length(hinit),totsteps);
h(:,1) = hinit(:,1);

%% Initialize posterior
%Initial posterior
[ lprior, fudgestd] = logprior(hinit,bath);
llikelihood = loglikelihood(kImputed, kinit, vark);
oldpost =  llikelihood + lprior;


%% Metropolis loop
disp('Performing Metropolis')
%for i = 1 : (totsteps-1)
cnt=0 ; %acceptance rate count
for i = 1:totsteps-1
    %calculate proposal
    [hprop,kprop] = proposal(fudgestd,h(:,i),bath);

    % calculate proposed posterior density
    proppost = loglikelihood(kImputed, kprop, vark) +  logprior(hprop,bath);

    %compare posteriors
    rho = exp(proppost - oldpost);

    % accept/reject step
    % more likely to accept proposal if proppost < oldpost
    u = rand;
    if rho > u
        h(:,i+1) = hprop;
        oldpost = proppost;
        cnt=1;
    else
        h(:,i+1) = h(:,i);
    end
end
%% Clean up and plot
disp('Acceptance rate:')
disp(cnt/totsteps)

disp('Plotting')
% throw away the burnin steps
    h_final = h(:,(burnin+1):totsteps);
    
    % keep every 10th step
    %h_final = h_final(1:10:length(h_final));
    
    hdens = nan(length(h_final(:,1)),100);
    f = nan(length(h_final(:,1)),100);
    for i = 1:length(h_final(:,1))
        [f(i,:),hdens(i,:)] = ksdensity(h_final(i,:));
    end

    figure(5)
    clf
    for i = 1:length(h_final(:,1))
        plot(hdens(i,:),f(i,:));hold on
    end
    
    maxh=nan(length(h_final(:,1)),1);
    for i = 1:length(h_final(:,1))
        maxh(i,1)= max(hdens(i,:));
    end
    figure(6)
    clf
    plot(xdat,flip(maxh),'b'); hold on
    plot(xdat,hinit,'r'); hold on
    plot(xq,hgrid,'k');
    


%     [f,x]=ksdensity(x);
%     plot(x,f);
%     [M I] = max(f)


