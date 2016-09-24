%% Final exam
% Juan Carlos Villaseñor-Derbez

clear, close, clc






%% Part two

load SOI

both=innerjoin(oniTbl,soiTbl);

subplot 222
scatter(both.soi, both.oni)
xlabel 'SOI'
ylabel 'ONI'
lsline
B=polyfit(both.soi, both.oni,1);
b0=B(2); b1=B(1); %These are our coefficients

% We can write our formula as:
f=horzcat(num2str(b0),'+(SOI*',num2str(b1),')');

% Aditionally
A=fitlm(both.soi, both.oni);
%A contains a table with the summary of the regression (i.e. p values, R
%squared and all that).

% We now take all the values previous to ONI data (1880-1950)
SOI=soiTbl.soi(soiTbl.datenum<min(oniTbl.datenum));
dates=soiTbl.datenum(soiTbl.datenum<min(oniTbl.datenum));
% and evaluate our function with eval(f) to obtain ONI
ONI=eval(f);
ONITbl=table(dates,ONI, 'VariableNames',{'datenum','oni'});

subplot 223
bar(ONITbl.datenum, ONITbl.oni,'k')
datetick('x','yyyy')
axis tight
xlabel 'Years'
ylabel 'ONI (predicted)'

%% Plotting again (A WORK)

events=3; % Since this is predicted data, we do not observe the typical
% oscilations of ENSO. Thus, 5 consecutive years rarely occur. We can be a
% bit flexible and modify that to be 3 consecutive years. If 5, only one El
% Niño occurs between 1880 and 1950. If 3, we observe 5 El Niños and 1 La
% Niña events.

% Yes, I whould have written this as a function. It would have been easier.


% El Niño
pen=ONITbl.oni>=0.5; %Values larger than 0.5

ens=diff(find(diff(pen))); %identifies length of sequences, but not the
% first one, nor the last one, so we build a fast cycle that does that

a=0;
j=0;
while a==0;
    j=j+1;
    a=pen(j);
end
ens=[j-1;ens];
ens=[ens;length(pen)-sum(ens)];


j=1;
pen2=zeros(length(pen),1);
for i=1:length(ens)
    if ens(i)>=events
        if ~mod(i,2)==1%this is when the group is made of true values
            if max(ONITbl.oni(j:j+ens(i)-1))>=1
                pen2(j:j+ens(i)-1)=1;
            end
        end
    end
    j=sum(ens(1:i))+1;
end
pen2=logical(pen2);



% La Niña
pln=ONITbl.oni<=-0.5; %Values under 0.5

lns=diff(find(diff(pln))); %identifies length of sequences, but not the
% first one, nor the last one, so we build a fast cycle that does that

a=0;
j=0;
while a==0;
    j=j+1;
    a=pln(j);
end
lns=[j-1;lns];
lns=[lns;length(pen)-sum(lns)];

j=1;
pln2=zeros(length(pln),1);
for i=1:length(lns)
    if lns(i)>=events
        if ~mod(i,2)==1%this is when the group is made of true values
            if min(ONITbl.oni(j:j+lns(i)-1))<=-1
                pln2(j:j+lns(i)-1)=1;
            end
        end
    end
    j=sum(lns(1:i))+1;
end
pln2=logical(pln2);

subplot 224
bar(ONITbl.datenum, ONITbl.oni,'FaceColor',[.9 .9 .9],'EdgeColor','k')
hold on
bar(ONITbl.datenum(pen2), ONITbl.oni(pen2),'r', 'EdgeColor','r'), hold on
bar(ONITbl.datenum(pln2), ONITbl.oni(pln2),'b','EdgeColor','b')

legend('Neutral','El Niño', 'La Niña')
datetick('x','yyyy')
axis tight
xlabel 'Years'
ylabel 'ONI (predicted)'


