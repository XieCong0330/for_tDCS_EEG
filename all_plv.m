for i = 1:1600
    if trial_rat(i,3)>15000
        trial_rat(i,2) = 3;
    end
end
pband = zeros(26,26);
for i = 1:size(reje_all,1)
    if reje_all(i,1)<=10
        if length(reje_trial{i,1})==20
            trial = trial_rat(find(trial_rat(:,1)==reje_all(i,2)),:);
            trial(find(reje_trial{i,1}==1),:) = [];
            for k = 1:20
                if isempty(find(trial(:,4)==k))==0
                    rat(i,k) = trial(find(trial(:,4)==k),2);
                    eeg = all_data{i,1};
                    eeg1 = squeeze(eeg(:,:,find(trial(:,4)==k)))';
                    if trial(find(trial(:,4)==k),3)<15000
                        if trial(find(trial(:,4)==k),3)>2000
                        eeg1 = eeg1([trial(find(trial(:,4)==k),3)-1999:trial(find(trial(:,4)==k),3)],:);
                        else
                            eeg1 = eeg1(1:trial(find(trial(:,4)==k),3),:);
                        end
                    else
                        eeg1 = eeg1(14001:16000,:);
                    end
                    pband(:,:,i,k) = calc_plv(eeg1,13,30,1000,[1,length(eeg1)]);
                else
                    pband(:,:,i,k)=0;
                    rat(i,k) = 0;
                end
            end
        end
    else
        rat(i,1:20) = 0;
    end
end
