function pattern_Callback3(~, ~, handles)

global fs s number_of_points;
global vars;
global match_loc;

h = findobj('menubar','figure');
delete(h);
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));

axes(handles.maxes2)
hhh = waitbar(0,'searching');
set(hhh,'position',[500 250 275 50]);

r = str2double(get(handles.rise,'string'))/1000;
d = str2double(get(handles.decay,'string'))/1000;

t = (1/fs):(1/fs):str2double(get(handles.template_size,'string'))/1000;
ftaps = (1-exp(-t/r)).*exp(-t/d);
ftaps = ftaps';
ftaps = -ftaps /max(ftaps);
template_size = length(ftaps);

wsize = round(fs*str2double(get(handles.windowsize,'string'))/1000);
wsize = max (wsize,round(numel(ftaps)/2));
hwsz = round(wsize/2);

tp = -ftaps;
stp = sum(tp);
denom = sum(tp.*tp) - stp*stp/template_size;
std_error = zeros(number_of_points -template_size,1);
detcrit = zeros(number_of_points -template_size,1);
scl = zeros(number_of_points -template_size,1);
stp_div_template_size = stp/template_size;

tic;
for   k =   template_size:(number_of_points -template_size)
   
    ss = s(k:k+template_size-1);
    sum_of_ss = sum(ss);
    scl(k) = (sum(tp.*ss) - stp_div_template_size*sum_of_ss) / denom;
    ofs = (sum_of_ss - scl(k)*stp)/template_size;
    ftp = scl(k)*tp + ofs;
    df = ss - ftp;
    std_error(k)  = sqrt(sum(df.*df)/(template_size-1));
    detcrit(k) = scl(k)/std_error(k);

%   drawnow   % check button push
    if mod(k,20000) == 0
        waitbar(k/number_of_points ,hhh);
    end
    k = k + 1;
end

delete(hhh);
toc 

% limit how close the events can be 
min_peak_disp = fs*vars.min_peak_dist/1000;  % 2 ms

if contains(get(handles.plusminus,'string'),'-') 
    % negative events
     [a b] = peakseek(-detcrit,min_peak_disp,vars.detcrit);
    [m,n] = find(scl(a) < -vars.mingain);
else
    % positive events
     [a b] = peakseek(detcrit,min_peak_disp,vars.detcrit);
    [m,n] = find(scl(a)  > vars.mingain);
end

% indeces of the peaks that exceed mingain
mindex = a(m);

nn = round(fs*vars.peakw/1000);
match_loc = mindex;
match_count = numel(match_loc);

fprintf('%d  initial matches found \n',match_count);
set(handles.matches_found,'string',[ 'Matches Found   '  num2str(match_count)]);
rej = [];
rt = zeros(match_count,1);

% DECRIT VS NUMBER_OF POINTS
for i = 1:numel(mindex)
    rt(i) = detcrit(mindex(i))/((detcrit(mindex(i)-nn) + detcrit(mindex(i)+nn))/2);
    if rt(i) < vars.drop
        rej = [rej i];
    end
end

fprintf('%d  matches rejected \n',numel(rej));
set(handles.matches_rejected,'string',[ 'Matches Rejected   '  num2str(numel(rej))]);
set(handles.go,'string','Process','backgroundColor',[0.9412 0.9412 0.9412]);
set(handles.pattern_text,'string','MiniAnalysis','foregroundcolor',[0 0 0]);

if get(handles.plt,'value')

    hplt = waitbar(0,'Processing Plots');
    set(hplt,'position',[500 250 275 50]);
    
    if contains(get(handles.plusminus,'string'),'-')
        decritline = -10*vars.detcrit ;
    else
        decritline = 10*vars.detcrit ;
    end

    figure(75)
    set(gcf,'position',[200 300 1500 600],'numbertitle','off');
    t = 0:(1/fs):(number_of_points  -1)/fs;
    ax1= subplot(2,1,1);
    plot(t,s);
    hold on;
    plot(t(match_loc),s(match_loc),'r.','markersize',18);
    plot(t(match_loc(rej)),s(match_loc(rej)),'k.','markersize',28);
    grid;
    hold off
    ax2 = subplot(2,1,2);
    plot(t(match_loc),10*rt,'g*');
    hold on
    plot(t(match_loc(rej)),10*rt(rej),'k*');
    t = 0:(1/fs):(numel(detcrit) -1)/fs;
    plot(t,10*detcrit,'r');
    line('xdata',[t(1) t(end)],'ydata',[decritline decritline]);
    t = 0:(1/fs):(numel(scl) -1)/fs;
    plot(t,scl,'k');
    hold off
    title('Detection Criteria');
    grid;
    linkaxes([ax1,ax2],'x');    
    xlim([t(1) t(end)]);
end

% get rid of rejects
match_loc(rej) = [];
match_count = numel(match_loc);

idx = 1;
stmp = zeros(wsize,match_count);

for i = 1:match_count
  k = match_loc(i)-hwsz+1;
  l = match_loc(i)+hwsz;
  if k >0 && l < number_of_points
      stmp(:,idx) =   s(k:l) ;
      idx = idx + 1;
  end
end 
 
t = 0:(1/fs):(wsize-1)/fs;
l = hwsz;
n  =  round(vars.baseline_duration*fs/1000);
k = l - n + 1;

[r,c] = size(stmp);
for i = 1:c
    ofs = sum(stmp(k:l,i))/n;
    stmp(:,i) = stmp(:,i) - ofs;
end

if get(handles.plt,'value')
    figure(11)
    set(gcf,'position',[450 400 1100 400],'numbertitle','off');
    plot(t,stmp);
    grid;
     xlim([t(1) t(end)]);
    title('all detected matches');
    figure(75)
    delete(hplt);
end

duration = number_of_points /fs;
freq = numel(match_loc)/duration;
match_locations = match_loc/fs;
match_signals = stmp;

fn = get(handles.outfilename,'string');
dr = get(handles.odir,'string');

fprintf('%d  matches found \n',numel(match_loc));

if ~isempty(fn)
   save([dr fn,'.mat'],'fs','duration','freq','match_locations','match_signals','vars');
end
