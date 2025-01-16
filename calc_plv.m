function plv = calc_plv(x,hp,lp,fs,range)
band = [hp lp];
%下面参数用于设置滤波器 一般不用修改
twid = 0.15;
nyquist = fs/2;
filtO = round(2*(fs/band(1))); %% order
freqs = [0 (1-twid)*band(1) band(1) band(2) (1+twid)*band(2) nyquist ]/nyquist;
ires = [ 0 0 1 1 0 0 ];
fweights = firls(filtO,freqs,ires);
for channel = 1:size(x,2)   % 对于每一个通道
    x(:,channel) = filtfilt(fweights,1,double(x(:,channel))); %滤波
end
x = x(range(1,1):range(1,2),:);
for channel1 = 1:size(x,2)
    for channel2 = 1:size(x,2)
        channel1_oxy_phase = angle(hilbert(x(:,channel1)));
        channel2_oxy_phase = angle(hilbert(x(:,channel2)));
        rp_oxy = channel1_oxy_phase - channel2_oxy_phase;
        plv(channel1,channel2) = abs(sum(exp(1i*rp_oxy))/length(rp_oxy));
    end
end
end
