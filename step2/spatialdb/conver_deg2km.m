clear all
close all
A=load('Dipslip_patch.txt');
lon=A(:,1);
lat=A(:,2);
value=A(:,3)*(-0.0823);
[AR,thigma]=distance(8.91123,-85.3991,9.71822,-84.5832);
B=[0,0,0];
for i=1:1:length(lon);
    [ARx,AZx]=distance(8.91123,-85.3991,lat(i),lon(i));
    dis=deg2km(ARx);
    dx=dis*cosd(thigma-AZx);
    dy=dis*sind(thigma-AZx);
    Bl=[dx,dy,value(i)];
    B=[B;Bl];
end
B(1,:)=[];
%% plot figure 
X=reshape(B(:,1),40,29);
Y=reshape(B(:,2),40,29);
Z=reshape(B(:,3),40,29);
figure(1)
surf(X,Y,Z)
axis equal

%% densify the X and Y
% X_interp=linspace(min(B(:,1)),max(B(:,1)),60);
% Y_interp=linspace(min(B(:,2)),max(B(:,2)),80);
X_interp=linspace(0,130,60);
Y_interp=linspace(0,190,80);
% new mesh of the denser grid
[Ymesh_interp,Xmesh_interp]=meshgrid(Y_interp,X_interp);
% interpolate denser locking data
locking_interp=griddata(X,Y,Z,Xmesh_interp,Ymesh_interp,'cubic');

figure(2)
surf(Xmesh_interp,Ymesh_interp,locking_interp)
axis equal

%%
mx=length(X_interp);
my=length(Y_interp);
mxy=mx*my;
Xmesh_interp1=reshape(Xmesh_interp,mxy,1);
Ymesh_interp1=reshape(Ymesh_interp,mxy,1);
locking_interp1=reshape(locking_interp,mxy,1);
z=zeros(mxy,1);
left=z;
fopening=z;
C=[Xmesh_interp1,Ymesh_interp1,z,left,locking_interp1,fopening];

%% output locking spatialdb
fid=fopen('locking_data.txt','w');
fprintf(fid,'%f %f %f %f %f %f\n',C');
fclose(fid)
%%
lx=length(B(:,1));
P=zeros(lx,1);
D=[B(:,1),B(:,2),P,P,B(:,3),P];
fid=fopen('locking.txt','w');
fprintf(fid,'%f %f %f %f %f %f\n',D');
fclose(fid)