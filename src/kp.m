function [ v ] = kp( d, t )
%   KP Kernel / Featurized Perceptron algorithm
%   Fill in your codes here.

% Kernel function
function [ phi ] = getPhi( x1, x2 )
  phi( 1, 1 ) = x1^2;
  phi( 1, 2 ) = sqrt( 2 ) * x1 * x2;
  phi( 1, 3 ) = x2^2;
endfunction

function [ k ] = kernelPoly( xi, xj ) % Polynomial
  k = dot( getPhi( xi( 1, 1 ), xi( 1, 2 ) ), getPhi( xj( 1, 1 ), xj( 1, 2 ) ) );
endfunction

function [ k ] = kernel( xi, xj )
  sigma = 0.05;
  k = exp( - ( ( norm( xi - xj ) )^2 ) / ( 2 * sigma^2 ) );
endfunction

v = [0];
n = rows( d );
n_test = rows( t );
E = zeros( n, 2 );
L = zeros( n, 1 );
alpha = 0.005; % learning rate
w = [ 0 1 0 ]; % initial weight matrix

for i = 1:n
  if( d( i, 3 ) == 2 )
    L( i ) = 1;
    E( i, 1 ) = d( i, 1 );
    E( i, 2 ) = d( i, 2 );
  endif
  if( d( i, 3 ) == 3 )
    L( i ) = -1;
    E( i, 1 ) = d( i, 1 );
    E( i, 2 ) = d( i, 2 );
  endif
endfor

M = zeros( n, 3 );
count = 1;
for i = 1:n
  predict = 0;
  for j = 1:rows( M )
    predict = predict + M( j, 3 ) * kernel( M( j, 1:2 ), E( i, : ) );
  endfor
  if ( predict >= 0 )
    predict = 1;
  endif
  if( predict < 0 )
    predict = -1;
  endif
  if( predict != L( i ) )
    M( count, : ) = [ E( i, 1 ) E( i, 2 ) L( i ) ]; 
    count = count + 1;
  endif
endfor

% Now test the algorithm on the test vectors
n_test = rows( t );

for i = 1:n_test
  predict = 0;
  for j = 1:rows( M )
    predict = predict + M( j, 3 ) * kernel( M( j, 1:2 ), t( i, : ) );
  endfor
  if( predict >= 0 )
    v( i ) = 2;
  endif
  if( predict < 0 )
    v( i ) = 3;
  endif
endfor
v = v';
end

