function [prior] = logprior(h)
%{
Need a prior on what we want: depth, h
Get this from previous observations. Use this to build a prior distribution
on h
%}


%Assume depth distribution is normal and find mean/std at each x
% depth = bath.depth;
% depthmean = nanmean(depth,2); %mean over time dimension
% depthstd = std(depth,0,2);

% xvec=(1:10:1150);
% depthmeanInterp = interp1(depthmean,xvec);
% fudgestd = 0.25;

%add bounds on h so unlikely to get values below 0 or more than 11

h(h<0) = 1e10;
h(h>11)=1e10;

mu=0;
sigma=1;

prior = sum(log(normpdf(h,mu,sigma)));
%prior = log(normpdf(h,flip(depthmean),depthstd));
%prior = log(normpdf(h,flip(depthmean),fudgestd));
%prior = log(normpdf(h,depthmeanInterp',depthstd));
%prior = log(normpdf(h,0,fudgestd));


end