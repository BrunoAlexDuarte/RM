# based on https://github.com/C2SR/pyarena

from ..core import slam
import numpy as np

class EKFSLAMLandmark(slam.SLAM):
    def __init__(self, **kwargs):
        if 'nb_landmarks' not in kwargs:
            raise KeyError("[SLAM/LandmarkEKF] Must specify number of landmarks")

        nb_landmarks = kwargs['nb_landmarks']
        Sigma0 = kwargs['Sigma0'] if 'Sigma0' in kwargs else 1.*np.eye(3)
        motion_noise = kwargs['motion_noise'] if 'motion_noise' in kwargs else np.array([.05,.01])
        measurement_noise = kwargs['measurement_noise'] if 'measurement_noise' in kwargs else np.array([.05,.05])

        # Storing parameters
        self.nb_landmarks = nb_landmarks
        self.has_initialized_landmark = np.zeros(nb_landmarks,dtype=bool)
        # Filter variables
        self.Sigma = 100*np.eye(3+2*nb_landmarks)
        self.Sigma[0:3,0:3] = Sigma0
        self.R = np.diag(motion_noise)
        self.Q = np.diag(measurement_noise)
        self.F = np.vstack([np.eye(3), np.zeros([2*nb_landmarks,3])])        

        # Initializing parent class
        kwargsSLAM = {'x_dimension': 3+2*nb_landmarks}
        kwargs.update(kwargsSLAM)
        super().__init__(**kwargs)

    """
    Extended Kalman Filter routine
    """
    def run(self, dt, u, measurements=None):
        # Loading from previous iterations
        x_est = self.x_est
        Sigma = self.Sigma

        # Computing matrices
        theta = x_est[2,0];
        vt = u[0,0];
        print("X_BEGGINING:", x_est)

        V = np.array([[dt*np.cos(theta), 0], [dt*np.sin(theta), 0], [0, dt]]); 
        g = V@u;

        G = np.eye(np.shape(self.F)[0]) + self.F@np.array([[0, 0, -vt*dt*np.sin(theta)], [0, 0, vt*dt*np.cos(theta)], [0, 0, 0]])@self.F.T;

        # Prediction   
        x_est = x_est + self.F@g;
        Sigma =  G@Sigma@G.T + self.F@V@self.R@V.T@self.F.T;
        #print("Sigma:", Sigma)

        # Update
        # Check if there are measurements available
        if measurements is not None and len(measurements['id']) > 0:
#                print("COORDS:", x_est[0:2,0])
#                print("measurements:", measurements)
                print("ID:", measurements['id'])

                j = measurements['id']

                delta_j = measurements['coordinate'].T - x_est[0:2,0];
                delta_j = delta_j.T;
#                print("delta_j:", delta_j)
                q = delta_j.T@delta_j;
                q = q[0][0];
                s_q = np.sqrt(q);
                d_x = delta_j[0,0];
                d_y = delta_j[1,0];
#                print("d_x:", d_x)
#                print("d_y:", d_y)
#                print("s_q:", s_q)

                H_l = np.array([[-s_q*d_x, -s_q*d_y, 0., s_q*d_x, s_q*d_y], [d_y, -d_x, -q, -d_y, d_x]]);
                F = np.zeros((np.shape(H_l)[1], np.shape(self.F)[0]))
                F[0,0] = 1;
                F[1,1] = 1;
                F[2,2] = 1;
                F[3,2*j+3] = 1;
                F[4,2*j+1+3] = 1;
            
                H = H_l@F;
#                print("F:", F)
#                print("H_l:", H_l)
#                print("H:", H)

                K = Sigma@H.T@np.linalg.inv((H@Sigma@H.T+self.Q))
#                print("K:", K)
                #hi = self.R * measurements['coordinate'];
                hi = measurements['coordinate'];
#                print("X_AFTER:", x_est)
#                print("MEASURE:", measurements['coordinate'])
#                print("HI:", hi)
                x_est = x_est + K@(measurements['coordinate'] - hi)      
#                print("New x_est:", x_est)
                Sigma = (np.eye(3+2*self.nb_landmarks) - K@H)@Sigma

        # Storing for next iterations
        self.x_est = np.copy(x_est)
        self.Sigma = np.copy(Sigma)
        
        return x_est, Sigma

