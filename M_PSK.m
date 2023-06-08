clear all
close all




%16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; %create random bits
X = bits_to_PSK_16(bit_seq); %turn bits into 2x100 gray coded coordinates  
rot90(bit_seq);

%divide coordinates into x,y
real=X(1,:); 
imag=X(2,:);


%PSK ASTERISM PLOT
figure(1)
plot(real,imag,'o')


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

figure(2)
plot(signal_t,Xin_srrc);
grid on;
title('3) SRRC instance Xin of 16PSK waveform')
figure(3)
plot(signal_t,Xqn_srrc);
grid on;
title('3) SRRC instance Xqn of 16PSK waveform')

%periodogram plot
Nf=1024;
Fs = 1/Ts;               % sampling frequency
freq = (-Fs/2:Fs/Nf:Fs/2-1/Nf); % zero-centered frequency range


%fft Xin SRRC 
fftshift_SRRC_Xin = fftshift(fft(Xin_srrc,Nf)*Ts);
power_fftshift_SRRC_Xin = abs(fftshift_SRRC_Xin).^2;     % zero-centered power

%fft Xin SRRC 
fftshift_SRRC_Xqn = fftshift(fft(Xqn_srrc,Nf)*Ts);
power_fftshift_SRRC_Xqn = abs(fftshift_SRRC_Xqn).^2;     % zero-centered power

figure(4)
plot(freq,power_fftshift_SRRC_Xin)
grid on;
title('3) periodogram of SRRC instance Xin')
figure(5)
plot(freq,power_fftshift_SRRC_Xqn)
grid on;
title('3) periodogram of SRRC instance Xqn')

%4
%define carrier signals
F0=200 %Hz carrier freq
i_carrier=2*cos(2*pi*F0*signal_t);
q_carrier=-2*sin(2*pi*F0*signal_t);

%multiply main signals with the 2 orthogonal carrier signals in order to be
%sent in parralel
Xi=Xin_srrc.*i_carrier;
Xq=Xqn_srrc.*q_carrier;

figure(6)
plot(signal_t,Xi);
grid on;
title('4) Xin modulated F0=200Hz 16PSK waveform')
figure(7)
plot(signal_t,Xq);
grid on;
title('4) Xqn modulated F0=200Hz 16PSK waveform')

%fft Xin SRRC with carrier
fftshift_SRRC_Xin = fftshift(fft(Xi,Nf)*Ts);
power_fftshift_SRRC_Xin = abs(fftshift_SRRC_Xin).^2;     % zero-centered power

%fft Xin SRRC with carrier
fftshift_SRRC_Xqn = fftshift(fft(Xq,Nf)*Ts);
power_fftshift_SRRC_Xqn = abs(fftshift_SRRC_Xqn).^2;     % zero-centered power

figure(8)
plot(freq,power_fftshift_SRRC_Xin)
grid on;
title('4) periodogram of instance Xin modulated F0=200Hz')
figure(9)
plot(freq,power_fftshift_SRRC_Xqn)
grid on;
title('4) periodogram of instance Xqn modulated F0=200Hz')


%5 add upp the 2 signals to be sent
Xt=Xi+Xq;
figure(10)
plot(signal_t,Xi);
grid on;
title('5) Sent signal Xt')

%periodogram of sender output
fftshift_Xt = fftshift(fft(Xt,Nf)*Ts);
power_fftshift_Xt = abs(fftshift_Xt).^2;     % zero-centered power

figure(11)
plot(freq,power_fftshift_Xt)
grid on;
title('5) periodogram of Sent signal Xt')

%7 create gaussian noise
SNR=10;
noiseVar=1/(Ts*(10^(SNR/10)));
W=wgn(1,length(signal_t),noiseVar,'linear');

Y=Xt+W; %add noise

figure(12)
plot(signal_t,W);
grid on;
title('7) gaussian noise')

figure(13)
plot(signal_t,Y);
grid on;
title('7) gaussian noise with signal')

