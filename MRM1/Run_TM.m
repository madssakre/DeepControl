% Script used to calculate multi-dimensional RF pulses for MRI
%
% as descibed in
%
% Ultra-fast (milliseconds), multi-dimensional RF pulse design with deep learning
%
% Mads Sloth Vinding 1, Birk Skyum 2, Ryan Sangill 1, Torben Ellegaard Lund 1
%
% 1: Center of Functionally Integrative Neuroscience, Aarhus University, Denmark
% 2: Interdisciplinary Nanoscience Center, Aarhus University, Denmark
%
% Correspondence:
% Mads Sloth Vinding,
% Center of Functionally Integrative Neuroscience,
% Aarhus University,
% Nørrebrogade 44, 10G-5-31,
% DK-8000 Aarhus C
% Denmark
% Email: msv<convert to certain symbol>cfin.au.dk
%
%
% 
% arXiv:1811.02273v3
%
%
%
%  PLEASE NOTE: 
%
%  This script is used to produce a target for training with
%  either the LTA or STA method as described in the paper mentioned above.
%
%  In order to produce a target (i.e. 2DRF pulse) using blOCh, the
%  underlying spatial grid must first be formed. Different examples for this is shown.
%  and the gradient waveform
%
%  Then the temporal dependecies ie. the gradient waveform must be
%  designed.
%  Different examples for this is shown.
%  For instance, we show how to produce 'a' waveform,
%  very similar to the one described in the paper - the time optimized 
%  variable density trajectory method by Michael Lustig. We have supplied a
%  mat-file with the gradient waveform that was used in the paper, but we
%  do currently not support the wrapper-script used to make it. But it is possible 
%  to get Michael Lustigs scripts and adapt them to produce the same gradient 
%  waveform.
%  
%  Getting vast amounts of targets and including an equal number of desired
%  magnetizations by one of the methods below to compute the targets is a
%  task best designed for the given computer setup the user has. We have
%  therefor not supplied a wrapper or a rigid setup such as the one we used
%  ourselves because it may simply not be suitable for your system.
%
%  The authors take no responsibilities for the use of this software
%
%
%     Copyright (C) 2019  Mads Sloth Vinding
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

clc
clear
close all


% SPC = 'Make default';
% SPC = 'Read image and make';
% SPC = 'Load structs and make';
SPC = 'Load Saved';


% KHR = 'Make default';
% KHR = 'Load from external source and make';
KHR = 'Load saved';



% TM = 'LTA';
TM = 'STA';


SIM = 'Yes';
% SIM = 'No';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Make spatial dependecies, e.g. a 64x64 grid, with a 25-cm FOX  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% the spatial dependencies are delivered in 'spc'
%
% FOX
L = 0.25;

% Grid size
R = 64;



switch SPC
    case 'Make default'
        
        % Initial magnetization M(0):
        M0 = ''; % default M(0) = M0
        % Desired magnetization
        Md = ''; % internal default a square.
        TH = [0.1,0.05]; % a square of size 0.1 m x 0.05 m
        Mdflip = [30,0]; % 30 deg flip angle, 0 deg flip phase => points to Mx
        % Maps
        MPS = ''; % default: perfect B1, ideal B0 conditions
        spc = blOCh__spc([],'2DAx',M0,Md,MPS,'pTx',1,'Show',0,'L',[L,L],'R',[R,R],'Mdflip',Mdflip,'TH',TH);
        
    case 'Read image and make'
        
        % Initial magnetization M(0):
        M0 = ''; % default M(0) = M0
        % Desired magnetization
        TH = [0.1,0.05]; % a square of size 0.1 m x 0.05 m
        Mdflip = [30,0]; % 30 deg flip angle, 0 deg flip phase => points to Mx
        % Maps
        MPS = ''; % default: perfect B1, ideal B0 conditions
        spc = blOCh__spc([],'2DAx',M0,'./Example_image.png',MPS,'pTx',1,'Show',0,'L',[L,L],'R',[R,R],'Mdflip',Mdflip);
        
        
    case 'Load structs and make'
        
        % Initial magnetization M(0):
        M0 = ''; % default M(0) = M0
        
        % Desired magnetization
        Md = './Example_desired_magnetization.md';

        % Maps
        MPS = './Example_maps.mps';
        
        spc = blOCh__spc([],'2DAx',M0,Md,MPS,'pTx',1,'Show',1,'L',[L,L],'R',[R,R]);
        
    case 'Load Saved'
        
        % This reflect the spatial dependencies used in the paper mentioned
        % above, for one particular desired magnetization.
        
        load('Example_spc.mat');
        
        
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Make temporal dependencies, i.e. the gradient waveform         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% the temporal dependencies are delivered in 'khr'
%
% The system. In blOCh__khr you can include your own system, and the max
% gradient strength and slewrate are specified this way.
%
Sys = '3T'; % has common gradient amplitude and slewrates, but check with your system. You can specify percentages of allowed strengths and slewrate on the frontend too: 'Gmpct', 'Smpct'
%
% dt
dt = 10e-6; % [s]. dwell time used in trajectory calculation

