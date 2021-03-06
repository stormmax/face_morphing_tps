function [morphed_im] = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
% Author: Max Lu
% Date: 10/17/2016
% luyiren@seas.upenn.edu
%
% Inputs:   im1:    H1 x W1 x 3 matrix representing the first image
%           im2:    H2 x W2 x 3 matrix representing the second image
%           im1_pts     N x 2 matrix representing the correspondences in 
%                       the first image
%           im2_pts     N x 2 matrix representing the correspondences in 
%                       the second image
%           warp_frac   parameter to control shape warp
%           dissolve_frac   paramter to control cross-dissolve
% Output:   morphed_im      H2 x W2 x 3 matrix representing the morphed img

function [u] = U(r)
u = -(r.^2.*log(r.^2));
u(isnan(u)) = 0;
end
im_pts = (1-warp_frac)*im1_pts + warp_frac*im2_pts;
[a1_x,ax_x,ay_x,w_x] = est_tps(im_pts, im1_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(im_pts, im1_pts(:,2));
morphed_1 = morph_tps(im1, a1_x, ax_x,  ay_x, w_x, a1_y, ax_y, ay_y, w_y, im_pts, size(im1));
[a1_x,ax_x,ay_x,w_x] = est_tps(im_pts, im2_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(im_pts, im2_pts(:,2));
morphed_2 = morph_tps(im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, im_pts, size(im2));
morphed_im = (1-dissolve_frac)*morphed_1 + dissolve_frac*morphed_2;
end