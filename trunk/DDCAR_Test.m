%% Wrapper to load sample datasets and run DDCAR
clear
clear functions
DataIn=csvread('gaussian5000b.csv',1,0);
figure(1)
scatter(DataIn(:,1),DataIn(:,2));

%% Normalise data
DataIn=double(DataIn(:,1:2));
for idx=1:size(DataIn,2)
    DataIn(:,idx) = (DataIn(:,idx)-min(DataIn(:,idx))) / (max(DataIn(:,idx))-min(DataIn(:,idx)));
end

%% Run DDCAR
MinimumClusterSize=1; % note this value is not currently used and is intended to remove 'clutter' from plots, or to identify outliers ratther than form part of the cluster technique itself
Verbose=0;
Merge=1;
tic
[Clusters, Results]=DDCAR_ver02(DataIn, MinimumClusterSize,Verbose, Merge); % data, min clus size, verbose, merge
t2=toc;
sprintf('Cluster time= %3f at %2f samples per second',t2, size(DataIn,1)/t2)
%% Plot Results
figure(3)
clf
Colours=distinguishable_colors(max(Results(:,3)));
scatter(Results(:,1),Results(:,2),20,Colours(Results(:,3),:))
axis([0 1 0 1])
hold on
for zz=1:size(Clusters.Centre,1)
  rectangle('Position',[Clusters.Centre(zz,1)-Clusters.Rad(zz,1), Clusters.Centre(zz,2)-Clusters.Rad(zz,2), 2*Clusters.Rad(zz,1), 2*Clusters.Rad(zz,2)],'Curvature',[1,1])
end