% Script used to test a neural network for multi-dimensional RF pulse
% prediction
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
%  PLEASE NOTE: This script test the neural network. The network
%  specifications need to be as described in Run_DL.m
%  For useful results the net should be be trained as devised in the paper
%  mentioned above and using a script similar to Run_DL.m (where the library
%  has been made sufficiently large etc.)
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




% load training and validation subsets
%
% Ntrain: number of training cases, e.g. 60% of library size
% Nvalidate: number of validate cases, e.g. 20% of library size
% Ntest: number of testing cases. e.g. 20% of library size
%
% training and validation is not used in this script.

load('Example_library.mat');

% 64x64x1xNtest
% 1278x1xNtest


% load the net, that was made with Run_DL.m. Even a bad net will produce
% "some" result.

load('net.mat')

% Find a testcase, either from the test subset

PickANumber = 1; % 1 <= PickANumber  <= Ntest

TestInput = testInput(:,:,:,PickANumber);

% or from a completely different place, but not the validation or training
% set.

% By drawing from the test subset, you also have the targets (TM-calculated
% pulses to compare with). From this point on we assume this is what you are
% doing. And we also assume you have trained your net upon the
% Example_spc.mat and Example_khr.mat data, such that the spatial and
% temporal parameters are the same and the simulation below will be meaningful

TM_Calculated_Pulse = testTarget(PickANumber,:);

% Now predict
DL_Predicted_Pulse = double(predict(net,TestInput));

N = 639;

% transfer predicted pulse back to physical units [rad/s]
u_DL_Predicted_Pulse = DL_Predicted_Pulse(1:N).*SC_Target;
v_DL_Predicted_Pulse = DL_Predicted_Pulse(N+1:end).*SC_Target;

% transfer target pulse back to physical units [rad/s]
u_TM_Calculated_Pulse = TM_Calculated_Pulse(1:N).*SC_Target;
v_TM_Calculated_Pulse = TM_Calculated_Pulse(N+1:end).*SC_Target;

% for simulation of both in one go, put both pulses into array
u_ = cat(3,u_TM_Calculated_Pulse,u_DL_Predicted_Pulse);
v_ = cat(3,v_TM_Calculated_Pulse,v_DL_Predicted_Pulse);
% use slider to shift between the two. moving the slider to the left will
% show the TM-calculated pulse.


% load spc
load('Example_spc.mat');

% load khr
load('Example_khr.mat');



% do simulation
sim = blOCh__sim([],spc,khr,[],'u',u_,'v',v_,'Show',1,'sim_k','all');

% Please note

% For the simulation it doesn't matter what the desired magnetization
% included in 'spc' is. blOCh__sim() can show what it is, but it has no
% effect on the simulation. Hence, the desired magnetization in 'Example_spc.mat'
% is in fact not the same as in the 'Example_library.mat' you are drawing
% from in this example script.
% To see the desired magnetization the net has predicted a pulse for,
% simply plot it here.

figure
colormap jet
imagesc(TestInput)
axis xy square off
