function ComputeProposals(parsedVOCDir, proposalsDir, configFile, evaluationParams)

  if(exist(proposalsDir, 'dir') ~= 0)
    disp(['The proposals dir: ' proposalsDir ' already exists. Press any key to use it (or delete it to parse it again)...']);
    pause;
    return;
  end
  
  f = dir(parsedVOCDir);
  f = f(3 : end);
  nImages = (numel(f) - 2) / 2; %Two additional files removed
  assert(nImages == round(nImages));
  mkdir(proposalsDir);
  
  configParams = LoadConfigFile(configFile);
  configParams.approxFinalNBoxes = 100000; %To increase number of unique windows and get the final part of the curve.
  configParams.evaluationParams = evaluationParams;
  
  imgs = {};
  gts = {};
  for k = 1 : nImages
    I = load([parsedVOCDir '/rgb_' num2str(k) '.mat']);
    imgs{end + 1} = I.iData.RGB;
    gt = load([parsedVOCDir '/gt_' num2str(k) '.mat']);
    gts{end + 1} = gt.gt;
  end
  
  addpath('~');
  addpath(genpath('/scratch/smanenfr/code_in_scratch/sm_toolbox/matlab/mg/matlabtools/'));
  sm_par_config();
  nWorkers = 100;
  home = pwd;
  assert(strcmp(home(1 : 12), '/scratch_net') ~= 0);
  outs = par_map('c', @RPandEval, {configParams}, {imgs, gts}, struct('memory', 5e9, 'time', 3599, 'workers', nWorkers));%, 'engine', 'local')); 
    
  for k = 1 : nImages
    results = outs{k};
    save([proposalsDir '/res_' num2str(k) '.mat'], 'results');
  end 
end

function out = RPandEval(configParams, I, gt)
  out.proposals = RP(I, configParams);
  
  gt.gt.boxes = gt.boxes;
  
  out.drs = ComputeDR(out.proposals, gt, configParams.evaluationParams);
  out.ious = configParams.evaluationParams.ious;
  out.nWindows = configParams.evaluationParams.nWindows;
end





















