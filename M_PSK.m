clear all
close all




%16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; 
bit_seq(1:4)
X = bits_to_PSK_16(bit_seq); %random symbols


real=X(1,:)
imag=X(2,:)


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
title('modulated instance Xin of 16PSK waveform')
figure(3)
plot(signal_t,Xqn_srrc);
grid on;
title('modulated instance Xqn of 16PSK waveform')


%4
F0=200 %Hz carrier freq
i_carrier=2*cos(2*pi*F0*signal_t);
q_carrier=-2*sin(2*pi*F0*signal_t);

Xi=Xin_srrc.*i_carrier;
Xq=Xqn_srrc.*q_carrier;

figure(4)
plot(signal_t,Xi);
grid on;
title('Xin carrier 16PSK waveform')
figure(5)
plot(signal_t,Xq);
grid on;
title('Xqn carrier 16PSK waveform')

%5
Xt=Xi+Xq;
figure(6)
plot(signal_t,Xi);
grid on;
title('channel entrance X(t)')

%7 add gaussian noise
SNR=10;
noiseVar=1/(Ts*(10^(SNR/10)));
W=wgn(1,length(signal_t),noiseVar,'linear');

Y=Xt+W;

figure(7)
plot(signal_t,W);
grid on;
title('gaussian noise')

figure(8)
plot(signal_t,Y);
grid on;
title('gaussian noise with signal')

%8







