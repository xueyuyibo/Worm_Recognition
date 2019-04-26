clear all;clc;close all;

% name image_num worm_num threshold
a1=[4 1 1 0.1;4 1 1 0.11;4 1 1 0.12;4 1 1 0.13;4 1 1 0.14;4 1 1 0.15;4 1 1 0.16;4 1 1 0.17;4 1 1 0.18;4 1 1 0.19;4 1 1 0.2];
a2=[4 2 1 0.1;4 2 1 0.11;4 2 1 0.12;4 2 1 0.13;4 2 1 0.14;4 2 1 0.15;4 2 1 0.16;4 2 1 0.17;4 2 1 0.18;4 2 1 0.19;4 2 1 0.2];
a3=[4 3 20 0.1;4 3 20 0.11;4 3 22 0.12;4 3 25 0.13;4 3 25 0.14;4 3 28 0.15;4 3 28 0.16;4 3 27 0.17;4 3 27 0.18;4 3 27 0.19];
a4=[4 4 28 0.1;4 4 28 0.11;4 4 24 0.12;4 4 27 0.13;4 4 27 0.14;4 4 28 0.15;4 4 28 0.16;4 4 30 0.17;4 4 33 0.18;4 4 33 0.19;4 4 34 0.2];
a5=[10 1 2 0.1;10 1 2 0.11;10 1 2 0.12;10 1 2 0.13;10 1 2 0.14;10 1 2 0.15;10 1 2 0.16;10 1 2 0.17;10 1 2 0.18;10 1 2 0.19;10 1 2 0.2];
a6=[10 2 2 0.1;10 2 2 0.11;10 2 2 0.12;10 2 2 0.13;10 2 2 0.14;10 2 2 0.15;10 2 2 0.16;10 2 2 0.17;10 2 2 0.18;10 2 2 0.19;10 2 2 0.2];
a7=[10 3 17 0.1;10 3 17 0.11;10 3 19 0.12;10 3 22 0.13;10 3 22 0.14;10 3 25 0.15;10 3 25 0.16;10 3 25 0.17;10 3 25 0.18;10 3 25 0.19;10 3 26 0.2];
% image 1
b1=[10 1 2 0.1;4 1 1 0.1;3 1 4 0.1;12 1 5 0.1;9 1 6 0.1;5 1 7 0.1;11 1 8 0.1;6 1 9 0.1;13 1 10 0.1;17 1 13 0.1;16 1 15 0.1;8 1 16 0.1;15 1 19 0.1;1 1 22 0.1;18 1 23 0.1;21 1 25 0.1;20 1 26 0.1;22 1 29 0.1];
b2=[10 1 2 0.11;4 1 1 0.11;3 1 4 0.11;12 1 5 0.11;9 1 6 0.11;5 1 7 0.11;11 1 8 0.11;6 1 9 0.11;13 1 10 0.11;17 1 13 0.11;16 1 15 0.11;8 1 16 0.11;15 1 19 0.11;1 1 22 0.11;18 1 23 0.11;21 1 25 0.11;20 1 26 0.11;22 1 29 0.11];
b3=[10 1 2 0.12;4 1 1 0.12;3 1 4 0.12;12 1 5 0.12;9 1 6 0.12;5 1 7 0.12;11 1 8 0.12;6 1 9 0.12;13 1 10 0.12;17 1 14 0.12;16 1 16 0.12;8 1 17 0.12;15 1 20 0.12;1 1 23 0.12;18 1 24 0.12;21 1 26 0.12;20 1 27 0.12;22 1 30 0.12;7 1 31 0.12];
b4=[10 1 2 0.13;4 1 1 0.13;3 1 4 0.13;12 1 5 0.13;9 1 6 0.13;5 1 7 0.13;11 1 8 0.13;6 1 9 0.13;13 1 10 0.13;14 1 12 0.13;17 1 15 0.13;16 1 17 0.13;8 1 18 0.13;15 1 21 0.13;1 1 24 0.13;18 1 25 0.13;21 1 27 0.13;20 1 28 0.13;22 1 31 0.13;7 1 32 0.13];
b5=[10 1 2 0.14;4 1 1 0.14;3 1 4 0.14;12 1 5 0.14;9 1 6 0.14;5 1 7 0.14;11 1 8 0.14;6 1 9 0.14;13 1 10 0.14;14 1 12 0.14;17 1 15 0.14;16 1 17 0.14;8 1 18 0.14;15 1 21 0.14;1 1 24 0.14;18 1 25 0.14;21 1 27 0.14;20 1 28 0.14;22 1 31 0.14;7 1 32 0.14];
b6=[10 1 2 0.15;4 1 1 0.15;3 1 4 0.15;12 1 6 0.15;9 1 7 0.15;5 1 9 0.15;11 1 11 0.15;6 1 12 0.15;13 1 13 0.15;14 1 17 0.15;17 1 21 0.15;16 1 23 0.15;8 1 24 0.15;15 1 27 0.15;1 1 31 0.15;18 1 32 0.15;19 1 33 0.15;21 1 35 0.15;20 1 36 0.15;22 1 38 0.15;7 1 39 0.15];
b7=[10 1 2 0.16;4 1 1 0.16;3 1 8 0.16;12 1 6 0.16;9 1 7 0.16;5 1 9 0.16;11 1 11 0.16;6 1 12 0.16;13 1 13 0.16;14 1 17 0.16;17 1 21 0.16;16 1 23 0.16;8 1 24 0.16;15 1 27 0.16;1 1 31 0.16;18 1 32 0.16;19 1 33 0.16;21 1 35 0.16;20 1 36 0.16;22 1 38 0.16;7 1 39 0.16];
b8=[10 1 2 0.17;4 1 1 0.17;3 1 8 0.17;12 1 6 0.17;9 1 7 0.17;5 1 9 0.17;11 1 11 0.17;6 1 12 0.17;13 1 13 0.17;14 1 17 0.17;17 1 21 0.17;16 1 23 0.17;8 1 24 0.17;15 1 27 0.17;18 1 31 0.17;19 1 32 0.17;21 1 34 0.17;20 1 35 0.17;22 1 37 0.17;7 1 38 0.17];
b9=[10 1 2 0.18;4 1 1 0.18;3 1 8 0.18;12 1 6 0.18;9 1 7 0.18;5 1 9 0.18;11 1 12 0.18;6 1 13 0.18;13 1 14 0.18;14 1 17 0.18;17 1 20 0.18;16 1 22 0.18;8 1 23 0.18;15 1 27 0.18;1 1 29 0.18;18 1 31 0.18;19 1 32 0.18;21 1 35 0.18;20 1 36 0.18;22 1 38 0.18;7 1 39 0.18];
b10=[10 1 2 0.19;4 1 1 0.19;3 1 8 0.19;12 1 6 0.19;9 1 7 0.19;5 1 9 0.19;11 1 12 0.19;6 1 13 0.19;13 1 14 0.19;14 1 17 0.19;17 1 20 0.19;16 1 22 0.19;8 1 23 0.19;15 1 26 0.19;1 1 29 0.19;18 1 31 0.19;19 1 32 0.19;21 1 35 0.19;20 1 36 0.19;22 1 38 0.19;7 1 39 0.19];
b11=[10 1 2 0.2;4 1 1 0.2;3 1 8 0.2;12 1 6 0.2;9 1 7 0.2;5 1 9 0.2;11 1 12 0.2;6 1 13 0.2;13 1 14 0.2;14 1 17 0.2;17 1 18 0.2;16 1 20 0.2;8 1 21 0.2;15 1 23 0.2;1 1 27 0.2;18 1 28 0.2;19 1 29 0.2;21 1 32 0.2;20 1 33 0.2;22 1 35 0.2;7 1 36 0.2];
% image 2
c1=[4 2 1 0.1;10 2 2 0.1;3 2 3 0.1;12 2 4 0.1;9 2 5 0.1;5 2 6 0.1;11 2 7 0.1;6 2 9 0.1;13 2 10 0.1;14 2 11 0.1;17 2 13 0.1;16 2 14 0.1;8 2 15 0.1;18 2 18 0.1;19 2 19 0.1;1 2 20 0.1;21 2 22 0.1;20 2 23 0.1;7 2 29 0.1];
c2=[4 2 1 0.11;10 2 2 0.11;3 2 3 0.11;12 2 4 0.11;9 2 5 0.11;5 2 6 0.11;11 2 7 0.11;6 2 9 0.11;13 2 10 0.11;14 2 11 0.11;17 2 13 0.11;16 2 14 0.11;8 2 15 0.11;18 2 18 0.11;19 2 19 0.11;1 2 20 0.11;21 2 22 0.11;20 2 23 0.11;7 2 29 0.11];
c3=[4 2 1 0.12;10 2 2 0.12;3 2 3 0.12;12 2 4 0.12;9 2 5 0.12;5 2 6 0.12;11 2 8 0.12;6 2 10 0.12;13 2 11 0.12;14 2 13 0.12;17 2 15 0.12;16 2 16 0.12;8 2 18 0.12;15 2 20 0.12;18 2 22 0.12;19 2 23 0.12;1 2 24 0.12;21 2 26 0.12;20 2 27 0.12;22 2 31 0.12;7 2 33 0.12];
c4=[4 2 1 0.13;10 2 2 0.13;3 2 3 0.13;12 2 4 0.13;9 2 5 0.13;5 2 6 0.13;11 2 8 0.13;6 2 10 0.13;13 2 11 0.13;14 2 12 0.13;17 2 14 0.13;16 2 15 0.13;8 2 17 0.13;15 2 19 0.13;18 2 21 0.13;19 2 22 0.13;1 2 23 0.13;21 2 25 0.13;20 2 26 0.13;23 2 27 0.13;22 2 31 0.13;7 2 33 0.13];
c5=[4 2 1 0.14;10 2 2 0.14;3 2 3 0.14;12 2 4 0.14;9 2 5 0.14;5 2 6 0.14;11 2 8 0.14;6 2 10 0.14;13 2 11 0.14;14 2 12 0.14;17 2 14 0.14;16 2 15 0.14;8 2 17 0.14;15 2 19 0.14;18 2 21 0.14;19 2 22 0.14;1 2 23 0.14;21 2 25 0.14;20 2 26 0.14;23 2 27 0.14;22 2 31 0.14;7 2 33 0.14];
c6=[4 2 1 0.15;10 2 2 0.15;3 2 3 0.15;12 2 4 0.15;9 2 5 0.15;5 2 6 0.15;11 2 7 0.15;6 2 9 0.15;13 2 12 0.15;14 2 13 0.15;17 2 14 0.15;16 2 15 0.15;8 2 17 0.15;15 2 18 0.15;18 2 20 0.15;19 2 21 0.15;1 2 22 0.15;21 2 24 0.15;20 2 26 0.15;23 2 27 0.15;22 2 31 0.15;7 2 33 0.15];
c7=[4 2 1 0.16;10 2 2 0.16;3 2 3 0.16;12 2 4 0.16;9 2 5 0.16;5 2 6 0.16;11 2 7 0.16;6 2 9 0.16;13 2 12 0.16;14 2 13 0.16;17 2 14 0.16;16 2 15 0.16;8 2 17 0.16;15 2 18 0.16;18 2 20 0.16;19 2 21 0.16;1 2 22 0.16;21 2 24 0.16;20 2 26 0.16;23 2 27 0.16;22 2 31 0.16;7 2 33 0.16];
c8=[4 2 1 0.17;10 2 2 0.17;3 2 3 0.17;12 2 4 0.17;9 2 5 0.17;5 2 6 0.17;11 2 7 0.17;6 2 10 0.17;13 2 13 0.17;14 2 14 0.17;16 2 17 0.17;8 2 18 0.17;15 2 19 0.17;18 2 21 0.17;19 2 22 0.17;1 2 23 0.17;21 2 25 0.17;23 2 28 0.17;20 2 30 0.17;22 2 33 0.17;7 2 35 0.17];
c9=[4 2 1 0.18;10 2 2 0.18;3 2 3 0.18;12 2 4 0.18;9 2 5 0.18;5 2 6 0.18;11 2 7 0.18;6 2 10 0.18;13 2 12 0.18;14 2 13 0.18;17 2 15 0.18;16 2 16 0.18;8 2 17 0.18;15 2 18 0.18;18 2 20 0.18;19 2 21 0.18;1 2 22 0.18;21 2 24 0.18;23 2 27 0.18;20 2 29 0.18;22 2 32 0.18;7 2 34 0.18];
c10=[4 2 1 0.19;10 2 2 0.19;3 2 3 0.19;12 2 4 0.19;9 2 5 0.19;5 2 6 0.19;11 2 7 0.19;6 2 10 0.19;13 2 12 0.19;14 2 13 0.19;17 2 15 0.19;16 2 16 0.19;8 2 17 0.19;15 2 18 0.19;18 2 20 0.19;19 2 21 0.19;1 2 22 0.19;21 2 24 0.19;23 2 27 0.19;20 2 29 0.19;22 2 32 0.19;7 2 34 0.19];
c11=[4 2 1 0.2;10 2 2 0.2;3 2 3 0.2;12 2 4 0.2;9 2 5 0.2;5 2 6 0.2;11 2 7 0.2;6 2 9 0.2;13 2 13 0.2;14 2 15 0.2;17 2 17 0.2;16 2 19 0.2;8 2 21 0.2;15 2 22 0.2;18 2 24 0.2;19 2 25 0.2;1 2 26 0.2;21 2 30 0.2;23 2 32 0.2;20 2 34 0.2;22 2 37 0.2;7 2 39 0.2];
% image 3
d1=[25 3 1 0.1;7 3 4 0.1;26 3 7 0.1;27 3 9 0.1;12 3 10 0.1;28 3 12 0.1;3 3 13 0.1;5 3 14 0.1;29 3 15 0.1;30 3 16 0.1;10 3 17 0.1;4 3 20 0.1];
d2=[25 3 1 0.11;7 3 4 0.11;26 3 7 0.11;27 3 9 0.11;12 3 10 0.11;28 3 12 0.11;3 3 13 0.11;5 3 14 0.11;29 3 15 0.11;30 3 16 0.11;10 3 17 0.11;4 3 20 0.11];
d3=[25 3 1 0.12;7 3 3 0.12;8 3 4 0.12;14 3 7 0.12;26 3 8 0.12;27 3 11 0.12;12 3 12 0.12;3 3 15 0.12;5 3 16 0.12;29 3 17 0.12;30 3 18 0.12;10 1 19 0.12;4 3 22 0.12];
d4=[25 3 1 0.13;7 3 4 0.13;8 3 5 0.13;9 3 7 0.13;14 3 9 0.13;26 3 10 0.13;12 3 13 0.13;27 3 14 0.13;28 3 16 0.13;3 3 18 0.13;5 3 19 0.13;29 3 20 0.13;30 3 21 0.13;10 3 22 0.13;4 3 25 0.13];
d5=[25 3 1 0.14;7 3 4 0.14;8 3 5 0.14;9 3 7 0.14;14 3 9 0.14;26 3 10 0.14;12 3 13 0.14;27 3 14 0.14;28 3 16 0.14;3 3 18 0.14;5 3 19 0.14;29 3 20 0.14;30 3 21 0.14;10 3 22 0.14;4 3 25 0.14];
d6=[25 3 1 0.15;7 3 4 0.15;8 3 5 0.15;9 3 7 0.15;14 3 9 0.15;26 3 11 0.15;27 3 14 0.15;12 3 15 0.15;2 3 16 0.15;28 3 18 0.15;3 3 20 0.15;24 3 21 0.15;5 3 22 0.15;29 3 23 0.15;30 3 24 0.15;10 3 25 0.15;4 3 28 0.15];
d7=[25 3 1 0.16;7 3 4 0.16;8 3 5 0.16;9 3 7 0.16;14 3 9 0.16;26 3 11 0.16;27 3 14 0.16;12 3 15 0.16;2 3 16 0.16;28 3 18 0.16;3 3 20 0.16;24 3 21 0.16;5 3 22 0.16;29 3 23 0.16;30 3 24 0.16;10 3 25 0.16;4 3 28 0.16];
d8=[25 3 1 0.17;7 3 4 0.17;8 3 5 0.17;9 3 8 0.17;14 3 10 0.17;26 3 11 0.17;27 3 14 0.17;12 3 15 0.17;2 3 16 0.17;28 3 18 0.17;3 3 20 0.17;24 3 21 0.17;5 3 22 0.17;29 3 23 0.17;30 3 24 0.17;10 3 25 0.17;4 3 27 0.17];
d9=[25 3 1 0.18;7 3 4 0.18;8 3 5 0.18;9 3 8 0.18;14 3 11 0.18;26 3 12 0.18;27 3 15 0.18;12 3 16 0.18;28 3 18 0.18;3 3 20 0.18;24 3 21 0.18;5 3 22 0.18;29 3 23 0.18;30 3 24 0.18;10 3 25 0.18;4 3 27 0.18];
d10=[25 3 1 0.19;7 3 4 0.19;8 3 5 0.19;9 3 8 0.19;14 3 11 0.19;26 3 12 0.19;27 3 15 0.19;12 3 16 0.19;28 3 18 0.19;3 3 20 0.19;24 3 21 0.19;5 3 22 0.19;29 3 23 0.19;30 3 24 0.19;10 3 25 0.19;4 3 27 0.19];
d11=[25 3 1 0.2;7 3 4 0.2;8 3 5 0.2;9 3 8 0.2;14 3 11 0.2;26 3 12 0.2;27 3 16 0.2;12 3 17 0.2;28 3 19 0.2;3 3 21 0.2;24 3 22 0.2;5 3 23 0.2;29 3 24 0.2;30 3 25 0.2;10 3 26 0.2];
% image 4
e1=[25 4 2 0.1;7 4 6 0.1;8 4 8 0.1;23 4 9 0.1;2 4 10 0.1;30 4 12 0.1;26 4 13 0.1;12 4 14 0.1;28 4 19 0.1;5 4 20 0.1;24 4 23 0.1;1 4 24 0.1;29 4 26 0.1;4 4 28 0.1];
e2=[25 4 2 0.11;7 4 6 0.11;8 4 8 0.11;23 4 9 0.11;2 4 10 0.11;30 4 12 0.11;26 4 13 0.11;12 4 14 0.11;28 4 19 0.11;5 4 20 0.11;24 4 23 0.11;1 4 24 0.11;29 4 26 0.11;4 4 28 0.11];
e3=[25 4 2 0.12;7 4 4 0.12;8 4 6 0.12;2 4 8 0.12;30 4 9 0.12;12 4 10 0.12;28 4 15 0.12;5 4 16 0.12;24 4 19 0.12;1 4 20 0.12;29 4 22 0.12;4 4 24 0.12];
e4=[25 4 2 0.13;7 4 5 0.13;8 4 6 0.13;23 4 8 0.13;2 4 10 0.13;14 4 11 0.13;30 4 12 0.13;26 4 13 0.13;12 4 14 0.13;28 4 19 0.13;5 4 20 0.13;24 4 22 0.13;1 4 23 0.13;29 4 25 0.13;4 4 27 0.13];
e5=[25 4 2 0.14;7 4 5 0.14;8 4 6 0.14;23 4 8 0.14;2 4 10 0.14;14 4 11 0.14;30 4 12 0.14;26 4 13 0.14;12 4 14 0.14;28 4 19 0.14;5 4 20 0.14;24 4 22 0.14;1 4 23 0.14;29 4 25 0.14;4 4 27 0.14];
e6=[25 4 2 0.15;7 4 5 0.15;8 4 6 0.15;9 4 7 0.15;23 4 9 0.15;2 4 11 0.15;14 4 12 0.15;30 4 13 0.15;26 4 14 0.15;12 4 15 0.15;28 4 20 0.15;5 4 21 0.15;24 4 23 0.15;1 4 24 0.15;29 4 26 0.15;4 4 28 0.15];
e7=[25 4 2 0.16;7 4 5 0.16;8 4 6 0.16;9 4 7 0.16;23 4 9 0.16;2 4 11 0.16;14 4 12 0.16;30 4 13 0.16;26 4 14 0.16;12 4 15 0.16;28 4 20 0.16;5 4 21 0.16;24 4 23 0.16;1 4 24 0.16;29 4 26 0.16;4 4 28 0.16];
e8=[25 4 2 0.17;7 4 6 0.17;8 4 7 0.17;9 4 8 0.17;23 4 10 0.17;2 4 12 0.17;14 4 13 0.17;30 4 14 0.17;26 4 16 0.17;12 4 17 0.17;28 4 22 0.17;5 4 23 0.17;24 4 25 0.17;1 4 26 0.17;29 4 28 0.17;4 4 30 0.17];
e9=[25 4 2 0.18;7 4 6 0.18;8 4 7 0.18;9 4 8 0.18;23 4 10 0.18;2 4 13 0.18;14 4 14 0.18;30 4 15 0.18;26 4 17 0.18;12 4 19 0.18;28 4 24 0.18;5 4 26 0.18;24 4 28 0.18;1 4 29 0.18;29 4 31 0.18;4 4 33 0.18];
e10=[25 4 2 0.19;7 4 6 0.19;8 4 7 0.19;9 4 8 0.19;23 4 10 0.19;2 4 13 0.19;14 4 14 0.19;30 4 15 0.19;26 4 17 0.19;12 4 19 0.19;28 4 24 0.19;5 4 26 0.19;24 4 28 0.19;1 4 29 0.19;29 4 31 0.19;4 4 33 0.19];
e11=[25 4 2 0.2;7 4 6 0.2;8 4 7 0.2;9 4 8 0.2;23 4 10 0.2;2 4 11 0.2;14 4 13 0.2;30 4 14 0.2;26 4 16 0.2;12 4 18 0.2;28 4 23 0.2;5 4 26 0.2;24 4 29 0.2;1 4 30 0.2;29 4 32 0.2;4 4 34 0.2];

