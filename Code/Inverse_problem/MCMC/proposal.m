function [hprop,kprop] = proposal(fudgestd,h,bath)
%{
A proposed vector of h to compare
%}

    % Propose h
%     zerovec = zeros(length(h),1);
%     h_inc = normrnd(zerovec,fudgestd);
% 
%     hprop = h+h_inc;

    %Propose a spatially correlated h
    depth = bath.depth;
    depthmean = nanmean(depth,2); %mean over time dimension
    depthstd = std(depth,0,2);

    dstd=depthstd(1);
    std_samp = normrnd(0,dstd);
    hprop = depthmean + std_samp;

%     %Quasi correlated: every pt much be within 1 m of the point next to it
%     hprop = normrnd(depthmean_prior,depthstd_prior);
%     for i = 1:length(hprop) - 1
%         if abs(hprop(i) - hprop(i+1)) > 1
%             hprop(i) = depthmean_prior(i) + std_samp;
%         else
%             hprop(i) = hprop(i);
%         end
%     end

    %Get proposed k | h
    [kprop, ~] = forward(hprop);


end