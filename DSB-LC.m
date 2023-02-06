clear;
close all;

%1-Read audio signal
%Read 20-second audio file
[mt,fs] = audioread('audio_signal.m4a'); %mt: sampled audio, fs: sampling frequency
mt = mt(:,1); %to handle sizes
audio_length = length(mt);
%sound(mt);

%initialize parameters
ts = 1/fs; %sampling interval 
fc = (fs/2); %carrier frequency
t = 0:ts:(audio_length-1)*ts; %time interval of signal
f = -fs/2:fs/2;
mp = max(mt); %maximum value of signal
m = 0.5; %modulation index
A = mp/m; %amplitude added to signal for modulation

%plot audio signal in frequency domain
mt_fft_amplitude = abs(fftshift(fft(mt,fs+1)));   %obtain fourier transform of modulating signal
mt_fft_phase = angle(fftshift(fft(mt,fs+1)));

%generate carrier
ct = cos(2*pi*fc*t);

%obtain and plot carrier in frequency domain
ct_fft = abs(fftshift(fft(ct,fs+1)));   %obtain fourier transform of modulating signal

%modulate the signal
st = (A + mt) .* ct';

%plot modulated signal in frequency domain
st_fft = abs(fftshift(fft(st,fs+1)));   %obtain fourier transform of modulating signal

%demodulation
wt = st .* ct';
wt_lpf = lowpass(wt, fc, fs, 'Steepness', 0.95) - A;

%plot demodulated signal in frequency domain
wt_fft_amplitude = abs(fftshift(fft(wt_lpf,fs+1)));   %obtain fourier transform of modulating signal
wt_fft_phase = angle(fftshift(fft(wt_lpf,fs+1)));   %obtain fourier transform of modulating signal

audiowrite('demodulated_signal.m4a', wt_lpf, fs);

%Message signal time and frequency domains plots
figure(1);
subplot(3,1,1);
plot(t,mt); title('Time Domain'); xlabel('time'); ylabel('amplitude');
subplot(3,1,2);
plot(f,mt_fft_amplitude); title('Frequency Domain Amplitude'); xlabel('frequency'); ylabel('amplitude');
subplot(3,1,3);
plot(f,mt_fft_phase) ;title('Frequency Domain Phase'); xlabel('frequency'); ylabel('phase');

%Carrier time and frequency domains plots
figure(2);
subplot(2,1,1);
plot(t,ct); title('Carrier time domain'); xlabel('time'); ylabel('amplitude');
subplot(2,1,2);
plot(f,ct_fft); title('Carrier frequency Domain'); xlabel('frequency'); ylabel('amplitude');

%Modulated signal time and frequency domains plots
figure(3);
subplot(2,1,1);
plot(t,st); title('Modulated signal time domain'); xlabel('time'); ylabel('amplitude');
subplot(2,1,2);
plot(f,st_fft); title('Modulated signal frequency Domain'); xlabel('frequency'); ylabel('amplitude');

%Demodulated signal time and frequency domains plots
figure(4);
subplot(3,1,1);
plot(t,wt_lpf); title('Demodulated signal time domain'); xlabel('time'); ylabel('amplitude');
subplot(3,1,2);
plot(f,wt_fft_amplitude); title('Demodulated signal frequency Domain'); xlabel('frequency'); ylabel('amplitude');
subplot(3,1,3);
plot(f,wt_fft_phase) ;title('Demodulated signal frequency domain Phase'); xlabel('frequency'); ylabel('phase');






