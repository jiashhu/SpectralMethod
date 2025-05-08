N = 200;
L = 10;
x = 2*(-N:N)/(2*N+1)*L;
y = 2*(-N:N)/(2*N+1)*L;
% 把x,y都看成行向量。XX的每一行都是x。YY的每一列都是y的转置，即YY的每一列从上往下是增长的。
% 把XX和YY分成四个象限。排列为
% [[第三象限，第四象限],
%  [第二象限，第一象限]]
[XX,YY] = meshgrid(x,y);

func = @(x,y) exp(-2*1i*pi/L*x+4*1i*pi/L*y);
fre = myFFT2(func(XX,YY));
real(fre(N+1 + (-4:4), N+1 + (-2:2)))



% 结果是系数1出现在（N+1,N+1）+(4,2)位置。
% 行数和列数增加意味着频率增加。行数增加对应y频率，列数增加对应x频率

% 因此要计算频率，需要物理空间中的值是XX，YY对应的type

% 下面测试nufftn：目的是计算func在非均匀采样点上的值


Nsample = 20;
xx = rand(Nsample,1);
yy = rand(Nsample,1);
[XX, YY] = meshgrid(xx,yy);

% 由于采样点必须是一个向量，所以需要把矩阵先拉成向量。然后计算完之后再reshape回到矩阵
% 用reshape，是按列展开，先第一列，再第二列，以此类推。
% 反过来将向量reshape成矩阵也是同理。先填充矩阵的第一列，然后是第二列。所以两次reshape之后会复原。

% 
tmp = nufftn(fre,{-N:N,-N:N},{-yy/(2*L),-xx/(2*L)});
res1 = reshape(tmp,[Nsample,Nsample]);
res2 = func(XX,YY);
norm(res1-res2,'fro')