% ========== Oppstart av nytt prosjekt ==========
clc % tømmer terminalen/kommandovinduet
clf % tømmer gjeldene figurvindu
clear all % tømmer alle variabler, funksjoner og all cache; treg, anbefales sjelden
clearvars % tømmer kun alle variabler; rask, anbefalses


% ========== Numerisk løsning av ligninger ==========
vpasolve([eq1, eq2], [var1, var2]); % eq: equation, var: variabel

% Eks:
syms IL % Ukjente i ligningen
VL = pi/4;

eq = cos(abs(angle(VL) - angle(IL))) == 0.95; % Ligning defineres med == som likhetsskille

IL = vpasolve(eq, IL); % Løsning numerisk med vpasolve()


% ========== Smbolsk løsning av ligninger ==========
sol([eq1 eq2], [var1 var2]); % eq: equation, var: variabel

% Eks:
syms I1 I2 % Ukjente i ligningen

R1 = 10; R2 = 20; R3 = 5;
Vs1 = 12; Vs2 = 6;

eq1 = Vs1 == R1*I1 + R3*(I1 - I2); % Ligning defineres med == som likhetsskille
eq2 = Vs2 == R2*I2 + R3*(I2 - I1); % Ligning defineres med == som likhetsskille

sol = solve([eq1, eq2], [I1, I2]); % Løsning symbolsk med solve()
I1 = sol.I1; % Svar uthentes fra solution
I2 = sol.I2; % Svar uthentes fra solution


% ========== Enkel plot ==========
plot(t, f(t)); % t: variabel, f: funksjon av t

% Eks:
w = 2*pi * linspace(10, 120, 100);
R = 10; L = 10e-3; C = 10e-9;

Z = R + 1j*w*L + 1./(1j*w*C);
plot(w, imag(Z)); 
hold on; % kommende funksjoner plottes i samme graf
grid on; % rutenett til grafen


% ========== Subplots ==========
subplot(m, n, p) % m: kolonner, n: rader, p: plassering

% Eks:
x = linspace(0, 10, 100);

subplot(2, 2, 1) % 2x2 grid, posisjon 1
plot(x, 2*x)

subplot(2, 2, 2) % 2x2 grid, posisjon 2
plot(x, x^2)

subplot(2, 2, 3) % 2x2 grid, posisjon 3
plot(x, x + 5)

subplot(2, 2, 4) % 2x2 grid, posisjon 4
plot(x, 1/x)


% ========== Fasorplot ==========
polarplot([theta0 theta1], [r0 r1]); % linje fra r0∠theta0 til r1∠theta1, vi starter alltid i 0∠0

% Eks:
I = 25*exp(1j*pi/2);

polarplot([0 angle(I)], [0 abs(I)]); % linje fra 0∠0 til abs(I)∠angle(I)


% ========== Bodeplot ==========
bode(H); % H: overføringsfunksjon

% Eks:
R = 10e3; C = 15.9e-9;
s = tf('s'); % s definert ved tf()

H = 1/(1+s*R1*C)^2; % overføringsfunksjon som funksjon av s
bode(H);

% Evt. ved egendefinert range
w = logspace(a, b, n); % range fra 10^a til 10^b med n steg
bode(H, w);

% ========== Kompleks/imaginær plot ==========
plot(real(s), imag(s)); % s: komplekst tall

% Eks:
R = linspace(0, 400, 100);

w0 = 1/sqrt(L*C);
alpha = R/(2*L);

s1 = -alpha + sqrt(alpha.^2 - w0.^2);
s2 = -alpha - sqrt(alpha.^2 - w0.^2);

plot(real(s1), imag(s1)); hold on
plot(real(s2), imag(s2))
axis equal


% ========== Førsteordens differensialligninger ==========
solution = dsolve(ode, cond); % ode: differensialligning, cond: initialbetingelse

% Eks:
syms i(t) % i som funksjon av t symbolsk

V = 45; R = 30; L = 90e-3;

ode = diff(i, t) + R/L * i == V/L; % Førsteordens ODE med diff() for deriverte og == for likhetsskille
cond = i(0) == 0.5; % Initialbetingelse definert ved ==
sol = dsolve(ode, cond); % Løsning ved dsolve()

fplot(sol, [0, 5*tau]);


% ========== Andreordens differensialligning ==========
solution = dsolve(ode, [cond1 cond2]); % ode: differensialligning, cond1/cond2: initialbetingelser

% Eks:
syms vcn(t) % naturlig respons som funksjon av t

R = 10; L = 2.5; C = 25e-3;

Vc0 = 15; % startspenning
Vcf = 0; % forced respons

ode = diff(vcn, t, 2) + R/L * diff(vcn, t) + 1/(L*C) * vcn == 0; % naturlig respons
d_vcn_dt = diff(vcn, t);

cond1 = vcn(0) == Vc0 - Vcf; % startverdi for naturlig respons
cond2 = C*d_vcn_dt(0) == 0; % startstrøm i kondensator

vcn(t) = dsolve(ode, [cond1 cond2]);
vc(t) = vcn + Vcf;

fplot(vc, [0, 5]); grid on;
grid on
