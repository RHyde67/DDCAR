function [ Clusters, Results, InitR ] = DDCAR_ver02( varargin )
%DDCAR_VER02 
% Copyright R Hyde 2014
% Released under the GNU GPLver3.0
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/
% If you use this file please acknowledge the author and cite as a
% reference the following two documents:
% Hyde, R., & Angelov, P. (2014, December). A fully autonomous Data Density based Clustering technique.
% In Evolving and Autonomous Learning Systems (EALS), 2014 IEEE Symposium on (pp. 116-123). IEEE.
% DOI: 10.1109/EALS.2014.7009512
% Downloadable from: http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=7009512
% Hyde, R.; Angelov, P., "Data density based clustering," Computational
% Intelligence (UKCI), 2014 14th UK Workshop on , vol., no., pp.1,7, 8-10 Sept. 2014
% doi: 10.1109/UKCI.2014.6930157
% Downloadable from: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6930157&isnumber=6930143
%%
%  DDCAR provides a technique for automatically estimating initial radii
%  for DDC clustering. The radius estimation is entirely data driven and
%  results in a clusterig technique requiring no user input. In it's
%  current form it is a demonstration limited to certain types of data.
% Useage:
%   [Clusters, Results]=DDCAR_ver02(DataIn, MinimumClusterSizeSize,Verbose, Merge)
% Inputs:
%   DataIn   an m x n array of data samples with each data sample contained in
%           the rows
%   MinimumClusterSize (not currently used)
%   Verbose   0 - silent, 1 - provide plotting and out put data during the clustering operation
%   Merge     0- do not merge initial clusters, 1 - basic merging operation
%             where cluster centres lie within another cluster
% Outputs:
%   Clusters  Structure containing the cluster centres and radii
%   Results   Array of data samples with the cluster number appended  
%%
DataIn=varargin{1}; % Read Array of Data
MinClus=varargin{2};
Verbose=varargin{3}; % Read flag for plotting during the run
Merge=varargin{4}; % Read flag for merging final clusters

SpaceRatio=9; %% can be adjusted but largely inependent 13 to 90
clear Results
%% Main function
Glob_Mean=mean(DataIn,1); % array of means of data dims
Glob_Scalar=sum(sum((DataIn.*DataIn),2),1)/size(DataIn,1); % array of scalar products of data dims
Glob_Density=1./(1+(pdist2(DataIn,Glob_Mean,'euclidean').^2)+Glob_Scalar-(sum(Glob_Mean.^2))); % calculate global densities
[~, MaxIdx]=max(Glob_Density); % find index of max densest point

%% Estimate Initial Radii
for idx2=1:size(DataIn,2)
    Axis_Mean=mean(DataIn(:,idx2));
    Axis_Scalar=sum((DataIn(:,idx2).^2),1) / size(DataIn,1);
    Axis_Density(:,idx2)=1./(1+(pdist2(DataIn(:,idx2),Axis_Mean,'euclidean').^2)+Axis_Scalar-(Glob_Mean(1,idx2).^2));
    [Axis_Density, idx1]=sort(Axis_Density,1,'descend'); % sort density in descending order
    AxisMaxDensPt=DataIn(MaxIdx(1),:);
    % apply moving average filter, find where change is greater than mean of change so far
    idx3=abs(diff(smooth(Axis_Density(:,idx2),SpaceRatio))) > mean(abs(diff(smooth(Axis_Density(:,idx2),SpaceRatio))));
    idx3=[idx3;1];
    idx3=find(diff(idx3)==1,1)-1;
    
    InitR(1,idx2)=abs(AxisMaxDensPt(:,idx2)-DataIn(idx1(idx3),idx2));
end
InitR=repmat(min(InitR(InitR~=0)),size(InitR));
%% DDC with Estimated Radii
[Clusters, Results]=DDC_ver01_1(DataIn, InitR, Merge, Verbose);


end

