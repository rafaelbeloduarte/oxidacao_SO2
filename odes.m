% Função com o sistema de EDOs
function [dY] = odes(W, Y)
  FA0 = 0.188;
  Ta = 1264.67;
  visc = 0.09;

  % O vetor coluna das EDOs 'dY'
  % deve ser gerado pois a função 'edo45'aceita apenas
  % duas entradas no campo função (Variável independente, Variável dependente)
  % Y(1) = X, Y(2) = T, Y(3) = P
  dY = zeros(3,1);
  % Condicional para a velocidade de reação constante quando X <= 0.05
  if (Y(1) <= 0.05)
    dY(1) = (k(Y(2)))*(0.848-0.012/(Kp(Y(2))^2))/FA0;
  else
    dY(1) = -ra(Y)/FA0;
  endif
  % EDO da temperatura (dT/dW)
  dY(2) = (5.11*(Ta - Y(2)) - ra(Y)*(-deltaHrx(Y(2))))/(0.188*(somaTetaCpi(Y(2)) + Y(1)*deltaCp(Y(2))));
  % EDO da pressão (dP/dW)
  dY(3) = ((-1.12E-8*(1-0.055*Y(1))*Y(2))/Y(3))*(5500*visc + 2288);
end

% Função ra(X,T)
function resultado_ra = ra(Y)
  P0 = 2;
  R = 1.987;
  ra = -(k(Y(2)))*(((1-Y(1))/Y(1))^(1/2))*(((0.2-0.11*Y(1))/(1-0.055*Y(1)))*(Y(3)/P0) - ((Y(1)/((1-Y(1))*Kp(Y(2))))^2));
  resultado_ra = ra;
end

% Função deltaHrx(T)
function resultado_deltaHrx = deltaHrx(T)
  deltaHrx = -42471 - 1.563*(T - 1260) + 1.36E-3*(T^2 - 1260^2) - 2.459E-7*(T^3 - 1260^3);
  resultado_deltaHrx = deltaHrx;
end

% Função somaTetaCpi(T)
function resultado_somaTetaCpi = somaTetaCpi(T)
  somaTetaCpi = 57.23 + 0.014*T - 1.94E-6*(T)^2;
  resultado_somaTetaCpi = somaTetaCpi;
end

% Função deltaCp(T)
function resultado_deltaCP = deltaCp(T)
  deltaCp = -1.5625 + 2.72E-3*T - 7.38E-7*T^2;
  resultado_deltaCP = deltaCp;
end

% Função k(T)
function resultado_k = k (T)
  k = 3600*exp((-176008/T) - 110.1*log(T) + 912.8);
  resultado_k = k;
end

% Função Kp(T)
function resultado_Kp = Kp(T)
  R = 1.987;
  Kp = exp((42311/(R*T)) - 11.24);
  resultado_Kp = Kp;
end