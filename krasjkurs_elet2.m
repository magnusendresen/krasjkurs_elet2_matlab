% ========== Matlab cheatsheet ELET1002 ==========
% Om du finner feil, eller har forslag til noe som bør legges til, gjerne gi beskjed til
% magnus.stensby.endresen@gmail.com
% eller
% magnsen@stud.ntnu.no



% ========== Oppstart av nytt prosjekt ==========
clc        % Tømmer terminalen/kommandovinduet
clf        % Tømmer gjeldene figurvindu
clearvars  % Tømmer kun alle variabler; rask, anbefalses, evt clear all for å tømme all cache

sympref('FloatingPointOutput',true) % Setter alle kommende utskrifter til desimaltall
format short % long: ca. 15 desimaler, short: ca. 4 desimaler, bank: ca. 2 desimaler


% ========== Symbolsk forenkling ==========
simplify(expr);          % Rydder uttrykk
simplifyFraction(expr);  % Samler brøk penere
collect(expr, s);        % Samler etter s
factor(expr);            % Faktoriserer uttrykk
numden(expr);            % Deler opp uttrykket i teller (numerator) og nevner (denomenator)

% Eks; nyttig for overføringsfunksjoner:
syms s R1 C RL real positive

Hs = ((1/(s*C))*RL/(1/(s*C) + RL)) / (R1 + ((1/(s*C))*RL/(1/(s*C) + RL)));  % Stygt uttrykk
Hs = collect(simplifyFraction(Hs), s);                                      % Penere uttrykk samlet etter s      


% ========== Symbolsk funksjon ==========
f(x) = a*x + b;  % x: variabel, a/b: konstanter

% Eks:
syms t

f(t) = 2*t + 3;  % Symbolsk funksjon av t

f0 = f(0);       % Verdi ved t = 0
f2 = f(2);       % Verdi ved t = 2

fplot(f, [0, 10]);  % Kan også plottes ved fplot()


% ========== Numerisk løsning av ligninger: for innvikla uttrykk ==========
vpasolve([eq1, eq2], [var1, var2]);  % eq: equation, var: variabel

% Eks:
syms IL  % Ukjente i ligningen
VL = pi/4;

eq = cos(abs(angle(VL) - angle(IL))) == 0.95;  % Ligning defineres med == som likhetsskille

IL = vpasolve(eq, IL);  % Løsning numerisk med vpasolve()


% ========== Smbolsk løsning av ligninger: for enklere symbolske uttrykk ==========
% IKKE solve5!! skrivefeil
solve([eq1 eq2], [var1 var2]);  % eq: equation, var: variabel

% Eks:H
syms I1 I2  % Ukjente i ligningen

R1 = 10; R2 = 20; R3 = 5;
Vs1 = 12; Vs2 = 6;

eq1 = Vs1 == R1*I1 + R3*(I1 - I2);  % Ligning defineres med == som likhetsskille
eq2 = Vs2 == R2*I2 + R3*(I2 - I1);  % Ligning defineres med == som likhetsskille

sol = solve([eq1, eq2], [I1, I2]);  % Løsning symbolsk med solve()
I1 = sol.I1;                        % Svar uthentes fra solution
I2 = sol.I2;                        % Svar uthentes fra solution


% ========== Funksjonsplot- to varianter ==========
plot(x, y);         % x: x-verdier, y: y-verdier
fplot(f, [a, b]);   % f: funksjon, a: start, b: slutt

% Eks:
x = linspace(0, 10, 100);
y = x.^2;
plot(x, y);         % Plotter y mot x
hold on;            % Kommende funksjoner plottes i samme graf

syms t
f(t) = 2*t + 3;     % Symbolsk funksjon av t
fplot(f, [0, 10]);  % Plotter f fra t = 0 til t = 10
grid on;            % Rutenett til grafen


% ========== Subplots ==========
subplot(m, n, p)  % m: kolonner, n: rader, p: plassering

% Eks:
x = linspace(0, 10, 100);

subplot(2, 2, 1)  % 2x2 grid, posisjon 1
plot(x, 2*x)

subplot(2, 2, 2)  % 2x2 grid, posisjon 2
plot(x, x^2)

subplot(2, 2, 3)  % 2x2 grid, posisjon 3
plot(x, x + 5)

subplot(2, 2, 4)  % 2x2 grid, posisjon 4
plot(x, 1/x)


% ========== Fasorplot ==========
polarplot([theta0 theta1], [r0 r1]);  % Linje fra r0∠theta0 til r1∠theta1, vi starter alltid i 0∠0

% Eks:
I = 25*exp(1j*pi/2);

polarplot([0 angle(I)], [0 abs(I)]);  % Linje fra 0∠0 til abs(I)∠angle(I)


% ========== Bodeplot ==========
bode(H);  % H: overføringsfunksjon

% Eks:
R = 10e3; C = 15.9e-9;
s = tf('s');  % s definert ved tf()

H = 1/(1+s*R*C)^2;  % Overføringsfunksjon som funksjon av s
bode(H);

% Evt. ved egendefinert range
w = logspace(a, b, n);  % Range fra 10^a til 10^b med n steg
bode(H, w);


% ========== Kompleks/imaginær plot ==========
plot(real(s), imag(s));  % s: komplekst tall

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
solution = dsolve(ode, cond);  % ode: differensialligning, cond: initialbetingelse

% Eks:
syms i(t)  % i som funksjon av t symbolsk

V = 45; R = 30; L = 90e-3;

ode = diff(i, t) + R/L * i == V/L;  % Førsteordens ODE med diff() for deriverte og == for likhetsskille
cond = i(0) == 0.5;                 % Initialbetingelse definert ved ==
sol = dsolve(ode, cond);            % Løsning ved dsolve()

