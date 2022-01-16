% Vetor massa de catalisador
intervalo_W = 0:0.01:28.54;

% Vetor Condições iniciais
Y0 = [0.01 1435 2];

% Resolução das EDOs utilizando o método de Dormand-Prince de ordem 4
[W Y] = ode45(@odes, intervalo_W, Y0);

% Abrindo o vetor solução em suas componentes X, T e P
X = Y(:,1);
T = Y(:,2);
P = Y(:,3);

% Imprimindo a conversão final
disp('Conversão final');
disp(X(length(X)));

R = 1.987;
P0 = 2;
Xe = [];
L = [];

% Calculando Xe
passo = 0.001;
for i = 1:1:length(Y)
  % aproveitando o loop para calcular L(W)
  L(end+1) = (4*W(i)/(pi*((0.2318**2)*33.8)));
  % calculando k e Kp ao longo do reator
  k = (-3600*exp((-176008/T(i)) - 110.1*log(T(i)) + 912.8));
  Kp = exp((42311/(R*T(i))) - 11.24);
  difquad = [];
  for x = 0:passo:1
    difquad(end+1) = (((((0.2-0.11*x)/(1-0.055*x))*(P(i)/P0)) - (x/((1-x)*Kp))**2)**2);
  endfor
  [x, m] = min(difquad);
  Xe(end+1) = m*passo;
endfor

% Gerando o gráfico
clf;
[ax, linhaX, linhaT] = plotyy (L, X, L, T);
hold on;
plot(L, Xe, 'linewidth', 2, 'g');
xlabel ("Distância ao longo do reator (ft)");
ylabel (ax(1), "Conversão");
ylabel (ax(2), "Temperatura (ºR)");
set(ax(1), 'linewidth', 2, 'fontsize', 20, 'YLim', [0 1]);
set(ax(2), 'linewidth', 2, 'fontsize', 20, 'YLim', [1200 1600]);
set(linhaX, 'linewidth', 2);
set(linhaT, 'linewidth', 2);
legend('X', 'Xe', 'T', 'fontsize', 20, 'location', "east");