worm_idx_threshold1 = [b1;b2;b3;b4;b5;b6;b7;b8;b9;b10;b11];
worm_idx_threshold2 = [b1;b2;b3;b4;b5;b6;b7;b8;b9;b10;b11;c1;c2;c3;c4;c5;c6;c7;c8;c9;c10;c11];
worm_idx_threshold3 = [d1;d2;d3;d4;d5;d6;d7;d8;d9;d10;d11;e1;e2;e3;e4;e5;e6;e7;e8;e9;e10;e11];
worm_idx_threshold4 = [b1;b2;b3;b4;b5;b6;b7;b8;b9;b10;b11;c1;c2;c3;c4;c5;c6;c7;c8;c9;c10;c11;d1;d2;d3;d4;d5;d6;d7;d8;d9;d10;d11;e1;e2;e3;e4;e5;e6;e7;e8;e9;e10;e11];

[size_idx1,~] = size(worm_idx_threshold1);
[size_idx2,~] = size(worm_idx_threshold2);
[size_idx3,~] = size(worm_idx_threshold3);
[size_idx4,~] = size(worm_idx_threshold4);

name_max_12 = 23;
name_max_34 = 30;

% color_list = [1 0 0;0 1 0;0 0 1;1 1 0;0 0 0];
% for worm_name=1:name_max_12
%     for feature_num=1:5
%         figure;hold on;
%         color_distr = color_list(feature_num,:);
%         count = 0;
%         for image_num=1:2
%             pic = [];
%             for i=1:size_idx2
%                 if worm_idx_threshold2(i,1)==worm_name
%                     for threshold=0.1:0.01:0.2
%                         if worm_idx_threshold2(i,4)==threshold
%                             if worm_idx_threshold2(i,2)==image_num
%                                 load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_idx_threshold2(i,3)),'.mat']);
%                                 pic = [pic;[threshold,feature]]; 
%                             end
%                         end
%                     end
%                 end
%             end
%             [size_pic,~] = size(pic);
%             if size_pic>0
%                 count = count+1;
%                 plot(pic(:,1),pic(:,feature_num+1),'Color',color_distr,'LineWidth',2);
%             end
%         end
%         if count>0
%             if feature_num>=1 && feature_num<=3
%                 axis([0.1,0.2,0,130]);
%             elseif feature_num==4
%                 axis([0.1,0.2,0,5000]);
%             elseif feature_num==5
%                 axis([0.1,0.2,0,300]);
%             end  
%             mkdir(['output/12/worm_name_',num2str(worm_name)]);
%             title(['image1 & image2,    worm ',num2str(worm_name),',    feature(',num2str(feature_num),')']);
%             saveas(gcf,['output/12/worm_name_',num2str(worm_name),'/feature_',num2str(feature_num),'.png']);
%         end
%     end
%     close all;
% end
% 
% for worm_name=1:name_max_34
%     for feature_num=1:5
%         figure;hold on;
%         color_distr = color_list(feature_num,:);
%         count = 0;
%         for image_num=3:4
%             pic = [];
%             for i=1:size_idx3
%                 if worm_idx_threshold3(i,1)==worm_name
%                     for threshold=0.1:0.01:0.2
%                         if worm_idx_threshold3(i,4)==threshold
%                             if worm_idx_threshold3(i,2)==image_num
%                                 load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_idx_threshold3(i,3)),'.mat']);
%                                 pic = [pic;[threshold,feature]]; 
%                             end
%                         end
%                     end
%                 end
%             end
%             [size_pic,~] = size(pic);
%             if size_pic>0
%                 count = count+1;
%                 plot(pic(:,1),pic(:,feature_num+1),'Color',color_distr,'LineWidth',2);
%             end
%         end
%         if count>0
%             if feature_num>=1 && feature_num<=3
%                 axis([0.1,0.2,0,130]);
%             elseif feature_num==4
%                 axis([0.1,0.2,0,5000]);
%             elseif feature_num==5
%                 axis([0.1,0.2,0,300]);
%             end  
%             mkdir(['output/34/worm_name_',num2str(worm_name)]);
%             title(['image3 & image4,    worm ',num2str(worm_name),',    feature(',num2str(feature_num),')']);
%             saveas(gcf,['output/34/worm_name_',num2str(worm_name),'/feature_',num2str(feature_num),'.png']);
%         end
%     end
%     close all;
% end
% 
% 

