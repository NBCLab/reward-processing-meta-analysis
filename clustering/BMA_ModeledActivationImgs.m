function ExpImg = BMA_ModeledActivationImgs(theexps)

EDsub = 11.6; %Based on Eickhoffs 2009 paper
EDtemp = 5.7; %Based on Eickhoffs 2009 paper
sigmasub = EDsub/(2*sqrt(2/pi));
sigmatemp = EDtemp/(2*sqrt(2/pi));
clear EDsub EDtemp
FWHMsub = sigmasub*sqrt(8*log(2));
FWHMtemp = sigmatemp*sqrt(8*log(2));
clear sigmatemp sigmasub
testmat = 80*96*70;
[i,j,k] = ind2sub([80 96 70], 1:testmat);
clear testmat
i = i-0.5;
j = j-0.5;
k = k-0.5;
firsttemp = load_nii('Tal_2x2x2_mask.nii.gz');
thelocs = find(firsttemp.img);
clear firsttemp 

for a = 1:numel(theexps)
    %ExpImg(a).BrainMap_ID = theexps(a).Citation.BrainMap_ID;
    %ExpImg(a).Experiment_ID = theexps(a).Citation.Experiment_ID;
    %ExpImg(a).Subjects = theexps(a).Subject_Total;
    %ExpImg(a).Brain_Template = theexps(a).Experiments.Brain_Template;
    tempmatrix = theexps(a).XYZ_Tal;
    FWHMsubeff = FWHMsub/sqrt(double(theexps(a).Subject_Total));
    FWHM = sqrt((FWHMtemp^2)+(FWHMsubeff^2));
    %Just a standard FWHM, not based on between template and between
    %subject variances
    %FWHM = 12;
    sigma = FWHM/(2*sqrt(2*log(2)));
    denomout = 1/(((2*pi)^1.5)*(sigma^3));
    denomin = 1/(2*(sigma^2));
    newp = zeros(80,96,70,size(tempmatrix,1));
    for b = 1:size(tempmatrix,1);
        xdif = (2*(i-tempmatrix(b,1))).^2;
        ydif = (2*(j-tempmatrix(b,2))).^2;
        zdif = (2*(k-tempmatrix(b,3))).^2;
        xyzsum = xdif+ydif+zdif;
        theexpon = denomin*(-1)*xyzsum;
        p = 8*denomout*exp(theexpon);
        p(find(p<0.00001)) = 0;
        clear xdif ydif zdif xyzsum theexpon
        newp(:,:,:,b) = reshape(p, [80 96 70]);
        clear p c
    end
    clear sigma FWHM FWHMsubeff

%   Corresponds to the old method of finding union of probabilities     
%     newp = 1 - newp;
%     finalnewp = 1-prod(newp, 4);

    finalnewp = max(newp,[],4);
    clear tempmatrix
    newfinalnewp = zeros(size(finalnewp,1), size(finalnewp,2), size(finalnewp,3));
    newfinalnewp(thelocs) = finalnewp(thelocs);
    
    ExpImg(a).ModActs = newfinalnewp;
end

clear thelocs i j k FWHMsub FWHMtemp

end