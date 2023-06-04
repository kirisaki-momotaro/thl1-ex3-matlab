clear all
close all




%A2 16-PSK
N=100; %number of symbols
bit_seq = (sign(randn(4*N, 1)) + 1)/2; 
X = bits_to_2PAM(b); %random symbols
















%initial parameters
T=0.01;
over=10;
Ts=T/over;
A=4;
a=0.5;


 

%A.1
%create SRRC pulse
[phi, t] = srrc_pulse(T, over, A, a);



%FFT SRRC
figure(1)
Nf=2048; %number of samples
Fs = 1/Ts;               % sampling frequency
freq = (-Fs/2:Fs/Nf:Fs/2-1/Nf); % zero-centered frequency range
%fft SRRC
fftshift_SRRC = fftshift(fft(phi,Nf)*Ts);
power_fftshift_SRRC = abs(fftshift_SRRC).^2;     % zero-centered power spectral density

semilogy(freq,power_fftshift_SRRC)
title('energy spectral density of SRRC pulse')
grid on;

%A2 2PAM
N=100; %number of symbols
b = (sign(randn(N, 1)) + 1)/2; 
X = bits_to_2PAM(b); %random symbols
