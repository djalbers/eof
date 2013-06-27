%EOF analysis!!!

%x has X(T,N), N variables, T time points
%meaning, T ROWS and N columns

clear all;
close all;

vb=1;  %first column to be used
ve=40; %last column to be used
       %NOTE, this is useful when your data file has multiple sets
       %of eeg data (e.g., 1-40 whole brain, 41-80, left brain, etc.)

N=ve-vb+1;  %number of variables
%x has X(T,N), N variables, T time points
%meaning, T ROWS and N columns


%load the data
x_foo=load('../data/foo.data');
clear foo;
%total length of time
[T Tjunk] = size(x_foo);
clear Tjunk;

%%%HOW TO SET THE EOF resolution: the eof resolution is the number
%%%of time points included in a given block of variables over which
%%%the eof is estimated. examples for how to set this are given
%%%below.  currently, we have time resolution of minutes and the
%%%set the eof resolution to be 2 hours, or 120. NOTE, the eof
%%%resolution has to always be equal to at least the number of
%%%variables, N.

%examples of how to set the grid points:
%e1:
%number of "grid points"
% we have 450 measurements over 30 minutes, that means 15
% measurements a minute, SO, let's do this, let's split it into 
% m=15*5=75 measurement bits ... which implies 6 five minute blocks
%e2:
%15 measurements per minute.
%let's do blocks of 5 minutes at a time
% that means blocks of 75 element chunks.
%number_of_blocks=floor(T/75);
%e3:
%we have measurements taken every minute, and we
%usually have something like 40 variables. so, we'd like 40 by 40
%blocks. in A, we have roughly 6015 minutes (4 days) worth of time,
number_of_measurements_per_block=120;
minutes_per_block=number_of_measurements_per_block;
%forty minute blocks: 
%number_of_blocks=floor(T/40);
%twenty minute blocks:
%number_of_blocks=floor(T/20);
%five minute blocks:
%number_of_blocks=floor(T/5);
number_of_blocks=floor(T/number_of_measurements_per_block);

%adjust x to the right size
x=x_foo(:,vb:ve);

[eof1, fv] = eof_unlimited_time(x, N, T, number_of_measurements_per_block);

%%%%%%%%%%%% FIG
eof_only_whole_fig=figure(1);
%let's do a few calculations first
for(i=1:number_of_blocks)
    index_of_max(i)=ind2sub(size(eof1(:,i)), find(abs(eof1(:,i))==max(abs(eof1(:,i)))));
end;

%xloc=linspace(1, number_of_blocks*5, number_of_blocks);
xloc=linspace(1, number_of_blocks*minutes_per_block, ...
              number_of_blocks);
%xloc=xloc/2;
yloc=linspace(1, N, N);
imagesc(xloc, yloc, abs(eof1));
set(gca, 'ytick', 5:5:N);
set(gca, 'yticklabel', (N:-5:5)/2);
colormap(flipud(colormap('hot')));
%pcolor(xloc, yloc, eof1);
xlabel('time');
ylabel('frequency bin');
hold all;
index_plot=plot(xloc, index_of_max);
set(index_plot,'Color','black','LineWidth',3);
%%%%%%%%%FIG 
eof_whole_fig=figure(2);
%let's do a few calculations first
for(i=1:number_of_blocks)
    index_of_max(i)=ind2sub(size(eof1(:,i)), find(abs(eof1(:,i))==max(abs(eof1(:,i)))));
end;

%xloc=linspace(1, number_of_blocks*5, number_of_blocks);
xloc=linspace(1, number_of_blocks*minutes_per_block, number_of_blocks);
yloc=linspace(1, N, N);
subplot(2,1,1);
imagesc(xloc, yloc, abs(eof1));
%pcolor(xloc, yloc, eof1);
xlabel('time');
ylabel('frequency bin');
hold all;
index_plot=plot(xloc, index_of_max);
set(index_plot,'Color','black','LineWidth',3);
title('First EOF');
set(gca, 'ytick', 5:5:N);
%set(gca, 'yticklabel', (5:5:40)/2);
set(gca, 'yticklabel', (N:-5:5)/2);
colormap(flipud(colormap('hot')));

subplot(2,1,2);
imagesc(xloc, yloc, fv);
xlabel('time');
ylabel('frequency bin');
title('Fractional variance represented by EOF1')
set(gca, 'ytick', 5:5:N);
%set(gca, 'yticklabel', (5:5:40)/2);
set(gca, 'yticklabel', (N:-5:5)/2);
colormap(flipud(colormap('hot')));

%stuff to dump out:
eof_seizure_data(:,1)=index_of_max.';
dlmwrite('eof_seizure_whole.data', eof_seizure_data, 'delimiter', '\t');

%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% diagnostics and OUTPUT
%%%%%%%%%%%%%%%%%%%%

saveas(eof_whole_fig, 'eof_whole_fig.jpg');
saveas(eof_only_whole_fig, 'eof_only_whole_fig.jpg');






