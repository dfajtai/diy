## Copyright (C) 2021 Fajtai Daniel
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} floor_area_approx (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Fajtai Daniel <fajtai@ws2>
## Created: 2021-05-19


function [ S_hat, lengths, w_real ] = floor_area_approx (N, R, D)
  floor_plank_len = @(x1,x2,r) max( sqrt(r^2 - x1^2), sqrt(r^2 - x2^2) ) ;
  
  N = floor(N);
  
  if ( N <= 1 )
    # S_hat = ( ( 2 * R ) + D ) * (2 * R); 
    S_hat = inf; # optimalization pruposes
    lengths = zeros(0);
    w_real = inf;
  else
    w = (R * 2) / N;
    w_real = w + D;
    S_hat = 0;
    lengths = zeros(1,N);
    for j = 1: N
      x1 = -R + (j - 1) * w;
      x2 = -R + j * w;
      # solve the top arch clipping problem
      if ((x1<=0) && (x2>=0))
        L = R*2;
      else
        L = floor_plank_len (x1, x2, R) * 2;
      endif
      
      lengths(1,j) = L;
      S_hat = S_hat + w_real * L;
    endfor
  endif
  S_hat = S_hat / (1000)^2;
endfunction