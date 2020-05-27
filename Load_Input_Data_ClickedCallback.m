% --------------------------------------------------------------------
function Load_Input_Data_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FileName; global Fname;
global fs;
global result_filename;
global vars;
global matfile_loaded;
global s number_of_points;

[FileName,PathName,FilterIndex]  = uigetfile({'*.h5'},'Input data file',vars.LoadPath);
if (PathName ~= 0)
    vars.LoadPath = PathName;
else
     return;
end

set(handles.figure1,'Name',strcat(PathName,FileName));
 
if FileName ==0
     return;
end
h = waitbar(.5,'Loading data file ...','position',[400 100 300 50]);
    
% load h5 file
matfile_loaded = strcat(PathName,FileName);
loadfile_hd5_total(matfile_loaded,handles);
       
[r ,c ] = size(s);

%      baseline from 57 to 58
t1= 57;  t2 = 58;
 
k = round(t1*fs);
l = round(t2*fs);
 idx = 1;
 
 for i = 1:c
     s1 = s(:,i);
     bs = sum(s1(k:l))/(l-k+1);
     mn = min(s1(k:end));
     
%      if theshold exceeded then include section
     if (bs - mn) > vars.spthr
         stemp{idx} = s1(1:k);
         idx = idx + 1;
    end
 end

stemp = cell2mat(stemp);
[r c ] = size(stemp);

% into one array
s = reshape(stemp,r*c,1);
number_of_points = length(s);

Fname = FileName(1:end-4);
drname = strcat('results/',Fname);

if exist(drname','dir') ~= 7
     mkdir(drname);
end
result_filename = strcat('./results/',Fname,'/',Fname,'_results','.txt');

fprintf(' original sampling rate = %5.1f \n',fs);
set(handles.duration_text,'string',['Duration '  num2str(length(s)/fs) ' s ']);  

Disp_Sig(handles);
dragzoom(handles.maxes2);
drawnow;

waitbar(1,h,'Complete');
close(h);
