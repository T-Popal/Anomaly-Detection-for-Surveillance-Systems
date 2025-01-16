%% Important Variables
% a : Input image
% kpmag : keypoints magnitude
% kpori : keypoints orientation
% kpd   : key point descriptors
% kp    : keypoints
% kpl   : keypoint locations

% c = cell(30,1);
clc;
close all;
srcFiles = dir('C:\Train019\*.tif');
starts=1;
ends=length(srcFiles)- 180;
[label_train, train_data] = keypointdetection(srcFiles,starts,ends);
 model = svmtrain(label_train, train_data, '-s 2 -t 2 -g 0.06');

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
srcFiles = dir('C:\Test019\*.tif');
starts = 111;
ends = length(srcFiles)-70;
[label_test, test_data] = keypointdetection(srcFiles,starts,ends);
[predict_label, accuracy, dec_values] = svmpredict(label_test, test_data, model);

%END