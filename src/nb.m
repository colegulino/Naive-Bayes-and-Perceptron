function [ v ] = nb( d, t )

% get the number of rows for d
v = [ 0 ];
n = rows( d );
n_test = rows( t );
d = d( 1:n, : );
t = t( 1:n_test, : );
n = rows( d );
prior = [ 0, 0 ]; % Initialize the prior

%Iterate through the data matrix and calculate the prior
for i = 1:n
  if( d( i, 3 ) == 1 ) % li = 1
    prior( 1 ) = prior( 1 ) + 1;
  endif
  if( d( i, 3 ) == 2 ) % li = 2
    prior( 2 ) = prior( 2 ) + 1;
  endif
endfor
prior;
prior = prior / n;

% Find the gaussian distribution parameters
X = d( 1:n, 1 );
Y = d( 1:n, 2 );
L = d( 1:n, 3 );
mu = [ 0 0; 0 0 ];
for i = 1:n
  if( L( i ) == 1 ) % Class 1
    mu( 1, 1 ) = mu( 1, 1 ) + X( i );
    mu( 1, 2 ) = mu( 1, 2 ) + Y( i );
  endif
  if( L( i ) == 2 ) % Class 2
    mu( 2, 1 ) = mu( 2, 1 ) + X( i );
    mu( 2, 2 ) = mu( 2, 2 ) + Y( i );
  endif
endfor
mu( 1, 1 ) = mu( 1, 1 ) / ( prior( 1 ) * n );
mu( 1, 2 ) = mu( 1, 2 ) / ( prior( 1 ) * n );
mu( 2, 1 ) = mu( 2, 1 ) / ( prior( 2 ) * n );
mu( 2, 2 ) = mu( 2, 2 ) / ( prior( 2 ) * n );
sigma = [ 0 0; 0 0 ];
for i = 1:n
  if( L( i ) == 1 ) % Class 1
    sigma( 1, 1 ) = sigma( 1, 1 ) + ( X( i ) - mu( 1, 1 ) )^2;
    sigma( 1, 2 ) = sigma( 1, 2 ) + ( Y( i ) - mu( 1, 2 ) )^2;
  endif
  if( L( i ) == 2 ) % Class 2
    sigma( 2, 1 ) = sigma( 2, 1 ) + ( X( i ) - mu( 2, 1 ) )^2;
    sigma( 2, 2 ) = sigma( 2, 2 ) + ( Y( i ) - mu( 2, 2 ) )^2;
  endif
endfor
sigma( 1, 1 ) = sigma( 1, 1 ) / ( prior( 1 ) * n );
sigma( 1, 2 ) = sigma( 1, 2 ) / ( prior( 1 ) * n );
sigma( 2, 1 ) = sigma( 2, 1 ) / ( prior( 2 ) * n );
sigma( 2, 2 ) = sigma( 2, 2 ) / ( prior( 2 ) * n );
% Take the test variables and put put them through the normal distribution function
n_test = rows( t ); % Number of test variables
Pt = zeros( n_test, 2 ); % Test matrix: each row is for each test instance nad each column is for p(xe,ye|c) which first column is p(xe,ye|1) and second column is p(xe,ye|2)
p = [ 0 0; 0 0 ];
for i = 1:n_test
  p( 1, 1 ) = ( 1 / sqrt( 2 * pi * sigma( 1, 1 ) ) ) * exp( -( ( t( i, 1 ) - mu( 1, 1 ) )^2 ) / ( 2 * sigma( 1, 1 ) ) ); % p(xe|1)
  p( 1, 2 ) = ( 1 / sqrt( 2 * pi * sigma( 1, 2 ) ) ) * exp( -( ( t( i, 2 ) - mu( 1, 2 ) )^2 ) / ( 2 * sigma( 1, 2 ) ) ); % p(ye|1)
  p( 2, 1 ) = ( 1 / sqrt( 2 * pi * sigma( 2, 1 ) ) ) * exp( -( ( t( i, 1 ) - mu( 2, 1 ) )^2 ) / ( 2 * sigma( 2, 1 ) ) ); % p(xe|2)
  p( 2, 2 ) = ( 1 / sqrt( 2 * pi * sigma( 2, 2 ) ) ) * exp( -( ( t( i, 2 ) - mu( 2, 2 ) )^2 ) / ( 2 * sigma( 2, 2 ) ) ); % p(ye|2)
  Pt( i, 1 ) = p( 1, 1 ) * p( 1, 2 ); % p(xe,ye|1)
  Pt( i, 2 ) = p( 2, 1 ) * p( 2, 2 ); % p(xe,ye|2)
endfor
Pt
% Now use Bayes Theorem to get probabilities and chose besed on what is highest probability for the label
p1 = 0; % Probability that the label is 1
p2 = 0; % Probability that the label is 2
denom = 0;
for i = 1:n_test
  denom = Pt( i, 1 ) * prior( 1 ) + Pt( i, 2 ) * prior( 2 );
  p1 = ( Pt( i, 1 ) * prior( 1 ) ) / denom
  p2 = ( Pt( i, 2 ) * prior( 2 ) ) / denom
  if ( p1 > p2 )
    v( i ) = 1;
  endif
  if ( p2 > p1 )
    v( i ) = 2;
  endif
endfor
v = v';
endfunction