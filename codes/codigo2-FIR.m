clear all;
clc;
pkg load signal; % Executa um pacote interno do octave

%Função de leitura do áudio que retorna um vetor sinal e frequencia de amostragem
[sinal,freq_amostral] = audioread('fala_sirene_tm1.wav'); 
tam = length(sinal); %Funçao que retorna o tamanho do sinal
X = abs(fft(sinal))/(tam/2); %Funçao que realiza a FFT do sinal
f=0:freq_amostral/(tam-1):freq_amostral; 

subplot(2,1,1);
plot(f(1:tam/2),X(1:tam/2));
title('Espectro do sinal de áudio e Filtros FIR 1 e 2','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on;
hold on;

fc = 100; %Frequencia de corte inicial do sinal 
fc1 = 200; %Frequencia de corte final do sinal
ordem = 500; %Numero da ordem do sinal
Wc = (2*pi*fc/freq_amostral)/pi; %Frequencia de corte inicial em tempo discreto
Wc1 = (2*pi*fc1/freq_amostral)/pi; %Frequencia de corte final em tempo discreto
num = fir1(ordem,[Wc Wc1],'bandpass');
[h,w] = freqz(num,1,512,freq_amostral); %Funçao que calcula a Resposta em Frequencia do filtro
plot(w,abs(h),'r');

fc=400;
fc1=700;
ordem = 500;
Wc = (2*pi*fc/freq_amostral)/pi; %Frequencia de corte em tempo discreto
Wc1 = (2*pi*fc1/freq_amostral)/pi; %Frequencia de corte em tempo discreto
num1 = fir1(ordem,[Wc Wc1],'bandpass');
[h,w] = freqz(num1,1,512,freq_amostral); %Funçao que calcula a Resposta em Frequencia do filtro
plot(w,abs(h),'g');
legend('Espectro','FIR Passa-Banda 1','FIR Passa-Banda 2');

y = filter(num,1,sinal); %Funçao que filtra o sinal
y1 = filter(num1,1,sinal);
y2 = y+y1;
Y = abs(fft(y2))/(tam/2);
subplot(2,1,2);
plot(f(1:tam/2),Y(1:tam/2));
title('Espectro de Frequencia do sinal de áudio final','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on;

% Resposta ao impulso dos filtros %
[Hi, Wi] = impz(num, 512); %Funçao que retorna a resposta ao impulso
[Hi1, Wi1] = impz(num1, 512);
figure();
plot(Wi,abs(Hi),'color', 'red'); hold on
plot(Wi1,abs(Hi1),'color', 'g');
title('Espectro da Resposta ao Impulso dos Filtros','FontSize',12, 'Color', 'b');
xlabel('Tempo','FontSize',12, 'Color','b');
ylabel('Amplitude','FontSize',12,'Color','b');
legend('Filtro FIR 1','Filtro FIR 2');
grid on;

audiowrite('fala_sirene_tm1_fir.wav',10*y2,freq_amostral);