fplot(sol, [0, 5*tau]);


% ========== Andreordens naturlig respons ==========
solution = dsolve(ode, [cond1 cond2]);  % ode: differensialligning, cond1/cond2: initialbetingelser

% Eks:
syms vcn(t)  % Naturlig respons som funksjon av t

R = 10; L = 2.5; C = 25e-3;
Vc0 = 15;  % Startspenning

ode = diff(vcn, t, 2) + R/L * diff(vcn, t) + 1/(L*C) * vcn == 0; % satt lik null for naturlig respons, kan brukes med tvungen respons om ønsket
d_vcn_dt = diff(vcn, t);

cond1 = vcn(0) == Vc0;       % Startspenning
cond2 = C*d_vcn_dt(0) == 0;  % Startstrøm i kondensator

vcn(t) = dsolve(ode, [cond1 cond2]);

fplot(vcn, [0, 5]); grid on;


% ========== Forced respons med fasor ==========
xf(t) = abs(X)*cos(w*t + angle(X));  % X: fasor, w: vinkelfrekvens

% Eks:
syms t

R = 10; L = 2.5; C = 25e-3;
w = 10;

Vs = 20*exp(1j*deg2rad(30));  % Fasor: 20∠30° V

Z = R + 1j*w*L + 1/(1j*w*C);  % Serie RLC-impedans
I = Vs/Z;                     % Fasorstrøm

X = I * 1/(1j*w*C);           % Respons som fasor

xf(t) = abs(X)*cos(w*t + angle(X));  % Forced respons i tidsplanet


% ========== Laplace ==========
F = laplace(f, t, s);    % f: tidsfunksjon, t: tidsvariabel, s: Laplace-variabel
f = ilaplace(F, s, t);   % F: s-domeneuttrykk, s: Laplace-variabel, t: tidsvariabel

% Eks:
syms t s R C positive

f = exp(-t/(R*C));       % Tidsfunksjon
F = laplace(f, t, s);    % Går fra tidsdomene til s-domene

f = ilaplace(F, s, t);   % Går fra s-domene tilbake til tidsdomene


% ========== Bonus: H(s) på standardform ==========
% H(s) = A*s/(a*s^2 + b*s + c)

syms R1 C1 R2 C2 Rf Ri s real positive

H1s = s / (s + 1/(R1*C1));
H2s = (1/(R2*C2)) / (s + 1/(R2*C2));
H3s = (Rf + Ri) / Ri;

Hs = collect(simplifyFraction(H1s*H2s*H3s), s);

A = C1*R1*(Rf + Ri);
a = C1*C2*R1*R2*Ri;
b = Ri*(C1*R1 + C2*R2);
c = Ri;

beta = b/a;
w0 = sqrt(c/a);
K = A/b;


% ========== Bonus: Teststrøm for Zth ==========
% Zth = Vab/i2 når uavhengige kilder er satt til null
R1 = 8; L1 = 62.5; L2 = 12.5; M = 10; w = 4000;
syms i1 i2

IL1(i1, i2) = -i1;      % Strøm i spole 1
IL2(i1, i2) = i2 - i1;  % Strøm i spole 2

VL1(i1, i2) = 1j*w*L1*IL1(i1, i2) + 1j*w*M*IL2(i1, i2);  % Spenning over L1
VL2(i1, i2) = 1j*w*L2*IL2(i1, i2) + 1j*w*M*IL1(i1, i2);  % Spenning over L2

eq = R1*i1 - VL1(i1, i2) - VL2(i1, i2) == 0;  % KVL med teststrøm
i1 = solve(eq, i1);                            % Løser intern strøm

Vab = -VL2(i1, i2);              % Portspenning fra teststrøm
Zth = simplifyFraction(Vab/i2)   % Thevenin-impedans


% ========== Bonus: Røtter / stabilitet ==========
roots(x);  % x: koeffisienter fra høyeste til laveste s-potens

% Eks:
syms s  % Fri variabel s

m = 2;  % Felles faktor
a = 1; b = 3; c = 7; d = 5; e = 0;  % Koeffisienter

p = m*(a*s^4 + b*s^3 + c*s^2 + d*s + e);  % Karakteristisk polynom / nevner
p = collect(simplify(p), s);              % Forenkling til polynomform i s

x = [a*m b*m c*m d*m e*m];  % Koeffisienter fra s^4 til s^0
r = roots(x)

% Stabilitet sjekkes manuelt fra r:
% Godkjent hvis alle realdeler er negative, bortsett fra maks én rot i s = 0 + j0.


% ========== Bonus: Fra symbolsk H(s) til bode ==========
% solve() gir symbolsk uttrykk, bode() krever transferfunksjon fra tf()

clc
clearvars

R1 = 20e3; R2 = 1e3;
C1 = 0.5e-6; C2 = C1;
Ri = 10e3; Rf = 30e3;

syms s
ZC = 1/(s*C1);

syms Vut_LPF Vut_HPF Vin Vut

eq1 = Vin/R1 == -Vut_LPF/(1/R1 + 1/ZC)^-1;
eq2 = Vin/(R2 + ZC) == -Vut_HPF/R2;
eq3 = Vut_LPF/Ri + Vut_HPF/Ri == -Vut/Rf;

sol = solve([eq1 eq2 eq3], [Vut_HPF Vut_LPF Vut]);

H = simplifyFraction(sol.Vut/Vin);  % Symbolsk transferfunksjon

[num, den] = numden(H);             % Teller og nevner hver for seg

num = sym2poly(num);                % Symbolsk polynom til koeffisienter, trengs for tf()
den = sym2poly(den);

H = tf(num, den);                   % Transferfunksjon

bode(H)
grid on
