
%EOF analysis!!!
%T=10;
%N=20;
%X_intro=rand(T,N);
%x has X(T,N), N variables, T time points
%meaning, T ROWS and N columns

clear all;
close all;

vb=1; %first column to be used
ve=40; %last column to be used
       %NOTE, this is useful when your data file has multiple sets
       %of eeg data (e.g., 1-40 whole brain, 41-80, left brain, etc.)

N=ve-vb+1; %number of variables
%x has X(T,N), N variables, T time points
%meaning, T ROWS and N columns

%load data
x_foo=load('../data/foo.data');

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

%estmate the EOFs
[eof, fv, eof_all] = eof_unlimited_time_return_all_EOFs(x, N, T, number_of_measurements_per_block);



%%%%%%%%%%%% EOF figures
for(j=1:N)
    eof(:,:)=eof_all(:,(N+1-j),:);
    
    %eof1(:,j)=em(:,N);
    %eof_all(:,:,j)=em;
    
    eof_only_whole_fig=figure(j);
    %let's do a few calculations first
    for(i=1:number_of_blocks)
        index_of_max(i)=ind2sub(size(eof(:,i)), find(abs(eof(:,i))==max(abs(eof(:,i)))));
    end;
    
    %xloc=linspace(1, number_of_blocks*5, number_of_blocks);
    xloc=linspace(1, number_of_blocks*minutes_per_block, ...
                  number_of_blocks);
    %xloc=xloc/2;
    yloc=linspace(1, N, N);
    imagesc(xloc, yloc, abs(eof));
    set(gca, 'ytick', 5:5:40);
    set(gca, 'yticklabel', (40:-5:5)/2);
    colormap(flipud(colormap('hot')));
    %pcolor(xloc, yloc, eof1);
    xlabel('time');
    ylabel('frequency bin');
    hold all;
    index_plot=plot(xloc, index_of_max);
    set(index_plot,'Color','black','LineWidth',3);
    saveas(eof_only_whole_fig, ['eof.', num2str(j), '.jpg'], 'jpg');
    clear eof_only_whole_fig;
end;

%%%%% FRACTIONAL VARIANCE FIGURES!!!!!
fv_fig=figure;
colors = distinguishable_colors(N);
image(reshape(colors,[1 size(colors)]));
scrsz = get(0,'ScreenSize');
%set(fig, 'Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)]);
set(gcf,'PaperPositionMode','manual');
set(gcf, 'PaperUnits', 'inches');
%[left bottom width height]
set(gcf, 'PaperPosition', [-2 0 20 15]);
for(i=1:N)
    plot(fv((N+1)-i,:))
    hold all;
end;
eof_label=linspace(1, 40, 40);
legend(num2str(eof_label(:)), 'Location', 'EastOutside');
saveas(fv_fig, 'fv_fig.jpg', 'jpg');

fv_log_fig=figure;
colors = distinguishable_colors(N);
image(reshape(colors,[1 size(colors)]));
scrsz = get(0,'ScreenSize');
%set(fig, 'Position',[1 scrsz(4)/2 scrsz(3) scrsz(4)]);
set(gcf,'PaperPositionMode','manual');
set(gcf, 'PaperUnits', 'inches');
%[left bottom width height]
set(gcf, 'PaperPosition', [-2 0 20 15]);
for(i=1:N)
    semilogy(fv((N+1)-i,:))
    hold all;
end;
legend(num2str(eof_label(:)), 'Location', 'EastOutside');
saveas(fv_log_fig, 'fv_log_fig.jpg', 'jpg');

%stuff to dump out:
eof_seizure_data(:,1)=index_of_max.';
dlmwrite('eof_seizure_whole.data', eof_seizure_data, 'delimiter', '\t');





