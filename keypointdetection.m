function [ label,dataset ] = keypointdetection(srcFiles,starts,ends )
for u = starts : ends
     filename = srcFiles(u).name;
    a = imread(strcat('C:\Test021\',filename));
% % %     a = aa{u};
     %a=imread(image);
% imshow(a);
% title('Selected image');
[m,n,plane]=size(a);
if plane==3
a=rgb2gray(a);
end
a=im2double(a);
original=a;
% % % store1=[];
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0;
[a, store1] = octavegen(a,m,n,original,k2);
%% 2nd Octave generation
k2=1;
[m,n]=size(a);
[a, store2] = octavegen(a,m,n,original,k2);
%% 3rd octave generation
k2=2;
[m,n]=size(a);
[a, store3] = octavegen(a,m,n,original,k2);
[m,n]=size(original);
%% Obtaining key point from the image
i1=store1(1:m,1:n)-store1(1:m,n+1:2*n);
i2=store1(1:m,n+1:2*n)-store1(1:m,2*n+1:3*n);
i3=store1(1:m,2*n+1:3*n)-store1(1:m,3*n+1:4*n);
[m,n]=size(i2);
kp=[];
kpl=[];
tic
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>my && i2(i,j)>mz) || (i2(i,j)<miy && i2(i,j)<miz)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
    end
end
% fprintf('\nTime taken for finding the key points is :%f\n',toc);

%% Key points plotting on to the image
for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    i2(k1,j1)=1;
end
% figure, imshow(i2);
% title('Image with key points mapped onto it');

%%
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i2(i+1,j)-i2(i,j))^2)+((i2(i,j+1)-i2(i,j))^2));
         oric(i,j)=atan2(((i2(i+1,j)-i2(i,j))),(i2(i,j+1)-i2(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods
kpmag=[];
kpori=[];
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag=[kpmag kmag];
kpori=[kpori kori];
end
%% Forming key point Descriptors
kpd=[];
for x1=1:2:length(kpl)
    kpdlent=1;
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 7 && j1 > 7 && k1 < m-8 && j1 < n-8
    p2=mag(k1-7:k1+8,j1-7:j1+8);
    q2=oric(k1-7:k1+8,j1-7:j1+8);
    else
        continue;
    end
    kpmagd=[];
    kporid=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);  
            [m1,n1]=size(p1);
            magcounts=[];
            for x=0:45:359
                magcount=0;
            for i=1:m1
                for j=1:n1
                    ch1=-180+x;
                    ch2=-180+45+x;
                    if ch1<0  ||  ch2<0
                    if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                        ori(i,j)=(ch1+ch2+1)/2;
                        magcount=magcount+p1(i,j);
                    end
                    else
                    if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                        ori(i,j)=(ch1+ch2+1)/2;
                        magcount=magcount+p1(i,j);
                    end
                    end
                end
            end
            magcounts=[magcounts magcount];
            end
           
     kpmagd=[kpmagd magcounts];
           f{u,1}=kpmagd;
           
        end
  
    end
     kpd=[kpd kpmagd];
end
kpd_row = length(kpd)/length(kpmagd);
kpd_col = length(kpmagd);
 kpdmtrx = reshape(kpd,[kpd_row,kpd_col]);
 kpdmtrx_all{u,1} = kpdmtrx; 
fprintf('\nTime taken for finding key point desctiptors is :%f\n',toc);
end
final_kpdmtrxall=cell2mat(kpdmtrx_all);
[idx,D] = kmeans(final_kpdmtrxall,100);
nrmvalue1= length(idx);
dataset= histc(idx,unique(idx))/nrmvalue1;
label= ones(100,1);
end

