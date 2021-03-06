%% 
% ------------------------ PS8 ------------------------
% PS 8.1 - finish kalman filter - done

% PS 8.2 - model the actuators in simulink
% ISS has 4760 N*m*s CMG's. I'll cheat and say 1 in each body axis
% 258 N*m
% https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20100021932.pdf


% PS 8.3 - implement linear control law
setupCMG;
bControl = 0;
bGravGrad = 1;
b_perturbs = 1;
bNoise = 0; % PS 7.2 hint
t_total = 0.2*90*60;
dt = 0.5;
w_des = [0 -n0 0]';
%run sim
runHW8Sim
sim('sixDOF_hw8',[],options);
%post-process
[ XYZ ] = getXYZpostprocess( A_DCM, Xout );
[yaw, pitch, roll] = dcm2angle( A_DCM ); %expressed in inertial
%figure;plot(tout, [yaw, pitch, roll]); 
% figure; plot(tout, XYZ); title('PS 8) XYZ position')
% legend('x','y','z')
% [ RTN ] = getRTNpostprocess( A_DCM, error_DCM, Xout );
% figure; plot(tout, RTN); title('PS 5.2) RTN position')
% legend('x','y','z')
% figure; plot(Xout(:,1), Xout(:,2))
w_true_free = w_true;
%figure;plot(tout, w_true);title('Ang. Vel. in principle')


bControl = 1;
%run sim
runHW8Sim
sim('sixDOF_hw8',[],options);
w_true_control = w_true;

%post-process
figure; hold on
subplot(2,1,1); plot(tout, w_true_free); title('8.4) True ang. vel. no control');
legend('yaw','pitch','roll')
subplot(2,1,2); plot(tout, w_true_control); title('8.4) True ang. vel. with CMG control')
legend('yaw','pitch','roll')

% PS 8.4 - plotting - att determ. errors, att. control errors, control
% actions, CMG angles
state_error = w_true - x_ekf;
figure;hold on; title('Ang. Vel. and Errors')
subplot(2,1,1); plot(tout(1:100,:), [w_true(1:100,:), x_ekf(1:100,:)]); title('True and estimated ang. vel.'); ylabel('Ang vel (rad/s')
subplot(2,1,2); plot(tout(1:100,:), state_error(1:100,:)); title('Error in ang. vel')
legend('yaw','pitch','roll'); ylabel('Ang vel (rad/s')
perm = permute(error_DCM, [3 1 2]);
flat_error = reshape(perm, [], 9);
figure; plot(tout, flat_error); title('PS 9) Att control error')
figure;plot(tout, Mcontrol); title('Control action')
ylabel('Moments (kN)')
perm = permute(A_CMG, [3 1 2]);
figure;plot(tout, reshape(perm,[],9));title('Rotation Amount for CMG')
ylabel('Radians')







