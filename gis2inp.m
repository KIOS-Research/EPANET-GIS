function varargout = gis2inp(varargin)
% GIS2INP MATLAB code for gis2inp.fig
%      GIS2INP, by itself, creates a new GIS2INP or raises the existing
%      singleton*.
%
%      H = GIS2INP returns the handle to a new GIS2INP or the handle to
%      the existing singleton*.
%
%      GIS2INP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIS2INP.M with the given input arguments.
%
%      GIS2INP('Property','Value',...) creates a new GIS2INP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gis2inp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gis2inp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gis2inp

% Last Modified by GUIDE v2.5 09-Dec-2016 17:24:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gis2inp_OpeningFcn, ...
                   'gui_OutputFcn',  @gis2inp_OutputFcn, ...
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


% --- Executes just before gis2inp is made visible.
function gis2inp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gis2inp (see VARARGIN)

% Choose default command line output for gis2inp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gis2inp wait for user response (see UIRESUME)
% uiwait(handles.figure1);
addpath(genpath(pwd));

set(handles.pushbutton1,'string','Export INP');
set(handles.popupmenu1,'string','Folder name in current folder.');
% set(handles.popupmenu1,'enable','off');
set(handles.edit2,'string','');
set(handles.edit2,'enable','off');
% set(handles.pushbutton1,'enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = gis2inp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

foldername = get(handles.popupmenu1,'String');
set(handles.edit2,'enable','on');

% try
%     d=epanet(getPathInpname,'bin','LoadFile');
% catch e
%     set(handles.edit2,'String','Wrong path of folder. Select new folder with GIS files.');
%     return;
% end
    
set(handles.edit2,'String','Wait a moment...')
pause(.01);
[~,f]=fileparts(foldername);
inpname = [f,'_gis2inp.inp'];

try
gis2inp_main(inpname,f);
catch e
    set(handles.edit2,'String','Invalid folder. Select new folder with GIS files.');
    return;
end
set(handles.edit2,'String','Operation complete.')

winopen(inpname)
% --- Executes on button press in text2.
function text2_Callback(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu1,'string','Folder name in current folder.');
% set(handles.popupmenu1,'enable','off');
set(handles.edit2,'string','');
set(handles.edit2,'enable','off');
% set(handles.pushbutton1,'enable','off');

[foldername] = uigetdir(pwd);
if length(foldername)~=1
    set(handles.popupmenu1,'enable','on');
    set(handles.edit2,'enable','off');
    set(handles.pushbutton1,'enable','on'); 
    set(handles.popupmenu1,'String',foldername);
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
