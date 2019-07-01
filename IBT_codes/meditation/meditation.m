% Matlab code to read Meditation using Mindwave mobile
 %      ****************************************************

%Clear Screen
clc;
%Clear Variables
clear all;
%Close figures
close all;
%Preallocate buffer
data_med = zeros(1,256);
%Comport Selection
portnum1 = 6;
%COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);
% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_115200 = 115200;
% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS = 0;
% Data type that can be requested from TG_GetValue().
TG_DATA_MEDITATION = 3;
%load thinkgear dll
loadlibrary('Thinkgear.dll');
%To display in Command Window
fprintf('Thinkgear.dll loaded\n');
patientID = 142314;
%get dll version
dllVersion = calllib('Thinkgear', 'TG_GetDriverVersion');
%To display in command window
fprintf('ThinkGear DLL version: %d\n', dllVersion );
% Get a connection ID handle to ThinkGear
connectionId1 = calllib('Thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
end;
% Attempt to connect the connection ID handle to serial port "COM3"
errCode = calllib('Thinkgear', 'TG_Connect', connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
end
fprintf( 'Connected. Reading Packets...\n' );
i=0;
j=0;
fileID = fopen('Meditation_data.txt','w');
%To display in Command Window
disp('Reading Brainwaves');
figure;
while i < 20
if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1) %if a packet was read...
if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_MEDITATION ) ~= 0)
j = j + 1;
i = i + 1;
%Read attention Valus from thinkgear packets
data_med(j) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_MEDITATION );
%To display in Command Window
md = data_med(j);
fprintf(fileID,'%d\t %5d\n',patientID,md);
disp(data_med(j));
%Plot Graph
plot(data_med);
title('Meditation');
%Delay to display graph
pause(1);
end
end
end
%To display in Command Window
disp('Loop Completed')
fclose(fileID);
%Release the comm port
calllib('Thinkgear', 'TG_FreeConnection', connectionId1 );