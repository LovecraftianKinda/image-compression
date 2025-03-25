clc;
clearvars;

%args are passed as >>octave --persist compression.m image_file.x{jpg/png/etc...} format{gray/rgb}
args = argv();

if length(args) < 2
    file_name = input("Enter file name : ","s");
    file_type = input("Enter format(rgb/gray) :","s");
else
    file_name = args{1};
    file_type = args{2};
end

% Get image path from the same directory as the script
script_dir = fileparts(mfilename('fullpath')); % Get script directory
image_file = fullfile(script_dir, file_name); % Concatenate with image filename

%Checks if the image exists or not
if ~exist(image_file, 'file')  % Check if file exists
    disp(['Image not found: ', image_file]);
    exit;
end

%If the image is RGB (color), imread returns a 3D matrix of size (height x width x 3)
%If the image is grayscale, imread returns a 2D matix of size (height x width)
img = imread(image_file); % Load image

switch lower(file_type)

    case 'rgb'

        %if gray image is passed of as rgb we have to convert it into 3d array
        if ndims(img) == 2  
            error("The given image is grayscale but RGB was selected.");
        else
            %Separate the image into 3 different channels and compress them all
            R = img(:,:,1); % Red channel
            G = img(:,:,2); % Green channel
            B = img(:,:,3); % Blue channel
        end

        zero_channel = zeros(size(R), 'uint8');

        disp("Compressing image.....");

        compressed_R = mat_comp(R,100);
        compressed_G = mat_comp(G,100);
        compressed_B = mat_comp(B,100);

        compressed_img = cat(3,compressed_R,compressed_G,compressed_B);

        figure;
        subplot(1,2,1);
        imshow(img);
        axis image;
        title('Original Image');

        subplot(1,2,2);
        imshow(compressed_img);
        axis image;
        title('Compressed Image');

        disp("Done.");
        
    case 'gray'
        if ~(ndims(img) == 2)
            img = rgb2gray(img);
        end

        disp("Compressing image.....");
        compressed_img = mat_comp(img,100);

        figure;
        subplot(1,2,1);
        imshow(img);
        axis image;
        title('Original Image');

        subplot(1,2,2);
        imshow(compressed_img);
        axis image;
        title('Compressed Image');

        disp("Done.");
        
    otherwise
        error("Invalid format. Use 'rgb' or 'gray'.");
end

imwrite(compressed_img, 'last_result.jpg');