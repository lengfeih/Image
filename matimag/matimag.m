% This file is designed to extract blue pixels from the photos.
% The color range definition is critical.
% 
% Author:Lengfei Han
% Date: 09/22/2014


function varargout = matimag(varargin)
% MATIMAG MATLAB code for matimag.fig
%      MATIMAG, by itself, creates a new MATIMAG or raises the existing
%      singleton*.
%
%      H = MATIMAG returns the handle to a new MATIMAG or the handle to
%      the existing singleton*.
%
%      MATIMAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATIMAG.M with the given input arguments.
%
%      MATIMAG('Property','Value',...) creates a new MATIMAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matimag_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matimag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matimag

% Last Modified by GUIDE v2.5 23-Sep-2014 11:39:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matimag_OpeningFcn, ...
                   'gui_OutputFcn',  @matimag_OutputFcn, ...
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


% --- Executes just before matimag is made visible.
function matimag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matimag (see VARARGIN)

% Choose default command line output for matimag
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matimag wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matimag_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Btn_open.
function Btn_open_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg;
[filename,pathname]=uigetfile({'*.jpg;*.bmp'},'Choose the image');

if isequal(filename,0)
    disp('Image loading failed');
else
    filename_p=[pathname filename];
    img_org = imread(filename_p);
    imshow(img_org,'Parent',handles.ImgFrame);
    handles.file = filename_p;
    handles.orgimage = img_org;
    guidata(hObject,handles);
    flg = 0;
end





% --- Executes during object creation, after setting all properties.
function ImgFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImgFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ImgFrame
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');


% --- Executes on button press in Btn_ColorEx.
function Btn_ColorEx_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_ColorEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg;

%load the color range for blue, these value will affect your result
%drastically
% Rmin(4) = 33;
% Rmax(4) = 150;
% Gmin(4) = 13;
% Gmax(4) = 188;
% Bmin(4) = 90;
% Bmax(4) = 255;

Rmin = str2num(get(handles.Edit_Rmin,'string'));
if Rmin>255
    msgbox('Value should be less than 255','Error');
end
Rmax = str2num(get(handles.Edit_Rmax,'string'));
if Rmax>255
    msgbox('Value should be less than 255','Error');
end
Gmin = str2num(get(handles.Edit_Gmin,'string'));
if Gmin>255
    msgbox('Value should be less than 255','Error');
end
Gmax = str2num(get(handles.Edit_Gmax,'string'));
if Gmax>255
    msgbox('Value should be less than 255','Error');
end
Bmin = str2num(get(handles.Edit_Bmin,'string'));
if Bmin>255
    msgbox('Value should be less than 255','Error');
end
Bmax = str2num(get(handles.Edit_Bmax,'string'));
if Bmax>255
    msgbox('Value should be less than 255','Error');
end



img_org = handles.orgimage;
img_ext = uint8(zeros(size(img_org)));

col_count = 0;
col_tot = 0;
%get the image dimension information
[row,col,~]=size(img_org);
col_tot = row * col;

    for m=1:row
       for n=1:col
           Rval = img_org(m,n,1);
           Gval = img_org(m,n,2);
           Bval = img_org(m,n,3);
           if Rval>=Rmin && Rval<=Rmax && Gval>=Gmin && Gval<=Gmax && Bval>=Bmin && Bval<=Bmax
              img_ext(m,n,:) = img_org(m,n,:); %keep this pixel
              col_count = col_count + 1;
           else
              img_ext(m,n,:) = [255,255,255]; 
           end
       end        
    end    


%show the image extraction result
imshow(img_ext,'Parent',handles.Img_out);

%show the result;
col_perc = (col_count/col_tot)*100;
set(findobj('Tag','edit_percent'),'string',num2str(col_perc));

handles.newimage = img_ext;
guidata(hObject,handles);
flg = 1;





% --- Executes during object creation, after setting all properties.
function Menu_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Menu_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function edit_percent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_percent_Callback(hObject, eventdata, handles)
% hObject    handle to edit_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_percent as text
%        str2double(get(hObject,'String')) returns contents of edit_percent as a double


% --- Executes during object creation, after setting all properties.
function Btn_open_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Btn_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in Menu_color.
function Menu_color_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Menu_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Menu_color


% --- Executes on button press in Btn_out.
function Btn_out_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg;

if  flg == 0
   msgbox('Handle the image before output!','error'); 
else
[pathname filename extension] = fileparts(handles.file); 
expandname = '_blue' ;
newfilename = [pathname '\' filename expandname extension];
img = handles.newimage;
imwrite(img,newfilename);
flg=0;
msgbox('New image output done!','note');

end



function Edit_Rmin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Rmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Rmin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Rmin as a double


% --- Executes during object creation, after setting all properties.
function Edit_Rmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Rmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Rmax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Rmax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Rmax as a double


% --- Executes during object creation, after setting all properties.
function Edit_Rmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Rmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Gmin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Gmin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Gmin as a double


% --- Executes during object creation, after setting all properties.
function Edit_Gmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Gmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Gmax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Gmax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Gmax as a double


% --- Executes during object creation, after setting all properties.
function Edit_Gmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Gmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Bmin_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Bmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Bmin as text
%        str2double(get(hObject,'String')) returns contents of Edit_Bmin as a double


% --- Executes during object creation, after setting all properties.
function Edit_Bmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Bmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Bmax_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Bmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Bmax as text
%        str2double(get(hObject,'String')) returns contents of Edit_Bmax as a double


% --- Executes during object creation, after setting all properties.
function Edit_Bmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Bmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