switch KHR
    case 'Make default'
        
        % This makes a 2D inward spiral. But not the time-optimized version
        % used in the paper mentioned above. You will notice that this
        % trajectory is longer.
        
        Park.Acc = [1,1,1,1]; % Acceleration parameters for trajectory.
        
        Smpct = 90;
        khr= blOCh__khr([],spc,'2Dspii',Park,'Show',1,'Sys',Sys,'dt',dt,'Smpct',Smpct);
        
        
        
    case 'Load from external source and make'
        
        % You can make your own gradient waveform instead of using
        % blOCh__khr.
        % As of now, we suggest you contact us for guidance.
        
    case 'Load saved'
        
        % This reflect the temporal dependencies used in the paper mentioned
        % above, and includes the time-optimized made from Michael Lustig's
        % scripts.
        
        load('Example_khr.mat');
        
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Run target method                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  The output of the target method is delivered in 'opt'. From this one can
%  assign the RF pulse to a variable, e.g. Target which is used for DL
%  training.
%
%  Once enough targets are produced, we advice to scale and normalize all targets by a
%  common scaling factor. It could be 2*pi*1000 (corresponding to 1 kHz),
%  and 2*pi because the output of blOCh__opt below is in [rad/s].
%


switch TM
    
    case 'LTA'
        % Number of iterations
        MaxIter = 10000;
        % Optimization gradient
        Par.Grad= 'Schirmer'; % These are exact gradients, but slow computation. 

        % Parameter specific to the 'blOCh__QN_LBFGS_SAR' method
        Par.Constr.RFpeak.Type = 'bnd';% Boundary type 'bnd' means the hard limit of fmincon()
        % Physical limit value
        Par.Constr.RFpeak.Lim = 1000;
        % Physical limit unit
        Par.Constr.RFpeak.Unit = 'Hz';
        % Coping with this: Ignore, Monitor, or Constr(ain).
        Par.Constr.RFpeak.Cope = 'Constr';
        
        % Parallization
        Ncores = 1; % Number of CPU cores you wish to use.
        
        % What to save. Modify to your needs
        Save = struct('Bundle','none','Data','none','Controls','none','Figures','none','Scripts','none');
        
        % Conduct the optimization
        opt = blOCh__opt([],spc,khr,'blOCh__QN_LBFGS_SAR',Par,'Init','0s','Handover',0,'TolFun',5e-6,...
            'TolX',5e-6,'MaxIter',MaxIter,'par_Ncores',Ncores,'Show',1,'Save',Save);
        
        % get the RF pulse out
        Target = [opt.opt1.uo(1,:,end),opt.opt1.vo(1,:,end)];
        
    case 'STA'
        
        
        
        % What to save. Modify to your needs
        Save = struct('Bundle','none','Data','none','Controls','none','Figures','none','Scripts','none');
        
        % Parameter specific to the 'blOCh__regu' method
        % Tikhonov
        Par.lambda = logspace(-6,10,25); % 
        % Scaling
        Par.ScaleX2Flip = -1; % If you want to make a crude (non-optimized) scaling of your final pulse after optimization, set to a desired FA then.
        
        % Conduct the optimization
        opt = blOCh__opt([],spc,khr,'blOCh__regu',Par,'Init','0s','Handover',0,'TolFun',5e-6,...
            'TolX',5e-6,'Show',1,'Save',Save);
        
        % get the RF pulse out
        Target = [opt.opt1.uo(1,:),opt.opt1.vo(1,:)];
        
        
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Run Bloch simulation                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    If you want to check a given pulse
%
%    The simulation output is delivered to 'sim'.
%    The magnetization is stored in sim.M_t
%    
switch SIM
    
    case 'Yes'
        
        sim = blOCh__sim([],spc,khr,opt);
        
        % a good idea here is to use another spc, say, spc2 which has twice
        % or higher resolution...
        % Even though blOCh__spc is loading *.md and *.mps, by specifying R
        % at the front end will overrule the resolution the md and mps
        % have. So in the above you can set R = X*R achieve X higher
        % resolution that way, e.g.:
        % spc2 = blOCh__spc([],'2DAx',M0,Md,MPS,'pTx',1,'Show',1,'L',[L,L],'R',[R,R]*2);
end

%%
%
%
% repeat the above (without simulation) multiple times to produce a DL training library.
%
% move to Run_DL.m