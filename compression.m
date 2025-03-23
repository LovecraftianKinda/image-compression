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
            R = img; %same as the image is grayscale
            G = img; %same as the image is grayscale
            B = img; %same as the image is grayscale
        else
            R = img(:,:,1); % Red channel
            G = img(:,:,2); % Green channel
            B = img(:,:,3); % Blue channel
        end

        zero_channel = zeros(size(R), 'uint8');

        Red_Image   = cat(3, R, zero_channel, zero_channel);
        Green_Image = cat(3, zero_channel, G, zero_channel);
        Blue_Image  = cat(3, zero_channel, zero_channel, B);

        figure;

        subplot(1,4,1);
        imshow(img);
        axis image;
        title('Original Image');

        subplot(1,4,2);
        imshow(Red_Image);
        axis image;
        title('Red Channel');

        subplot(1,4,3);
        imshow(Green_Image);
        axis image;
        title('Green Channel');

        subplot(1,4,4);
        imshow(Blue_Image);
        axis image;
        title('Blue Channel');

    case 'gray'
        if ~(ndims(img) == 2)
            img = rgb2gray(img);
        end

        figure;

        imshow(img);
        axis image;
        title('Original Image');
    otherwise
        error("Invalid format. Use 'rgb' or 'gray'.");
end