worm_name_list = [1 6 5];
for h=1:5
    worm_name = worm_name_list(h);
%     pic = [];
    color_distr = rand(1,3);
    for image_num=1:2
        pic = [];
        for i=1:size_idx2
            if worm_idx_threshold2(i,1)==worm_name
                for threshold=0.1:0.01:0.2
                    if worm_idx_threshold2(i,4)==threshold
                        if worm_idx_threshold2(i,2)==image_num
                            load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_idx_threshold2(i,3)),'.mat']);
                            pic = [pic;[threshold,feature]];
                        end
                    end
                end
            end
        end
        [size_pic,~] = size(pic);
        if size_pic>0
            figure(1);hold on;
            plot(pic(:,1),pic(:,2),'Color',color_distr,'LineWidth',2);
            title(['image1 & image2,    feature(',num2str(1),')']);
            axis([0.1,0.2,0,130]);

            figure(2);hold on;
            plot(pic(:,1),pic(:,3),'Color',color_distr,'LineWidth',2);
            title(['image1 & image2,    feature(',num2str(2),')']);
            axis([0.1,0.2,0,130]);

            figure(3);hold on;
            plot(pic(:,1),pic(:,4),'Color',color_distr,'LineWidth',2);
            title(['image1 & image2,    feature(',num2str(3),')']);
            axis([0.1,0.2,0,130]);

            figure(4);hold on;
            plot(pic(:,1),pic(:,5),'Color',color_distr,'LineWidth',2);
            title(['image1 & image2,    feature(',num2str(4),')']);
            axis([0.1,0.2,0,5000]);

            figure(5);hold on;
            plot(pic(:,1),pic(:,6),'Color',color_distr,'LineWidth',2);
            title(['image1 & image2,    feature(',num2str(5),')']);
            axis([0.1,0.2,0,300]);
        end
    end
