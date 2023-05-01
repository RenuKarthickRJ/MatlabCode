







addpath(genpath('C:\Users\renu\Desktop\CST-MATLAB-API-master')); %For instance, my path is: addpath(genpath('C:\Users\simos\Dropbox\cst api'));
 
cst = actxserver('CSTStudio.application');


mws = cst.invoke('NewMWS');



CstDefaultUnits(mws) 


CstDefineFrequencyRange(mws,1.5,3.5)


CstMeshInitiator(mws)



Xmin='expanded open';
Xmax='expanded open';
Ymin='expanded open';
Ymax='expanded open';
Zmin='expanded open';
Zmax='expanded open';
minfrequency = 1.5;
CstDefineOpenBoundary(mws,minfrequency,Xmin,Xmax,Ymin,Ymax,Zmin,Zmax)


XminSpace = 0;
XmaxSpace = 0;
YminSpace = 0;
YmaxSpace = 0;
ZminSpace = 0;
ZmaxSpace = 0;
CstDefineBackroundMaterial(mws,XminSpace,XmaxSpace, YminSpace, YmaxSpace, ZminSpace, ZmaxSpace)


CstCopperAnnealedLossy(mws)
CstFR4lossy(mws)

W = 28.45; %Width of the patch
L = 28.45; %Lenght of the patch
Fi = 9; %Depth of the cut inside the microstrip
Wf = 1.137;%Width of the feedline
Gpf=1; %Width of the empty space slot 
Lg = 2*L;%Length of the ground 
Wg = 2*W;%Width of the ground
Ht = 0.035;%Height of the copper
Hs = 1.6;% Height of the substrate


Name = 'Groundplane';
component = 'component1';
material = 'Copper (annealed)';
Xrange = [-0.5*Wg 0.5*Wg];
Yrange = [-0.5*Lg 0.5*Lg];
Zrange = [0 Ht];
Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

%This creates the substrate
Name = 'Substrate';
component = 'component1';
material = 'FR-4 (lossy)';
Xrange = [-0.5*Wg 0.5*Wg];
Yrange = [-0.5*Lg 0.5*Lg];
Zrange = [Ht Ht+Hs];
Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

%This one creates the patch
Name = 'Patch';
component = 'component1';
material = 'Copper (annealed)';
Xrange = [-W/2 W/2];
Yrange = [-L/2 L/2];
Zrange = [Ht+Hs Ht+Hs+Ht];
Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

%Here I am cutting the patch to fit the feedline
Name = 'Empty space';
component = 'component1';
material = 'Copper (annealed)';
Xrange = [-((Wf/2)+Gpf)  ((Wf/2)+Gpf)];
Yrange = [-L/2+Fi -L/2];
Zrange = [Ht+Hs Ht+Hs+Ht];
Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

%This subtracts two components
component1 = 'component1:Patch';
component2 = 'component1:Empty space';
CstSubtract(mws,component1,component2)

%This creates the feedline
Name = 'FeedLine';
component = 'component1';
material = 'Copper (annealed)';
Xrange = [-Wf/2 Wf/2];
Yrange = [-L/2+Fi -Lg/2];
Zrange = [Ht+Hs Ht+Hs+Ht];
Cstbrick(mws, Name, component, material, Xrange, Yrange, Zrange)

%This adds the feedline to the patch
component1 = 'component1:Patch';
component2 = 'component1:FeedLine';
CstAdd(mws,component1,component2)


Name = 'Substrate';
id = 3;
CstPickFace(mws,Name,id)



PortNumber = 1;
Xrange = [-W W];
Yrange = [-L L];
Zrange = [Ht Ht+Hs];
XrangeAdd = [-6*Hs -6*Hs];
YrangeAdd = [0 0];
ZrangeAdd = [0 6*Hs];
CstWaveguidePort(mws,PortNumber, Xrange, Yrange, Zrange, XrangeAdd, YrangeAdd, ZrangeAdd, 'Picks','positive')


CstDefineEfieldMonitor(mws,strcat('e-field', 2.45),2.45);
CstDefineHfieldMonitor(mws,strcat('h-field', 2.45), 2.45);
%CstDefineFarfieldMonitor(mws,strcat('Farfield',2.45), 2.45);



CstSaveProject(mws)



CstDefineTimedomainSolver(mws,-40)


exportpath = 'C:\Users\renu\Desktop\CST-MATLAB-API-master';
filenameTXT = 'microstrip';





