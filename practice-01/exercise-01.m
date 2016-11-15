%% Exercise 1: Airfoils for Wind Turbines
% Class: Modeling, Control and Design of Wind Energy Systems
% University: Technische Universit?t M?nchen
% Date = 2016/11/15
%
%
% Consider a 3MW wind turbine: rotor diameter (d = 100 m), rated rotor
% speed (Omega = 15 rpm), rated wind speed (V_r = 11 m/s).
%
%     3. Plot all airfoil profiles and identify airfoils (see folder
%     "Airfoils") to be best used at both locations.
%
%     4. For the chosen airfoils, plot the lift and drag coefficients and
%     the aerodynamic efficiency as funtion of the angle of attack (AoA).
%     Compare and discuss the figures.
%
%     5. For the airfoils "FFA-W3-241", also plot the moment coefficient,
%     which is given at 25% chod( =~ AC), versus AoA.
%     Calculate the center of pressure (CP) and the moment coefficient at
%     0% chord (LE) for all AoA.
%
%     6. Compute the lift, drag and moment forces per unir span at both
%     radial locations (density of air at 15?C, pho = 1.225 kg/m^3).
%     Assume the AoA at maximum efficiency.
%     Assume the following realtive velocities: (V_r/R=0.2 = 20 m/s) and
%     V_r/R=0.9 = 71 m/s.
%

%% Part 3: Plotting the airfoils

% Data loading

addpath('./Airfoils/');

% A cell array is a data type with indexed data containers called cells, 
% where each cell can contain any type of data. Cell arrays commonly 
% contain either lists of text strings, combinations of text and numbers,
% or numeric arrays of different sizes. Refer to sets of cells by enclosing
% indices in smooth parentheses, (). Access the contents of cells by 
% indexing with curly braces, {}.

% To import or export multiple files, create a control loop to process one
% file at a time. When constructing the loop: To build sequential file
% names, use sprintf. To find files that match a pattern, use dir. Use 
% function syntax to pass the name of the file to the import or export 
% function.

% To read all files that match 'ProfileFFA-W3-*.txt':

% D = dir('directory_name') returns the results in an M-by-1 structure with
% the fields: 
%     name    -- Filename
%     ...

ProfileNames = dir('Airfoils/ProfileFFA-W3-*.txt'); 
numfiles = length(ProfileNames);
% cell(N) is an N-by-N cell array of empty matrices.
CoordData = cell(1, numfiles); 

for k=1:numfiles
  CoordData{k} = load(ProfileNames(k).name); 
end

% Plotting

% There are two ways to refer to the elements of a cell array. Enclose 
% indices in smooth parentheses, (), to refer to sets of cells?for example,
% to define a subset of the array. Enclose indices in curly braces, {}, to 
% refer to the text, numbers, or other data within individual cells.

figure(1);
hold on

for k=1:numfiles
    x = CoordData{k}(:, 1);
    y = CoordData{k}(:, 2);
    
    plot(x, y, 'LineWidth', 1.5)
end

names = regexprep({ProfileNames.name}, '[Profile*.txt]', '');

title('Airfoil profiles')
h = legend(names);

xlabel('x [-]','FontSize',12)
ylabel('y [-]','FontSize',12)

set(h,'FontSize',12)
set(gca,'FontSize',12)

axis equal
grid on

savefig(gcf, 'Profiles')

% Selection
%
% Close to root: Thicker airfoil (FFA-W3-480) for high resistance to 
%                bending loads
% Close to tip: Thinner airfoil (FFA-W3-241) for best aerodynamic 
%               efficiency
%
% Note: FFA-W3-xxx, where xxx is the thickness number for the airfoil. 
% E.g.: ?FFA-W3-480?, t/c=0.480


%% Part 4: Polars

% Use the explicit loading because they are just the airfoils choosen.
PolarNames={'PolarsFFA-W3-241.txt', ...
    'PolarsFFA-W3-480.txt'};

numfiles = length(PolarNames);

for k=1:numfiles
    name = PolarNames{k}; 
    PolarData = load(name); 
    
    alpha = PolarData(:,1);
    Cl = PolarData(:,2);
    Cd = PolarData(:,3);
    Cm = PolarData(:,4);
    
    figure(2);
    hold on
    
    plot(alpha,Cl, 'LineWidth' , 2, 'displayname', ...
        [name(7:end-4) ' - C_L']);
    
    plot(alpha,Cd, 'LineWidth' , 2, 'displayname', ...
        [name(7:end-4) ' - C_D']);

    figure(3);
    hold on
    
    plot(alpha,Cl./Cd, 'LineWidth' , 2, 'displayname', ...
        [name(7:end-4) ' - C_L/C_D']);
    
    figure(4)
    hold on
    
    % Taking just the values from 0 to 40
    plot(Cd(and(alpha<40, alpha>0)), Cl(and(alpha<40, alpha>0)), ...
        'LineWidth' , 2, 'displayname', [name(7:end-4)]);
   
end

% Figure formatting

figure(2)

xlabel('Angle of Attack [deg]','FontSize',12)
ylabel('Lift, Drag [-]','FontSize',12)

h=legend('show');

set(h,'FontSize',12, 'location','southeast')
set(gca,'FontSize',12)

grid on

xlim([-20 20]);

savefig(gcf,'Polars')


figure(3)

xlabel('Angle of Attack [deg]','FontSize',12)
ylabel('C_L/C_D [-]','FontSize',12)

h=legend('show');

set(h,'FontSize',12)
set(gca,'FontSize',12)

grid on

xlim([-20 20]);

savefig(gcf,'Efficiency')


figure(4)

xlabel('C_D [-]','FontSize',12)
ylabel('C_L [-]','FontSize',12)

h=legend('show');

set(h,'FontSize',12)
set(gca,'FontSize',12)

grid on

xlim([0 0.2]);

savefig(gcf,'Cd_Cl')


%% Part 5

PolarNames={'PolarsFFA-W3-241.txt'};

x_AC = 0.25;
c_P = 0.27;

name = PolarNames{:};
Data = load(name);

alpha = Data(:,1);
Cl = Data(:,2);
Cd = Data(:,3);
Cm = Data(:,4);

figure(5);

subplot(2,1,1)
hold on

plot(alpha,Cm, 'LineWidth' , 2, 'displayname', ...
    [name(7:end-4) ' - C_{M,AC}']);

plot(alpha,-Cl*x_AC+Cm, 'LineWidth' , 2, 'displayname', ...
    [name(7:end-4) ' - C_{M,LE}']);

%plot(alpha,Cl*(x_P-x_AC)+Cm, 'LineWidth' , 2, 'displayname', ...
%    [name(7:end-4) ' - C_{M,P}']);

subplot(2,1,2)
hold on

plot(alpha,x_AC-Cm./Cl, 'LineWidth' , 2, 'displayname', [name(7:end-4)]);


figure(5)

subplot(2,1,1)

xlabel('Angle of Attack [deg]','FontSize',12)
ylabel('C_M [-]','FontSize',12)

h=legend('show');

set(h,'FontSize',12, 'location','southwest')
set(gca,'FontSize',12)

grid on

xlim([-20 20]);

subplot(2,1,2)

xlabel('Angle of Attack [deg]','FontSize',12)
ylabel('Center of pressure [c]','FontSize',12)

h=legend('show');

set(h,'FontSize',12, 'location','southeast')
set(gca,'FontSize',12)

grid on

xlim([-20 20]);

savefig(gcf,'CM')