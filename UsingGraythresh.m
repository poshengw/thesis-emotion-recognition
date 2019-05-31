function [S] = UsingGraythresh(C)
level= graythresh(C);
S = im2bw(C,level);
S = ~S;