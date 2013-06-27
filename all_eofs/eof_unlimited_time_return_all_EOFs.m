function[eof1, fv, eof_all] = eof_unlimited_time_return_all_EOFs(x, N, T, number_of_measurements_per_block);

%X=detrend(X_intro, 0);
X=detrend(x, 0);

% 2. compute the eigenvectors of the covarian matrix X^T X 
C=X'*X;
[E, Lambda]=eig(C);

%note that Lambda is the diagonal matrix of eigenvalues, and E
%is the matrix of eigenvectors

% 3.
total_variance=trace(Lambda);
fractional_variance=diag(Lambda)/total_variance;

%4. now find the principle component associated with the various
%eigenvalues
for(i=1:N)
  PC(:,i)=X*E(:,i);
end;

%fig1=figure(1);
%plot(PC(1:T, 1));
%%imagesc(PC.');

number_of_blocks=floor(T/number_of_measurements_per_block);

for(j=1:number_of_blocks)
    %beginpoint=1+(j-1)*75;
    %endpoint=75+(j-1)*75;
  beginpoint=1+(j-1)*number_of_measurements_per_block;
  endpoint=number_of_measurements_per_block+(j-1)*number_of_measurements_per_block;
  %X=detrend(X_intro, 0);
  xm=detrend(x(beginpoint:endpoint,:), 0);
  % 2. compute the eigenvectors of the covarian matrix X^T X 
  c=xm'*xm;
  [em, lambda]=eig(c);
  %note that Lambda is the diagonal matrix of eigenvalues, and E
  %is the matrix of eigenvectors
  % 3.
  tv=trace(lambda);
  %now find the fraction of the variance explained by the various
  %eigen vectors
  fv(:,j)=diag(lambda)/tv;
  %4. now find the principle component associated with the various
  %eigenvalues
  for(i=1:N)
    pc(:,i)=xm*em(:,i);
  end;
  eof1(:,j)=em(:,N);
  eof_all(:,:,j)=em;

end;