end

% figure(1);
% saveas(gcf,['output/12_',num2str(1),'.png']);
% figure(2);
% saveas(gcf,['output/12_',num2str(2),'.png']);
% figure(3);
% saveas(gcf,['output/12_',num2str(3),'.png']);
% figure(4);
% saveas(gcf,['output/12_',num2str(4),'.png']);
% figure(5);
% saveas(gcf,['output/12_',num2str(5),'.png']);


% for h=1:5
%     worm_name = worm_name_list(h);
% %     pic = [];
%     color_distr = rand(1,3);
%     for image_num=3:4
%         pic = [];
%         for i=1:size_idx3
%             if worm_idx_threshold3(i,1)==worm_name
%                 for threshold=0.1:0.01:0.2
%                     if worm_idx_threshold3(i,4)==threshold
%                         if worm_idx_threshold3(i,2)==image_num
%                             load (['output/threshold_',num2str(threshold),'/good_worms/image_',num2str(image_num),'/data_',num2str(worm_idx_threshold3(i,3)),'.mat']);
%                             pic = [pic;[threshold,feature]];
%                         end
%                     end
%                 end
%             end
%         end
%         [size_pic,~] = size(pic);
%         if size_pic>0
%             figure(6);hold on;
%             plot(pic(:,1),pic(:,2),'Color',color_distr,'LineWidth',2);
%             title(['image3 & image4,    feature(',num2str(1),')']);
%             axis([0.1,0.2,0,130]);
% 
%             figure(7);hold on;
%             plot(pic(:,1),pic(:,3),'Color',color_distr,'LineWidth',2);
%             title(['image3 & image4,    feature(',num2str(2),')']);
%             axis([0.1,0.2,0,130]);
% 
%             figure(8);hold on;
%             plot(pic(:,1),pic(:,4),'Color',color_distr,'LineWidth',2);
%             title(['image3 & image4,    feature(',num2str(3),')']);
%             axis([0.1,0.2,0,130]);
% 
%             figure(9);hold on;
%             plot(pic(:,1),pic(:,5),'Color',color_distr,'LineWidth',2);
%             title(['image3 & image4,    feature(',num2str(4),')']);
%             axis([0.1,0.2,0,5000]);
% 
%             figure(10);hold on;
%             plot(pic(:,1),pic(:,6),'Color',color_distr,'LineWidth',2);
%             title(['image3 & image4,    feature(',num2str(5),')']);
%             axis([0.1,0.2,0,300]);
%         end
%     end
% end