%8
F0=200 %Hz reciever freq
i_reciever=cos(2*pi*F0*signal_t);
q_reciever=-sin(2*pi*F0*signal_t);

Xi_reciever=Y.*i_reciever;
Xq_reciever=Y.*q_reciever;

figure(14)
plot(signal_t,Xi_reciever);
grid on;
title('8) Xi_reciever 16PSK waveform')
figure(15)
plot(signal_t,Xq_reciever);
grid on;
title('8) Xq_reciever 16PSK waveform')

%reciever periodogram
%fft Xin reciever 
fftshift_reciever_Xin = fftshift(fft(Xi_reciever,Nf)*Ts);
power_fftshift_reciever_Xin = abs(fftshift_reciever_Xin).^2;     % zero-centered power

%fft Xin reciever 
fftshift_reciever_Xqn = fftshift(fft(Xq_reciever,Nf)*Ts);
power_fftshift_reciever_Xqn = abs(fftshift_reciever_Xqn).^2;     % zero-centered power

figure(16)
plot(freq,power_fftshift_reciever_Xin)
grid on;
title('8) periodogram of instance Xin reciever')
figure(17)
plot(freq,power_fftshift_reciever_Xqn)
grid on;
title('8) periodogram of instance Xqn reciever')

%9
Xin_srrc_reciever = conv(Xi_reciever,phi)*Ts; %convolute symbols waveform with SRRC pulse
Xqn_srrc_reciever = conv(Xq_reciever,phi)*Ts; %convolute symbols waveform with SRRC pulse
signal_t_reciever = [signal_t(1)+t(1):Ts:signal_t(end)+t(end)];
figure(18)
plot(signal_t_reciever,Xin_srrc_reciever);
grid on;
title('9) SRRC filtered instance Xin of 16PSK waveform')
figure(19)
plot(signal_t_reciever,Xqn_srrc_reciever);
grid on;
title('9) SRRC filtered instance Xqn of 16PSK waveform')

%defiltered reciever periodogram
%fft Xin reciever 
fftshift_srrc_reciever_Xin = fftshift(fft(Xin_srrc_reciever,Nf)*Ts);
power_fftshift_srrc_reciever_Xin = abs(fftshift_srrc_reciever_Xin).^2;     % zero-centered power

%fft Xin reciever 
fftshift_srrc_reciever_Xqn = fftshift(fft(Xqn_srrc_reciever,Nf)*Ts);
power_fftshift_srrc_reciever_Xqn = abs(fftshift_srrc_reciever_Xqn).^2;     % zero-centered power

figure(20)
plot(freq,power_fftshift_srrc_reciever_Xin)
grid on;
title('9) periodogram of instance SRRC Xin reciever')
figure(21)
plot(freq,power_fftshift_srrc_reciever_Xqn)
grid on;
title('9) periodogram of instance SRRC Xqn reciever')

%10
Xi_sampled=Xin_srrc_reciever(1:over:end);
Xq_sampled=Xqn_srrc_reciever(1:over:end);
Xi_sampled=Xi_sampled(9:end-8);
Xq_sampled=Xq_sampled(9:end-8);
X_reciever(1,:)=Xi_sampled;
X_reciever(2,:)=Xq_sampled;
figure(22)
scatterplot(rot90(X_reciever));
title('10) received symbols asterism')


%11
out_b=detect_PSK_16(X_reciever);

bit_error=num_of_bit_errors(out_b,rot90(bit_seq))
sym_error=num_of_symbol_errors(X,X_reciever)


out_b(end-11:end)
rot90(bit_seq(end-11:end))




% save images
% FolderName = ('C:\Users\chris\Desktop\THL I\ex3\thl1-ex3-matlab\images');   % using my directory
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   FigName   = num2str(get(FigHandle, 'Number'));
%   set(0, 'CurrentFigure', FigHandle);
% %   saveas(FigHandle, strcat(FigName, '.png'));
%   saveas(FigHandle, fullfile(FolderName,strcat(FigName, '.png'))); % specify the full path
% end




