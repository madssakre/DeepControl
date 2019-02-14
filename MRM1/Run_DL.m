% Script used to train networks to predict multi-dimensional RF pulses for MRI
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
%
%
%  PLEASE NOTE: The training and validation inputs and targets loaded below
%  are designed for this demonstration... to enable the user to see
%  the script running. It is not expected, due to the limited size, that
%  the network will converge to a state-of-the-art network. The user will have to
%  increase the library by own hand, and the data provided is only to show
%  one possible construction.
%
%  The authors take no responsibilities for the use of this software
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





% load training and validation subsets
%
% Ntrain: number of training cases, e.g. 60% of library size
% Nvalidate: number of validate cases, e.g. 20% of library size
% Ntest: number of testing cases. e.g. 20% of library size
%
% testing is not done in this script.

load('Example_library.mat'); 

% 64x64x1xNtrain
% 1278x1xNtrain
% 64x64x1xNvalidate
% 1278xNvalidate


% design the neural network skeleton
Layers = [ ...
    imageInputLayer([64 64 1])
    fullyConnectedLayer(4096)
    reluLayer
    fullyConnectedLayer(3000)
    reluLayer
    fullyConnectedLayer(1278)
    regressionLayer];



% define options
options = trainingOptions(...
    'sgdm','InitialLearnRate',0.003, ...
    'MaxEpochs',1000,...
    'L2Regularization',1.0e-3,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',30,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',{validateInput,validateTarget},...
    'ValidationPatience',Inf );


% start training with validation
[net,netinfo] = trainNetwork(trainInput,trainTarget,Layers,options);


% save the net
save('net.mat','net')

% move to Test_DL.m




