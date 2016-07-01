function [Dist]=dtw(t,r)
    N=size(t,2);
    M=size(r,2);
    for n=1:N
        for m=1:M
            d(n,m)=0;
            for i=1:size(t,2)
                aux_dif = reshape(t(n,i,:) - r(m,i,:),[1,size(t,3)]);      
                aux_eq = sqrt(aux_dif *aux_dif');
                d(n,m)=d(n,m)+aux_eq;
            end
        end
    end
    D=zeros(size(d));
    D(1,1)=d(1,1);
    for n=2:N
        D(n,1)=d(n,1)+D(n-1,1);
    end
    for m=2:M
        D(1,m)=d(1,m)+D(1,m-1);
    end
    for n=2:N
        for m=2:M
            D(n,m)=d(n,m)+min([D(n-1,m),D(n-1,m-1),D(n,m-1)]);
        end
    end
    Dist=D(N,M);
    n=N;
    m=M;
    k=1;
    w=[];
    w(1,:)=[N,M];
    while ((n+m)~=2)
        if (n-1)==0
            m=m-1;
        elseif (m-1)==0
            n=n-1;
        else 
          [values,number]=min([D(n-1,m),D(n,m-1),D(n-1,m-1)]);
          switch number
              case 1
                n=n-1;
              case 2
                m=m-1;
              case 3
                n=n-1;
                m=m-1;
          end
        end
        k=k+1;
        w=cat(1,w,[n,m]);
    end
end

