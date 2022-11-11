classdef TypeDetection
    methods(Static)
        function [edges] = laplace(img)
            % Filter Laplace
            lap = [0 1 0; 1 -4 1; 0 1 0];
            edges = abs(uint8(conv2(double(img), lap,'same')));
        end
        function [edges] = log(img)
            filter = [0 0 -1 0 0;
                    0 -1 -2 -1 0;
                    -1 -2 16 -2 -1;
                    0 -1 -2 -1 0;
                    0 0 -1 0 0];
            edges = uint8(conv2(double(img), double(filter),'same'));
        end
        function [edges] = sobel(img)
            sobelX = [-1 0 1; -2 0 2; -1 0 1];
            sobelY = [1 2 1; 0 0 0; -1 -2 -1];
            edgeX = conv2(double(img), double(sobelX),'same');
            edgeY = conv2(double(img), double(sobelY),'same');
            edges = uint8(sqrt(edgeX.^2 + edgeY.^2));
            edges(:,1) = 0;
            edges(1,:) = 0;
        end
        function [edges] = prewitt(img)
            prewittX = [-1 0 1;-1 0 1;-1 0 1];
            prewittY = [-1 -1 -1; 0 0 0; 1 1 1];
            edgeX = conv2(double(img), double(prewittX),'same');
            edgeY = conv2(double(img), double(prewittY),'same');
            edges = uint8(sqrt(edgeX.^2 + edgeY.^2));
            edges(:,1) = 0;
            edges(1,:) = 0;
        end
        function [edges] = roberts(img)
            robertsX = [1 0; 0 -1];
            robertsY = [0 1; -1 0];
            edgeX = conv2(double(img), double(robertsX),'same');
            edgeY = conv2(double(img), double(robertsY),'same');
            edges = uint8(sqrt(im2double(edgeX.^2 + edgeY.^2)));
            edges(:,1) = 0;
            edges(1,:) = 0;
        end
        function [edges] = canny(img)
            edges = edge(img,'canny');
        end
        function [edges] = createBinary(edges, t)
            [r,c,rgb] = size(edges);
            for i=1:r 
                for j=1:c
                    if edges(i,j)>t
                        edges(i,j)=1;
                    else
                        edges(i,j)=0;
                    end
                end
            end
        end
        function imgOut = segment(edge, ori)
            [r,c,rgb] = size(edge);
            clear = edge;
            clear(1,:) = 0;
            clear(r,:) = 0;
            clear(:,1) = 0;
            clear(:,c) = 0;
            mask = imdilate(clear, strel('line', 3, 0));
            mask = imdilate(mask, strel('line', 3, 45));
            mask = imdilate(mask, strel('line', 3, 90));
            mask = imdilate(mask, strel('line', 3, 135));
            mask = imdilate(mask, strel('disk', 2));
            mask = imfill(mask, 8, 'holes');
            imgOut = ori .* uint8(mask);
        end
        function result = segmentation(img, t, operation)
            if size(img,3)==1
                if operation =="Canny"
                    result = TypeDetection.segment(TypeDetection.canny(img), img);
                elseif operation =="Prewitt"
                    result = TypeDetection.segment(TypeDetection.createBinary(TypeDetection.prewitt(img),t), img);
                elseif operation == "Sobel"
                    result = TypeDetection.segment(TypeDetection.createBinary(TypeDetection.sobel(img),t), img);
                elseif operation == "Roberts"
                    result = TypeDetection.segment(TypeDetection.createBinary(TypeDetection.roberts(img),t), img);
                elseif operation == "Laplace"
                    result = TypeDetection.segment(TypeDetection.createBinary(TypeDetection.laplace(img),t), img);
                elseif operation == "LoG"
                    result = TypeDetection.segment(TypeDetection.createBinary(TypeDetection.log(img),t), img);
                end
            else
                if operation == "Canny"
                    edge = TypeDetection.canny(img(:,:,1)) | TypeDetection.canny(img(:,:,2)) | TypeDetection.canny(img(:,:,3));
                elseif operation == "Prewitt"
                    edge = TypeDetection.createBinary(TypeDetection.prewitt(img(:,:,1)),t) |  TypeDetection.createBinary(TypeDetection.prewitt(img(:,:,2)),t) |  TypeDetection.createBinary(TypeDetection.prewitt(img(:,:,3)),t);
                elseif operation == "Sobel"
                    edge = TypeDetection.createBinary(TypeDetection.sobel(img(:,:,1)),t) |  TypeDetection.createBinary(TypeDetection.sobel(img(:,:,2)),t) |  TypeDetection.createBinary(TypeDetection.sobel(img(:,:,3)),t);
                elseif operation == "Roberts"
                    edge = TypeDetection.createBinary(TypeDetection.roberts(img(:,:,1)),t) |  TypeDetection.createBinary(TypeDetection.roberts(img(:,:,2)),t) |  TypeDetection.createBinary(TypeDetection.roberts(img(:,:,3)),t);
                elseif operation == "Laplace"
                    edge = TypeDetection.createBinary(TypeDetection.laplace(img(:,:,1)),t) |  TypeDetection.createBinary(TypeDetection.laplace(img(:,:,2)),t) |  TypeDetection.createBinary(TypeDetection.laplace(img(:,:,3)),t);
                elseif operation == "LoG"
                    edge = TypeDetection.createBinary(TypeDetection.log(img(:,:,1)),t) |  TypeDetection.createBinary(TypeDetection.log(img(:,:,2)),t) |  TypeDetection.createBinary(TypeDetection.log(img(:,:,3)),t);
                end
                result = TypeDetection.segment(edge, img);
            end
        end
    end
end