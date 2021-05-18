close all;
clear all;
clc;

# Paraméterek:
#
#   D     :=  kád átmérő
#   K     :=  kád kerület
#   N     :=  faldeszka db szám
#   A     :=  faldeszka anyagszélesség
#   B'    :=  faldeszka anyagvastagság ráhagyás pozitív profil két oldalán
#   B     :=  faldeszka anyagvastagság (eredeti arány A/B ~ 11/4; ( R + B' ) * 2 ) 
#   A_d   :=  faldeszka negatív profil eltolás (R és alpha függvénye) [A']
#   R     :=  faldeszka pozitív profil sugár (eredeti arány A/R ~ 6)
#   alpha :=  két szomszédos faldeszka által bezárt külső szög (N függvénye)
#   L     :=  egy faldeszka effektív hossza ( L = A - R + A' ) 

D_target = 1600; # cél átmérő
A = 110; 
R = floor(A/6); # empirikus
B_d = 2;

B = ( R + B_d ) * 2;

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
alpha_relaxed = alpha * 1.75;
printf("relaxált alpha szög (75%%-kal növelt érték): %d°\n",rad2deg(alpha_relaxed));

A_d = R * sin( alpha_relaxed );
printf("relaxált A' érték: %d mm\n", A_d);

disp("------------------------------");
disp("Fürdődézsa végleges paraméterei:");

printf("N = %u db\nA = %d mm\nR = %d mm\nA' = %d mm\n",opt_N,A,R,A_d);
L = A - R + A_d;

printf("Egy faldeszka effektív szélessége: L = %d\n",L);
D_approx = opt_N * L / pi;

printf("A fürdődézsa közelítőleges átmérője közelítőleges középvonali kerület alapján:\nD = %d mm\n",D_approx);
printf("Faldeszkák marás előtt szükséges keresztmetszete:\nA = %d mm\nB = %d mm\n",A, B);

disp("------------------------------");

floor_thickness = 20; # padló vastagsága
floor_overhang = 10; # padló átfedése a fallal
floor_profile_depth = 8; #padló deszkák kötési profiljának mélysége

floor_radius = ( D_approx / 2 + floor_displacement );
floor_area = ( floor_radius ^ 2 * pi ) / ( 1000 ^ 2 );

printf("A fürdődézsa padlójának sugara ( %d mm falátfedéssel ): %d m^2\n", floor_overhang, floor_radius);
printf("A fürdődézsa padlójának területe: %d m^2\n", floor_overhang, floor_area);



