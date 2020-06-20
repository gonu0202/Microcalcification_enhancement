clear all;
close all;
clc; 
%threshold values for different images
%{
    image 1: 130
    image 2: 160
    image 3: 170
    image 4: 100
    image 5: 140
    image 6: 150
    image 7: 170
    image 8: 160
    image 9; 230
 %}
A=imread('C:\Users\ANIKET KUMAR\Desktop\Image Processing\mammogram7.jpg');
A = rgb2gray(A);
m = 3; %m is the order of mask used for calculating variance
maxn = max(max(A));
%Finding mean of intensities value greater than 100

[x,y] = size(A);
%boundary between background and tissues
tf = A > 170 ;
k = mean(reshape(A(tf),1,[]));
k = ceil(k);

pi = membership(A,k);
V = non_uniformity(A,m,k); 
%Enhanced image(E) is given by
E = (pi.*V)*double(maxn);
subplot(1,2,1); imshow(A);
subplot(1,2,2); imshow(E);

