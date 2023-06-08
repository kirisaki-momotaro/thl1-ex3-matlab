clear all
close all

K=1000
j=0;
for SNR=-2:2:24
    j=j+1;
    for i=1:K
        
        %16-PSK
        N=100; %number of symbols
        bit_seq = (sign(randn(4*N, 1)) + 1)/2; %create random bits
        X = bits_to_PSK_16(bit_seq); %turn bits into 2x100 gray coded coordinates  
        rot90(bit_seq);
        %divide coordinates into x,y
        real=X(1,:); 
        imag=X(2,:);
        %3
        %initial parameters
        T=0.01;
        over=10;
        Ts=T/over;
        A=4;
        a=0.5; 
        %create SRRC pulse
        [phi, t] = srrc_pulse(T, over, A, a);
        %upsample
        X_real_delta = 1/Ts * upsample(real, over);
        X_imag_delta = 1/Ts * upsample(imag, over);
        %define time
        time = 0:Ts:N*Ts*over-Ts;
        signal_t = [time(1)+t(1):Ts:time(end)+t(end)];
        Xin_srrc = conv(X_real_delta,phi)*Ts; %convolute symbols waveform with SRRC pulse
        Xqn_srrc = conv(X_imag_delta,phi)*Ts; %convolute symbols waveform with SRRC pulse
        %4
        %define carrier signals
        F0=200; %Hz carrier freq
        i_carrier=2*cos(2*pi*F0*signal_t);
        q_carrier=-2*sin(2*pi*F0*signal_t);
        %multiply main signals with the 2 orthogonal carrier signals in order to be
        %sent in parralel
        Xi=Xin_srrc.*i_carrier;
        Xq=Xqn_srrc.*q_carrier;
        %5 add upp the 2 signals to be sent
        Xt=Xi+Xq;
        %7 create gaussian noise
        
        noiseVar=1/(Ts*(10^(SNR/10)));
        W=wgn(1,length(signal_t),noiseVar,'linear');
        Y=Xt+W; %add noise
        %8
        F0=200 %Hz reciever freq
        i_reciever=cos(2*pi*F0*signal_t);
        q_reciever=-sin(2*pi*F0*signal_t);
        Xi_reciever=Y.*i_reciever;
        Xq_reciever=Y.*q_reciever;
        %9
        Xin_srrc_reciever = conv(Xi_reciever,phi)*Ts; %convolute symbols waveform with SRRC pulse
        Xqn_srrc_reciever = conv(Xq_reciever,phi)*Ts; %convolute symbols waveform with SRRC pulse
        signal_t_reciever = [signal_t(1)+t(1):Ts:signal_t(end)+t(end)];
        %10
        Xi_sampled=Xin_srrc_reciever(1:over:end);
        Xq_sampled=Xqn_srrc_reciever(1:over:end);
        Xi_sampled=Xi_sampled(9:end-8);
        Xq_sampled=Xq_sampled(9:end-8);
        X_reciever(1,:)=Xi_sampled;
        X_reciever(2,:)=Xq_sampled;
        %11
        out_b=detect_PSK_16(X_reciever);
        P_bit_error(j)=num_of_bit_errors(out_b,rot90(bit_seq))/(4*N);
        P_symbol_error(j)=num_of_symbol_errors(X,X_reciever)/(2*N);
    end 
end

P_bit_error
P_symbol_error
t=-2:2:24
figure(25);
semilogy(t,P_symbol_error);
grid on;
title('symbol error rate by SNR')
figure(26);
semilogy(t,P_bit_error);
grid on;
title('bit error rate by SNR')

save images
FolderName = ('C:\Users\chris\Desktop\THL I\ex3\thl1-ex3-matlab\images');   % using my directory
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = num2str(get(FigHandle, 'Number'));
  set(0, 'CurrentFigure', FigHandle);
%   saveas(FigHandle, strcat(FigName, '.png'));
  saveas(FigHandle, fullfile(FolderName,strcat(FigName, '.png'))); % specify the full path
end

