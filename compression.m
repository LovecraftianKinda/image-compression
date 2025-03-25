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
script_directory = fileparts(mfilename('fullpath')); % Get script directory
image_file = fullfile(script_directory, file_name); % Concatenate with image filename

%Checks if the image exists or not
if ~exist(image_file, 'file')  % Check if file exists
    disp(['Image not found: ', image_file]);
    exit;
end

%If the image is RGB (color), imread returns a 3D matrix of size (height x width x 3)
%If the image is grayscale, imread returns a 2D matix of size (height x width)
img = imread(image_file); % Load image
size_old = dir(image_file).bytes;%save the size of file for future computation

K_vals = [2 10 50 100];%values of k to compress nxm to nxk
len_k = length(K_vals);

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

        compressed_img = cell(1, len_k);

        disp("Multiplying a bunch of matrices...");
        for i = 1:len_k
            disp(["Compressing for k = ",num2str(K_vals(i))]);
            compressed_R = mat_comp(R, K_vals(i));
            compressed_G = mat_comp(G, K_vals(i));
            compressed_B = mat_comp(B, K_vals(i));
    
            compressed_img{i} = cat(3, compressed_R, compressed_G, compressed_B);
            disp("Done.");
        end

        disp("Displaying all the images....");
        figure;
        subplot(1,len_k+1,1);
        imshow(img);
        axis image;
        title('Original Image','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Arial');

        for i = 1:len_k
            subplot(1,len_k+1,i+1);
            imshow(compressed_img{i});
            axis image;
            title(['K = ',num2str(K_vals(i))],'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Arial');
        end

        disp("Done.");
        
    case 'gray'
        if ~(ndims(img) == 2)
            img = rgb2gray(img);
        end

        disp("Compressing image.....");

        compressed_img = cell(1, len_k);

        disp("Multiplying a bunch of matrices...");
        for i = 1:len_k
            disp(["Compressing for k = ",num2str(K_vals(i))]);
            compressed_img{i} = mat_comp(img, K_vals(i));
            disp("Done.");
        end

        disp("Displaying all the images....");
        figure;
        subplot(1,len_k+1,1);
        imshow(img);
        axis image;
        title('Original Image','FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Arial');

        for i = 1:len_k
            subplot(1,len_k+1,i+1);
            imshow(compressed_img{i});
            axis image;
            title(['K = ',num2str(K_vals(i))],'FontSize', 18, 'FontWeight', 'bold', 'FontName', 'Arial');
        end

        disp("Done.");
        
    otherwise
        error("Invalid format. Use 'rgb' or 'gray'.");
end

disp("Saving....");
for i = 1:len_k
    new_file_name = ['compressed_K', num2str(K_vals(i)), '.jpg'];
    imwrite(compressed_img{i}, new_file_name);
    size_new = dir(new_file_name).bytes;
    compression_perc = (1 - (size_new/size_old)) * 100;
    disp(['Saved: ',new_file_name, ' | Compression Percentage: ',num2str(compression_perc, '%.3f'), '%']);
end
disp("Done....");