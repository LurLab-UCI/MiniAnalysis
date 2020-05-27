function varargout = MiniAnalysis(varargin)
% MINIANALYSIS MATLAB code for MiniAnalysis.fig
%      MINIANALYSIS, by itself, creates a new MINIANALYSIS or raises the existing
%      singleton*.
%
%      H = MINIANALYSIS returns the handle to a new MINIANALYSIS or the handle to
%      the existing singleton*.
%
%      MINIANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINIANALYSIS.M with the given input arguments.
%
%      MINIANALYSIS('Property','Value',...) creates a new MINIANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MiniAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MiniAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MiniAnalysis

% Last Modified by GUIDE v2.5 11-Dec-2019 14:08:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MiniAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @MiniAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MiniAnalysis is made visible.
function MiniAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MiniAnalysis (see VARARGIN)

% Choose default command line output for MiniAnalysis
global vars cursor_status;
cursor_status = 0;
try
    load settings.mat;
catch
        vars.windowsize = 50;
        vars.detcrit = 5;
        vars.drop = 1.4;
        vars.peakw = 1;
        vars.template_size = 8;
        vars.rise = 2;
        vars.decay = 4;
        vars.mingain = 10;
        vars.spthr = 500;
        vars.odir = 'c:\matlab_code';
        vars.LoadPath = pwd;
        vars.baseline_duration = 5;
        vars.min_peak_dist = 2;
end

% ps =  get(hObject,'position');
% set(hObject,'position' ,[vars.xloc vars.yloc ps(3) ps(4)]);

handles.output = hObject;