% figure(6);
% saveas(gcf,['output/34_',num2str(1),'.png']);
% figure(7);
% saveas(gcf,['output/34_',num2str(2),'.png']);
% figure(8);
% saveas(gcf,['output/34_',num2str(3),'.png']);
% figure(9);
% saveas(gcf,['output/34_',num2str(4),'.png']);
% figure(10);
% saveas(gcf,['output/34_',num2str(5),'.png']);


% for worm_name=1:22
%     pic = [];
%     for i=1:size_idx1
%         if worm_idx_threshold1(i,1)==worm_name
%             for threshold=0.1:0.01:0.2
%                 if worm_idx_threshold1(i,4)==threshold
%                     load (['output/threshold_',num2str(threshold),'/good_worms/image_1/data_',num2str(worm_idx_threshold1(i,3)),'.mat']);
%                     pic = [pic;[threshold,feature]];
%                 end
%             end
%         end
%     end
%     [size_pic,~] = size(pic);
%     if size_pic>0
%         figure(1);hold on;
%         plot(pic(:,1),pic(:,2),'-b');
%         axis([0.1,0.2,0,130]);
%         title('feature(1)');
% %         title(['worm number ',num2str(worm_name),'    feature(',num2str(1),')']);
% %         saveas(gcf,['output/worm_number_',num2str(worm_name),'_feature(',num2str(1),').png']);
%         
%         figure(2);hold on;
%         plot(pic(:,1),pic(:,3),'-b');
%         axis([0.1,0.2,0,130]);
%         title('feature(2)');
% %         title(['worm number ',num2str(worm_name),'    feature(',num2str(2),')']);
% %         saveas(gcf,['output/worm_number_',num2str(worm_name),'_feature(',num2str(2),').png']);
%         
%         figure(3);hold on;
%         plot(pic(:,1),pic(:,4),'-b');
%         axis([0.1,0.2,0,130]);
%         title('feature(3)');
% %         title(['worm number ',num2str(worm_name),'    feature(',num2str(3),')']);
% %         saveas(gcf,['output/worm_number_',num2str(worm_name),'_feature(',num2str(3),').png']);
%         
%         figure(4);hold on;
%         plot(pic(:,1),pic(:,5),'-b');
%         title('feature(4)');
% %         title(['worm number ',num2str(worm_name),'    feature(',num2str(4),')']);
% %         saveas(gcf,['output/worm_number_',num2str(worm_name),'_feature(',num2str(4),').png']);
%         
%         figure(5);hold on;
%         plot(pic(:,1),pic(:,6),'-b');
%         title('feature(5)');
% %         title(['worm number ',num2str(worm_name),'    feature(',num2str(5),')']);
% %         saveas(gcf,['output/worm_number_',num2str(worm_name),'_feature(',num2str(5),').png']);
%         
%     end
% end

