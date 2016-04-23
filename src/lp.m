function [ v ] = lp( d, t )
%   LP Linear Perceptron algorithm
%   Fill in your codes here.

v = [0];
n = rows( d );
n_test = rows( t );
%d = d( 2:n, : );
%t = t( 2:n_test, : );
%n = rows( d );
%n_test = rows( t );
E = zeros( n, 3 );
L = zeros( n, 1 );
alpha = 0.005; % learning rate
w = [ 0 1 0 ]; % initial weight matrix

% Fill up the rows and columns of E
for i = 1:n
  E( i, 1 ) = d( i, 1 );
  E( i, 2 ) = d( i, 2 );
  E( i, 3 ) = 1;
endfor
% Fill up L
for i = 1:n
  if( d( i, 3 ) == 1 )
    L( i ) = 0;
  endif
  if( d( i, 3 ) == 2 )
    L( i ) = 1;
  endif
  if( d( i, 3 ) == 3 )
    L( i ) = -1;
  endif
endfor

% Iterate over a number of times until you get to a good point
for j = 1:n
  predict = w * E( j, : )';
  if( predict > 0 )
    predict = 1;
  endif
  if( predict < 0 )
    predict = -1;
  endif
  if( predict != L( j ) )
    w = w + L( j ) * E( j, : ) * alpha;
  endif
endfor

% Now test the algorithm on the test vectors
n_test = rows( t );
t( :, 3 ) = 1;

for i = 1:n_test
  v( i ) = w * t( i, : )';
endfor
v = v';
for i = 1:n_test
  if( v( i ) > 0 )
    v( i ) = 2;
  endif
  if( v( i ) < 0 )
    v( i ) = 3;
  endif
endfor
end

