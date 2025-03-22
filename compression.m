clc;
clearvars;

% Get image path from the same directory as the script
script_dir = fileparts(mfilename('fullpath')); % Get script directory
image_file = fullfile(script_dir, 'cat_sample.jpg'); % Concatenate with image filename

%If the image is RGB (color), imread returns a 3D matrix of size (height × width × 3)

if exist(image_file, 'file')  % Check if file exists
    img = imread(image_file); % Load image
    R = img(:,:,1); % Red channel
    G = img(:,:,2); % Green channel
    B = img(:,:,3); % Blue channel

    zero_channel = zeros(size(R), 'uint8');

    Red_Image   = cat(3, R, zero_channel, zero_channel);
    Green_Image = cat(3, zero_channel, G, zero_channel);
    Blue_Image  = cat(3, zero_channel, zero_channel, B);

    figure;

    imshow(img);
    axis image;
    title('Original Image');

    figure;

    subplot(1,3,1);
    imshow(Red_Image);
    axis image;
    title('Red Channel');

    subplot(1,3,2);
    imshow(Green_Image);
    axis image;
    title('Green Channel');

    subplot(1,3,3);
    imshow(Blue_Image);
    axis image;
    title('Blue Channel');
else
    disp(['Image not found: ', image_file]);
end
