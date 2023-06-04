clear all
close all




%16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; 
bit_seq(1:4)
X = bits_to_PSK_16(bit_seq); %random symbols


%PSK ASTERISM
real=X(1,:)
imag=X(2,:)

figure(1)
plot(real,imag,'o')



%initial parameters
T=0.01;
over=10;
Ts=T/over;
A=4;
a=0.5; 


%create SRRC pulse
[phi, t] = srrc_pulse(T, over, A, a);


X_real_delta = 1/Ts * upsample(real, over);
X_imag_delta = 1/Ts * upsample(imag, over);

time = 0:Ts:N*Ts*over-Ts;

signal_t = [time(1)+t(1):Ts:time(end)+t(end)];

signal = conv(X_real_delta,phi)*Ts; %convolute symbols waveform with SRRC pulse

figure(2)
plot(signal_t,signal);
grid on;
title('modulated instance of 2PAM waveform')

signal = conv(X_imag_delta,phi)*Ts; %convolute symbols waveform with SRRC pulse

figure(3)
plot(signal_t,signal);
grid on;
title('modulated instance of 2PAM waveform')





