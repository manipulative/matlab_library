function dev_iscWithinFnirs_shuffle(params, datafiles) %keptVox)
% Calculate ISC within a group of subjects (each subject to average of
% others). Saves results both as nifti and .mat file
%
% ARGUMENTS:
%  - params: struct specifying experiment params with fields -
%         subs: {1x18 cell}
%         crop: [tr1 tr2] % start timepoint and end timepoint
%       method: wtc or pcorr
%         iter: 1000
%
% - iscParams: struct specifying params for running ISC
%      savedir: ''
%         name: 'shapesMovie_smooth4mm2_half1' %name of resulting nifti
%         type: 'within' %type of ISC (within/between)
%
% - datafiles: list of .mat datafiles to run isc over. Each .mat file
%      contains a struct with the following fields:
%           oxyData: [3000*47 double] %timepoints x channels
%
%  - Dependency function:
%           hmrR_BandpassFilt_Nirs -[homer2];
%           phase_rand -[self-bulit]
%
%  - Version 1.0 : only used to pcorr method


fprintf(['\n *** Calculating ISC (' params.type '-group): ' params.name '***\n']);

%% load all data (option:filter)
fprintf('calculating sum of all...\n')

for i = 1:length(datafiles)
    
    % load subdata
    data = load(datafiles{i});
    
    % aggregate data (z-scored)
    if i == 1
        data_all = zscore(data.oxyData,[],1);
    else
        data_all(:,:,i) = zscore(data.oxyData,[],1);
    end
end
% Calc sum of all
sum_all = sum(data_all,3);

%sum_savename = fullfile(iscParams.savedir, [iscParams.name '_sumAll.mat']);
%save(sum_savename, 'sum_all');


%% Do ISC

isc = nan(size(sum_all,2),params.iter);

for k = 1:params.iter
    
    
        fprintf([num2str(k) '-']);
    
    
    corr_data = nan(size(data_all,[2 3]));
    
    
    for i = 1:length(datafiles)
        
        % load subdata
        subj = data_all(:,:,i);
        
        % get avg others
        others = (sum_all - subj) / (length(params.subs)-1);
        
        % crop, phase-randomization and zscore
        subj = zscore(subj(params.crop(1):params.crop(2),:),[],1);
        others = zscore(others(params.crop(1):params.crop(2),:), [],1);
        
        subj = phase_rand(subj,0);
        others = phase_rand(others,0);
        
        for j = 1:size(subj,2)
            if strcmp(params.method,'pcorr')
                corr_data(j,i) = corr(subj(:,j),others(:,j)); % ISC-based
            elseif strcmp(params.method,'wtc')
                wtc_data = wcoherence(subj(:,j)',others(:,j)');
                m_wtc = mean(wtc_data(params.fs_range,:),'all');
                corr_data(j,i) = m_wtc;
            end
        end
    end
    isc(:,k) = nanmean(corr_data,length(size(corr_data)));
    
end

%% Save
% Save ISC data
isc_savename = fullfile(params.savedir, [params.name '_shuffle_ISC.mat']);
save(isc_savename, 'isc', 'params');
fprintf('done! \n');
