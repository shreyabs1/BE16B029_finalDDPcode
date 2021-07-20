clear; warning of-f; current = pwd;
path = uigetdir(pwd,'select your working directory');
cd(path);

[file,path] = uigetfile('*.nii');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
   
   image = niftiread(fullfile(path,file));
   image_info = niftiinfo(fullfile(path,file));
   nifti_array = size(image);
   double = im2double(image);
   
   ask_rotate = input(' Would you like to rotate the orientation? (y/n) ', 's');
   if lower(ask_rotate) == 'y'
       ask_rotate_num = str2double(input('OK. By 90° 180° or 270°? ', 's'));
       if ask_rotate_num == 90 || ask_rotate_num == 180 || ask_rotate_num == 270
           disp('Got it. Your images will be rotated.');
       else
           disp('Sorry, I did not understand that. Quitting...');
           exit;
       end
   elseif lower(ask_rotate) ~= 'n' && lower(ask_rotate) ~= 'y'
       disp('Sorry, I did not understand that. Quitting...');
       exit;
   end

   if length(nifti_array) == 4
       
       mkdir png
       
       total_volumes = nifti_array(4);
       total_slices = nifti_array(3);
       
       current_volume = 1;
       disp('Converting NIfTI to png, please wait...')
       while current_volume <= total_volumes
           slice_counter = 0;
            current_slice = 1;
            while current_slice <= total_slices
                if mod(slice_counter, 1) == 0
                    
                    if lower(ask_rotate) == 'y'
                        if ask_rotate_num == 90
                            data = rot90(mat2gray(double(:,:,current_slice,current_volume)));
                        elseif ask_rotate_num == 180
                            data = rot90(rot90(mat2gray(double(:,:,current_slice,current_volume))));
                        elseif ask_rotate_num == 270
                            data = rot90(rot90(rot90(mat2gray(double(:,:,current_slice,current_volume)))));
                        end
                    elseif lower(ask_rotate) == 'n'
                    disp('OK, I will convert it as it is.');
                    data = mat2gray(double(:,:,current_slice,current_volume));
                    end
                    
                    filename = file(1:end-4) + "_t" + sprintf('%03d', current_volume) + "_z" + sprintf('%03d', current_slice) + ".png";
                    
                    newfile = imresize(filename, [448, 448]);
                    
                    
                    imwrite(data, char(newfile));
                                        
                    if current_slice == total_slices
                        if current_volume < total_volumes
                            current_volume = current_volume + 1;
                            imwrite(data, char(newfile));
                        else         
                            imwrite(data, char(newfile));
                            disp('Finished!')
                            return
                        end
                    end
                 
                    movefile(char(newfile),'png');
                    
                    slice_counter = slice_counter + 1;
                    
                    percentage = strcat('Please wait. Converting...', ' ', num2str((current_volume/total_volumes)*100), '% Complete');
                    
                    if ((current_volume/total_volumes)*100) == 100
                        disp('100% Complete! Images successfully converted.');
                    else
                        disp(percentage);
                    end                    
                end
                current_slice = current_slice + 1;
            end
       current_volume = current_volume + 1;
       end
   elseif length(nifti_array) == 3
       mkdir png
       total_slices = nifti_array(3);
       
       disp('Converting NIfTI to png, please wait...')

       slice_counter = 0;
        current_slice = 1;
        while current_slice <= total_slices
            if mod(slice_counter, 1) == 0     
                
                if lower(ask_rotate) == 'y'
                    if ask_rotate_num == 90
                        data = rot90(mat2gray(double(:,:,current_slice)));
                    elseif ask_rotate_num == 180
                        data = rot90(rot90(mat2gray(double(:,:,current_slice))));
                    elseif ask_rotate_num == 270
                        data = rot90(rot90(rot90(mat2gray(double(:,:,current_slice)))));
                    end
                elseif lower(ask_rotate) == 'n'
                disp('OK, I will convert it as it is.');
                data = mat2gray(double(:,:,current_slice));
                end
                
                filename = file(1:end-4) + "_z" + sprintf('%03d', current_slice) + ".png";
                newfile = imresize(filename, [448, 448]);
                imwrite(data, char(newfile));
                movefile(char(newfile),'png');
                slice_counter = slice_counter + 1;

                percentage = strcat('Please wait. Converting...', ' ', num2str((current_slice/total_slices)*100), '% Complete');

                if ((current_slice/total_slices)*100) == 100
                    disp('100% Complete! Images successfully converted');
                else
                    disp(percentage);
                end                    
            end
            current_slice  = current_slice  + 1;
        end
   elseif length(nifti_array) ~= 3 || 4
       disp('NIfTI must be 3D or 4D. Please try again.');
   end
end
