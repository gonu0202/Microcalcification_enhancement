

clear
close all
clc

%   Accessing the image and the Pectoral Muscle Gold Standard files
% image_Folder = 'D:\My PhD\Mammographic Database\miniMIAS\Mammograms' ;  %  Mammographic Image Folder.
image_Folder = 'E:\Matlab Work\mias_Data\Mini Mammographic';
% pm_Folder = 'D:\My PhD\Mammographic Database\miniMIAS\PECTORAL';    %   Mammogram Pectoral Muscle Boundary in Text Format.
%current_Folder = 'E:\Matlab Work\DICOM_PM\INB_PM_Segmentation' ;
%
image_Files = dir(fullfile(image_Folder,'*.pgm')) ;
% pm_Files = dir(fullfile(pm_Folder,'*.pec'));  % List of Available Pectoral Muscle mammograms name/ID in .xml format
%
%   List og the Images to be Processed for whic PM GS is Available
image_List = fopen('list.txt','rt');

% %   Creating a folder "Result" to store output.
% Output = 'Result/';
% if ~exist(Output,'dir')
%     mkdir(Output)
% end
% Output = 'ROI_ds/';
% if ~exist(Output,'dir')
%     mkdir(Output)
% end
% Output = 'GF_Edges/';
% if ~exist(Output,'dir')
%     mkdir(Output)
% end
% Output = 'GaborPhase/';
% if ~exist(Output,'dir')
%     mkdir(Output)
% end
% Output = 'FinalResult/';
% if ~exist(Output,'dir')
%     mkdir(Output)
% end
%  Creating the result in Tabular Format
statsF = fopen('miniMIAS_Res.txt','wt');
fprintf(statsF,'Name \t\t\tPP_FP   \tPP_FN   \tHD(No. of Pixels)  \tHD(in mm) \n');
fprintf(statsF,'-------------------------------------------------------------------\n');
kk =1;

%   Setting the Condition for termination of Current Progaamm.
while ~feof(image_List)
    tic
    imgFile = fgetl(image_List);%   Reading Each line of Image List file
    %f1 = flip(imgFile);
    imgFile1 = imgFile(1:6);
%     imgFile1 = flip(f1(19:60));
%     pmFile = flip(f1(3:17));
    % imgFile = imagFile{3};
    if isempty(imgFile)
        break;
    end
    
    %%  Preprocessing and Image Adjustment and ROI Selection
    %%
    img = imread(strcat(image_Folder,'\',imgFile1,'.pgm')); %   Reading the Mammographic Image:
    if isempty(img)
        break;
    end
    img1 = img; % Converting the 12 bit Intensity values of DICOM Images to 8 bit
    %   Flipping the mammographic image if it is MLO-R
    %   Selection of Region of Interest (ROI) Containing Pectoral Muscles:
    %ROI = f_ROI(img1);
    ROI = ar_ROI(img1);
    
    %   Enhancing the Quality of ROI Image:::
    ROI_he = adapthisteq(ROI); %    Adaptive Histogtam Equilization:
    ROI_enhanced = imgaussfilt(ROI_he,1);   %   Gaussian Filtering:
        figure()
        subplot(1,2,1),imshow(img1)
        subplot(1,2,2),imshow(ROI,[])
    %%  Straight Line Estimation Using Hough Transform:
    %%
    ROI_ds = imresize(ROI_enhanced,1);    %  Downsampled  ROI After Enhancement
    [PTG, ROI_entropy] = f_PTG(ROI_ds,30,80);
    PTG_mask = PTG;

    
    %%  Performance Measure::::::::::::::::::::::::::::::::::::::::::::::::::::
    %%  Reading the Pectoral Muscle Gold Standard
%     
%     %fileID = fopen('E:\IITP\DATABASE\INbreast Release 1.0\INB_PM_TextFile\20588680_pm.txt','r');
%     PM_1 = fopen(strcat(pm_Folder,'\',pmFile1,'.pec'));
%     PM_gs = fscanf(PM_1,'%f');
%     [pm_gs_x,pm_gs_y] = f_Interpolation(PM_gs);
%     
%     %  Calculation of False Positive(FP) and False Negative(FN)
%     [PP_FP,PP_FN,TP] = f_Performance_FP_FN(ROI,cc_X_Interpo,cc_Y_Interpo,pm_gs_x,pm_gs_y);
%     
% %      Finding Hausdorff Distance
%     gs_3 = [pm_gs_x;pm_gs_y]';
%     Present_1 = [cc_X_Interpo;cc_Y_Interpo]';
%     [HD,ed] = HausdorffDist(Present_1,gs_3);
%     
%     %%  Writing The Result into an output file and storing it;
%     %fprintf(statsRes2,'%s \t\t%f \t\t%f \n',imgFile,PP_FP, PP_FN);
%     fprintf(statsF,'%s \t\t%f \t%f \t%f \t\t\t%f\n',imgFile1(1:8),PP_FP,PP_FN,HD,HD*0.02);
%     toc
%     
    %%  Writing and Storing the images of::: imwrite(A,'myGray.png')
        imwrite(ROI_ds,strcat('ROI_ds','\',pmFile(1:8),'.png'));  %   ROI_ds
%         imwrite(gaborEdges,strcat('GF_Edges','\',pmFile(1:8),'.png'));% Edges of Gabored phase response
%         imwrite(p,strcat('GaborPhase','\',pmFile(1:8),'.png'));% Gabored phase response
%     
    figure()
    subplot(1,5,1), imshow(ROI,[]), title('GF_Edges')
    hold on, plot(cc_X_Interpo,cc_Y_Interpo,'r')
    %hold on, plot(pm_gs_x,pm_gs_y,'b')
    subplot(1,5,2), imshow(ROI,[]), title('Gabor_Phase')
   % hold on, plot(pm_gs_x,pm_gs_y)
    subplot(1,5,3), imshow(gaborEdges_mask,[]), title('edgeStrengths')
   % subplot(1,5,4), imshow(p,[]), title(strcat(pmFile(1:8),'gaborGradx'))
    
    %%  Taking Results::::

end





