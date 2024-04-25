#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# based on Cyril Stachniss - Mobile Sensing and Robotics 1 course assignment

import numpy as np
import matplotlib.pyplot as plt
import bresenham as bh

#desenha o gridmap
def plot_gridmap(gridmap):
    gridmap = np.array(gridmap, dtype=np.float64)
    plt.figure()
    plt.imshow(gridmap, cmap='Greys',vmin=0, vmax=1)
    plt.show()
    
#inicializa o gridmap todo a zeros
def init_gridmap(size, res):
    gridmap = np.zeros([int(np.ceil(size/res)), int(np.ceil(size/res))])
    return gridmap

#transforma as coordenadas de mundo para coordenadas do mapa
#(0,0) do mundo é o centro do mapa
#pode mandar várias posicoes nnum array bidimensional
#a primeira posicao e um arary com todos os X's
#a segunda tem todos os Y's
def world2map(pose, gridmap, map_res):
    origin = np.array(gridmap.shape)/2
    new_pose = np.zeros((pose.shape))
    new_pose[0:] = np.round(pose[0:]/map_res) + origin[0]
    new_pose[1:] = np.round(pose[1:]/map_res) + origin[1]
    return new_pose.astype(int)

#recebe um pose com velocidade x, velocidade y, e orientação
#a matriz serve para atualizar a posição
def v2t(pose):
    c = np.cos(pose[2])
    s = np.sin(pose[2])
    tr = np.array([[c, -s, pose[0]], [s, c, pose[1]], [0, 0, 1]])
    return tr    

#recebe varios ranges de raios, verifica se os mesmos são bons (range é a distância)
#depois usa os que são bons para calcular qual posição os mesmos estão a ver
#os ranges vêm ordenados por angulo
#manda de volta os pontos na forma homogenea
def ranges2points(ranges):
    # laser properties
    start_angle = -1.5708
    angular_res = 0.0087270
    max_range = 30
    # rays within range
    num_beams = ranges.shape[0]
    idx = (ranges < max_range) & (ranges > 0)
    # 2D points
    angles = np.linspace(start_angle, start_angle + (num_beams*angular_res), num_beams)[idx]
    points = np.array([np.multiply(ranges[idx], np.cos(angles)), np.multiply(ranges[idx], np.sin(angles))])
    # homogeneous points
    points_hom = np.append(points, np.ones((1, points.shape[1])), axis=0)
    return points_hom

#recebe os ranges e a pose do mundo e manda de volta as células detetadas
def ranges2cells(r_ranges, w_pose, gridmap, map_res):
    # ranges to points
    r_points = ranges2points(r_ranges)
    w_P = v2t(w_pose)
    w_points = np.matmul(w_P, r_points)
    # covert to map frame
    m_points = world2map(w_points, gridmap, map_res)
    m_points = m_points[0:2,:]
    return m_points

#transforma a pose do mundo para ser relativa ao mapa
def poses2cells(w_pose, gridmap, map_res):
    # covert to map frame
    m_pose = world2map(w_pose, gridmap, map_res)
    return m_pose  

def bresenham(x0, y0, x1, y1):
    l = np.array(list(bh.bresenham(x0, y0, x1, y1)))
    return l
    
def prob2logodds(p):
    return np.log(p/(1-p));
    
def logodds2prob(l):
    return 1-1/(1+np.exp(l))

#def inv_sensor_model(cell, endpoint, prob_occ, prob_free):
#    print("CELL:", cell)
#    print("ENDPOINT:", endpoint)
#    comp = np.all(cell==endpoint, axis=1)
#    probs = np.zeros((comp.shape[0], 1)) + prob_free;
#    probs[comp] = prob_occ;
#   return np.append(endpoint, probs, axis=1)

def inv_sensor_model(cell, endpoint, prob_occ, prob_free):
    l = bresenham(cell[0], cell[1], endpoint[0], endpoint[1])
    temp = np.full(len(l),prob_occ)
    temp[-1] = prob_free
    a = np.column_stack((l,temp))
    print("A:", a)
    return a

def grid_mapping_with_known_poses(ranges_raw, poses_raw, occ_gridmap, map_res, prob_occ, prob_free, prior):
    poses = poses2cells(poses_raw, occ_gridmap, map_res);

    occ_gridmap = prob2logodds(occ_gridmap);

    for i in range(poses_raw.shape[0]):
        ranges = ranges2cells(ranges_raw[0], poses[i], occ_gridmap, map_res);
        for r in range(ranges.shape[0]):
            inv = inv_sensor_model(poses[i], ranges[r], prob_occ, prob_free);
            #for c in range(inv.shape[0]):
            print("Inv:", inv.shape)
            return 1
            for c in range(inv):
                occ_gridmap[c, :] = occ_gridmap[c,:] + prob2logodds(inv)[2] - prob2logodds(prior)
                #occ_gridmap = occ_gridmap + prob2logodds(inv) - prob2logodds(prior);

    return occ_gridmap


map_size = 100
map_res = 0.25

prior = 0.50
prob_occ = 0.90
prob_free = 0.35

# load data
ranges_raw = np.loadtxt("data/ranges.data", delimiter=',', dtype='float')
poses_raw = np.loadtxt("data/poses.data", delimiter=',', dtype='float')

print(ranges_raw.shape)
print(poses_raw.shape)

# initialize gridmap
occ_gridmap = init_gridmap(map_size, map_res)+prior
plot_gridmap(occ_gridmap)

#Grid map output
gridmap = grid_mapping_with_known_poses(ranges_raw, poses_raw, occ_gridmap, map_res, prob_occ, prob_free, prior)

#Plot the grid map
plot_gridmap(gridmap)
