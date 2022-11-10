clear
clc
close all

img = imread('images\burung.png');
img_gs = rgb2gray(img);

edgeLog = TypeDetection.log(img_gs);
edgeSobel = TypeDetection.sobel(img_gs);
edgePrewitt = TypeDetection.prewitt(img_gs);
edgeLaplace = TypeDetection.laplace(img_gs);
edgeRoberts = TypeDetection.roberts(img_gs);
edgeCanny = TypeDetection.canny(img_gs);

% importing the image
subplot(1, 2, 1),
imshow(edgeSobel);
title("Laplace");
 
% Sobel Edge Detection
J = edge(img_gs, 'sobel');
subplot(1, 2, 2),
imshow(J);
title("Sobel");
