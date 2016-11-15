addpath('./Airfoils/')

% Prameters

P = 7.5e6; % [W]
vr = 12; % [m/s]
Cp = 0.5; % [-]
B = 3; % number of blades
rho = 1.225; % [kg7m^3]
R = sqrt(2 * P / (rho * Cp * pi * vr^3));
tsr = 8; % tip speed ratio [-]

data = load('PolarsFFA-W3-241.txt');

alpha = data(:, 1);
cl = data(:, 2);
cd = data(:, 3);
cm = data(:, 4);

mask = and(alpha >= -10, alpha <= 30);

alpha = alpha(mask);
cl = cl(mask);
cd = cd(mask);
cm = cm(mask);

figure(1)
hold on

plot(alpha, cl, 'DisplayName', 'C_l');
plot(alpha, cd, 'DisplayName', 'C_d');

legend('C_l', 'C_d')

figure(2)
hold on

plot(alpha, cl./cd, 'DisplayName', 'C_l / C_d');

legend('show')

[M, I] = max(cl./cd);

cl_opt = M;
alpha_opt = alpha(I);

tsr_local = @(eta) tsr * eta;
InflowAngle_opt = @(r) (2/3) * atan(tsr_local(r/R));

r = [3 10 20 30 40 50 60 67.2];

InflowAngle_opt(r)