% figure;hold on;
% [size_idx,~] = size(a1);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a1(i,4)),'/good_worms/image_1/data_',num2str(a1(i,3)),'.mat']);
%     pic = [pic;[a1(i,4),feature]];
%     plot(pic(:,1),pic(:,2),'+b');axis([0.1,0.2,0,255]);
% end
% [size_idx,~] = size(a2);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a2(i,4)),'/good_worms/image_2/data_',num2str(a2(i,3)),'.mat']);
%     pic = [pic;[a2(i,4),feature]];
%     plot(pic(:,1),pic(:,2),'.r');axis([0.1,0.2,0,255]);
% end
% axis([0.1,0.2,0,130]);
% title('feature(1)');
% % [size_idx,~] = size(a3);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a3(i,4)),'/good_worms/image_1/data_',num2str(a3(i,3)),'.mat']);
% %     pic = [pic;[a3(i,4),feature]];
% %     plot(pic(:,1),pic(:,2),'sg');
% % end
% % [size_idx,~] = size(a4);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a4(i,4)),'/good_worms/image_1/data_',num2str(a4(i,3)),'.mat']);
% %     pic = [pic;[a4(i,4),feature]];
% %     plot(pic(:,1),pic(:,2),'*k');
% % end
% 
% figure;hold on;
% [size_idx,~] = size(a1);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a1(i,4)),'/good_worms/image_1/data_',num2str(a1(i,3)),'.mat']);
%     pic = [pic;[a1(i,4),feature]];
%     plot(pic(:,1),pic(:,3),'+b');axis([0.1,0.2,0,255]);
% end
% [size_idx,~] = size(a2);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a2(i,4)),'/good_worms/image_2/data_',num2str(a2(i,3)),'.mat']);
%     pic = [pic;[a2(i,4),feature]];
%     plot(pic(:,1),pic(:,3),'.r');axis([0.1,0.2,0,255]);
% end
% axis([0.1,0.2,0,130]);
% title('feature(2)');
% % [size_idx,~] = size(a3);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a3(i,4)),'/good_worms/image_1/data_',num2str(a3(i,3)),'.mat']);
% %     pic = [pic;[a3(i,4),feature]];
% %     plot(pic(:,1),pic(:,3),'sg');
% % end
% % [size_idx,~] = size(a4);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a4(i,4)),'/good_worms/image_1/data_',num2str(a4(i,3)),'.mat']);
% %     pic = [pic;[a4(i,4),feature]];
% %     plot(pic(:,1),pic(:,3),'*k');
% % end
% 
% 
% figure;hold on;
% [size_idx,~] = size(a1);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a1(i,4)),'/good_worms/image_1/data_',num2str(a1(i,3)),'.mat']);
%     pic = [pic;[a1(i,4),feature]];
%     plot(pic(:,1),pic(:,4),'+b');axis([0.1,0.2,0,255]);
% end
% [size_idx,~] = size(a2);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a2(i,4)),'/good_worms/image_2/data_',num2str(a2(i,3)),'.mat']);
%     pic = [pic;[a2(i,4),feature]];
%     plot(pic(:,1),pic(:,4),'.r');
% end
% axis([0.1,0.2,0,130]);
% title('feature(3)');
% % [size_idx,~] = size(a3);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a3(i,4)),'/good_worms/image_1/data_',num2str(a3(i,3)),'.mat']);
% %     pic = [pic;[a3(i,4),feature]];
% %     plot(pic(:,1),pic(:,4),'sg');
% % end
% % [size_idx,~] = size(a4);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a4(i,4)),'/good_worms/image_1/data_',num2str(a4(i,3)),'.mat']);
% %     pic = [pic;[a4(i,4),feature]];
% %     plot(pic(:,1),pic(:,4),'*k');
% % end
% 
% figure;hold on;
% [size_idx,~] = size(a1);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a1(i,4)),'/good_worms/image_1/data_',num2str(a1(i,3)),'.mat']);
%     pic = [pic;[a1(i,4),feature]];
%     plot(pic(:,1),pic(:,5),'+b');
% end
% [size_idx,~] = size(a2);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a2(i,4)),'/good_worms/image_2/data_',num2str(a2(i,3)),'.mat']);
%     pic = [pic;[a2(i,4),feature]];
%     plot(pic(:,1),pic(:,5),'.r');
% end
% axis([0.1,0.2,0,5000]);
% title('feature(4)');
% % [size_idx,~] = size(a3);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a3(i,4)),'/good_worms/image_1/data_',num2str(a3(i,3)),'.mat']);
% %     pic = [pic;[a3(i,4),feature]];
% %     plot(pic(:,1),pic(:,5),'sg');
% % end
% % [size_idx,~] = size(a4);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a4(i,4)),'/good_worms/image_1/data_',num2str(a4(i,3)),'.mat']);
% %     pic = [pic;[a4(i,4),feature]];
% %     plot(pic(:,1),pic(:,5),'*k');
% % end
% 
% 
% figure;hold on;
% [size_idx,~] = size(a1);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a1(i,4)),'/good_worms/image_1/data_',num2str(a1(i,3)),'.mat']);
%     pic = [pic;[a1(i,4),feature]];
%     plot(pic(:,1),pic(:,6),'+b');
% end
% [size_idx,~] = size(a2);
% pic = [];
% for i=1:size_idx
%     load (['output/threshold_',num2str(a2(i,4)),'/good_worms/image_2/data_',num2str(a2(i,3)),'.mat']);
%     pic = [pic;[a2(i,4),feature]];
%     plot(pic(:,1),pic(:,6),'.r');
% end
% axis([0.1,0.2,0,300]);
% title('feature(5)');
% % [size_idx,~] = size(a3);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a3(i,4)),'/good_worms/image_1/data_',num2str(a3(i,3)),'.mat']);
% %     pic = [pic;[a3(i,4),feature]];
% %     plot(pic(:,1),pic(:,6),'sg');
% % end
% % [size_idx,~] = size(a4);
% % pic = [];
% % for i=1:size_idx
% %     load (['output/threshold_',num2str(a4(i,4)),'/good_worms/image_1/data_',num2str(a4(i,3)),'.mat']);
% %     pic = [pic;[a4(i,4),feature]];
% %     plot(pic(:,1),pic(:,6),'*k');
% % end
