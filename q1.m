figure(1);
T = csvread('PROJ.CSV');
X=[T(1:1440,1)', flip(T(1441:end,1))'];
Y=[T(1:1440,2)', flip(T(1441:end,2))'];
plot(X,Y);