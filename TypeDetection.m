classdef TypeDetection
    methods(Static)
        function [edges] = laplace(img)
            lap = [0 1 0; 1 -4 1; 0 1 0];
            edges = abs(uint8(conv2(double(img), lap,'same')));
        end
        function [edges] = log(img)
            filter = [0 0 -1 0 0; 0 -1 -2 -1 0; -1 -2 16 -2 -1; 0 -1 -2 -1 0; 0 0 -1 0 0];
            edges = uint8(convn(double(img), double(filter),'same'));
        end
        function [edges] = sobel(img)
            sobelX = [-1 0 1; -2 0 2; -1 0 1];
            sobelY = [1 2 1; 0 0 0; -1 -2 -1];
            edgeX = conv2(double(img), double(sobelX),'same');
            edgeY = conv2(double(img), double(sobelY),'same');
            edges = uint8(sqrt(edgeX.^2 + edgeY.^2));
        end
        function [edges] = prewitt(img)
            prewittX = [-1 0 1;-1 0 1;-1 0 1];
            prewittY = [1 1 1; 0 0 0; -1 -1 -1];
            edgeX = conv2(double(img), double(prewittX),'same');
            edgeY = conv2(double(img), double(prewittY),'same');
            edges = uint8(sqrt(edgeX.^2 + edgeY.^2));
        end
        function [edges] = roberts(img)
            robertsX = [1 0; 0 -1];
            robertsY = [0 1; -1 0];
            edgeX = conv2(double(img), double(robertsX),'same');
            edgeY = conv2(double(img), double(robertsY),'same');
            edges = uint8(sqrt(im2double(edgeX.^2 + edgeY.^2)));
        end
        function [edges] = canny(img)
            edges = edge(img,'canny')
        end
    end
end