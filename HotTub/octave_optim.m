close all;

# Paraméterek:
#
#   D     :=  kád átmérő
#   K     :=  kád kerület
#   N     :=  faldeszka db szám
#   A     :=  faldeszka anyagszélesség
#   B     :=  faldeszka anyagvastagság (A/B ~ 11/4)
#   A_d   :=  faldeszka negatív profil eltolás (R és alpha függvénye) [A']
#   R     :=  faldeszka pozitív profil sugár (A/R ~ 6)
#   alpha :=  két szomszédos faldeszka által bezárt külső szög (N függvénye)


D_target = 1600; # cél átmérő
A = 120; 
R = A/6; # empirikus

disp("Fürdődézsa kezdeti paraméterei:");
printf("N = ? db\nA = %d mm\nR = %d mm\nA' = ? mm\n",A,R);
printf("A fürdődézsa cél átmérője: D = %d mm\n",D_target);
disp("------------------------------");

# D értéke A, R, alpha és N függvényében
D = @(A, R, alpha, N)  ( N / pi ) * ( A - R * (1 - sin( alpha ) ) )

# alpha maximális, ha alpha = 2 * pi / N
# minimalizálandó függvény rögzített A és R mellett, maximális alpha esetén.

f = @(N) abs( D_target - D(A, R, 2 * pi / N , N) )

N_scale = [1:1:100];
plot(N_scale, arrayfun(f,N_scale));

guess_N = 30;
[opt_N, opt_f] = fminunc(f,guess_N);

printf("Optimális faldeszka darabszám: %d db\n", opt_N);

opt_N = ceil(opt_N);
printf("Felfelé kerekítve: %u db\n", opt_N);

alpha = (2*pi/opt_N);
printf("eredeti alpha szög: %d°\n",rad2deg(alpha));
printf("eredeti A' érték: %d\n",R * sin( alpha ));

# alpha_max kövelése -> elforgatási holtjáték 
alpha_relaxed = alpha * 1.20;
printf("relaxált alpha szög (20%%-kal növelt érték): %d°\n",rad2deg(alpha_relaxed));

A_d = R * sin( alpha_relaxed );
printf("relaxált A' érték: %d mm\n", A_d);

disp("------------------------------");
disp("Fürdődézsa végleges paraméterei:");
printf("N = %u db\nA = %d mm\nR = %d mm\nA' = %d mm\n",opt_N,A,R,A_d);
D_approx = opt_N * ( A - R + A_d ) / pi;
printf("A fürdődézsa közelítőleges átmérője közelítőleges középvonali kerület alapján:\nD = %d mm\n",D_approx);
