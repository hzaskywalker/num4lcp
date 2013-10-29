
% A0,b0 is the LCP with no tangential force, so friction should be zero
% A1,b1 is the LCP with some tangential force, so friction should be non-zero
% The idea is to introduce lower and upper bound for the friction
% and convert those bounds into the A and b, so that friction is clamped


clear all;
close all;
clc;

lambda1 = 1.0;
max_iter = 50;
tol_rel  = 0.0;
tol_abs  = 0.0;
num_variables = 8;

A0 =   [    4.0006         1        -2         1       1.5       1.5       1.5       1.5
           1    4.0006         1        -2       1.5       1.5       1.5       1.5
          -2         1    4.0006         1      -1.5      -1.5      -1.5      -1.5
           1        -2         1    4.0006      -1.5      -1.5      -1.5      -1.5
         1.5       1.5      -1.5      -1.5    4.0006         1         1         4
         1.5       1.5      -1.5      -1.5         1    4.0006         4         1
         1.5       1.5      -1.5      -1.5         1         4    4.0006         1
         1.5       1.5      -1.5      -1.5         4         1         1    4.0006 ];
     
b0  =  [  -1
    -1
    -1
    -1
		0
		0
		0
		0 ];

A1 =     [    4.0006         1        -2         1       1.5       1.5       1.5       1.5
           1    4.0006         1        -2      -1.5      -1.5      -1.5      -1.5
          -2         1    4.0006         1      -1.5      -1.5      -1.5      -1.5
           1        -2         1    4.0006       1.5       1.5       1.5       1.5
         1.5      -1.5      -1.5       1.5    4.0006         4         1         1
         1.5      -1.5      -1.5       1.5         4    4.0006         1         1
         1.5      -1.5      -1.5       1.5         1         1    4.0006         4
         1.5      -1.5      -1.5       1.5         1         1         4    4.0006 ]
     
b1  =  [  -1
    -1
    -1
    -1
		-1
		-1
		-1
		-1 ]

x	 = zeros(num_variables,1);
x0     = zeros(num_variables,1);
    
%[z1 e1 i1 f1 conv1 m1] = psor(A, b, x0, lambda1, max_iter, tol_rel, tol_abs, true);
display('lemke no tangential force (friction should be zero)')
[z1 err] = lemke(A0,b0,x0);
display(z1);

display('lemke with tangential force (non-zero friction)')
[z1 err] = lemke(A1,b1,x0);
display(z1);

%
lo = [ 0.
			0.
			0.
			0.
			-0.1
			-0.1
			-0.1
			-0.1 ];

hi = [ 10000.
			10000.
			10000.
			10000.
			0.1
			0.1
			0.1
			0.1 ];

%Method 0, not working yet
B = pinv(A1);
M = [ B -B
    -B B];
q = [ (-B*b1 - lo)'   (hi + B*b1)' ]';
x0 = zeros(16,1);

[z1 err] = lemke(M,q,x0);
display('Method 0: lemke with tangential force, friction clamped to lo=-0.1 hi=0.1]')
display(z1);

%Method 1, not working yet

Q = zeros(8,8);

M = [A1 Q
    Q -A1];
q1 = b1 + A1*lo;
q2 = b1 + A1*hi;

q = [(q1)' (q2)']';

[z1 err] = lemke(M,q,x0);

display('Method 1: lemke with tangential force, friction clamped to lo=-0.1 hi=0.1]')
display(z1);



