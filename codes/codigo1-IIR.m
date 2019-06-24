clear all;
clc;
pkg load signal; % Executa um pacote interno do octave

[sinal,freq_amostral] = audioread('fala_sirene_tm1.wav');
tam = length(sinal); %Função para pegar tamanho do vetor
X = abs(fft(sinal))/(tam/2);
f=0:freq_amostral/(tam-1):freq_amostral;

%Plot da analise espectral do Sinal
figure();
plot(f(1:tam/2),X(1:tam/2));
title('Espectro de Frequencia do áudio','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on; %Função para criar grades do gráfico
hold on; %Função para manter o gráfico sobreposto
%Fim da análise espectral do Sinal

figure();
subplot(2,1,1);
plot(f(1:tam/2),X(1:tam/2));
title('Espectro do Sinal e Filtro Notch em 300Hz','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on; %Função para criar grades do gráfico
hold on; %Função para manter o gráfico sobreposto

freq_corte = 300; %Frequencia de corte em tempo continuo
raio = 0.98; %Raio da circunferencia
Wc = (2*pi*freq_corte/freq_amostral); % Frequencia tempo discreto
num2 = [1, -2*cos(Wc),1]; % Gera coeficiente do numerador do filtro Notch
den2 = [1, -2*raio*cos(Wc), raio^2]; % Gerar coeficiente do numerador do filtro Notch
[h, w] = freqz(num2,den2,512,freq_amostral);
plot(w,abs(h), 'color','r');

subplot(2,1,2);
y2 = filter(num2,den2,sinal);
Y = abs(fft(y2))/(tam/2);
subplot(2,1,2);
plot(f(1:tam/2),Y(1:tam/2));
title('Espectro do sinal com filtro Notch aplicado','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on; %Função para criar grades do gráfico

%%%%%%%%%%%%%%%%%%%%%%
figure();
subplot(2,1,1);
plot(f(1:tam/2),X(1:tam/2));
title('Espectro do sinal de áudio e Filtro Butterworth','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on; %Função para criar grades do gráfico
hold on; %Função para manter o gráfico sobreposto

freq_corte = 100; %Frequencia de corte em tempo continuo
Wc = (2*pi*freq_corte/freq_amostral)/pi; %Frequencia de corte em tempo discreto
N = 5; %Ordem do filtro
[num,den]=butter(N,Wc,'high'); %Função que gera o Filtro Butterworth passa alta
[h,w]=freqz(num,den,512,freq_amostral); %Calcula a Resposta em Frequencia do filtro
plot(w,abs(h),'r')

freq_corte = 550; %Frequencia de corte em tempo continuo
Wc = (2*pi*freq_corte/freq_amostral)/pi; %Frequencia de corte em tempo discreto
N = 10; %Ordem do filtro
[num1,den1]=butter(N,Wc,'low'); %Gera o filtro butterworf Passa Baixa
[h,w]=freqz(num1,den1,512,freq_amostral); %Calcula a resposta em Frequencia do filtro
plot(w,abs(h),'g');
grid on;
%hold on;
legend('Espectro','Butterworth Passa-Alta','Butterworth Passa-Baixa','Notch');

y = filter(num,den,sinal); %Filtra o sinal passa alta
y1 = filter(num1,den1,y); %Filtra o sinal passa baixa
y2 = filter(num2,den2,y1); %Filtra o sinal notch

Y = abs(fft(y2))/(tam/2);
subplot(2,1,2);
plot(f(1:tam/2),Y(1:tam/2));
title('Espectro do sinal de audio final','FontSize',12, 'Color', 'b');
xlabel('Frequencia (Hz)','FontSize',11,'Color','b');
ylabel('Amplitude','FontSize',11,'Color','b');
grid on;
hold on;

% Resposta ao impulso dos filtros %
[Hi, Wi] = impz(num, den, 512); %Funçao que retorna a resposta ao impulso
[Hi1, Wi1] = impz(num1, den1, 512);
[Hi2, Wi2] = impz(num2, den2, 512);
figure();
plot(Wi,abs(Hi),'color', 'red'); hold on
plot(Wi1,abs(Hi1),'color', 'g');
plot(Wi2,abs(Hi2),'color', 'c');
title('Espectro da Resposta ao Impulso dos Filtros','FontSize',12, 'Color', 'b');
xlabel('Tempo','FontSize',12, 'Color','b');
ylabel('Amplitude','FontSize',12,'Color','b');
legend('Butterworth Passa-Alta','Butterworth Passa-Baixa','Notch');
grid on;

audiowrite('fala_sirene_tm1_iir.wav',10*y2,freq_amostral);