update(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MiniAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MiniAnalysis_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function windowsize_Callback(hObject, eventdata, handles)
% hObject    handle to windowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowsize as text
%        str2double(get(hObject,'String')) returns contents of windowsize as a double
global vars;
vars.windowsize = str2double(get(handles.windowsize,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function windowsize_CreateFcn(hObject, ~, ~)
% hObject    handle to windowsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vars;
global fid; global result_filename;global seach_active;

% if seach_active == 1
%     seach_active =0;
%     set(handles.go,'string','minianalysis','backgroundColor',[0.9412 0.9412 0.9412]);
%     return;
% end
seach_active =1;

set(handles.pattern_text,'string','Searching Events','foregroundcolor',[1 0 0]);%,'backgroundcolor',[0 0 0]);
drawnow
% fid = procstart('MiniAnalysis',result_filename,vars.MiniAnalysis);

% pattern_Callback1(hObject, eventdata, handles);
pattern_Callback3(hObject, eventdata, handles);

% fclose(fid);
% delete(handles.figure1);
save('settings.mat','vars');

% ========================================
function update(~, ~, handles)

global vars;

set(handles.windowsize,'string',num2str(vars.windowsize,'%3.1f'));
set(handles.mingain,'string',num2str(vars.mingain,'%2.1f'));
set(handles.detcrit,'string',num2str(vars.detcrit,'%2.1f'));
set(handles.drop,'string',num2str(vars.drop,'%2.1f'));
set(handles.peakw,'string',num2str(vars.peakw,'%2.1f'));
set(handles.template_size,'string',num2str(vars.template_size,'%2.1f'));
set(handles.rise,'string',num2str(vars.rise,'%2.1f'));
set(handles.decay,'string',num2str(vars.decay,'%2.1f'));
set(handles.spthr,'string',num2str(vars.spthr,'%2.1f'));
set(handles.odir,'string',vars.odir);
set(handles.min_peak_dist,'string',num2str(vars.min_peak_dist,'%2.1f'));
set(handles.baseline_duration,'string',num2str(vars.baseline_duration,'%2.1f'));

save('settings.mat','vars');
    
    
function outfilename_Callback(hObject, eventdata, handles)
% hObject    handle to outfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outfilename as text
%        str2double(get(hObject,'String')) returns contents of outfilename as a double


% --- Executes during object creation, after setting all properties.
function outfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mingain_Callback(hObject, eventdata, handles)
% hObject    handle to mingain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mingain as text
%        str2double(get(hObject,'String')) returns contents of mingain as a double
global vars;
vars.mingain = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function mingain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mingain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rise_Callback(hObject, eventdata, handles)
% hObject    handle to rise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rise as text
%        str2double(get(hObject,'String')) returns contents of rise as a double
global vars;
vars.rise = str2double(get(hObject,'string'));

% --- Executes during object creation, after setting all properties.
function rise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function decay_Callback(hObject, eventdata, handles)
% hObject    handle to decay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decay as text
%        str2double(get(hObject,'String')) returns contents of decay as a double
global vars;
vars.decay = str2double(get(hObject,'string'));


% --- Executes during object creation, after setting all properties.
function decay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function template_size_Callback(hObject, eventdata, handles)
% hObject    handle to template_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of template_size as text
%        str2double(get(hObject,'String')) returns contents of template_size as a double
global vars;
vars.template_size = str2double(get(hObject,'string'));


% --- Executes during object creation, after setting all properties.
function template_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to template_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in tplate.
function tplate_Callback(hObject, eventdata, handles)
% hObject    handle to tplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sg; global fs;global s ;  
global seach_active;
global sdisplay;global mainhandles;
global vars;
global spoint;
global ttaps;
global ffi;
seach_active = 1;
if 0%get(handles.savematches,'value') == 1
%     fo = fopen(strcat(result_filename(1:end-4),'_matches','.txt'),'w');
    fo = fopen(strcat(get(handles.outfilename,'string'),'.txt'),'w');
end

t = 0:(1/fs):(length(s)-1)/fs;
%     ftemplate = get(handles.tfilename,'string');
% s=[];

h = findobj('menubar','figure');
delete(h);
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'));

axes(handles.maxes2);
if 1%get(handles.template,'value') == 0
    val = dualcursor;
val = dualcursor;
if isempty(val)
    h = warndlg('define cursors first');
    pause(1.5)
    delete(h)
    return;
end
    
    % dualcursor off
    k = max(1,round(val(1)*fs));
    l = min(length(s),round(val(3)*fs));
%     ftaps = sg.raw(k:l,1);
    if mod((l-k),2) == 1
        l = l - 1;   % make sure template even number
    end
    ftaps = s(k:l-1,1);
    
    if strfind(get(handles.plusminus,'string'),'+')
        ftaps = - ftaps;
    end
    
    if 0% ~isempty(ftemplate)
        save ([ftemplate '.mat'] ,'ftaps');
    end
else
    
 [FileName,PathName,FilterIndex]  = uigetfile({'*.mat'},'Input data file',vars.LoadPath_pattern);
 if FileName == 0
     return;
 else
    vars.LoadPath_pattern = PathName;
 end
    load(strcat(PathName,FileName));
end

plot(handles.tpaxes1,ftaps);

ff = ones(16,1)/16;
ffi = filtfilt(ff,1,double(ftaps));

df = diff(ffi);

d = zeros(numel(df),1);
d(df<0) = 1;

%    figure(10)
%    plot(d);
%    ylim([0 2]);

q = diff(d);
u = find(q==1);
d = find(q == -1);
if d(1) < u(1)
    d = d(2:end);
end
jj = min(numel(u),numel(d));

for i = 1:jj
%     if d(i) - u(i) > 20
            a = ffi(u(i));
            b = ffi(d(i));
        if ((ffi(u(i)) - ffi(d(i))) > 5)
            break
        end
        
%     end0
    
end
ofs = sum(ftaps(1:u(i)))/u(i);
ftaps = ftaps - ofs;

ofsf = sum(ffi(1:u(i)))/u(i);
ffi = ffi - ofsf;
g = -1/min(ffi);

ftaps = g*ftaps;
ffi = g*ffi;
spoint = u(i)+7;

t = 0:(1/fs):(numel(ftaps)-1)/fs;

axes(handles.tpaxes1);
plot(t,ftaps);
hold on
plot(t,ffi,'r','linewidth',2);
line('xdata',[t(spoint) t(spoint)],'ydata',[-1.2 0.5],'color','k','linewidth',2,'linestyle','--');
hold off
grid;
ylim([-1.2 0.5]);

% if strfind(get(handles.plusminus,'string'),'-')
     ttaps = ftaps;
% else
%     ttaps = -ftaps;
% end




% --- Executes on button press in clearall.
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tindex tparray spoint_arr;

tindex =1;
tparray  = [];
spoint_arr = [];
set(handles.ntps,'string','0');


% --- Executes on button press in addtp.
function addtp_Callback(hObject, eventdata, handles)
% hObject    handle to addtp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tindex tparray ttaps fs spoint_arr spoint;
global savg;

tparray{tindex} = ttaps;
spoint_arr(tindex) = spoint;
tindex = tindex + 1;

[a,b] = size(tparray);
axes(handles.tpaxes1);
hold off


for j = 1:b
    
     stemp = cell2mat(tparray(j));
     s{j} = stemp(spoint_arr(j):end);
     n(j) = numel(s{j});
     t = 0:(1/fs):(numel(s{j})-1)/fs;
    plot(t,s{j});
    xlim([0 t(end)]);
    if ~ishold
        hold on;
    end
end

nn = min(n);


savg = s{1}(1:nn);
for j = 2:b
    savg = savg + s{j}(1:nn);
end
savg = savg/b;

t = 0:(1/fs):(numel(savg)-1)/fs;
plot(t,savg,'k','linewidth',1.5);
grid
hold off

set(handles.ntps,'string',num2str(tindex-1));

% --- Executes on button press in risefall.
function risefall_Callback(hObject, eventdata, handles)
% hObject    handle to risefall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs savg vars;
dur = numel(savg)/fs;
t = 0:(1/fs):(dur-1/fs);
t = 1000*t;
rix = 1;
rstart = 1;
rinc = 0.1;
dstart = 1;
dinc = 0.1;
dfs = [];

for rise = rstart:rinc:10
    dix = 1;
    for decay = dstart:dinc:10
        tp = (1-exp(-t/rise)).*exp(-t/decay);
        tp = tp';
        tp = tp/max(tp);
        df  = sum(-savg-tp);
        dfs(rix,dix) = df.*df;
        dix = dix + 1;
    end
    rix = rix + 1;
end

vv = min(min(dfs));
[x,y] = find(dfs == vv);

r = rstart + (x-1)*rinc;
d = dstart + (y-1)*dinc;

set(handles.rise,'string',num2str(r));
set(handles.decay,'string',num2str(d));
vars.rise = r;
vars.decay = d;


% --- Executes on button press in spt.
function spt_Callback(hObject, eventdata, handles)
% hObject    handle to spt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spoint  ttaps fs ffi;

spoint = spoint - 1;
t = 0:(1/fs):(numel(ttaps)-1)/fs;
axes(handles.tpaxes1);
plot(t,ttaps);
hold on
plot(t,ffi,'r','linewidth',2);
line('xdata',[t(spoint) t(spoint)],'ydata',[-1.2 0.5],'color','k','linewidth',2,'linestyle','--');
hold off
grid;
ylim([-1.2 0.5]);
xlim([t(1) t(end)]);
 

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over spt.
function spt_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to spt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spoint  ttaps fs ffi;


spoint = spoint + 1;
t = 0:(1/fs):(numel(ttaps)-1)/fs;
axes(handles.tpaxes1);
plot(t,ttaps);
hold on
plot(t,ffi,'r','linewidth',2);
line('xdata',[t(spoint) t(spoint)],'ydata',[-1.2 0.5],'color','k','linewidth',2,'linestyle','--');
hold off
grid;
ylim([-1.2 0.5]);
xlim([t(1) t(end)]);


function detcrit_Callback(hObject, eventdata, handles)
% hObject    handle to detcrit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of detcrit as text
%        str2double(get(hObject,'String')) returns contents of detcrit as a double
global vars;
vars.detcrit = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function detcrit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to detcrit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in crtp.
function crtp_Callback(hObject, eventdata, handles)
% hObject    handle to crtp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs ftaps spoint;

rise = str2double(get(handles.rise,'string'))/1000;
decay = str2double(get(handles.decay,'string'))/1000;
dur =  str2double(get(handles.template_size,'string'))/1000;
t = 0:(1/fs):dur;

tp = (1-exp(-t/rise)).*exp(-t/decay);
tp = tp/max(tp);
ftaps = tp;
t = (1/fs):(1/fs):numel(ftaps)/fs;

axes(handles.tpaxes1);
hold on
plot(t,-ftaps,'k','linewidth',2);
xlim([0 t(end)]);
hold off



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over crtp.
function crtp_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to crtp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fs ftaps spoint;


addtp_Callback(hObject, eventdata, handles);

rise = str2double(get(handles.rise,'string'))/1000;
decay = str2double(get(handles.decay,'string'))/1000;
dur =  str2double(get(handles.template_size,'string'))/1000;
t = 0:(1/fs):dur;

tp = (1-exp(-t/rise)).*exp(-t/decay);
tp = tp/max(tp);

ftaps = tp;

t = (1/fs):(1/fs):numel(ftaps)/fs;

axes(handles.tpaxes1);
hold on
plot(t,-ftaps,'k','linewidth',2);
xlim([0 t(end)]);
hold off


% --- Executes on button press in plusminus.
function plusminus_Callback(hObject, eventdata, handles)
% hObject    handle to plusminus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'string');

if strfind(str,'+')
    set(hObject,'string','-');
else
    set(hObject,'string','+');
end



function drop_Callback(hObject, eventdata, handles)
% hObject    handle to drop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drop as text
%        str2double(get(hObject,'String')) returns contents of drop as a double
global vars;
vars.drop = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function drop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function peakw_Callback(hObject, eventdata, handles)
% hObject    handle to peakw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peakw as text
%        str2double(get(hObject,'String')) returns contents of peakw as a double
global vars;
vars.peakw = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function peakw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plt.
function plt_Callback(hObject, eventdata, handles)
% hObject    handle to plt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plt


% --- Executes on button press in openfile.
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Load_Input_Data_ClickedCallback(hObject, eventdata, handles)


% --- Executes on button press in cursors.
function cursors_Callback(hObject, eventdata, handles)
% hObject    handle to cursors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%  deltalabelpos = [DeltaX_x, DeltaX_y; DeltaY_x, DeltaY_y] in normalized axis units
%  default = [.65 -.08;.9 -.08]  puts them just below the lower right-hand corner.
global cursor_status;
if cursor_status
    dualcursor('off')
    dragzoom(handles.maxes2);
    cursor_status = 0;
else
    dualcursor([],[.79 0.05; .91  0.05]);
    cursor_status = 1;
end

% --- Executes on button press in cursorsoff.
function cursorsoff_Callback(hObject, eventdata, handles)
% hObject    handle to cursorsoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dualcursor('off')
dragzoom(handles.maxes2);


function spthr_Callback(hObject, eventdata, handles)
% hObject    handle to spthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spthr as text
%        str2double(get(hObject,'String')) returns contents of spthr as a double
global vars;
vars.spthr = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function spthr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outdir.
function outdir_Callback(hObject, eventdata, handles)
% hObject    handle to outdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vars;
if isempty(vars.odir)
    vars.odir = pwd;
end
ddir = uigetdir(vars.odir);
vars.odir = [ddir '\'];
set(handles.odir,'string',vars.odir);



function odir_Callback(hObject, eventdata, handles)
% hObject    handle to odir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of odir as text
%        str2double(get(hObject,'String')) returns contents of odir as a double
global vars;
vars.odir = [get(hObject,'string') '\'];
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function odir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 


% --- Executes on button press in entire_trace.
function entire_trace_Callback(hObject, eventdata, handles)
% hObject    handle to entire_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cursor_status;
dualcursor('off')
cursor_status = 0;
Disp_Sig(handles);
dragzoom(handles.maxes2);
drawnow;



function min_peak_dist_Callback(hObject, eventdata, handles)
% hObject    handle to min_peak_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_peak_dist as text
%        str2double(get(hObject,'String')) returns contents of min_peak_dist as a double
global vars;
vars.min_peak_dist = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function min_peak_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_peak_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baseline_duration_Callback(hObject, eventdata, handles)
% hObject    handle to baseline_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baseline_duration as text
%        str2double(get(hObject,'String')) returns contents of baseline_duration as a double
global vars;
vars.baseline_duration = str2double(get(hObject,'string'));
update(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function baseline_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseline_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
