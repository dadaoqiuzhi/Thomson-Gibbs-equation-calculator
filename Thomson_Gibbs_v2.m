fprintf('\n�뽫���ݷ���input_data��')
range=input('\n����������¶����䣬�ո���������ţ�\n');
range=strtrim(range);range=strsplit(range);
datain=xlsread('input_data.xlsx');
a=str2num(range{1});b=str2num(range{2});
range=[];range(1)=a;range(2)=b;Tdata=[];
[row,col]=size(datain);
for i=1:col/2
    Tdata(:,i)=datain(:,2*i-1);
    if min(datain(:,2*i))<0
        datain(:,2*i)=datain(:,2*i)-min(datain(:,2*i));%DSC�ź�ǿ�Ȼ�Ϊ�Ǹ���
    end
    for j=1:row
        datain(j,2*i-1)=29015/144/(141.35-datain(j,2*i-1));%��λnm
    end
end
range(1)=29015/144/(141.35-range(1));range(2)=29015/144/(141.35-range(2));%��������
thickness={};thickness{1,1}='����';thickness{1,2}='�ؾ�';
%������
for i=1:col/2
    Ia=0;Ib=0;Ic=0;Id=0;
    for j=1:row
        if datain(j,2*i-1)>=range(1) && datain(j,2*i-1)<=range(2) && datain(j,2*i-1)>0
            Ia=Ia+datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%������ĸ
            Ib=Ib+datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%��������
            Ic=Ic+datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%�ؾ���ĸ
            Id=Id+datain(j,2*i-1)*datain(j,2*i-1)*datain(j,2*i)*(Tdata(j+1,i)-Tdata(j,i));%�ؾ�����
        end
        if datain(j,2*i-1)>range(2) || datain(j,2*i-1)<0
            break;
        end
    end
    [row2,~]=size(thickness);
    thickness{row2+1,1}=Ib/Ia;
    thickness{row2+1,2}=Id/Ic;
end
clear a b col i Ia Ib Ic Id j range row row2 
fprintf('\n���������thickness��,��λnm\n')