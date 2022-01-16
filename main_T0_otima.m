% Vetor massa de catalisador
intervalo_W = 0:0.01:28.54;

% Aumentando o número de algarismos no console
format long;

% Inicializando o vetor conversão final
Xf = [];
Xf_sem_DP = [];
media_T = [];
% Vetor temperatura de alimentação
T0 = 1200:1:1600;

disp('Com queda de pressão:');

% Laço para produzir T0 x Xf
for i = T0
    % Vetor Condições iniciais
    Y0 = [0.01 i 2];
    % Solução
    [W Y] = ode45(@odes, intervalo_W, Y0);
    % Vetor conversão ao longo do reator
    X = Y(:,1);
    T = Y(:,2);
    % Conversão final
    xf = X(length(X));
    disp(xf);
    % Acrescentando a conversão final (xf) ao vetor conversão final (Xf)
    Xf(end+1) = xf;
    media_T (end+1) = mean(T);
endfor

disp('Sem queda de pressão');

% Laço para produzir T0 x Xf sem queda de pressão
for i = T0
    % Vetor Condições iniciais
    Y0 = [0.01 i];
    % Solução
    [W_sem_DP Y_sem_DP] = ode45(@odes_sem_delta_P, intervalo_W, Y0);
    % Vetor conversão ao longo do reator
    X_sem_DP = Y_sem_DP(:,1);
    % Conversão final
    xf_sem_DP = X_sem_DP(length(X_sem_DP));
    disp(xf_sem_DP);
    % Acrescentando a conversão final (xf) ao vetor conversão final (Xf)
    Xf_sem_DP(end+1) = xf_sem_DP;
endfor

% Encontrando a conversão máxima e temperatura ótima de alimentação.
[Xf_max, i] = max(Xf); % Quando a função 'max' é chamada com dois argumentos ela retorna o valor e índice no vetor
T_otima = T0(1)+(i-1);

[Xf_max_sem_DP, i] = max(Xf_sem_DP);
T_otima_sem_DP = T0(1)+(i-1);

% Imprimindo o resultado no console
disp('###Com queda de pressão###');
disp('Conversão máxima:');
disp(Xf_max);
disp('Temperatura ótima de alimentação (ºR):')
disp(T_otima);

disp('###Sem queda de pressão###')
disp('Conversão máxima:');
disp(Xf_max_sem_DP);
disp('Temperatura ótima de alimentação (ºR):')
disp(T_otima_sem_DP);

% Gerando o gráfico de T0 x Xf
clf;
plot(T0, Xf, "linewidth", 3);
hold on;
% 'hold on' segura o gráfico na tela,
% se não for usado, a chamada de outra função gráfica apaga o que já foi feito

% T0 x Xf sem queda de pressão
plot(T0, Xf_sem_DP, "linewidth", 3);
hold on;

% Inserindo os pontos máximos no gráfico
plot(T_otima, Xf_max, '+', "linewidth", 2);
hold on;

plot(T_otima_sem_DP, Xf_max_sem_DP, 'o', "linewidth", 2);
hold on;

xlabel('Temperatura inicial (ºR)');
ylabel('Conversão final');

% Desenhando o ponto T_otima
text(T_otima, Xf_max-0.015, ['(' num2str(T_otima) ',' num2str(Xf_max) ')'], "fontsize", 14);
text(T_otima_sem_DP, Xf_max_sem_DP+0.015, ['(' num2str(T_otima_sem_DP) ',' num2str(Xf_max_sem_DP) ')'], "fontsize", 14);

legend('Com queda de pressão', 'Sem queda de pressão', 'Máximo com queda de pressão', 'Máximo sem queda de pressão', "location", "east");
axis([min(T0), max(T0), 0, 1]);

% Formatação do gráfico
set(gca, "linewidth", 2, "fontsize", 16)

% Gerando o gráfico da média de temperatura no leito em função da temperatura de entrada
figure;
plot(T0, media_T, 'linewidth', 2);
xlabel('T0 (ºR)');
ylabel('Média de Temperatura no Leito (ºR)');
axis([min(T0), max(T0), 0, 1400]);
set(gca, "linewidth", 2, "fontsize", 16);