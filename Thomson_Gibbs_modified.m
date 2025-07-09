fprintf('\n请将数据放在input_data中')
range=input('\n请输入积分温度区间，空格隔开带引号，单位摄氏度：\n');
range=strtrim(range);range=strsplit(range);
datain=xlsread('input_data.xlsx');
a=str2num(range{1});b=str2num(range{2});
range=[];range(1)=a;range(2)=b;
[row,col]=size(datain);Tdata=[];
for i=1:col/2
    Tdata(:,i)=datain(:,2*i-1);
    if min(datain(:,2*i))<0
        datain(:,2*i)=datain(:,2*i)-min(datain(:,2*i));%DSC信号强度化为非负数
    end
    for j=1:row
        datain(j,2*i-1)=4145*0.254/(141.35-datain(j,2*i-1))/8.2;%单位nm
    end
end
range(1)=4145*0.254/(141.35-range(1))/8.2;range(2)=4145*0.254/(141.35-range(2))/8.2;%新的积分区间，nm
thickness={};thickness{1,1}='数均';thickness{1,2}='重均';
%计算厚度
for i=1:col/2
    Ia=0;Ib=0;Ic=0;Id=0;
    for j=1:row
        if datain(j,2*i-1)>=range(1) && datain(j,2*i-1)<=range(2) && datain(j,2*i-1)>0
            Ia=Ia+datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%数均分母
            Ib=Ib+datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%数均分子
            Ic=Ic+datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%重均分母
            Id=Id+datain(j,2*i-1)*datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%重均分子
        end
        if datain(j,2*i-1)>range(2) || datain(j,2*i-1)<0
            break;
        end
    end
    [row2,~]=size(thickness);
    thickness{row2+1,1}=Ib/Ia;
    thickness{row2+1,2}=Id/Ic;
end
clear a b col i Ia Ib Ic Id j range row row2 Tdata
fprintf('\n结果数存在thickness中，单位纳米\n')